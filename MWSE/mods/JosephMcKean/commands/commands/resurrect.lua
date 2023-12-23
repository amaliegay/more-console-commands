local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "resurrect",
		description = "Resurrect the current reference and keep the inventory",
		callback = function(argv)
			local ref = tes3ui.getConsoleReference()
			if ref and ref.mobile then
				local actor = ref.mobile ---@cast actor tes3mobileNPC|tes3mobileCreature|tes3mobilePlayer
				actor:resurrect({ resetState = false })
			end
		end,
	})
end)
