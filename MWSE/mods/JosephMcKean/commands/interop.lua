---@class command.interop
local interop = {}

local common = require("JosephMcKean.commands.common")

---@param commandsData command.data[]
function interop.registerCommands(commandsData) for _, command in ipairs(commandsData) do interop.registerCommand(command) end end

---@param command command.data
function interop.registerCommand(command) common.registerCommand(command) end

---@param command string
function interop.run(command)
	local context = "lua"
	event.trigger("UIEXP:consoleCommand", { command = command, context = context }, { filter = context })
end

---@return table<string, command> commands
function interop.getCommands() return common.commands end

return interop

--[[

	Example code: 

	local command = include("JosephMcKean.commands.interop")
	if not command then
		return
	end

	event.register("command:register", function()
		command.registerCommands({
			{
				name = "killall",
				description = "Kills all non-essential NPCs within the cell the player is currently in",
				callback = function(argv)
					for npcRef in tes3.player.cell:iterateReferences(tes3.objectType.npc) do
						if not npcRef.object.isEssential then
							local mobileNPC = npcRef.mobile ---@cast mobileNPC tes3mobileNPC
							mobileNPC:kill()
						end
					end
				end,
			},
		})
	end)
]]
