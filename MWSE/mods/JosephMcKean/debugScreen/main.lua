local fileName = "Debug Screen"
-- DEFAULTS: F4 to show debug screen
local defaults = { keybind = { keyCode = tes3.scanCode.F4, isShiftDown = false, isAltDown = false, isControlDown = false }, logLevel = "INFO" }

---@class debugScreen.config
---@field keybind debugScreen.keybind
---@field logLevel mwseLoggerLogLevel
local config = mwse.loadConfig(fileName, defaults)

local logging = require("logging.logger")
local log = logging.new({ name = fileName, logLevel = config.logLevel })
log:info("initializing!")

---@param k1 debugScreen.keybind
---@param k2 debugScreen.keybind
local function complexKeybindTest(k1, k2) return k1.keyCode == k2.keyCode and k1.isAltDown == k2.isAltDown and k1.isControlDown == k2.isControlDown and k1.isShiftDown == k2.isShiftDown end

---@class debugScreen.keybind
---@field keyCode integer
---@field isShiftDown boolean
---@field isAltDown boolean
---@field isControlDown boolean

---@class debugScreen.uiids
local uiids = {
	menuMulti = tes3ui.registerID("MenuMulti"),
	debugScreen = tes3ui.registerID("MenuMulti_DebugScreen"),
	leftBlock = tes3ui.registerID("MenuMulti_DebugScreen_L"),
	rightBlock = tes3ui.registerID("MenuMulti_DebugScreen_R"),
	version = tes3ui.registerID("MenuMulti_DebugScreen_L_ver"),
	versionBlock = tes3ui.registerID("MenuMulti_DebugScreen_L_ver_b"),
	fps = tes3ui.registerID("MenuMulti_DebugScreen_L_fps"),
	fpsBlock = tes3ui.registerID("MenuMulti_DebugScreen_L_fps_b"),
	xyz = tes3ui.registerID("MenuMulti_DebugScreen_L_XYZ"),
	xyzBlock = tes3ui.registerID("MenuMulti_DebugScreen_L_XYZ_b"),
	cell = tes3ui.registerID("MenuMulti_DebugScreen_L_cell"),
	cellBlock = tes3ui.registerID("MenuMulti_DebugScreen_L_cell_b"),
	facing = tes3ui.registerID("MenuMulti_DebugScreen_L_facing"),
	region = tes3ui.registerID("MenuMulti_DebugScreen_L_region"),
	separator = tes3ui.registerID("MenuMulti_DebugScreen_separator"),
	mem = tes3ui.registerID("MenuMulti_DebugScreen_R_mem"),
	memBlock = tes3ui.registerID("MenuMulti_DebugScreen_R_mem_b"),
	targetedReference = tes3ui.registerID("MenuMulti_DebugScreen_R_targetedRef"),
	targetRef = tes3ui.registerID("MenuMulti_DebugScreen_R_targetRef"),
	targetBase = tes3ui.registerID("MenuMulti_DebugScreen_R_targetBase"),
	targetPos = tes3ui.registerID("MenuMulti_DebugScreen_R_targetPos"),
	hair = tes3ui.registerID("MenuMulti_DebugScreen_R_targetHair"),
	head = tes3ui.registerID("MenuMulti_DebugScreen_R_targetHead"),
	fight = tes3ui.registerID("MenuMulti_DebugScreen_R_fight"),
}

---@class debugScreen.temp
local temp = {
	---@type tes3uiElement
	menuMulti = nil,
	---@type tes3uiElement
	debugScreen = nil,
	---@type tes3uiElement
	leftBlock = nil,
	---@type tes3uiElement
	rightBlock = nil,
	---@type tes3reference?
	targetedReference = nil,
	---@type number
	fps = nil,
}

local function calcFPSTimer()
	timer.start({
		duration = 0.25,
		callback = function()
			temp.fps = temp.fps or (1 / tes3.worldController.deltaTime)
			temp.fps = temp.fps * 0.9 + (1 / tes3.worldController.deltaTime) * 0.1
		end,
		iterations = -1,
		type = timer.real,
	})
end

---@class debugScreen.debugInfo
---@field id string
---@field uiid number
---@field uiidBlock number?
---@field text string|fun():string

