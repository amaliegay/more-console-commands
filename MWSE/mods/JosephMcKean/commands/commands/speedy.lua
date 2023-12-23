local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "speedy",
		description = "Increase the player's speed to 200, athletics to 200",
		requiresInGame = true,
		callback = function(argv)
			tes3.setStatistic({ reference = tes3.player, attribute = tes3.attribute.speed, value = 200 })
			tes3.setStatistic({ reference = tes3.player, skill = tes3.skill.athletics, value = 200 })
		end,
	})
end)
