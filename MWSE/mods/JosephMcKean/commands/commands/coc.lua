local utils = include("JosephMcKean.lib.utils")

local common = require("JosephMcKean.commands.common")
local registerCommand = require("JosephMcKean.commands.interop").registerCommand
local mod = require("JosephMcKean.commands")
local log = mod:log("coc")

local isMarker = { ["TravelMarker"] = true, ["TempleMarker"] = true, ["DivineMarker"] = true, ["DoorMarker"] = true }

---@return tes3cell
local function randomCell()
	local isBlacklistedRegion = { ["Abecean Sea Region"] = true }
	---@param cell tes3cell?
	local function isInvalidCell(cell)
		if not cell then return true end
		if not cell.activators.head and not cell.actors.head and not cell.statics.head then
			log:trace("randomCell: skip cell %s", cell.editorName)
			return true
		end
		if cell.isInterior then return false end
		if not cell.region or isBlacklistedRegion[cell.region.id] then
			log:trace("randomCell: skip cell %s", cell.editorName)
			return true
		end
		return false
	end
	local cell ---@type tes3cell
	while isInvalidCell(cell) do cell = table.choice(tes3.dataHandler.nonDynamicData.cells) end
	return cell
end

local cellIdAlias = {
	["mournhold"] = "mournhold, royal palace: courtyard",
	["mournhold, royal palace"] = "mournhold, royal palace: reception area",
	["mournhold temple"] = "mournhold temple: reception area",
	["solstheim"] = "fort frostmoth",
	["sotha sil"] = "sotha sil, outer flooded halls",
	["sotha sil,"] = "sotha sil, outer flooded halls",
}

event.register("command:register", function()
	registerCommand({
		name = "coc",
		description = "Teleport the player to a cell with specified id or specified grid x and grid y",
		arguments = { { index = 1, metavar = "id", required = false, help = "the id of the cell to teleport to" } },
		requiresInGame = true,
		callback = function(argv)
			local cell2coc ---@type tes3cell
			local cellId = common.concat(argv)
			log:debug("coc %s", cellId)
			if not cellId then
				tes3ui.log("cellId not found")
				return
			elseif cellIdAlias[cellId] then
				cellId = cellIdAlias[cellId]
			elseif cellId == "random" then
				cell2coc = randomCell()
			end

			local grid = false
			local gridX = tonumber(argv[1])
			local gridY = tonumber(argv[2])
			if gridX and gridY and not argv[3] then
				cell2coc = tes3.getCell({ x = gridX, y = gridY })
				if not cell2coc then
					tes3ui.log("cell %s %s not found", gridX, gridY)
					return
				end
				cellId = cell2coc.id
				grid = true
			end

			local position = tes3vector3.new()
			local orientation = tes3vector3.new()

			local markers = {} ---@type table<tes3cell,table<string,tes3reference>>
			if grid then
				markers[cell2coc] = {}
			elseif cellId == "random" then
				markers[cell2coc] = {}
			else
				for _, cell in ipairs(tes3.dataHandler.nonDynamicData.cells) do
					if cell.id:lower() == cellId:lower() then
						markers[cell] = {}
						cell2coc = cell2coc or cell
					end
				end
			end
			if table.empty(markers) then
				tes3ui.log("cellId %s not found", cellId)
				return
			end
			if not cell2coc.isInterior then
				local gridSize = 8192
				position = tes3vector3.new(gridSize / 2 + cell2coc.gridX * gridSize, gridSize / 2 + cell2coc.gridY * gridSize, 994)
			end
			tes3.positionCell({ cell = cell2coc, position = position, orientation = orientation })

			timer.delayOneFrame(function()
				local intervention = false
				for cell, mks in pairs(markers) do
					-- TravelMarker, TempleMarker, DivineMarker, and DoorMarker are activators in game but static in TESCS
					local activators = cell.activators
					if activators.head then
						for activator in utils.iterateReferenceList(activators) do
							if isMarker[activator.id] and not markers[cell][activator.id] then
								markers[cell][activator.id] = activator
								log:debug("Found %s at %s (%s, %s), %s", activator.id, cell.editorName, position.x, position.y, activator.sourceMod)
							end
						end
						cell2coc = cell
						if mks["TravelMarker"] then
							position = mks["TravelMarker"].position
							orientation = mks["TravelMarker"].orientation
							log:debug("Found TravelMarker at %s (%s, %s)", cell.editorName, position.x, position.y)
							break
						end
						if not intervention and mks["DoorMarker"] then
							position = mks["DoorMarker"].position
							orientation = mks["DoorMarker"].orientation
							log:debug("Found DoorMarker at %s (%s, %s)", cell.editorName, position.x, position.y)
						end
						if mks["DivineMarker"] then
							position = mks["DivineMarker"].position
							orientation = mks["DivineMarker"].orientation
							intervention = true
							log:debug("Found DivineMarker at %s (%s, %s)", cell.editorName, position.x, position.y)
						end
						if mks["TempleMarker"] then
							position = mks["TempleMarker"].position
							orientation = mks["TempleMarker"].orientation
							intervention = true
							log:debug("Found TempleMarker at %s (%s, %s)", cell.editorName, position.x, position.y)
						end
					end
				end
				log:debug("Teleporting to %s (%s, %s)", cell2coc.editorName, position.x, position.y)
				tes3.positionCell({ cell = cell2coc, position = position, orientation = orientation })
			end, timer.real)
		end,
	})
end)
