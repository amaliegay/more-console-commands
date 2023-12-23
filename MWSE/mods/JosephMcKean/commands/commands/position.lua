local common = require("JosephMcKean.commands.common")
local registerCommand = require("JosephMcKean.commands.interop").registerCommand

event.register("command:register", function()
	registerCommand({
		name = "position",
		description = "Teleport the player to a npc with specified id",
		alias = { "moveto" },
		arguments = { { index = 1, metavar = "id", required = true, help = "the id of the npc to teleport to" } },
		requiresInGame = true,
		callback = function(argv)
			local refId = common.concat(argv)
			if refId then
				local ref = tes3.getReference(refId)
				if ref and ref.baseObject.objectType == tes3.objectType.npc then
					tes3.positionCell({
						cell = ref.cell,
						position = tes3vector3.new(ref.position.x - 64, ref.position.y + 64, ref.position.z),
						orientation = tes3vector3.new(ref.orientation.x, ref.orientation.y, ref.orientation.z + math.pi),
					})
				end
			end
		end,
	})
end)
