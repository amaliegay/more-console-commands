local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "setownership",
		description = "Set ownership of the current reference to none, or the specified NPC or faction with specified base ID",
		arguments = { { index = 1, containsSpaces = true, metavar = "id", required = false, help = "the base id of the npc or faction to set ownership" } },
		requiresInGame = true,
		callback = function(argv)
			local ref = tes3ui.getConsoleReference()
			if not ref then return end
			local owner = argv[1] ~= "" and argv[1] or nil
			local faction = owner and tes3.getFaction(owner)
			local npc = owner and tes3.getObject(owner)
			if not (npc and npc.objectType == tes3.objectType.npc) then npc = nil end
			---@cast npc tes3npc?
			if not owner then
				---@diagnostic disable-next-line: missing-fields
				tes3.setOwner({ reference = ref, remove = true })
				tes3ui.log("Clear %s ownership", ref.id)
				ref.modified = true
			elseif faction then
				tes3.setOwner({ reference = ref, owner = faction })
				tes3ui.log("%s is now Faction Owned by %s", ref.id, faction.name)
			elseif npc then
				tes3.setOwner({ reference = ref, owner = npc })
				tes3ui.log("%s is now Owned by %s", ref.id, npc.name)
			else
				tes3ui.log("usage: setownership id?")
				tes3ui.log("setownership: error: argument id: invalid input.")
			end
		end,
	})
end)
