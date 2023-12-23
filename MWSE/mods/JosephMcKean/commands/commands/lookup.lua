local common = require("JosephMcKean.commands.common")
local registerCommand = require("JosephMcKean.commands.interop").registerCommand
local mod = require("JosephMcKean.commands")
local log = mod:log("lookup")

---@param name string
---@return number?
local function getObjectType(name) return tes3.objectType[name] end

---@param obj tes3object|tes3npc|tes3cell
---@return string type
local function getTypeOfObject(obj)
	local type
	type = obj.objectType and table.find(tes3.objectType, obj.objectType)
	type = obj.cellFlags and "cell" or type
	return type
end

event.register("command:register", function()
	registerCommand({
		name = "fly",
		description = "Look up objects by id or name",
		arguments = {
			{ index = 1, metavar = "name", required = true, help = "the id or name of the object to look up" },
			{ index = 1, metavar = "objecttype", required = false, help = "the type of the object to look up" },
		},
		callback = function(argv)
			local isCellType = argv[#argv] == "cell"
			local objectType = getObjectType(argv[#argv])
			if isCellType or objectType then
				log:trace("%s is objectType", argv[#argv])
				table.remove(argv, #argv)
			end
			local name = common.concat(argv)
			if not isCellType and not objectType and not name then return end
			local lookUpObjs = {}
			if objectType then
				for object in tes3.iterateObjects(objectType) do
					local obj = object ---@cast obj tes3object|tes3npc
					local objId = obj.id and obj.id:lower()
					local objName = obj.name and obj.name:lower()
					if not name or (objId:find(name) or (objName and objName:find(name))) then table.insert(lookUpObjs, obj) end
				end
			end
			if isCellType then
				local nonDynamicData = tes3.dataHandler.nonDynamicData
				for _, cell in ipairs(nonDynamicData.cells) do if not name or (cell.id:lower():find(name)) then table.insert(lookUpObjs, cell) end end
			end
			if table.empty(lookUpObjs) then
				tes3ui.log("No matching information")
			else
				tes3ui.log("%s matching information:", #lookUpObjs)
				---@param obj tes3object|tes3npc|tes3cell
				for _, obj in ipairs(lookUpObjs) do
					local objType = getTypeOfObject(obj)
					local info = string.format("- %s, %s", objType, obj.id)
					if objType == "cell" then
						info = string.format("%s, %s", info, obj.editorName)
					elseif obj.name then
						info = string.format("%s, %s", info, obj.name)
					end
					local ref = tes3.getReference(obj.id)
					if ref and ref.cell then info = string.format("%s, %s", info, ref.cell.editorName) end
					if obj.sourceMod then info = string.format("%s, %s", info, obj.sourceMod) end
					tes3ui.log(info)
				end
			end
		end,
	})
end)
