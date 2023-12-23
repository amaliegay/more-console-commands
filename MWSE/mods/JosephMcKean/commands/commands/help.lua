local interop = require("JosephMcKean.commands.interop")
local registerCommand = interop.registerCommand

event.register("command:register", function()
	registerCommand({
		name = "help",
		description = "Shows available commands",
		callback = function(argv) for cmd, data in pairs(interop.getCommands()) do if not data.hidden then tes3ui.log("%s: %s", cmd, data.description) end end end,
	})
end)
