local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "cls",
		description = "Clear console",
		callback = function(argv)
			local console = tes3ui.registerID("MenuConsole")
			if (not console) then return end
			tes3ui.findMenu(console):findChild("MenuConsole_scroll_pane"):findChild("PartScrollPane_pane"):destroyChildren()
		end,
	})
end)
