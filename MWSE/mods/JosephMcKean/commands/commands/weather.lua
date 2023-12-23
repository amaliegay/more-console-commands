local registerCommand = require("JosephMcKean.commands.interop").registerCommand

local weathers = { "clear", "cloudy", "foggy", "overcast", "rain", "thunder", "ash", "blight", "snow", "blizzard" }

event.register("command:register", function()
	registerCommand({
		name = "weather",
		description = "Set current weather",
		aliases = { "forceweather", "fw" },
		arguments = { { index = 1, metavar = "weather", required = true, choices = weathers, help = "the name of the weather" } },
		callback = function(argv)
			local weatherController = tes3.worldController.weatherController
			local weather = tes3.weather[argv[1]] ---@type number?
			if weather then
				weatherController:switchImmediate(weather)
				weatherController:updateVisuals()
			end
		end,
	})
end)
