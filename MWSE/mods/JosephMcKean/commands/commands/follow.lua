local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "follow",
		description = "Make the current reference your follower",
		callback = function(argv)
			local ref = tes3ui.getConsoleReference()
			if not ref then return end
			tes3.setAIFollow({ reference = ref, target = tes3.player })
			-- ref.modified = true
		end,
	})
end)
