local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function() registerCommand({ name = "qqq", aliases = { "quitgame" }, description = "Quit Morrowind", callback = function(argv) os.exit() end }) end)
