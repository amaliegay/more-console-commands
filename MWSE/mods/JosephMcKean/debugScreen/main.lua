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
	separator = tes3ui.registerID("MenuMulti_DebugScreen_separator"),
	mem = tes3ui.registerID("MenuMulti_DebugScreen_R_mem"),
	memBlock = tes3ui.registerID("MenuMulti_DebugScreen_R_mem_b"),
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
}

---@class debugScreen.debugInfo
---@field id string
---@field uiid number
---@field uiidBlock number?
---@field text string|fun():string

---@type debugScreen.debugInfo[]
local leftDebugInfo = {
	{ id = "Version", uiid = uiids.version, uiidBlock = uiids.versionBlock, text = string.format("Morrowind Script Extender %s (built %s)", mwse.buildNumber, mwse.buildDate) },
	{ id = "fps", uiid = uiids.fps, uiidBlock = uiids.fpsBlock, text = function() return "fps" end },
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
		id = "Cell",
		uiid = uiids.cell,
		uiidBlock = uiids.cellBlock,
		text = function()
			local cell = tes3.player.cell
			return string.format("Cell: %s", cell.editorName)
		end,
	},
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
			-- local background = block:createRect({ id = debugInfo.uiidBlock })
			-- background.color = tes3ui.getPalette(tes3.palette.journalFinishedQuestColor)
			-- background.alpha = 0.5
			-- background.autoWidth, background.autoHeight = true, true
			-- local label = background:createLabel({ id = debugInfo.uiid })
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
	event.register(tes3.event.keyDown, keyDown)
end)
