local registerCommand = require("JosephMcKean.commands.interop").registerCommand

local aliases = {
	["census and excise office"] = "census and excise",
	["aundae clan"] = "clan aundae",
	["berne clan"] = "clan berne",
	["quarra clan"] = "clan quarra",
	["house hlaalu"] = "hlaalu",
	["great house hlaalu"] = "hlaalu",
	["house redoran"] = "redoran",
	["great house redoran"] = "redoran",
	["house telvanni"] = "telvanni",
	["great house telvanni"] = "telvanni",
	["tribunal temple"] = "temple",
	["imperial legions"] = "imperial legion",
}

event.register("command:register", function()
	registerCommand({
		name = "join",
		description = "Join the specified faction and raise to the specified rank.",
		aliases = { "addtofaction" },
		arguments = {
			{ index = 1, metavar = "faction-id", required = true, help = "the id of the faction you wish to join" },
			{ index = 2, metavar = "rank", required = false, help = "the rank in the faction" },
		},
		callback = function(argv)
			local rank = tonumber(argv[#argv])
			if rank then table.remove(argv, #argv) end
			local factionId = argv and not table.empty(argv) and table.concat(argv, " ") or nil
			local faction = factionId and tes3.getFaction(factionId)
			if not faction then
				tes3ui.log("join: error: factionId %s not found", factionId)
				if aliases[factionId] then tes3ui.log("Did you mean: %s", aliases[factionId]) end
				return
			end
			faction.playerJoined = true
			faction.playerRank = rank or 0
		end,
	})
end)
