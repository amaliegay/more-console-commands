local registerCommands = require("JosephMcKean.commands.interop").registerCommands

local function killAll()
	for npcRef in tes3.player.cell:iterateReferences({ tes3.objectType.npc, tes3.objectType.creature }) do
		if not npcRef.object.isEssential then
			local mobileNPC = npcRef.mobile ---@cast mobileNPC tes3mobileNPC
			mobileNPC:kill()
		end
	end
end

event.register("command:register", function()
	registerCommands({
		{
			name = "kill",
			description = "Kill the current reference. For safety reason, type kill player to kill the player",
			arguments = { { index = 1, metavar = "player", required = false, help = "specified to kill player" } },
			requiresInGame = true,
			callback = function(argv)
				local ref = tes3ui.getConsoleReference()
				if not argv[1] and ref and ref.mobile then
					local actor = ref.mobile ---@cast actor tes3mobileNPC|tes3mobileCreature|tes3mobilePlayer
					if actor ~= tes3.mobilePlayer then
						actor:kill()
					else
						tes3ui.log("For safety reason, type kill player to kill the player.")
					end
				elseif argv[1] == "player" then
					tes3.mobilePlayer:kill()
				elseif argv[1] == "all" then
					killAll()
				end
			end,
		},
		{ name = "killall", description = "Kills all non-essential NPCs and creatures within the cell the player is currently in", requiresInGame = true, callback = function(argv) killAll() end },
	})
end)
