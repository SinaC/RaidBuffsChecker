-- Based on Tukui_RaidbuffPlus by Epicgrim

-- TODO:
--	left click on bigButton cast spell
--	button to check buff on everyone in the raid (check only food&elixir)
--	flask+elixir (one flask or 2 elixirs)
--	[DONE]mover

local ADDON_NAME, Engine = ...
local L = Engine.Locales
local C = Engine.Config
local UI = Engine.UI

-- Settings
local personalCount = 11 -- we're lucky CasterIndex and NonCasterIndex have the same size
local position = {"TOP", UIParent, "TOP", 0, -3}
local buttonSpacing = 2
local buttonSize = 20
local frameSize = (buttonSize * personalCount) + (buttonSpacing * (personalCount+1)) -- spacing - button - spacing - button - ... - button - spacing
local smallButtonSize = 20
local bigButtonSize = smallButtonSize * 2
local bigButtonSpacing = 14

-- 3 main frames
local PersonalBuff
local RaidBuff
local RaidBuffToggle

-- Personal bar
local CasterIndex = {
	[1] = C.RaidBuffs.Stats,
	[2] = C.RaidBuffs.Stamina,
	[3] = C.RaidBuffs.SpellPower,
	[4] = C.RaidBuffs.Haste,
	[5] = C.RaidBuffs.CriticalStrike,
	[6] = C.RaidBuffs.Mastery,
	[7] = C.RaidBuffs.Multistrike,
	[8] = C.RaidBuffs.Versatility,
	[9] = C.RaidBuffs.Food,
	[10] = C.RaidBuffs.Flask,
	[11] = C.RaidBuffs.BurstHaste,
	-- TODO: [8] = { [1] = { list = C.RaidBuffs.Flask, count = 1 }, [2] { list = C.RaidBuffs.Elixir, count = 2} }
}

local NonCasterIndex = {
	[1] = C.RaidBuffs.Stats,
	[2] = C.RaidBuffs.Stamina,
	[3] = C.RaidBuffs.AttackPower,
	[4] = C.RaidBuffs.Haste,
	[5] = C.RaidBuffs.CriticalStrike,
	[6] = C.RaidBuffs.Mastery,
	[7] = C.RaidBuffs.Multistrike,
	[8] = C.RaidBuffs.Versatility,
	[9] = C.RaidBuffs.Food,
	[10] = C.RaidBuffs.Flask,
	[11] = C.RaidBuffs.BurstHaste,
	-- TODO: [8] = { [1] = { list = C.RaidBuffs.Flask, count = 1 }, [2] { list = C.RaidBuffs.Elixir, count = 2} }
}

-- Raid bar
local RaidIndex = {
	[1] = C.RaidBuffs.Stats,
	[2] = C.RaidBuffs.Stamina,
	[3] = C.RaidBuffs.AttackPower,
	[4] = C.RaidBuffs.Haste,
	[5] = C.RaidBuffs.SpellPower,
	[6] = C.RaidBuffs.CriticalStrike,
	[7] = C.RaidBuffs.Mastery,
	[8] = C.RaidBuffs.Multistrike,
	[9] = C.RaidBuffs.Versatility,
}

-- http://www.wowinterface.com/forums/showthread.php?t=28868
local function VerticalText(str)
	-- Dealing with multi-byte?
	local _, len = str:gsub("[^\128-\193]", "")

	-- nah...
	if len == #str then
		return str:gsub(".", "%1\n")
	else
		return str:gsub("([%z\1-\127\194-\244][\128-\191]*)", "%1\n")
	end
end

-- If unit is affected by a spell from spellList, return spell name, spell icon, return false, default icon otherwise
local function GetIcon(unit, spellList)
	local index = 1
	for spellID in pairs(spellList) do
		if spellID ~= "default" and spellID ~= "name" then
			local spellName, _, spellIcon = GetSpellInfo(spellID)
			assert(spellName, "Incorrect spellID: "..spellID)
			if UnitAura(unit, spellName) then
				return index, spellName, spellIcon, spellID -- found
			end
			index = index+1
		end
	end
	local defaultSpellID = spellList["default"]
	local defaultIcon = select(3, GetSpellInfo(defaultSpellID))
	return 0, "", defaultIcon, defaultSpellID -- not found
end

