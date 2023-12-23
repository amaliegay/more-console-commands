local registerCommand = require("JosephMcKean.commands.interop").registerCommand

---@param ref tes3reference
local function removeItems(ref)
	if not ref then return end
	if not ref.object.inventory then
		tes3ui.log("error: %s does not have an inventory", ref.object.name or ref.id)
		return
	end

	for _, stack in pairs(ref.object.inventory.items) do tes3.removeItem({ reference = ref, item = stack.object, count = stack.count, playSound = false }) end
	tes3ui.log("%s inventory has been emptied.", ref.id)
end

event.register("command:register", function()
	registerCommand({
		name = "emptyinventory",
		description = "Empty the current reference's inventory",
		arguments = { { index = 1, metavar = "player", required = false, help = "specified to empty player inventory" } },
		requiresInGame = true,
		callback = function(argv)
			if argv[1] == "player" then
				removeItems(tes3.player)
				return
			end
			local ref = tes3ui.getConsoleReference()
			if not ref or (ref == tes3.player) then
				tes3ui.log("For safety reason, type emptyinventory player to empty player inventory.")
			else
				removeItems(ref)
			end
		end,
	})
end)
