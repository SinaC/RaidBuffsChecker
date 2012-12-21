local ADDON_NAME, Engine = ...

local C = Engine.Config
local UI = Engine.UI

Engine.GetRole = function()
	local spec = GetSpecialization()
	if type(C.ClassRole[UI.MyClass]) == "string" then
		return C.ClassRole[UI.MyClass]
	elseif spec then
		return C.ClassRole[UI.MyClass][spec]
	end
	return "Melee"
end

Engine.DebugPrint = function(...)
	if RaidBuffsChecker.DebugMode == true then
		local line = "RBC DEBUG:" .. strjoin(" ", ...)
		print(line)
	end
end