local registerCommands = require("JosephMcKean.commands.interop").registerCommands

---@param ref tes3reference
local function removeItems(ref)
	if not ref then return end
	if not ref.object.inventory then
		tes3ui.log("error: %s does not have an inventory", ref.object.name or ref.id)
		return
	end
	local count = tes3.getItemCount({ reference = ref, item = "gold_001" })
	if ref then -- tes3.player might be nil
		tes3.removeItem({ reference = ref, item = "gold_001", count = count })
	end
end

---@param count number
local function giveGold(count)
	if count <= 0 then return end
	local ref = tes3ui.getConsoleReference() or tes3.player ---@type tes3reference
	if not ref then return end
	if not ref.object.inventory then
		tes3ui.log("error: %s does not have an inventory", ref.object.name or ref.id)
		return
	end
	tes3.addItem({ reference = ref, item = "gold_001", count = count, showMessage = true })
	tes3ui.log("%s gold added to %s inventory", count, ref.id)
end

event.register("command:register", function()
	registerCommands({
		{ name = "kaching", description = "Give current reference 1,000 gold", argPattern = "", callback = function() giveGold(1000) end },
		{ name = "motherlode", description = "Give current reference 50,000 gold", argPattern = "", callback = function() giveGold(50000) end },
		{
			name = "money",
			description = "Set current reference gold amount to the input value. e.g. money 420",
			arguments = { { index = 1, metavar = "goldcount", required = true, help = "the amount of gold to add" } },
			callback = function(argv)
				local ref = tes3ui.getConsoleReference() or tes3.player ---@type tes3reference
				if not ref then return end
				if not ref.object.inventory then
					tes3ui.log("error: %s does not have an inventory", ref.object.name or ref.id)
					return
				end
				local count = tonumber(argv[1])
				if not count then return end
				removeItems(ref)
				giveGold(count)
			end,
		},
	})
end)

