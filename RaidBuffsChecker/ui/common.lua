local ADDON_NAME, Engine = ...
local L = Engine.Locales
local UI = Engine.UI

UI.MyClass = nil

UI.SetFontString = function(parent, fontHeight, fontStyle)
	assert(false, "MUST BE OVERRIDEN IN UI COMPATIBLITY")
end

UI.ClassColor = function(className)
	assert(false, "MUST BE OVERRIDEN IN UI COMPATIBLITY")
end

UI.CreateMover = function(name, width, height, anchor, text)
	assert(false, "MUST BE OVERRIDEN IN UI COMPATIBLITY")
end