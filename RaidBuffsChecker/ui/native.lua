local ADDON_NAME, Engine = ...

local L = Engine.Locales
local C = Engine.Config
local UI = Engine.UI

if Tukui or ElvUI then return end

C.ClassRole = { -- Ripped from ElvUI
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


----------------------------------
-- Create a pseudo Tukui look&feel
----------------------------------

-- Credits to Tukz
local backdropcolor = { .1,.1,.1 }
local bordercolor = { .6,.6,.6 }
local blank = [[Interface\AddOns\ClassMonitor\medias\textures\blank]]
local normTex = [[Interface\AddOns\ClassMonitor\medias\textures\normTex]]
local glowTex = [[Interface\AddOns\ClassMonitor\medias\textures\glowTex]]
local normalFont = [=[Interface\Addons\ClassMonitor\medias\fonts\normal_font.ttf]=]
local ufFont = [=[Interface\Addons\ClassMonitor\medias\fonts\uf_font.ttf]=]

local floor = math.floor
local texture = blank
local backdropr, backdropg, backdropb, backdropa, borderr, borderg, borderb = 0, 0, 0, 1, 0, 0, 0

--local mult = 1
local resolution = GetCVar("gxResolution")
local uiscale = min(2, max(.64, 768/string.match(resolution, "%d+x(%d+)")))
local mult = 768 / string.match(GetCVar("gxResolution"), "%d+x(%d+)") / uiscale
--print(tostring(mult).."  "..tostring(resolution).."  "..tostring(uiscale))
local Scale = function(x)
	return mult*math.floor(x/mult+.5)
end

local function Size(frame, width, height)
	frame:SetSize(Scale(width), Scale(height or width))
end

local function Width(frame, width)
	frame:SetWidth(Scale(width))
end

local function Height(frame, height)
	frame:SetHeight(Scale(height))
end

local function Point(obj, arg1, arg2, arg3, arg4, arg5)
	-- anyone has a more elegant way for this?
	if type(arg1)=="number" then arg1 = Scale(arg1) end
	if type(arg2)=="number" then arg2 = Scale(arg2) end
	if type(arg3)=="number" then arg3 = Scale(arg3) end
	if type(arg4)=="number" then arg4 = Scale(arg4) end
	if type(arg5)=="number" then arg5 = Scale(arg5) end

	obj:SetPoint(arg1, arg2, arg3, arg4, arg5)
end

local function SetTemplate(f, t, tex)
	if tex then
		texture = normTex
	else
		texture = blank
	end

	borderr, borderg, borderb = unpack(bordercolor)
	backdropr, backdropg, backdropb = unpack(backdropcolor)

	f:SetBackdrop({
		bgFile = texture, 
		edgeFile = blank, 
		tile = false, tileSize = 0, edgeSize = mult, 
		insets = { left = -mult, right = -mult, top = -mult, bottom = -mult}
	})
	
	if t == "Transparent" then backdropa = 0.8 else backdropa = 1 end
	
	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb)
end

-- local function CreateShadow(f, t)
	-- if f.shadow then return end

	-- local shadow = CreateFrame("Frame", nil, f)
	-- shadow:SetFrameLevel(1)
	-- shadow:SetFrameStrata(f:GetFrameStrata())
	-- shadow:Point("TOPLEFT", -3, 3)
	-- shadow:Point("BOTTOMLEFT", -3, -3)
	-- shadow:Point("TOPRIGHT", 3, 3)
	-- shadow:Point("BOTTOMRIGHT", 3, -3)
	-- shadow:SetBackdrop( { 
		-- edgeFile = glowTex, edgeSize = Scale(3),
		-- insets = {left = Scale(5), right = Scale(5), top = Scale(5), bottom = Scale(5)},
	-- })
	-- shadow:SetBackdropColor(0, 0, 0, 0)
	-- shadow:SetBackdropBorderColor(0, 0, 0, 0.8)
	-- f.shadow = shadow
-- end

local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	object.Show = noop
	object:Hide()
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Size then mt.Size = Size end
	if not object.Width then mt.Width = Width end
	if not object.Height then mt.Height = Height end
	if not object.Point then mt.Point = Point end
	if not object.SetTemplate then mt.SetTemplate = SetTemplate end
	--if not object.CreateShadow then mt.CreateShadow = CreateShadow end
	if not object.Kill then mt.Kill = Kill end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end

-- Hider Secure (mostly used to hide stuff while in pet battle)  ripped from Tukui
local petBattleHider = CreateFrame("Frame", "RaidBuffsCheckerPetBattleHider", UIParent, "SecureHandlerStateTemplate")
petBattleHider:SetAllPoints(UIParent)
RegisterStateDriver(petBattleHider, "visibility", "[petbattle] hide; show")

--
UI.PetBattleHider = petBattleHider
UI.MyClass = select(2, UnitClass("player"))

UI.SetFontString = function(parent, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(ufFont, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end

UI.ClassColor = function(className)
	local class = className or UI.MyClass
	return { RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b}
end

local AllowFrameMoving = {}
UI.CreateMover = function(name, width, height, anchor, text)
	local mover = CreateFrame("Frame", name, UIParent)
	mover:SetTemplate()
	mover:SetBackdropBorderColor(1, 0, 0, 1)
	mover:SetFrameStrata("HIGH")
	mover:SetMovable(true)
	mover:Size(width, height)
	mover:Point(unpack(anchor))

	mover.text = UI.SetFontString(mover, 12)
	mover.text:SetPoint("CENTER")
	mover.text:SetText(text)
	mover.text.Show = function() mover:Show() end
	mover.text.Hide = function() mover:Hide() end
	mover:Hide()

	tinsert(AllowFrameMoving, mover)

	return mover
end

local enable = true
local origa1, origf, origa2, origx, origy
UI.Move = function()
	for i = 1, getn(AllowFrameMoving) do
		if AllowFrameMoving[i] then
			if enable then
				AllowFrameMoving[i]:EnableMouse(true)
				AllowFrameMoving[i]:RegisterForDrag("LeftButton", "RightButton")
				AllowFrameMoving[i]:SetScript("OnDragStart", function(self) 
					origa1, origf, origa2, origx, origy = AllowFrameMoving[i]:GetPoint() 
					self.moving = true 
					self:SetUserPlaced(true) 
					self:StartMoving() 
				end)
				AllowFrameMoving[i]:SetScript("OnDragStop", function(self) 
					self.moving = false 
					self:StopMovingOrSizing() 
				end)
				if AllowFrameMoving[i].text then 
					AllowFrameMoving[i].text:Show() 
				end
			else
				AllowFrameMoving[i]:EnableMouse(false)
				if AllowFrameMoving[i].moving == true then
					AllowFrameMoving[i]:StopMovingOrSizing()
					AllowFrameMoving[i]:ClearAllPoints()
					AllowFrameMoving[i]:SetPoint(origa1, origf, origa2, origx, origy)
				end
				if AllowFrameMoving[i].text then
					AllowFrameMoving[i].text:Hide()
				end
				AllowFrameMoving[i].moving = false
			end
		end
	end
	enable = not enable
end