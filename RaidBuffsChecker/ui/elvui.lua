local ADDON_NAME, Engine = ...

local L = Engine.Locales
local C = Engine.Config
local UI = Engine.UI

if not ElvUI then return end -- ElvUI detected

------------
--- ElvUI
------------
local E, _, _, P, _, _ = unpack(ElvUI)

C.ClassRole = E.ClassRole

-- Hider Secure (mostly used to hide stuff while in pet battle)  ripped from Tukui
local petBattleHider = CreateFrame("Frame", "RaidBuffsCheckerPetBattleHider", UIParent, "SecureHandlerStateTemplate")
petBattleHider:SetAllPoints(UIParent)
RegisterStateDriver(petBattleHider, "visibility", "[petbattle] hide; show")

--
UI.PetBattleHider = petBattleHider
UI.MyClass = E.myclass

UI.SetFontString = function(parent, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:FontTemplate(nil, fontHeight, fontStyle)
	return fs
end

UI.CreateMover = function(name, width, height, anchor, text)
	local holder = CreateFrame("Frame", name.."HOLDER", UIParent)
	holder:Size(width, height)
	holder:Point(unpack(anchor))

	E:CreateMover(holder, name, text, true)--snapOffset, postdrag, moverTypes)

	--return holder
	return E.CreatedMovers[name].mover -- we need the mover for multiple anchors
end