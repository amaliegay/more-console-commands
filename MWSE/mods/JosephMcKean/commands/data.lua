local mod = require("JosephMcKean.commands")
local log = mod:log("data")

local data = {}

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
		},
	},
}

---@type table<string, command>
data.commands = {}
data.aliases = {}

---@param cmd command.data
function data.new(cmd)
	local name = cmd.name
	log:debug("registering new command %s", name)
	name = name:lower() -- Make sure the command is lower case
	if data.commands[name] then
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

	data.commands[name] = commandData
end

return data
