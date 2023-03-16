local config = require("JosephMcKean.commands.config")
local console = tes3ui.registerID("MenuConsole")
local data = {}
local modName = "More Console Commands"

local objectType = {
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

---@return tes3reference ref
function data.getCurrentRef()
	local ref = tes3ui.findMenu(console):getPropertyObject("MenuConsole_current_ref")
	return ref
end

---@param name string
---@return string? type 
---@return number? id 
local function getAttributeId(name)
	local type = nil
	local id = nil
	local camelCased = {
		["mediumarmor"] = "mediumArmor",
		["heavyarmor"] = "heavyArmor",
		["bluntweapon"] = "bluntWeapon",
		["longblade"] = "longBlade",
		["lightarmor"] = "lightArmor",
		["shortblade"] = "shortBlade",
		["handtohand"] = "handToHand",
	}
	name = camelCased[name] or name
	if tes3.attribute[name] then
		type = "attribute"
		id = tes3.attribute[name]
	elseif tes3.skill[name] then
		type = "skill"
		id = tes3.skill[name]
	end
	return type, id
end

data.skillModuleSkills = {
	["bushcrafting"] = { id = "Bushcrafting", mod = "Ashfall", include = "mer.ashfall.common.common" },
	["climbing"] = { id = "climbing", mod = "Mantle of Ascension", include = "mantle.main" },
	["cooking"] = { id = "mc_Cooking", mod = "Morrowind Crafting", include = "Morrowind_Crafting_3.mc_common" },
	["corpsepreparation"] = { id = "NC:CorpsePreparation", mod = "Necrocraft", include = "necroCraft.main" },
	["crafting"] = { id = "mc_Crafting", mod = "Morrowind Crafting", include = "Morrowind_Crafting_3.mc_common" },
	["fletching"] = { id = "fletching", mod = "Go Fletch", include = "mer.goFletch.main" },
	["mcfletching"] = { id = "mc_Fletching", mod = "Morrowind Crafting", include = "Morrowind_Crafting_3.mc_common" },
	["inscription"] = { id = "Hermes:Inscription", mod = "Demon of Knowledge", include = "MMM2018.sx2.main" },
	["masonry"] = { id = "mc_Masonry", mod = "Morrowind Crafting", include = "Morrowind_Crafting_3.mc_common" },
	["metalworking"] = { id = "mc_Metalworking", mod = "Morrowind Crafting", include = "Morrowind_Crafting_3.mc_common" },
	["mining"] = { id = "mc_Mining", mod = "Morrowind Crafting", include = "Morrowind_Crafting_3.mc_common" },
	["packrat"] = { id = "Packrat", mod = "Packrat Skill", include = "gool.packrat.main" },
	["performance"] = {
		id = "BardicInspiration:Performance",
		mod = "Bardic Inspiration",
		include = "mer.bardicInspiration.controllers.skillController",
	},
	["sewing"] = { id = "mc_Sewing", mod = "Morrowind Crafting", include = "Morrowind_Crafting_3.mc_common" },
	["smithing"] = { id = "mc_Smithing", mod = "Morrowind Crafting", include = "Morrowind_Crafting_3.mc_common" },
	["staff"] = { id = "MSS:Staff", mod = "MWSE Staff Skill", include = "inpv.Staff Skill.main" },
	["survival"] = { id = "Ashfall:Survival", mod = "Ashfall", include = "mer.ashfall.common.common" },
	["woodworking"] = { id = "mc_Woodworking", mod = "Morrowind Crafting", include = "Morrowind_Crafting_3.mc_common" },
}

local function listMarks()
	if not table.empty(config.marks) then
		tes3ui.log("\nHere is a list of marks that are available:")
		for id, mark in pairs(config.marks) do
			tes3ui.log("%s: %s", id, mark.name)
		end
	else
		tes3ui.log(
		"Type mark or recall to view all marks, type mark <id> to mark, type recall <id> to recall. \nExample: mark home, recall home.\n<id> needs to be one single word like this or likethis or like_this.")
	end
end

local function listAvailableSkills()
	local skillModule = include("OtherSkills.skillModule")
	if not skillModule then
		return
	end
	tes3ui.log("Example: levelup survival 69\nHere is a list of skills that are available:")
	for name, data in pairs(data.skillModuleSkills) do
		if include(data.include) then
			tes3ui.log("%s (%s)", name, data.mod)
		end
	end
end

---@param name string
---@param value number
local function levelUp(name, value)
	local skillModule = include("OtherSkills.skillModule")
	if not skillModule then
		return
	end
	local skillData = data.skillModuleSkills[name:lower()]
	if not skillData then
		return
	end
	local skill = skillModule.getSkill(skillData.id)
	if not skill then
		return
	end
	skill:levelUpSkill(value)
end

local function removeGold()
	local ref = data.getCurrentRef() or tes3.player ---@type tes3reference
	local count = tes3.getItemCount({ reference = ref, item = "gold_001" })
	if ref then -- tes3.player might be nil
		tes3.removeItem({ reference = ref, item = "gold_001", count = count })
	end
end

---@param count number
local function giveGold(count)
	if count <= 0 then
		return
	end
	local ref = data.getCurrentRef() or tes3.player ---@type tes3reference
	if ref then
		tes3.addItem({ reference = ref, item = "gold_001", count = count, showMessage = true })
	end
end

data.command = {
	-- Money cheats
	["kaching"] = {
		description = "Give current reference 1,000 gold.",
		callback = function()
			giveGold(1000)
		end,
	},
	["motherlode"] = {
		description = "Give current reference 50,000 gold.",
		callback = function()
			giveGold(50000)
		end,
	},
	["money"] = {
		description = "Set current reference gold amount to the input value. e.g. money 420",
		callback = function(params)
			if not params[1] then
				return
			end
			local count = tonumber(params[1])
			if not count then
				return
			end
			removeGold()
			giveGold(count)
		end,
	},
	-- stats cheats
	["levelup"] = {
		description = "Increase the player's skill by the input value. e.g. levelup bushcrafting 69, levelup survival 420",
		callback = function(params)
			if not params[1] then
				listAvailableSkills()
				return
			elseif not params[2] then
				levelUp(params[1], 1)
				return
			end
			levelUp(params[1], tonumber(params[2]) or 0)
		end,
	},
	["set"] = {
		description = "Set the current reference's attribute or skill current value.",
		callback = function(params)
			local ref = data.getCurrentRef() or tes3.player
			if not ref then
				return
			end
			local type, id = getAttributeId(params[1])
			if type == "attribute" then
				tes3.setStatistic({ reference = tes3.player, attribute = id, current = tonumber(params[2]) })
			elseif type == "skill" then
				tes3.setStatistic({ reference = tes3.player, skill = id, current = tonumber(params[2]) })
			end
		end,
	},
	["speedy"] = {
		description = "Increase the player's speed to 200, athletics to 200.",
		callback = function(params)
			tes3.setStatistic({ reference = tes3.player, attribute = tes3.attribute.speed, current = 200 })
			tes3.setStatistic({ reference = tes3.player, skill = tes3.skill.athletics, current = 200 })
		end,
	},
	-- mark and recall
	["mark"] = {
		description = "Mark the player's current cell and position for recall. Type mark to view all marks, type mark <id> to mark. e.g. mark home",
		callback = function(params)
			if not params[1] then
				listMarks()
			else
				local cell = nil
				if tes3.player.cell.isInterior then
					cell = tes3.player.cell.id
				end
				local position = tes3.player.position
				local orientation = tes3.player.orientation
				config.marks[params[1]] = {
					name = tes3.player.cell.editorName,
					cell = cell,
					position = { x = position.x, y = position.y, z = position.z },
					orientation = { x = orientation.x, y = orientation.y, z = orientation.z },
				}
				mwse.saveConfig(modName, config)
				tes3ui.log("%s: %s", params[1], tes3.player.cell.editorName)
				mwse.log("marks[%s].cell = {\nname = %s,\ncell = %s,\nposition = { %s, %s, %s },\norientation = { %s, %s, %s }\n}",
				         params[1], tes3.player.cell.editorName, cell, position.x, position.y, position.z, orientation.x,
				         orientation.y, orientation.z)
			end
		end,
	},
	["recall"] = {
		description = "Teleport the player to a previous mark. Type recall to view all marks, type recall <id> to recall. e.g. recall home",
		callback = function(params)
			if not params[1] then
				listMarks()
			else
				local mark = config.marks[params[1]]
				if mark then
					mwse.log("tes3.positionCell({\ncell = %s,\nposition = { %s, %s, %s },\norientation = { %s, %s, %s }\n}", mark.cell,
					         mark.position.x, mark.position.y, mark.position.z, mark.orientation.x, mark.orientation.y,
					         mark.orientation.z)
					if mark.cell then
						tes3.positionCell({
							cell = tes3.getCell({ id = mark.cell }),
							position = { mark.position.x, mark.position.y, mark.position.z },
							orientation = { mark.orientation.x, mark.orientation.y, mark.orientation.z },
							forceCellChange = true,
						})
					else
						tes3.positionCell({
							position = { mark.position.x, mark.position.y, mark.position.z },
							orientation = { mark.orientation.x, mark.orientation.y },
							forceCellChange = true,
						})
					end
				end
			end
		end,
	},
	-- NPC command
	["follow"] = {
		description = "Make the current reference your follower.",
		callback = function(params)
			local ref = data.getCurrentRef()
			if not ref then
				return
			end
			tes3.setAIFollow({ reference = ref, target = tes3.player })
		end,
	},
	["kill"] = {
		description = "Kill the current reference. For safety reason, type kill player to kill the player.",
		callback = function(params)
			local ref = data.getCurrentRef()
			if not params[1] and ref and ref.mobile then
				local actor = ref.mobile ---@cast actor tes3mobileNPC|tes3mobileCreature|tes3mobilePlayer
				if actor ~= tes3.mobilePlayer then
					actor:kill()
				else
					tes3ui.log("For safety reason, type kill player to kill the player.")
				end
			elseif params[1] == "player" then
				tes3.mobilePlayer:kill()
			end
		end,
	},
	["wander"] = {
		description = "Make the current reference wander.",
		callback = function(params)
			local ref = data.getCurrentRef()
			if not ref then
				return
			end
			tes3.setAIWander({ reference = ref, range = 512, idles = { 60, 20, 20, 0, 0, 0, 0, 0 } })
		end,
	},
	-- item commands
	["addall"] = {
		description = "Add all objects of the objectType type to the current reference's inventory.",
		callback = function(params)
			local ref = data.getCurrentRef() or tes3.player
			if not ref then
				return
			end
			local filter = objectType[params[1]]
			if not filter then
				return
			end
			local count = tonumber(params[2])
			if not count then
				count = 1
			elseif count <= 0 then
				return
			end
			---@param object tes3object|tes3light
			for object in tes3.iterateObjects(filter) do
				if (object.name ~= "") and not object.script then
					if filter == tes3.objectType.light then
						if object.canCarry then
							tes3.addItem({ reference = ref, item = object.id, count = count, playSound = false })
						end
					else
						tes3.addItem({ reference = ref, item = object.id, count = count, playSound = false })
					end
				end
			end
		end,
	},
	["addone"] = {
		description = "Add one object of the objectType type to the current reference's inventory.",
		callback = function(params)
			local ref = data.getCurrentRef() or tes3.player
			if not ref then
				return
			end
			local filter = objectType[params[1]]
			if not filter then
				return
			end
			---@param object tes3object|tes3light
			for object in tes3.iterateObjects(filter) do
				if (object.name ~= "") and not object.script then
					if filter == tes3.objectType.light then
						if object.canCarry then
							tes3.addItem({ reference = ref, item = object.id, count = 1, playSound = false })
							return
						end
					else
						local function isGold(id)
							local goldList = {
								["gold_001"] = true,
								["gold_005"] = true,
								["gold_010"] = true,
								["gold_025"] = true,
								["gold_100"] = true,
								["gold_dae_cursed_001"] = true,
								["gold_dae_cursed_005"] = true,
							}
							return goldList[id]
						end
						if not isGold(object.id:lower()) then
							tes3.addItem({ reference = ref, item = object.id, count = 1, playSound = false })
							return
						end
					end
				end
			end
		end,
	},
	["quit"] = {
		description = "Quit Morrowind.",
		callback = function(params)
			os.exit()
		end,
	},
}

return data
