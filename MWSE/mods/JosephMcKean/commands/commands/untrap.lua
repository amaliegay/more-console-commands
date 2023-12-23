local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "untrap",
		description = "Untrap trap",
		callback = function(argv)
			local ref = tes3ui.getConsoleReference()
			if not ref or not ref.lockNode or not ref.lockNode.trap then return end
			ref.lockNode.trap = nil
		end,
	})
end)