---@type debugScreen.debugInfo[]
local leftDebugInfo = {
	{ id = "Version", uiid = uiids.version, uiidBlock = uiids.versionBlock, text = string.format("Morrowind Script Extender %s (built %s)", mwse.buildNumber, mwse.buildDate) },
	{ id = "fps", uiid = uiids.fps, uiidBlock = uiids.fpsBlock, text = function() return string.format("%d fps Draw Distance: %d", temp.fps, mge.distantLandRenderConfig.drawDistance) end },
	{ id = "separator", uiid = uiids.separator, text = "" },
	{
		id = "XYZ",
		uiid = uiids.xyz,
		uiidBlock = uiids.xyzBlock,
		text = function()
			local position = tes3.player.position
			return string.format("XYZ: %.3f / %.3f / %.3f", position.x, position.y, position.z)
		end,
	},
	{
		id = "Facing",
		uiid = uiids.facing,
		text = function()
			local rotation = tes3.getCameraVector()
			local xyProjection = tes3vector2.new(rotation.x, rotation.y):normalized()
			local horizontalRotation = math.deg(math.atan2(xyProjection.y, xyProjection.x))
			local zSign = math.abs(rotation.z) / rotation.z
			local verticalRotation = math.deg(tes3vector3.new(rotation.x, rotation.y, 0):angle(rotation) * zSign)
			return string.format("Facing: %.3f (h) / %.3f (v)", horizontalRotation, verticalRotation)
		end,
	},
	{
		id = "Cell",
		uiid = uiids.cell,
		uiidBlock = uiids.cellBlock,
		text = function()
			local cell = tes3.player.cell
			return string.format("Cell: %s", cell.editorName)
		end,
	},
	{ id = "Region", uiid = uiids.region, text = function() return string.format("Region: %s", tes3.getRegion() or "nil") end },
}
---@type debugScreen.debugInfo[]
local rightDebugInfo = {
	{
		id = "Mem",
		uiid = uiids.mem,
		uiidBlock = uiids.memBlock,
		text = function()
			local memoryUsageInMB = mwse.getVirtualMemoryUsage() / 1024 / 1024
			local maxMemoryUsage = 4096
			return string.format("Mem: %d%% %d/%dMB", memoryUsageInMB / maxMemoryUsage * 100, memoryUsageInMB, maxMemoryUsage)
		end,
	},
	{ id = "separator", uiid = uiids.separator, text = "" },
	{
		id = "targetedReference",
		uiid = uiids.targetedReference,
		text = function()
			local result = tes3.rayTest({ position = tes3.getPlayerEyePosition(), direction = tes3.getPlayerEyeVector(), ignore = { tes3.player } })
			temp.targetedReference = result and result.reference
			if temp.targetedReference then
				local position = temp.targetedReference.position
				return string.format("Targeted Reference: %.3f, %.3f, %.3f", position.x, position.y, position.z)
			else
				return "Targeted Reference: nil"
			end
		end,
	},
	{
		id = "targetRef",
		uiid = uiids.targetRef,
		text = function()
			if temp.targetedReference then
				if temp.targetedReference.sourceMod then
					temp.refSource = temp.targetedReference.sourceMod .. ":" .. temp.targetedReference.id
					return temp.refSource
				else
					temp.refSource = temp.targetedReference.id
					return temp.refSource
				end
			else
				return ""
			end
		end,
	},
	{
		id = "targetBase",
		uiid = uiids.targetBase,
		text = function()
			if temp.targetedReference then
				local baseObject = temp.targetedReference.baseObject
				if baseObject.sourceMod then
					local baseSource = baseObject.sourceMod .. ":" .. baseObject.id
					return (baseSource == temp.refSource) and "" or baseSource
				else
					local baseSource = baseObject.id
					return (baseSource == temp.refSource) and "" or baseSource
				end
			else
				return ""
			end
		end,
	},
	{
		id = "hair",
		uiid = uiids.hair,
		text = function()
			if temp.targetedReference then
				local bodyPartManager = temp.targetedReference.bodyPartManager
				if bodyPartManager then
					local hair = bodyPartManager:getActiveBodyPart(tes3.activeBodyPartLayer.base, tes3.activeBodyPart.hair).bodyPart
					if hair then
						local hairSource = hair.sourceMod .. ":" .. hair.id
						return hairSource
					end
				end
			end
			return ""
		end,
	},
	{
		id = "head",
		uiid = uiids.head,
		text = function()
			if temp.targetedReference then
				local bodyPartManager = temp.targetedReference.bodyPartManager
				if bodyPartManager then
					local head = bodyPartManager:getActiveBodyPart(tes3.activeBodyPartLayer.base, tes3.activeBodyPart.head).bodyPart
					if head then
						local headSource = head.sourceMod .. ":" .. head.id
						return headSource
					end
				end
			end
			return ""
		end,
	},
	{
		id = "fight",
		uiid = uiids.fight,
		text = function()
			if temp.targetedReference then
				local mobile = temp.targetedReference.mobile
				if mobile then if mobile.fight then return string.format("Fight: %s", mobile.fight) end end
			end
			return ""
		end,
	},
}

