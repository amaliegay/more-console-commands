local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "unlock",
		description = "Unlock lock",
		callback = function(argv)
			local ref = tes3ui.getConsoleReference()
			if not ref then return end
			tes3.unlock({ reference = ref })
		end,
	})
end)
