local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "paralyze",
		description = "Paralyze or unparalyze the current reference",
		callback = function(argv)
			local ref = tes3ui.getConsoleReference()
			if ref and ref.mobile then
				ref.mobile.paralyze = (ref.mobile.paralyze == 0) and 1 or 0
				tes3ui.log("%s Paralyzed -> %s", ref.id, (ref.mobile.paralyze == 0) and "False" or "True")
			end
		end,
	})
end)
