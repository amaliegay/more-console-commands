local utils = include("JosephMcKean.lib.utils")

local mod = require("JosephMcKean.commands")
local config = mod.config
local log = mod:log("main")
log:info("initializing")

local modName = "More Console Commands"

local common = require("JosephMcKean.commands.common")

--- @param e uiActivatedEventData
local function onMenuConsoleActivated(e)
	if (not e.newlyCreated) then return end

	local menuConsole = e.element
	local input = menuConsole:findChild("UIEXP:ConsoleInputBox")
	if not input then return end
	local scriptToggleButton = input.parent.parent:findChild(-984).parent
	if config.defaultLuaConsole then
		local toggleText = scriptToggleButton.text
		if toggleText ~= "lua" then scriptToggleButton:triggerEvent("mouseClick") end
	end

	input:registerBefore("keyPress", function(k)
		if not config.leftRightArrowSwitch then return end
		local key = k.data0
		if (key == -0x7FFFFFFE) or (key == -0x7FFFFFFF) then
			-- Pressing right or left
			scriptToggleButton:triggerEvent("mouseClick")
		end
	end)
end

---@param w string
---@return string
local function unquote(w)
	local word = w
	word = word:gsub("^\"", "")
	word = word:gsub("\"$", "")
	return word
end

---@param command string
---@return string? fn
---@return string[] args
local function getArgs(command)
	log:trace("getArgs(%s)", command)
	local args = {} ---@type string[]
	for w in string.gmatch(command, "%S+") do table.insert(args, unquote(w)) end
	local fn = args[1] and args[1]:lower()
	if fn then table.remove(args, 1) end
	return fn, args
end

---@param fn string 
---@param args string[]
local function parseArgs(fn, args)
	log:trace("parseArgs(%s, arg)", fn)
	local command = common.commands[fn]
	if command.requiresInGame and not tes3.player then
		tes3ui.log("Player not found. Try loading a save then recall.")
		return
	end
	if not command.caseSensitive then
		log:trace("lowercasing args")
		for i, _ in ipairs(args) do
			args[i] = args[i]:lower()
			log:trace("args[%s] = %s", i, args[i])
		end
	end
	if command.arguments then
		local errored
		local metavars = ""
		local invalidChoiceArgs = {} ---@type command.data.argument[]
		local missingMetavars = nil

		-- parsing arguments
		for _, argument in ipairs(command.arguments) do
			if argument.index == 1 and argument.containsSpaces then args = { table.concat(args, " ") } end
			metavars = metavars .. argument.metavar .. " "
			local arg = args[argument.index]

			-- missing args error
			if argument.required and not arg then
				errored = true
				missingMetavars = missingMetavars or {}
				table.insert(missingMetavars, argument.metavar .. ": " .. argument.help)
			end
			-- invalid choices error
			if argument.choices and not table.empty(argument.choices) and not table.find(argument.choices, arg) then
				errored = true
				table.insert(invalidChoiceArgs, argument)
			end
		end

		-- printing error messages
		if errored then
			tes3ui.log("usage: %s %s", fn, metavars) -- usage: money goldcount

			-- missing args error
			if missingMetavars then
				tes3ui.log("error: the following arguments are required")
				for _, missingMetavar in ipairs(missingMetavars) do tes3ui.log("    " .. missingMetavar) end
				-- error: the following arguments are required
				--     hour: the time to set, e.g. 18:23 or day/night/noon/midnight/sunrise/sunset
			end
			-- invalid choices error
			if not table.empty(invalidChoiceArgs) then
				for _, invalidChoiceArg in ipairs(invalidChoiceArgs) do
					tes3ui.log("error: argument %s: invalid choice: %s (choose from %s)", invalidChoiceArg.metavar, args[invalidChoiceArg.index], table.concat(invalidChoiceArg.choices, ", "))
					-- levelup: error: argument skillname: invalid choice: block (choose from bushcrafting, survival)
				end
			end
			return false
		end
	end
	return true
end

---@param alias string
---@return string?
local function getAlias(alias)
	log:trace("getAlias(%s)", alias)
	if common.commands[alias] then
		return alias
	elseif common.aliases[alias] then
		return common.aliases[alias]
	end
	return nil
end

local function parseCommands(e)
	if e.context ~= "lua" then return end
	if not e.command then return end
	e.command = e.command:gsub("`", "") --[[@as string]]
	log:debug("parseCommands \"%s\"", e.command)
	if not e.command then return end
	if e.command == "" then return end
	local fnAlias, args = getArgs(e.command)
	if not fnAlias then return end
	local fn = getAlias(fnAlias)
	if not fn then return end
	local parseResult = parseArgs(fn, args)
	if parseResult then common.commands[fn].callback(args) end
	e.block = true
end

---@param functionName string
---@param commandData command
local function registerAliases(functionName, commandData) if commandData.aliases then for _, alias in ipairs(commandData.aliases) do common.aliases[alias] = functionName end end end

local function registerCommands()
	local commandsDirectory = "Data Files/MWSE/mods/JosephMcKean/commands/commands/"
	utils.executeAllLuaFilesIn(commandsDirectory)
end

event.register("initialized", function()
	log:debug("registering commands")
	registerCommands()
	event.trigger("command:register")
	local commands = common.commands ---@type table<string, command>
	for functionName, commandData in pairs(commands) do
		log:debug("command %s registered", functionName)
		registerAliases(functionName, commandData)
	end
	event.register("uiActivated", onMenuConsoleActivated, { filter = "MenuConsole", priority = -9999 })
	event.register("UIEXP:consoleCommand", parseCommands)
	log:info("initialized")
end, { priority = -999 })

event.register("UIEXP:sandboxConsole", function(e) e.sandbox.command = require("JosephMcKean.commands.interop") end)

local function registerModConfig()
	local interop = require("JosephMcKean.commands.interop")
	local template = mwse.mcm.createTemplate(modName)
	template:saveOnClose(modName, config)

	local page = template:createPage()

	local settings = page:createCategory("Settings")
	settings:createYesNoButton({ label = "Press left right arrow to switch between lua and mwscript console", variable = mwse.mcm.createTableVariable({ id = "leftRightArrowSwitch", table = config }) })
	settings:createYesNoButton({ label = "Default to lua console", variable = mwse.mcm.createTableVariable({ id = "defaultLuaConsole", table = config }) })

	local info = page:createCategory("Available Commands")
	for functionName, commandData in pairs(interop.getCommands()) do info:createInfo({ text = string.format("%s: %s", functionName, commandData.description) }) end
	info:createInfo({
		text = "\nClick on the object while console menu is open to select the current reference. If nothing is selected, current reference is default to the player. \n" ..
		"For example, if nothing is selected, you type and enter money 420, the player will get 420 gold. But if fargoth is selected, fargoth will get the money instead.",
	})
	info:createInfo({ text = "\nMore detailed documentation see Docs\\More Console Commands.md or \nNexusmods page:\n" })
	info:createHyperlink({ text = "https://www.nexusmods.com/morrowind/mods/52500", url = "https://www.nexusmods.com/morrowind/mods/52500" })

	mwse.mcm.register(template)
end
event.register("modConfigReady", registerModConfig)
