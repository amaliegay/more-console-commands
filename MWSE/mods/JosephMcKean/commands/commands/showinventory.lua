local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "showinventory",
		description = "Show the current reference's inventory",
		requiresInGame = true,
		callback = function(argv)
			local ref = tes3ui.getConsoleReference()
			if not ref then
				tes3ui.log("No target reference found")
				return
			end
			tes3ui.leaveMenuMode()
			tes3ui.findMenu("MenuConsole").visible = false
			timer.delayOneFrame(function() tes3.showContentsMenu({ reference = ref }) end)
		end,
	})
end)
