local interop = require("JosephMcKean.commands.interop")
local registerCommands = interop.registerCommands

event.register("command:register", function()
	registerCommands({
		{
			name = "help",
			description = "Shows available commands",
			callback = function(argv) for cmd, data in pairs(interop.getCommands()) do if not data.hidden then tes3ui.log("%s: %s", cmd, data.description) end end end,
		},
	})
end)
