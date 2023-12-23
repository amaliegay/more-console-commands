local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "spawn",
		description = "Spawn a reference with the specified id",
		aliases = { "summon" },
		arguments = { { index = 1, metavar = "id", required = true, help = "the id of the reference to spawn" } },
		callback = function(argv)
			local id = argv and not table.empty(argv) and table.concat(argv, " ") or nil
			if not id then return end
			local obj = tes3.getObject(id)
			if not obj then
				tes3ui.log("spawn: error: %s is not a valid object id", id)
				return
			end
			tes3.createReference({ object = id, position = tes3.player.position, orientation = tes3.player.orientation, cell = tes3.player.cell })
		end,
	})
end)