local updateTimer ---@type mwseTimer?
local function updateDebugInfo()
	if not temp.menuMulti then return end
	if not temp.debugScreen then return end
	if not temp.leftBlock then return end
	for _, debugInfo in ipairs(leftDebugInfo) do
		local label = temp.leftBlock:findChild(debugInfo.uiid)
		if label then
			local text = debugInfo.text
			if type(text) == "function" then label.text = text() end
		end
	end
	if not temp.rightBlock then return end
	for _, debugInfo in ipairs(rightDebugInfo) do
		local label = temp.rightBlock:findChild(debugInfo.uiid)
		if label then
			local text = debugInfo.text
			if type(text) == "function" then label.text = text() end
		end
	end
end

---@param block tes3uiElement
---@param leftOrRight string
local function createDebugInfo(block, leftOrRight)
	local isLeft = leftOrRight == "left"
	for _, debugInfo in ipairs(isLeft and leftDebugInfo or rightDebugInfo) do
		if debugInfo.id ~= "separator" then
			local label = block:createLabel({ id = debugInfo.uiid })
			local text = debugInfo.text
			if type(text) == "function" then
				label.text = text()
			elseif type(text) == "string" then
				---@cast text string
				label.text = text
			end
		else
			block:createLabel({ id = uiids.separator, text = "" })
		end
	end
end

---@param debugScreen tes3uiElement
local function createLeftBlock(debugScreen)
	if not debugScreen then return end
	local leftBlock = debugScreen:createBlock({ id = uiids.leftBlock })
	temp.leftBlock = leftBlock
	leftBlock.flowDirection = tes3.flowDirection.topToBottom
	leftBlock.width, leftBlock.height = debugScreen.width / 2, debugScreen.height
	leftBlock.consumeMouseEvents = false
	createDebugInfo(leftBlock, "left")
end

---@param debugScreen tes3uiElement
local function createRightBlock(debugScreen)
	if not debugScreen then return end
	local rightBlock = debugScreen:createBlock({ id = uiids.rightBlock })
	temp.rightBlock = rightBlock
	rightBlock.flowDirection = tes3.flowDirection.topToBottom
	rightBlock.width, rightBlock.height = debugScreen.width / 2, debugScreen.height
	rightBlock.consumeMouseEvents = false
	rightBlock.childAlignX = 1
	createDebugInfo(rightBlock, "right")
end

---@param menu tes3uiElement
local function createDebugScreen(menu)
	if not menu then return end
	local debugScreen = menu:createBlock({ id = uiids.debugScreen })
	temp.debugScreen = debugScreen
	local width, height = tes3ui.getViewportSize()
	debugScreen.absolutePosAlignX, debugScreen.absolutePosAlignY = 0, 0
	debugScreen.flowDirection = tes3.flowDirection.leftToRight
	debugScreen.consumeMouseEvents = false
	debugScreen.borderAllSides = 20
	debugScreen.width, debugScreen.height = width - 2 * debugScreen.borderAllSides, height - 2 * debugScreen.borderAllSides
	createLeftBlock(debugScreen)
	createRightBlock(debugScreen)
end

---@param e debugScreen.keybind
local function keyDown(e)
	if not complexKeybindTest(e, config.keybind) then return end

	local menuMulti = tes3ui.findMenu(uiids.menuMulti)
	if not menuMulti then return end
	temp.menuMulti = menuMulti
	local debugScreen = menuMulti:findChild(uiids.debugScreen)
	if debugScreen then
		debugScreen:destroy()
		if updateTimer then
			updateTimer:cancel()
			updateTimer = nil
		end
	else
		createDebugScreen(menuMulti)
		updateTimer = timer.start({ duration = 0.25, callback = updateDebugInfo, iterations = -1, type = timer.real })
	end
end

event.register(tes3.event.initialized, function()
	log:info("initialized!")
	event.register(tes3.event.loaded, calcFPSTimer)
	event.register(tes3.event.keyDown, keyDown)
end)
