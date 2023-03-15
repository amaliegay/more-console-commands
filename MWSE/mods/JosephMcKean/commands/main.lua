local defaultConfig = { defaultLuaConsole = false, leftRightArrowSwitch = false, marks = {} }
local configPath = "More Console Commands"
local config = mwse.loadConfig(configPath, defaultConfig)
local console = tes3ui.registerID("MenuConsole")

--- @param e uiActivatedEventData
local function onMenuConsoleActivated(e)
	if (not e.newlyCreated) then
		return
	end

	local menuConsole = e.element
	local input = menuConsole:findChild("UIEXP:ConsoleInputBox")
	local scriptToggleButton = input.parent.parent:findChild(-984).parent
	if config.defaultLuaConsole then
		local toggleText = scriptToggleButton.text
		if toggleText ~= "lua" then
			scriptToggleButton:triggerEvent("mouseClick")
		end
	end

	input:registerBefore("keyPress", function(k)
		if not config.leftRightArrowSwitch then
			return
		end
		local key = k.data0
		if (key == -0x7FFFFFFE) or (key == -0x7FFFFFFF) then
			-- Pressing right or left
			scriptToggleButton:triggerEvent("mouseClick")
		end
	end)
end
event.register("uiActivated", onMenuConsoleActivated, { filter = "MenuConsole", priority = -9999 })

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

local skillModuleSkills = {
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

local function listAvailableSkills()
	local skillModule = include("OtherSkills.skillModule")
	if not skillModule then
		return
	end
	tes3ui.log("Example: levelup survival 69\nHere is a list of skills that are available:")
	for name, data in pairs(skillModuleSkills) do
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
	local skillData = skillModuleSkills[name:lower()]
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
	local ref = tes3ui.findMenu(console):getPropertyObject("MenuConsole_current_ref")
	ref = ref or tes3.player ---@type tes3reference
	if ref then
		local count = tes3.getItemCount({ reference = ref, item = "gold_001" })
		tes3.removeItem({ reference = ref, item = "gold_001", count = count })
	end
end

---@param count number
local function giveGold(count)
	if count <= 0 then
		return
	end
	local ref = tes3ui.findMenu(console):getPropertyObject("MenuConsole_current_ref")
	ref = ref or tes3.player ---@type tes3reference
	if ref then
		tes3.addItem({ reference = ref, item = "gold_001", count = count, showMessage = true })
	end
end

local command = {
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
	-- skill module cheats
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
				mwse.saveConfig(configPath, config)
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
			local ref = tes3ui.findMenu(console):getPropertyObject("MenuConsole_current_ref")
			if not ref then
				return
			end
			tes3.setAIFollow({ reference = ref, target = tes3.player })
		end,
	},
	["kill"] = {
		description = "Kill the current reference. For safety reason, type kill player to kill the player.",
		callback = function(params)
			local ref = tes3ui.findMenu(console):getPropertyObject("MenuConsole_current_ref")
			if not params[1] and ref and ref.mobile then
				if ref.mobile ~= tes3.mobilePlayer then
					ref.mobile:kill()
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
			local ref = tes3ui.findMenu(console):getPropertyObject("MenuConsole_current_ref")
			if not ref then
				return
			end
			tes3.setAIWander({ reference = ref, range = 512, idles = { 60, 20, 20, 0, 0, 0, 0, 0 } })
		end,
	},
}

event.register("UIEXP:consoleCommand", function(e)
	if e.context ~= "lua" then
		return
	end
	local text = e.command ---@type string
	local words = {}
	for w in string.gmatch(text, "%S+") do
		table.insert(words, w:lower())
	end
	local functionName = words[1]
	if not command[functionName] then
		return
	end
	table.remove(words, 1)
	command[functionName].callback(words)
	e.block = true
end)

event.register("UIEXP:consoleCommand", function(e)
	if e.context ~= "lua" then
		return
	end
	local text = e.command ---@type string
	local words = {}
	for w in string.gmatch(text, "%S+") do
		table.insert(words, w:lower())
	end
	local help = words[1]
	if help ~= "help" then
		return
	end
	tes3ui.log("help: Shows up available commands.")
	for functionName, data in pairs(command) do
		tes3ui.log("%s: %s", functionName, data.description)
	end
	e.block = true
end, { priority = -9999 })

local function registerModConfig()
	local template = mwse.mcm.createTemplate(configPath)
	template:saveOnClose(configPath, config)

	local page = template:createPage()

	local settings = page:createCategory("Settings")
	settings:createYesNoButton({
		label = "Press left right arrow to switch between lua and mwscript console",
		variable = mwse.mcm.createTableVariable({ id = "leftRightArrowSwitch", table = config }),
	})
	settings:createYesNoButton({
		label = "Default to lua console",
		variable = mwse.mcm.createTableVariable({ id = "defaultLuaConsole", table = config }),
	})

	local info = page:createCategory("Available Commands")
	info:createInfo({ text = "help: Shows up available communeDeadDesc." })
	for functionName, data in pairs(command) do
		info:createInfo({ text = string.format("%s: %s", functionName, data.description) })
	end
	info:createInfo({
		text = "\nClick on the object while console menu is open to select the current reference. If nothing is selected, current reference is default to the player. \n" ..
		"For example, if nothing is selected, you type and enter money 420, the player will get 420 gold. But if fargoth is selected, fargoth will get the money instead.",
	})
	info:createInfo({ text = "\nMore detailed documentation see Docs\\More Console Commands.md or \nNexusmods page:\n" })
	info:createHyperlink{
		text = "https://www.nexusmods.com/morrowind/mods/52500",
		exec = "https://www.nexusmods.com/morrowind/mods/52500",
	}

	mwse.mcm.register(template)
end
event.register("modConfigReady", registerModConfig)
