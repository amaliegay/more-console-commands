local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "cure",
		description = "Cure current reference of disease, blight, poison, and restore attributes and skills",
		callback = function(argv)
			local ref = tes3ui.getConsoleReference() or tes3.player ---@type tes3reference
			if not ref.mobile then
				tes3ui.log("cure: error: invalid mobile")
				return
			end
			local cureCommon = tes3.getObject("Cure Common Disease Other") ---@cast cureCommon tes3spell
			local cureBlight = tes3.getObject("Cure Blight Disease") ---@cast cureBlight tes3spell
			local curePoison = tes3.getObject("Cure Poison Touch") ---@cast curePoison tes3spell
			local restoreAttribute = tes3.getObject("Almsivi Restoration") ---@cast restoreAttribute tes3spell
			local restoreSkillsFighter = tes3.getObject("Almsivi Restore Fighter") ---@cast restoreSkillsFighter tes3spell
			local restoreSkillsMage = tes3.getObject("Almsivi Restore Mage") ---@cast restoreSkillsMage tes3spell
			local restoreSkillsThief = tes3.getObject("Almsivi Restore Stealth") ---@cast restoreSkillsThief tes3spell
			local restoreSkillsOther = tes3.getObject("Almsivi Restore Other") ---@cast restoreSkillsOther tes3spell
			if ref.mobile.isDiseased then
				tes3.applyMagicSource({ reference = ref, source = cureCommon, castChance = 100, bypassResistances = true })
				tes3.applyMagicSource({ reference = ref, source = cureBlight, castChance = 100, bypassResistances = true })
			end
			if tes3.isAffectedBy({ reference = ref, effect = tes3.effect.poison }) then tes3.applyMagicSource({ reference = ref, source = curePoison, castChance = 100, bypassResistances = true }) end
			tes3.applyMagicSource({ reference = ref, source = restoreAttribute, castChance = 100, bypassResistances = true })
			-- Restore Skills
			tes3.applyMagicSource({ reference = ref, source = restoreSkillsFighter, castChance = 100, bypassResistances = true })
			tes3.applyMagicSource({ reference = ref, source = restoreSkillsMage, castChance = 100, bypassResistances = true })
			tes3.applyMagicSource({ reference = ref, source = restoreSkillsThief, castChance = 100, bypassResistances = true })
			tes3.applyMagicSource({ reference = ref, source = restoreSkillsOther, castChance = 100, bypassResistances = true })
		end,

	})
end)
