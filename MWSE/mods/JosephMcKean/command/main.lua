local config = mwse.loadConfig("More Console Command", { marks = {} })
local configPath = "More Console Command"
local console = tes3ui.registerID("MenuConsole")

local function listMarks()
	tes3ui.log("mark <id>: Mark the player's current cell and position for recall.")
	if not table.empty(config.marks) then
		tes3ui.log("\nHere is a list of marks that are available:")
		for id, mark in pairs(config.marks) do
			tes3ui.log("%s: %s", id, mark.name)
		end
	else
		tes3ui.log(
		"Type mark to view all marks, type mark <id> to mark. \nExample: mark home, recall home.\n<id> needs to be one single word like this or likethis or like_this.")
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
		description = "Gives current reference 1,000 gold.",
		callback = function()
			giveGold(1000)
		end,
	},
	["motherlode"] = {
		description = "Gives current reference 50,000 gold.",
		callback = function()
			giveGold(50000)
		end,
	},
	["money"] = {
		description = "Sets current reference gold amount to the input value. e.g. money 420",
		callback = function(params)
			removeGold()
			giveGold(tonumber(params[1]) or 0)
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
					position = tes3vector3.new(position.x, position.y, position.z),
					orientation = tes3vector3.new(orientation.x, orientation.y, orientation.z),
				}
				mwse.saveConfig(configPath, config)
				tes3ui.log("%s: %s", params[1], tes3.player.cell.editorName)
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
					mwse.log("mark.cell = %s", mark.cell)
					if mark.cell then
						tes3.positionCell({
							cell = mark.cell and tes3.getCell({ id = mark.cell }),
							position = mark.position,
							orientation = mark.orientation,
						})
					else
						tes3.positionCell({ position = mark.position, orientation = mark.orientation })
					end
				end
			end
		end,
	},
}

local functionCommand = {
	["kill"] = function()
	end,
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

--[[event.register("UIEXP:sandboxConsole", function(e)
	e.sandbox.help = function()
		tes3ui.log("help: Shows up available cheats.")
		for command, data in pairs(functionCommand) do
			tes3ui.log("%s: %s", command, data.description)
		end
	end
end, { priority = -9999 })]]

--[[local function registerModConfig()
	local template = mwse.mcm.createTemplate(configPath)
	template:saveOnClose(configPath, config)

	local page = template:createSideBarPage()

	page:createYesNoButton({
		label = "Commands for mwscript console?",
		description = "Normally the \"Quick Load\" feature will only load the latest save made using \"Quick Save\". This feature makes loading a quick save instead load the newest save of any type.",
		variable = mwse.mcm.createTableVariable({ id = "loadLatestSave", table = config }),
	})

	mwse.mcm.register(template)
end
event.register("modConfigReady", registerModConfig)]]

--[[
    check mark in West Gash -- bugged if save and reload
    default lua console
    arrow left right switch between lua and mwscript console
]]