-- Personal index management
local PersonalIndex = NonCasterIndex
local PersonalIndexHandler = CreateFrame("Frame")
PersonalIndexHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
PersonalIndexHandler:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
PersonalIndexHandler:SetScript("OnEvent", function()
	local role = Engine.GetRole() -- Caster, Melee, Tank
--print("Role:"..tostring(role))
	if role == "Caster" then
		PersonalIndex = CasterIndex
	else
		PersonalIndex = NonCasterIndex
	end
end)

-----------------------------
-- Personal buff checker
-----------------------------
local function CreatePersonalBuffFrame(layout)
	PersonalBuff = CreateFrame("Frame", "RaidBuffsCheckerPersonalFrame", UIParent)
	RegisterStateDriver(PersonalBuff, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
	PersonalBuff:SetClampedToScreen(true)
	PersonalBuff:SetTemplate()
	if layout == "HORIZONTAL" then
		PersonalBuff:Size(frameSize, buttonSize + 4)
	else
		PersonalBuff:Size(buttonSize + 4, frameSize)
	end
	PersonalBuff:Point(unpack(position))
	PersonalBuff:SetFrameLevel(Minimap:GetFrameLevel() + 2)
	-- Create button frames
	PersonalBuff.Buttons = {}
	for i = 1, personalCount do
		local button = CreateFrame("Frame", nil, PersonalBuff)
		button:SetTemplate()
		button:Size(buttonSize, buttonSize)
		if layout == "HORIZONTAL" then
			if i == 1 then
				button:Point("LEFT", PersonalBuff, "LEFT", buttonSpacing, 0)
			else
				button:Point("LEFT", PersonalBuff.Buttons[i-1], "RIGHT", buttonSpacing, 0)
			end
		else
			if i == 1 then
				button:Point("TOP", PersonalBuff, "TOP", 0, -buttonSpacing)
			else
				button:Point("TOP", PersonalBuff.Buttons[i-1], "BOTTOM", 0, -buttonSpacing)
			end
		end
		button:SetFrameLevel(PersonalBuff:GetFrameLevel() + 2)

		button.texture = button:CreateTexture(nil, "OVERLAY")
		button.texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button.texture:Point("TOPLEFT", 2, -2)
		button.texture:Point("BOTTOMRIGHT", -2, 2)

		tinsert(PersonalBuff.Buttons, button)
	end

	-- Update buff only when shown, update needed and timeout elapsed
	PersonalBuff.lastUpdate = GetTime()
	local function PersonalBuffUpdate(self, elapsed)
		local current = GetTime()
		if (self.needUpdate and current - self.lastUpdate > 1) or current - self.lastUpdate > 10 then -- no need to be hyper reactive + at least every 10 seconds (just in case we missed something)
			for i = 1, personalCount do
				local button = self.Buttons[i]
				local index, spellName, icon, spellID = GetIcon("player", PersonalIndex[i])
				button.texture:SetTexture(icon)
				if 0 ~= index then
					button.texture:SetAlpha(1.0)
				else
					button.texture:SetAlpha(0.2)
				end
			end
			self.needUpdate = false
			self.lastUpdate = GetTime()
		end
	end

	PersonalBuff:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
	PersonalBuff:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
	PersonalBuff:RegisterUnitEvent("UNIT_AURA", "player")
	PersonalBuff:RegisterEvent("PLAYER_REGEN_ENABLED")
	PersonalBuff:RegisterEvent("PLAYER_REGEN_DISABLED")
	PersonalBuff:RegisterEvent("PLAYER_ENTERING_WORLD")
	PersonalBuff:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	PersonalBuff:RegisterEvent("CHARACTER_POINTS_CHANGED")
	PersonalBuff:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	PersonalBuff:SetScript("OnEvent", function(self)
		if not C.InstanceOnly then
			self:Show()
		else
			local inInstance = IsInInstance()
			if inInstance then
				self:Show()
			else
				self:Hide()
			end
		end
		self.needUpdate = true
	end)
	PersonalBuff:SetScript("OnShow", function(self)
		self.needUpdate = true
		self:SetScript("OnUpdate", PersonalBuffUpdate)
	end)
	PersonalBuff:SetScript("OnHide", function(self)
		self:SetScript("OnUpdate", nil)
	end)
	PersonalBuff:Hide() -- starts hidden
end

-----------------------------
-- Raid
-----------------------------
-- Raid frame
--    Left                                                                                           RIGHT
--   --------                                                                                       -------- 
--  |   BIG  | Name                                                                           Name |   BIG  |
--  | BUTTON | ------- -------- -------  --------      ------- -------- -------- -------- -------- | BUTTON | 
--  |    1   | SMALL1 | SMALL2 | SMALL3 | SMALL4 |    | SMALL5 | SMALL4 | SMALL3 | SMALL2 | SMALL1 |    2   |
--   -------- -------- -------- -------- --------      -------- -------- -------- -------- -------- --------
local function CreateRaidBuffFrame(layout)
	RaidBuff = CreateFrame("Frame", "RaidBuffsCheckerFrame", PersonalBuff)
	RaidBuff:SetClampedToScreen(true)
	RaidBuff:SetTemplate()
	if layout == "HORIZONTAL" then
		RaidBuff:Size(650, 325)--RaidBuff:Size(440, 250) -- TODO: placeholder, real size will be computed later
		RaidBuff:Point("TOP", PersonalBuff, "BOTTOM", 0, -1)
	else
		RaidBuff:Size(650, 300)--RaidBuff:Size(440, 250) -- TODO: placeholder, real size will be computed later
		RaidBuff:Point("TOPLEFT", PersonalBuff, "TOPRIGHT", 1, 0)
	end
	RaidBuff:Hide()
	-- -- get maximum number of entry in spell list
	-- local maxInSpellList = 1
	-- for i = 1, #RaidIndex do
		-- local spellList = RaidIndex[i]
		-- local count = 0 -- grrrr, no API to get number of entries in table
		-- for _, _ in pairs(spellList) do count = count + 1 end
		-- if count > maxInSpellList then maxInSpellList = count end
	-- end
	-- tooltip
	local function SetTooltip(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:SetSpellByID(self.spellID)
		GameTooltip:Show()
	end
	-- create big & small buttons
	local raidBuffWidth = 0
	local raidBuffHeight = 0
	RaidBuff.BigButtons = {}
	for i = 1, #RaidIndex do
		local spellList = RaidIndex[i]
		-- big button
		local bigButton = CreateFrame("Frame", nil, RaidBuff)
		bigButton:SetTemplate()
		bigButton:Size(bigButtonSize, bigButtonSize)
		if i == 1 then -- left
			bigButton:Point("TOPLEFT", RaidBuff, "TOPLEFT", bigButtonSpacing, -bigButtonSpacing)
		elseif i == 2 then -- right
			bigButton:Point("TOPRIGHT", RaidBuff, "TOPRIGHT", -bigButtonSpacing, -bigButtonSpacing)
		elseif 1 == (i%2) then -- left
			bigButton:Point("TOPLEFT", RaidBuff.BigButtons[i-2], "BOTTOMLEFT", 0, -bigButtonSpacing)
		else -- right
			bigButton:Point("TOPRIGHT", RaidBuff.BigButtons[i-2], "BOTTOMRIGHT", 0, -bigButtonSpacing)
		end

		bigButton.texture = bigButton:CreateTexture(nil, "OVERLAY")
		bigButton.texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		bigButton.texture:Point("TOPLEFT", 2, -2)
		bigButton.texture:Point("BOTTOMRIGHT", -2, 2)

		-- virtual row with name
		-- bigButton.text = bigButton:CreateFontString(nil, "OVERLAY")
		-- if 1 == (i%2) then -- left
			-- bigButton.text:SetPoint("TOPLEFT", bigButton, "TOPRIGHT", 3, -1)
		-- else -- right
			-- bigButton.text:SetPoint("TOPRIGHT", bigButton, "TOPLEFT", -3, -1)
		-- end
		-- bigButton.text:SetFont(C.media.font, 16)
		-- bigButton.text:SetText(spellList["name"])
		bigButton.text = UI.SetFontString(bigButton, 14)
		if 1 == (i%2) then -- left
			bigButton.text:SetPoint("TOPLEFT", bigButton, "TOPRIGHT", 3, -1)
		else -- right
			bigButton.text:SetPoint("TOPRIGHT", bigButton, "TOPLEFT", -3, -1)
		end
		bigButton.text:SetText(spellList["name"])

		-- tooltip
		bigButton:SetScript("OnEnter", SetTooltip)
		bigButton:SetScript("OnLeave", GameTooltip_Hide)

		tinsert(RaidBuff.BigButtons, bigButton)

		-- small buttons
		bigButton.SmallButtons = {}
		local j = 1
		for spellID, className in pairs(spellList) do
			if spellID ~= "default" and spellID ~= "name" then
				local smallButton = CreateFrame("Frame", nil, bigButton)
				smallButton:SetTemplate()
				smallButton:Size(smallButtonSize, smallButtonSize)
				-- 1 virtual row with name and one row with buttons
				if 1 == (i%2) then -- left
					if 1 == j then
						smallButton:Point("BOTTOMLEFT", bigButton, "BOTTOMRIGHT", buttonSpacing, 0)
					else
						smallButton:Point("LEFT", bigButton.SmallButtons[j-1], "RIGHT", buttonSpacing, 0)
					end
				else -- right
					if 1 == j then
						smallButton:Point("BOTTOMRIGHT", bigButton, "BOTTOMLEFT", -buttonSpacing, 0)
					else
						smallButton:Point("RIGHT", bigButton.SmallButtons[j-1], "LEFT", -buttonSpacing, 0)
					end

				end
				smallButton.spellID = spellID
				-- texture
				local spellName, _, spellIcon = GetSpellInfo(spellID)
				assert(spellName, "Incorrect spellID: "..spellID)
				smallButton.texture = smallButton:CreateTexture(nil, "OVERLAY")
				smallButton.texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				smallButton.texture:Point("TOPLEFT", 2, -2)
				smallButton.texture:Point("BOTTOMRIGHT", -2, 2)
				smallButton.texture:SetTexture(spellIcon)
				smallButton.texture:SetAlpha(0.2)
				-- border
				if className then
					smallButton:SetBackdropBorderColor(unpack(UI.ClassColor(className)))
				end

				-- tooltip
				smallButton:SetScript("OnEnter", SetTooltip)
				smallButton:SetScript("OnLeave", GameTooltip_Hide)

				tinsert(bigButton.SmallButtons, smallButton)
				j = j + 1
			end
		end
	end

	RaidBuff:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
	RaidBuff:RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
	RaidBuff:RegisterUnitEvent("UNIT_AURA", "player")
	RaidBuff:RegisterEvent("PLAYER_REGEN_ENABLED")
	RaidBuff:RegisterEvent("PLAYER_REGEN_DISABLED")
	RaidBuff:RegisterEvent("PLAYER_ENTERING_WORLD")
	RaidBuff:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	RaidBuff:RegisterEvent("CHARACTER_POINTS_CHANGED")
	RaidBuff:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	RaidBuff:SetScript("OnEvent", function(self)
		-- inform updater
		self.needUpdate = true
	end)
end
-- Update buff only when shown, update needed and timeout elapsed
local function RaidBuffUpdate(self, elapsed)
	local current = GetTime()
	if (self.needUpdate and current - self.lastUpdate > 1) or current - self.lastUpdate > 10 then -- no need to be hyper reactive + at least every 10 seconds (just in case we missed something)
		for i = 1, #RaidIndex do
			local bigButton = self.BigButtons[i]
			local spellList = RaidIndex[i]
			local index, spellName, icon, spellID = GetIcon("player", spellList)
			bigButton.texture:SetTexture(icon)
			bigButton.spellID = spellID
			if 0 ~= index then
				bigButton.texture:SetAlpha(1.0)
			else
				bigButton.texture:SetAlpha(0.2)
			end
			local j = 1
			for spellID in pairs(spellList) do
				if spellID ~= "default" and spellID ~= "name" then
					local smallButton = bigButton.SmallButtons[j]
					if j == index then
						smallButton.texture:SetAlpha(1.0)
					else
						smallButton.texture:SetAlpha(0.2)
					end
					j = j + 1
				end
			end
		end
		self.needUpdate = false
		self.lastUpdate = GetTime()
	end
end

-----------------------------
-- Toggle button
-----------------------------
local function ShowOnHover(activate)
	if activate then
		RaidBuffToggle:SetScript("OnEnter", function(self)
			if C.NoToggleInCombat ~= true or not InCombatLockdown() then
				self:SetAlpha(1)
			end
		end)
		RaidBuffToggle:SetScript("OnLeave", function(self)
			self:SetAlpha(0)
		end)
	else
		RaidBuffToggle:SetScript("OnEnter", nil)
		RaidBuffToggle:SetScript("OnLeave", nil)
	end
end
local function CreateToggleButton(layout)
	RaidBuffToggle = CreateFrame("Frame", "RaidBuffsCheckerToggleFrame", PersonalBuff)
	RaidBuffToggle:SetTemplate()
	if layout == "HORIZONTAL" then
		RaidBuffToggle:Size(PersonalBuff:GetWidth(), 18)
		RaidBuffToggle:Point("TOP", PersonalBuff, "BOTTOM", 0, -1)
	else
		RaidBuffToggle:Size(18, PersonalBuff:GetHeight())
		RaidBuffToggle:Point("LEFT", PersonalBuff, "RIGHT", -1, 0)
	end
	RaidBuffToggle.text = UI.SetFontString(RaidBuffToggle, 12)
	RaidBuffToggle.text:SetPoint("CENTER")
	if layout == "HORIZONTAL" then
		RaidBuffToggle.text:SetText(L.raidbuffschecker_viewall)
	else
		local vText = VerticalText(L.raidbuffschecker_viewall)
		RaidBuffToggle.text:SetText(vText)
	end

	RaidBuffToggle:SetScript("OnMouseDown", function(self)
		if RaidBuff:IsShown() then
			-- Hide raid buff and attach toggle to personal (default)
			RaidBuff:Hide()
			self:ClearAllPoints()
			if layout == "HORIZONTAL" then
				self:Point("TOP", PersonalBuff, "BOTTOM", 0, -1)
				self.text:SetText(L.raidbuffschecker_viewall)
			else
				self:Point("LEFT", PersonalBuff, "RIGHT", -1, 0)
				local vText = VerticalText(L.raidbuffschecker_viewall)
				self.text:SetText(vText)
			end
			ShowOnHover(true)
			RaidBuff:SetScript("OnUpdate", nil)
		else
			-- Show raid buff and attach toggle to raid buff
			RaidBuff:Show()
			self:ClearAllPoints()
			if layout == "HORIZONTAL" then
				self:Point("BOTTOM", RaidBuff, "BOTTOM", 0, 5)
				self.text:SetText(L.raidbuffschecker_minimizeall)
			else
				self:Point("RIGHT", RaidBuff, "RIGHT", 5, 0)
				local vText = VerticalText(L.raidbuffschecker_minimizeall)
				self.text:SetText(vText)
			end
			ShowOnHover(false)
			RaidBuff.needUpdate = true
			RaidBuff.lastUpdate = GetTime() - 10 -- force update
			RaidBuff:SetScript("OnUpdate", RaidBuffUpdate)
		end
	end)
end

-- -----------------------------
-- -- Mover
-- -----------------------------
-- local function CreateMover(layout)
	-- local text = L.raidbuffschecker_move
	-- if layout == "VERTICAL" then
		-- text = VerticalText(text)
	-- end
	-- local mover = UI.CreateMover(PersonalBuff:GetName().."_MOVER", PersonalBuff:GetWidth(), PersonalBuff:GetHeight(), position, text)
	-- PersonalBuff:ClearAllPoints()
	-- PersonalBuff:Point("TOPLEFT", mover, 0, 0)
	-- return mover
-- end

----------------------------
-- Main frame
----------------------------
local frame = CreateFrame("Frame", "RaidBuffsChecker")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
	if ADDON_NAME ~= addon then return end
	frame:UnregisterEvent("ADDON_LOADED")
	-- Greetings
	print(string.format(L.raidbuffschecker_help_use, SLASH_RAIDBUFFSCHECKER1, SLASH_RAIDBUFFSCHECKER2))
	-- Saved variables defaulting
	RaidBuffsChecker = RaidBuffsChecker or {}
	RaidBuffsChecker.Layout = RaidBuffsChecker.Layout or "HORIZONTAL"
	RaidBuffsChecker.DebugMode = (RaidBuffsChecker.DebugMode ~= nil) and RaidBuffsChecker.DebugMode or false
	-- Create frames
	CreatePersonalBuffFrame(RaidBuffsChecker.Layout)
	CreateRaidBuffFrame(RaidBuffsChecker.Layout)
	CreateToggleButton(RaidBuffsChecker.Layout)
	RaidBuffToggle:SetAlpha(0) -- hidden by default
	ShowOnHover(true) -- Show on hover by default
	-- -- Create mover
	-- CreateMover(RaidBuffsChecker.Layout)
	UI.RegisterMovable(PersonalBuff)
end)