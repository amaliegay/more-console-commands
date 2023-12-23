local registerCommand = require("JosephMcKean.commands.interop").registerCommand

local function calm()
	for _, cell in pairs(tes3.getActiveCells()) do
		for ref in cell:iterateReferences({ tes3.objectType.creature, tes3.objectType.npc }) do
			local mobile = ref.mobile ---@cast mobile tes3mobileCreature|tes3mobileNPC
			if mobile then
				mobile.fight = 0
				if mobile.inCombat then mobile:stopCombat(true) end
			end
		end
	end
end

event.register("command:register", function()
	registerCommand({
		name = "peace",
		description = "Pacify all enemies. Irreversible",
		callback = function(argv)
			calm()
			if not event.isRegistered("cellChanged", calm) then event.register("cellChanged", calm) end
		end,
	})
end)
