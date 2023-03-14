local config = mwse.loadConfig("More Console Command", { marks = {} })
local configPath = "More Console Command"
local console = tes3ui.registerID("MenuConsole")

local function listMarks()
	for id, mark in pairs(config.marks) do
		tes3ui.log("%s: %s", id, mark.name)
	end
end

---@param id string
---@param value number
local function SMSkillLevelUp(id, value)
	local skillModule = include("OtherSkills.skillModule")
	if not skillModule then
		return
	end
	local skill = skillModule.getSkill(id)
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
	local ref = tes3ui.findMenu(console):getPropertyObject("MenuConsole_current_ref")
	ref = ref or tes3.player ---@type tes3reference
	if ref then
		tes3.addItem({ reference = ref, item = "gold_001", count = count })
	end
end

config.stringCommand = {
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
}

config.functionCommand = {
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
		---@param count number
		callback = function(count)
			removeGold()
			giveGold(count)
		end,
	},
	-- skill module cheats
	["setbushcrafting"] = {
		description = "Sets current reference Ashfall Bushcrafting skill to the input value. e.g. setbushcrafting 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("Bushcrafting", value)
		end,
	},
	["setclimbing"] = {
		description = "Sets current reference Mantle of Ascension Climbing skill to the input value. e.g. setclimbing 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("climbing", value)
		end,
	},
	["setcooking"] = {
		description = "Sets current reference Cooking skill to the input value. e.g. setcooking 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("mc_Cooking", value)
		end,
	},
	["setcorpsepreparation"] = {
		description = "Sets current reference Necrocraft Corpse Preparation skill to the input value. e.g. setcorpsepreparation 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("NC:CorpsePreparation", value)
		end,
	},
	["setcrafting"] = {
		description = "Sets current reference Morrowind Crafting Crafting skill to the input value. e.g. setcrafting 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("mc_Crafting", value)
		end,
	},
	["setfletching"] = {
		description = "Sets current reference Go Fletch and/or Morrowind Crafting Fletching skill to the input value. e.g. setflecthing 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("fletching", value)
			SMSkillLevelUp("mc_Fletching", value)
		end,
	},
	["setinscription"] = {
		description = "Sets current reference Demon of Knowledge Inscription skill to the input value. e.g. setinscription 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("Hermes:Inscription", value)
		end,
	},
	["setmasonry"] = {
		description = "Sets current reference Morrowind Crafting Masonry skill to the input value. e.g. setmasonry 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("mc_Masonry", value)
		end,
	},
	["setmetalworking"] = {
		description = "Sets current reference Morrowind Crafting Metalworking skill to the input value. e.g. setmetalworking 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("mc_Metalworking", value)
		end,
	},
	["setmining"] = {
		description = "Sets current reference Morrowind Crafting Mining skill to the input value. e.g. setmining 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("mc_Mining", value)
		end,
	},
	["setpackrat"] = {
		description = "Sets current reference Packrat skill to the input value. e.g. setpackrat 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("Packrat", value)
		end,
	},
	["setperformance"] = {
		description = "Sets current reference Bardic Inspiration Performance skill to the input value. e.g. setperformance 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("BardicInspiration:Performance", value)
		end,
	},
	["setsewing"] = {
		description = "Sets current reference Morrowind Crafting Sewing skill to the input value. e.g. setsewing 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("mc_Sewing", value)
		end,
	},
	["setsmithing"] = {
		description = "Sets current reference Morrowind Crafting Smithing skill to the input value. e.g. setsmithing 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("mc_Smithing", value)
		end,
	},
	["setstaff"] = {
		description = "Sets current reference Staffing skill to the input value. e.g. setstaff 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("MSS:Staff", value)
		end,
	},
	["setsurvival"] = {
		description = "Sets current reference Ashfall Survival skill to the input value. e.g. setsurvival 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("Ashfall:Survival", value)
		end,
	},
	["setwoodworking"] = {
		description = "Sets current reference Morrowind Crafting Woodworking skill to the input value. e.g. setwoodworking 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("mc_Woodworking", value)
		end,
	},
	["setdaedric"] = {
		description = "Sets current reference Read Aloud Daedric skill to the input value. e.g. setdaedric 69",
		---@param value number
		callback = function(value)
			SMSkillLevelUp("ab01daedric", value)
		end,
	},
	-- mark and recall
	["mark"] = {
		description = "Mark the player's current cell and position for recall. Type mark to view all marks, type mark <id> to mark. e.g. mark home",
		---@param id string
		callback = function(id)
			if (not id) or type(id) ~= "string" then
				listMarks()
			else
				local position = tes3.player.position
				local orientation = tes3.player.orientation
				config.marks[id] = {
					name = tes3.player.cell.id,
					cell = tes3.player.cell.id,
					position = tes3vector3.new(position.x, position.y, position.z),
					orientation = tes3vector3.new(orientation.x, orientation.y, orientation.z),
				}
				mwse.saveConfig(configPath, config)
			end
		end,
	},
	["recall"] = {
		description = "Teleport the player to a previous mark. Type recall to view all marks, type recall <id> to recall. e.g. recall home",
		---@param id string
		callback = function(id)
			if (not id) or type(id) ~= "string" then
				listMarks()
			else
				local mark = config.marks[id]
				if mark then
					tes3.positionCell({ cell = tes3.getCell(mark.cell), position = mark.position, orientation = mark.orientation })
				end
			end
		end,
	},
}

event.register("UIEXP:consoleCommand", function(e)
	if e.context ~= "lua" then
		return
	end
	if not config.stringCommand[e.command] then
		return
	end
	config.stringCommand[e.command].callback()
	e.block = true
end)

event.register("UIEXP:sandboxConsole", function(e)
	for command, data in pairs(config.functionCommand) do
		e.sandbox[command] = data.callback
	end
end)

event.register("UIEXP:sandboxConsole", function(e)
	e.sandbox.help = function()
		tes3ui.log("help: Shows up available cheats.")
		for command, data in pairs(config.functionCommand) do
			tes3ui.log("%s: %s", command, data.description)
		end
	end
end, { priority = -9999 })

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
    check mark in Balmora, Caius Cosades's House
    check mark in West Gash
    default lua console
    arrow left right switch between lua and mwscript console
]]
