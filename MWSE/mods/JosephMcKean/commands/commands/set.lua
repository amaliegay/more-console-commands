local mod = require("JosephMcKean.commands")
local registerCommands = require("JosephMcKean.commands.interop").registerCommands
local log = mod:log("set")

local names = {
	"agility",
	"endurance",
	"intelligence",
	"luck",
	"personality",
	"speed",
	"strength",
	"willpower",
	"acrobatics",
	"alchemy",
	"alteration",
	"armorer",
	"athletics",
	"axe",
	"block",
	"bluntweapon",
	"conjuration",
	"destruction",
	"enchant",
	"handtohand",
	"heavyarmor",
	"illusion",
	"lightarmor",
	"longblade",
	"marksman",
	"mediumarmor",
	"mercantile",
	"mysticism",
	"restoration",
	"security",
	"shortblade",
	"sneak",
	"spear",
	"speechcraft",
	"unarmored",
	"health",
	"magicka",
	"fatigue",
}

---@param name string
---@return string?
local function getName(name)
	local camelCased = {
		["mediumarmor"] = "mediumArmor",
		["heavyarmor"] = "heavyArmor",
		["bluntweapon"] = "bluntWeapon",
		["longblade"] = "longBlade",
		["longsword"] = "longBlade", -- alias
		["lightarmor"] = "lightArmor",
		["shortblade"] = "shortBlade",
		["handtohand"] = "handToHand",
	}
	name = camelCased[name] or name
	return name
end

event.register("command:register", function()
	registerCommands({
		{
			name = "set",
			description = "Set the current reference's attribute or skill base value",
			arguments = {
				{ index = 1, metavar = "name", required = true, choices = names, help = "the name of the attribute or skill to set" },
				{ index = 2, metavar = "value", required = true, help = "the value to set" },
			},
			requiresInGame = true,
			callback = function(argv)
				local ref = tes3ui.getConsoleReference() or tes3.player
				if not ref then return end
				if not ref.mobile then
					tes3ui.log("set: error: currentRef has no mobile.")
					return
				end
				local name = getName(argv[1])
				log:trace("set: name = %s", name)
				local value = tonumber(argv[2])
				tes3.setStatistic({ reference = ref, name = name, value = value })
				tes3ui.log("Set %s to %d on %s", name, value, ref.id)
			end,
		},
		{
			name = "max",
			description = "Set the current reference's all attributes and skills base value to the input value",
			arguments = { { index = 1, metavar = "value", required = false, help = "the value to set" } },
			requiresInGame = true,
			callback = function(argv)
				local ref = tes3ui.getConsoleReference() or tes3.player
				if not ref then return end
				local value = tonumber(argv[1]) or 200
				for _, name in ipairs(names) do tes3.setStatistic({ reference = tes3.player, name = getName(name), value = value }) end
			end,
		},
	})
end)
