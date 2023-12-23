local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "wander",
		description = "Make the current reference wander",
		requiresInGame = true,
		callback = function(argv)
			local ref = tes3ui.getConsoleReference()
			if not ref then return end
			tes3.setAIWander({ reference = ref, range = 512, idles = { 60, 20, 20, 0, 0, 0, 0, 0 } })
			-- ref.modified = true
		end,
	})
end)
