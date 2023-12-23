local mod = require("JosephMcKean.commands")
local log = mod:log("common")

local common = {}

---@class command.data.argument
---@field index integer
---@field containsSpaces boolean? If the parameter can contain spaces. Only available for the first parameter
---@field metavar string
---@field required boolean
---@field choices string[]?
---@field help string

---@class command.data
---@field name string The name of the command
---@field description string? The description of the command
---@field hidden boolean?
---@field aliases string[]?
---@field arguments command.data.argument[]?
---@field callback fun(argv:string[]) The callback function
---@field caseSensitive boolean? If the arguments are case sensitive
---@field requiresInGame boolean?

---@class command : command.data
local command = {
	schema = {
		name = "Command",
		fields = {
			description = { type = "string", required = true },
			hidden = { type = "boolean", required = false },
			aliases = { type = "table", required = false },
			arguments = { type = "table", required = false },
			callback = { type = "function", required = true },
			caseSensitive = { type = "boolean", required = false },
			requiresInGame = { type = "boolean", required = false },
		},
	},
}

---@type table<string, command>
common.commands = {}
common.aliases = {}

---@param cmd command.data
function common.registerCommand(cmd)
	local name = cmd.name
	log:debug("registering new command %s", name)
	name = name:lower() -- Make sure the command is lower case
	if common.commands[name] then
		log:error("Attempt to create existing command `%s`.", name)
		return
	end

	local commandData = {}
	local fields = command.schema.fields
	for field, fieldData in pairs(fields) do
		if fieldData.type == "table" then
			commandData[field] = table.deepcopy(cmd[field])
		else
			commandData[field] = cmd[field]
		end
	end

	common.commands[name] = commandData
end

---@param argv table?
---@return string?
function common.concat(argv) return argv and not table.empty(argv) and table.concat(argv, " ") or nil end

return common
