local common = require("JosephMcKean.commands.common")
local registerCommand = require("JosephMcKean.commands.interop").registerCommand

local itemAliases = {
	["wood"] = "ashfall_firewood",
	["resin"] = "ingred_resin_01",
	["stone"] = "ashfall_stone",
	["fibre"] = "ashfall_plant_fibre",
	["rope"] = "ashfall_rope",
	["straw"] = "ashfall_straw",
	["fabric"] = "ashfall_fabric",
	["flint"] = "ashfall_flint",
	["coal"] = "ashfall_ingred_coal_01",
	["leather"] = "ashfall_leather",
	["gold"] = "gold_001",
}

local canCarryObjectType = {
	["alchemy"] = tes3.objectType.alchemy,
	["ammunition"] = tes3.objectType.ammunition,
	["apparatus"] = tes3.objectType.apparatus,
	["armor"] = tes3.objectType.armor,
	["book"] = tes3.objectType.book,
	["clothing"] = tes3.objectType.clothing,
	["ingredient"] = tes3.objectType.ingredient,
	["light"] = tes3.objectType.light,
	["lockpick"] = tes3.objectType.lockpick,
	["miscitem"] = tes3.objectType.miscItem,
	["probe"] = tes3.objectType.probe,
	["repairitem"] = tes3.objectType.repairItem,
	["weapon"] = tes3.objectType.weapon,
}

---@param object tes3object|tes3light
---@return boolean
local function canCarry(object)
	if table.find(canCarryObjectType, object.objectType) then
		if object.objectType == tes3.objectType.light then
			return true
		else
			return true
		end
	end
	return false
end

---@param ref tes3reference
---@param itemId string
---@param count integer
local function addItem(ref, itemId, count)
	if itemAliases[itemId] then itemId = itemAliases[itemId] end
	local item = tes3.getObject(itemId) ---@cast item tes3object|any
	if not item then
		local ingredId = "ingred_" .. itemId .. "_01"
		local ingred = tes3.getObject(ingredId)
		if ingred then
			itemId = ingredId
			item = ingred
		else
			tes3ui.log("additem: error: itemId %s not found", itemId)
			return
		end
	end
	if not canCarry(item) then
		tes3ui.log("error: %s is not carryable", item.id)
		return
	end
	tes3.addItem({ reference = ref, item = itemId, count = count, playSound = false })
	tes3ui.log("additem %s%s to %s", count and count .. " " or "", itemId, ref.id)
end

local function dupe(count)
	local ref = tes3ui.getConsoleReference()
	if not ref then return end
	local item = ref.baseObject
	local soul = ref.itemData and ref.itemData.soul
	if soul then
		tes3.addItem({ reference = tes3.player, item = item.id, soul = soul, playSound = false })
		tes3ui.log("additem %s (%s) to player", item.id, soul.id)
	elseif not canCarry(item) then
		tes3ui.log("error: %s is not carryable", item.name or ref.id)
		return
	else
		tes3.addItem({ reference = tes3.player, item = item.id, count = count or 1, playSound = false })
		tes3ui.log("additem %s%s to player", count and count .. " " or "", item.id)
	end
end

event.register("command:register", function()
	registerCommand({
		name = "additem",
		aliases = { "add" },
		description = "Add item(s) to the current reference's inventory",
		arguments = { { index = 1, metavar = "id", required = true, help = "the id of the item to add" }, { index = 2, metavar = "count", required = false, help = "the add item count" } },
		requiresInGame = true,
		callback = function(argv)
			local ref = tes3ui.getConsoleReference() or tes3.player
			if not ref then return end
			if not ref.object.inventory then
				tes3ui.log("error: %s does not have an inventory", ref.object.name or ref.id)
				return
			end
			local count = tonumber(argv[#argv])
			if count then table.remove(argv, #argv) end
			local itemId = common.concat(argv)
			if not itemId then return end
			addItem(ref, itemId, count)
		end,
	})
	registerCommand({
		name = "dupe",
		aliases = { "copy" },
		description = "Duplicate the item that is the current reference to the player's inventory",
		arguments = { { index = 1, metavar = "count", required = false, help = "the count of the item to duplicate" } },
		requiresInGame = true,
		callback = function(argv) dupe(tonumber(argv[1])) end,
	})
	for alias, itemId in pairs(itemAliases) do
		registerCommand({
			name = alias,
			hidden = true,
			arguments = { { index = 1, metavar = "count", required = true, help = "the count of the item to add" } },
			requiresInGame = true,
			callback = function(argv) addItem(tes3.player, itemId, tonumber(argv[1])) end,
		})
	end
end)
