local mod = require("JosephMcKean.commands")
local log = mod:log("mark")
local config = mod.config
local registerCommands = require("JosephMcKean.commands.interop").registerCommands

local function listMarks()
	if not table.empty(config.marks) then
		tes3ui.log("\nHere is a list of marks that are available:")
		for id, mark in pairs(config.marks) do tes3ui.log("%s: %s", id, mark.name) end
	else
		tes3ui.log(
		"Type mark or recall to view all marks, type mark <id> to mark, type recall <id> to recall. \nExample: mark home, recall home.\n<id> needs to be one single word like this or likethis or like_this.")
	end
end

event.register("command:register", function()
	registerCommands({
		{
			name = "mark",
			description = "Mark the player's current cell and position for recall. Type mark to view all marks, type mark <id> to mark. e.g. mark home",
			arguments = { { index = 1, metavar = "id", required = false, help = "the id of the mark" } },
			callback = function(argv)
				if not argv[1] then
					listMarks()
				else
					local cell = nil
					if tes3.player.cell.isInterior then cell = tes3.player.cell.id end
					local position = tes3.player.position
					local orientation = tes3.player.orientation
					config.marks[argv[1]] = {
						name = tes3.player.cell.editorName,
						cell = cell,
						position = { x = position.x, y = position.y, z = position.z },
						orientation = { x = orientation.x, y = orientation.y, z = orientation.z },
					}
					mwse.saveConfig(config.mod.name, config)
					tes3ui.log("%s: %s", argv[1], tes3.player.cell.editorName)
					log:info("marks[%s].cell = {\nname = %s,\ncell = %s,\nposition = { %s, %s, %s },\norientation = { %s, %s, %s }\n}", argv[1], tes3.player.cell.editorName, cell, position.x, position.y,
					         position.z, orientation.x, orientation.y, orientation.z)
				end
			end,
		},
		{
			name = "recall",
			description = "Teleport the player to a previous mark. Type recall to view all marks, type recall <id> to recall. e.g. recall home",
			arguments = { { index = 1, metavar = "id", required = false, help = "the id of the mark" } },
			callback = function(argv)
				if not argv[1] then
					listMarks()
				else
					local mark = config.marks[argv[1]]
					if mark then
						if mark.cell then
							tes3.positionCell({
								cell = tes3.getCell({ id = mark.cell }),
								position = tes3vector3.new(mark.position.x, mark.position.y, mark.position.z),
								orientation = tes3vector3.new(mark.orientation.x, mark.orientation.y, mark.orientation.z),
								forceCellChange = true,
							})
						else
							tes3.positionCell({
								position = tes3vector3.new(mark.position.x, mark.position.y, mark.position.z),
								orientation = tes3vector3.new(mark.orientation.x, mark.orientation.y),
								forceCellChange = true,
							})
						end
					end
				end
			end,
		},
	})
end)
