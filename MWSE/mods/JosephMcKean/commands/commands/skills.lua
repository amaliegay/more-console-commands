local registerCommand = require("JosephMcKean.commands.interop").registerCommand

---@param npc tes3mobileNPC
---@return table
local function getSkillsDesc(npc)
	local skills = {}
	---@param index integer
	---@param value integer
	for index, value in ipairs(npc.skills) do -- index = skillId + 1
		table.insert(skills, { index = index, value = value.current })
	end
	table.sort(skills, function(a, b) return a.value > b.value end)
	return skills
end

event.register("command:register", function()
	registerCommand({
		name = "skills",
		description = "Print the current reference's skills",
		requiresInGame = true,
		callback = function(argv)
			local ref = tes3ui.getConsoleReference()
			if not ref then
				tes3ui.log("skills: error: currentRef not found")
				return
			end
			local npc = ref.mobile
			if not npc then return end
			---@cast npc tes3mobileNPC
			tes3ui.log("%s skills:", npc.reference.object.name)
			for _, skill in ipairs(getSkillsDesc(npc)) do tes3ui.log("%s %s", tes3.skillName[skill.index - 1], skill.value) end
		end,
	})
end)
