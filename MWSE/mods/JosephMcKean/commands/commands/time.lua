local registerCommand = require("JosephMcKean.commands.interop").registerCommand

local hours = { ["midnight"] = "1:00", ["sunrise"] = "6:00", ["day"] = "8:00", ["noon"] = "13:00", ["sunset"] = "18:00", ["night"] = "20:00" }

event.register("command:register", function()
	registerCommand({
		name = "time",
		description = "Set current ingame time",
		arguments = { { index = 1, metavar = "time", required = true, help = "the time to set, e.g. 18:23 or day/night/noon/midnight/sunrise/sunset" } },
		callback = function(argv)
			local time = hours[argv[1]] or argv[1]
			local hourStr, minuteStr = table.unpack(time:split(":"))
			local hour, minute = tonumber(hourStr), tonumber(minuteStr) or 0
			if hour then
				local minuteMod = minute % 60
				hour = hour + (minute - minuteMod) / 60
				local hourMod = hour % 24
				tes3.setGlobal("GameHour", hourMod + minuteMod / 60)
			end
		end,
	})
end)
