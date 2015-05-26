local ADDON_NAME, Engine = ...
local L = Engine.Locales
local C = Engine.Config
local UI = Engine.UI

SLASH_RAIDBUFFSCHECKER1 = "/rbc"
SLASH_RAIDBUFFSCHECKER2 = "/raidbuffschecker"

local function SlashHandlerShowHelp()
	print(string.format(L.raidbuffschecker_help_use, SLASH_RAIDBUFFSCHECKER1, SLASH_RAIDBUFFSCHECKER2))
	print(string.format(L.raidbuffschecker_help_move, SLASH_RAIDBUFFSCHECKER1))
	print(string.format(L.raidbuffschecker_help_layout, SLASH_RAIDBUFFSCHECKER1))
	print(string.format(L.L.raidbuffschecker_help_zoom, SLASH_RAIDBUFFSCHECKER1))
end

local function SlashHandlerMove(args)
	if InCombatLockdown() then print(ERR_NOT_IN_COMBAT) return end
	local enable = UI.Move()
	if not enable then
		print(string.format(L.raidbuffschecker_command_stopmoving, SLASH_RAIDBUFFSCHECKER1))
	end
end

local function SlashHandlerLayout(args)
	RaidBuffsChecker.Layout = (RaidBuffsChecker.Layout == "HORIZONTAL") and "VERTICAL" or "HORIZONTAL"
	ReloadUI()
end

local function SlashHandlerZoom(args)
	RaidBuffsChecker.Zoom = (RaidBuffsChecker.Zoom ~= true) and true or false
	ReloadUI()
end

SlashCmdList["RAIDBUFFSCHECKER"] = function(cmd)
	local switch = cmd:match("([^ ]+)")
	local args = cmd:match("[^ ]+ (.+)")
	if switch == "move" then
		SlashHandlerMove(args)
	elseif switch == "layout" then
		SlashHandlerLayout(args)
	elseif switch == "zoom" then
		SlashHandlerZoom(args)
	elseif switch == "debug" then
		RaidBuffsChecker.DebugMode = (RaidBuffsChecker.DebugMode ~= true) and true or false
	else
		SlashHandlerShowHelp()
	end
end