local config = require("JosephMcKean.commands.config")
local data = require("JosephMcKean.commands.data")
local modName = "More Console Commands"

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
	if not data.command[functionName] then
		return
	end
	table.remove(words, 1)
	data.command[functionName].callback(words)
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
	for functionName, data in pairs(data.command) do
		tes3ui.log("%s: %s", functionName, data.description)
	end
	e.block = true
end, { priority = -9999 })

local function registerModConfig()
	local template = mwse.mcm.createTemplate(modName)
	template:saveOnClose(modName, config)

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
	for functionName, data in pairs(data.command) do
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
