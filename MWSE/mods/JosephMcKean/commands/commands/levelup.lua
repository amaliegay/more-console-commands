local mod = require("JosephMcKean.commands")
local registerCommand = require("JosephMcKean.commands.interop").registerCommand
local log = mod:log("levelup")

local skillModuleSkills = {
	["bushcrafting"] = { id = "Bushcrafting", mod = "Ashfall", luaMod = "mer.ashfall" },
	["climbing"] = { id = "climbing", mod = "Mantle of Ascension", luaMod = "mantle" },
	["cooking"] = { id = "mc_Cooking", mod = "Morrowind Crafting", luaMod = "Morrowind_Crafting_3" },
	["corpsepreparation"] = { id = "NC:CorpsePreparation", mod = "Necrocraft", luaMod = "necroCraft" },
	["crafting"] = { id = "mc_Crafting", mod = "Morrowind Crafting", luaMod = "Morrowind_Crafting_3" },
	["fishing"] = { id = "fishing", mod = "Ultimate Fishing", luaMod = "mer.fishing" },
	["fletching"] = { id = "fletching", mod = "Go Fletch", luaMod = "mer.goFletch" },
	["mcfletching"] = { id = "mc_Fletching", mod = "Morrowind Crafting", luaMod = "Morrowind_Crafting_3" },
	["inscription"] = { id = "Hermes:Inscription", mod = "Demon of Knowledge", luaMod = "MMM2018.sx2" },
	["masonry"] = { id = "mc_Masonry", mod = "Morrowind Crafting", luaMod = "Morrowind_Crafting_3" },
	["metalworking"] = { id = "mc_Metalworking", mod = "Morrowind Crafting", luaMod = "Morrowind_Crafting_3" },
	["mining"] = { id = "mc_Mining", mod = "Morrowind Crafting", luaMod = "Morrowind_Crafting_3" },
	["packrat"] = { id = "Packrat", mod = "Packrat Skill", luaMod = "gool.packrat" },
	["painting"] = { id = "painting", mod = "Joy of Painting", luaMod = "mer.joyOfPainting" },
	["performance"] = { id = "BardicInspiration:Performance", mod = "Bardic Inspiration", luaMod = "mer.bardicInspiration" },
	["sewing"] = { id = "mc_Sewing", mod = "Morrowind Crafting", luaMod = "Morrowind_Crafting_3" },
	["smithing"] = { id = "mc_Smithing", mod = "Morrowind Crafting", luaMod = "Morrowind_Crafting_3" },
	["staff"] = { id = "MSS:Staff", mod = "MWSE Staff Skill", luaMod = "inpv.Staff Skill" },
	["survival"] = { id = "Ashfall:Survival", mod = "Ashfall", luaMod = "mer.ashfall" },
	["woodworking"] = { id = "mc_Woodworking", mod = "Morrowind Crafting", luaMod = "Morrowind_Crafting_3" },
}

local skillModuleSkillNames = {} ---@type string[]
for skillname, skillData in pairs(skillModuleSkills) do
	log:debug("if tes3.isLuaModActive(%s) %s", skillData.luaMod, tes3.isLuaModActive(skillData.luaMod))
	if tes3.isLuaModActive(skillData.luaMod) then table.insert(skillModuleSkillNames, skillname) end
end

---@param name string
---@param value number
local function levelUp(name, value)
	local skillModule = include("SkillsModule")
	if not skillModule then return end
	local skillData = skillModuleSkills[name:lower()]
	if not skillData then return end
	local skill = skillModule.getSkill(skillData.id)
	if not skill then return end
	skill:levelUp(value)
end

event.register("command:register", function()
	registerCommand({
		name = "levelup",
		description = "Increase the player's skill by the input value. e.g. levelup bushcrafting 69, levelup survival 420",
		arguments = {
			{ index = 1, metavar = "skillname", required = true, choices = skillModuleSkillNames, help = "the name of the skill to level up" },
			{ index = 2, metavar = "value", required = true, help = "the increase value" },
		},
		requiresInGame = true,
		callback = function(argv) levelUp(argv[1], tonumber(argv[2]) or 0) end,
	})
end)
