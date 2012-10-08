local ADDON_NAME, Engine = ...

local L = Engine.Locales
local Config = Engine.Config
local UI = Engine.UI

if not Tukui then return end -- no Tukui detected

------------
--- Tukui
------------
local T, C, _ = unpack(Tukui)


Config.ClassRole = { -- Ripped from ElvUI
	["PALADIN"] = {
		[1] = "Caster",
		[2] = "Tank",
		[3] = "Melee",
	},
	["PRIEST"] = "Caster",
	["WARLOCK"] = "Caster",
	["WARRIOR"] = {
		[1] = "Melee",
		[2] = "Melee",
		[3] = "Tank",
	},
	["HUNTER"] = "Melee",
	["SHAMAN"] = {
		[1] = "Caster",
		[2] = "Melee",
		[3] = "Caster",
	},
	["ROGUE"] = "Melee",
	["MAGE"] = "Caster",
	["DEATHKNIGHT"] = {
		[1] = "Tank",
		[2] = "Melee",
		[3] = "Melee",
	},
	["DRUID"] = {
		[1] = "Caster",
		[2] = "Melee",
		[3] = "Tank",
		[4] = "Caster"
	},
	["MONK"] = {
		[1] = "Tank",
		[2] = "Caster",
		[3] = "Melee",
	},
}

--
UI.PetBattleHider = TukuiPetBattleHider
UI.MyClass = T.myclass

UI.SetFontString = function(parent, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(C["media"]["uffont"], fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end

UI.CreateMover = function(name, width, height, anchor, text)
	local mover = CreateFrame("Frame", name, UIParent)
	mover:SetTemplate()
	mover:SetBackdropBorderColor(1, 0, 0, 1)
	mover:SetFrameStrata("HIGH")
	mover:SetMovable(true)
	mover:Size(width, height)
	mover:Point(unpack(anchor))

	mover.text = T.SetFontString(mover, C["media"]["uffont"], 12)
	mover.text:SetPoint("CENTER")
	mover.text:SetText(text)
	mover.text.Show = function() mover:Show() end
	mover.text.Hide = function() mover:Hide() end
	mover:Hide()

	tinsert(T.AllowFrameMoving, mover)

	return mover
end