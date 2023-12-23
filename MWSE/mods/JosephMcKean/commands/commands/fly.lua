local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "fly",
		description = "Toggle levitate",
		callback = function(argv)
			tes3.mobilePlayer.isFlying = not tes3.mobilePlayer.isFlying
			tes3ui.log("Levitate -> %s", tes3.mobilePlayer.isFlying and "On" or "Off")
		end,
	})
end)
