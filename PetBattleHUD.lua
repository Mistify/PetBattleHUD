local A, C = unpack(Tukui or ElvUI or AsphyxiaUI or DuffedUI)
local border, offset
if ElvUI then
	border = A["media"]["bordercolor"]
	offset = -1
else
	border = C["media"]["bordercolor"]
	if not AsphyxiaUI then offset = 1 else offset = 0 end
end

local function CreatePlayerHUD(name)
	local width = 260
	local frame = CreateFrame("Frame", name, UIParent)
	frame:Hide()
	frame:Size(width, 60)
	frame:CreateBackdrop("Transparent")
	frame.backdrop:CreateShadow()

	_G[name.."IconBackdrop"] = CreateFrame("Frame", _G[name.."IconBackdrop"], frame)
	_G[name.."IconBackdrop"]:SetPoint("LEFT", frame, "LEFT", 10, 0)
	_G[name.."IconBackdrop"]:CreateBackdrop()
	_G[name.."IconBackdrop"]:Size(40)
	_G[name.."IconBackdropText"] = _G[name.."IconBackdrop"]:CreateFontString(nil, "OVERLAY")
	_G[name.."IconBackdropText"]:SetPoint("BOTTOMRIGHT", 0, 2)

	_G[name.."IconBackdropTexture"] = _G[name.."IconBackdrop"]:CreateTexture(_G[name.."IconBackdropTexture"], "MEDIUM")
	_G[name.."IconBackdropTexture"]:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	_G[name.."IconBackdropTexture"]:SetInside(_G[name.."IconBackdrop"].backdrop)

	_G[name.."IconBackdropTextureDead"] = _G[name.."IconBackdrop"]:CreateTexture(_G[name.."IconBackdropTextureDead"], "OVERLAY")
	_G[name.."IconBackdropTextureDead"]:Hide()
	_G[name.."IconBackdropTextureDead"]:SetOutside(_G[name.."IconBackdrop"].backdrop, 8, 8)
	_G[name.."IconBackdropTextureDead"]:SetTexture("Interface\\AddOns\\PetBattleHUD\\Dead")

	_G[name.."IconPetType"] = CreateFrame("Frame", _G[name.."IconPetType"], frame)
	_G[name.."IconPetType"]:Size(32)
	_G[name.."IconPetType"]:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)

	_G[name.."IconPetTypeTexture"] = _G[name.."IconPetType"]:CreateTexture(_G[name.."IconPetTypeTexture"], "OVERLAY")
	_G[name.."IconPetTypeTexture"]:SetInside(_G[name.."IconPetType"])

	_G[name.."Health"] = CreateFrame('StatusBar', _G[name.."Health"], frame)
	_G[name.."Health"]:SetPoint("LEFT", _G[name.."IconBackdrop"].backdrop, "RIGHT", 4, 1)
	_G[name.."Health"]:Size(width-110, 11)
	_G[name.."Health"]:SetFrameLevel(TukuiPetBattleHUD_Pet1:GetFrameLevel() + 2)
	_G[name.."Health"]:CreateBackdrop()
	_G[name.."HealthText"] = _G[name.."Health"]:CreateFontString(nil, "OVERLAY")
	_G[name.."HealthText"]:SetPoint("TOP", 0, (1+offset))
	_G[name.."AtkPowerIcon"] = frame:CreateTexture(nil, "OVERLAY")
	_G[name.."AtkPowerIcon"]:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
	_G[name.."AtkPowerIcon"]:Size(16)
	_G[name.."AtkPowerIcon"]:SetPoint("TOPLEFT", _G[name.."Health"].backdrop, "RIGHT", 2, 8)
	_G[name.."AtkPowerIconText"] = _G[name.."Health"]:CreateFontString(nil, "OVERLAY")
	_G[name.."AtkPowerIconText"]:SetPoint("LEFT", _G[name.."Health"].backdrop, "RIGHT", 20, 2)
	_G[name.."NameText"] = frame:CreateFontString(nil, "OVERLAY")
	_G[name.."NameText"]:SetPoint("BOTTOMLEFT", _G[name.."Health"].backdrop, "TOPLEFT", 2, 4)

	_G[name.."Experience"] = CreateFrame('StatusBar', _G[name.."Experience"], frame)
	_G[name.."Experience"]:SetPoint("TOP", _G[name.."Health"], "BOTTOM", 0, -5)
	_G[name.."Experience"]:Size(width-110, 11)
	_G[name.."Experience"]:SetFrameLevel(frame:GetFrameLevel() + 2)
	_G[name.."Experience"]:CreateBackdrop()
	_G[name.."ExperienceText"] = _G[name.."Experience"]:CreateFontString(nil, "OVERLAY")
	_G[name.."ExperienceText"]:SetPoint("TOP", 0, (1+offset))
	_G[name.."AtkSpeedIcon"] = frame:CreateTexture(_G[name.."AtkSpeedIcon"], "OVERLAY")
	_G[name.."AtkSpeedIcon"]:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
	_G[name.."AtkSpeedIcon"]:Size(16)
	_G[name.."AtkSpeedIcon"]:SetPoint("TOPLEFT", _G[name.."Experience"].backdrop, "RIGHT", 2, 8)
	_G[name.."AtkSpeedIconText"] = _G[name.."Experience"]:CreateFontString(nil, "OVERLAY")
	_G[name.."AtkSpeedIconText"]:SetPoint("LEFT", _G[name.."Experience"].backdrop, "RIGHT", 20, 0)

	for i = 1, 3 do
		_G[name.."Buff"..i] = CreateFrame("Frame", _G[name.."Buff"..i], frame)
		_G[name.."Buff"..i]:Hide()
		_G[name.."Buff"..i]:Size(30)
		_G[name.."Buff"..i]:SetTemplate()
		_G[name.."Buff"..i.."Text"] = _G[name.."Buff"..i]:CreateFontString(nil, "OVERLAY")
		_G[name.."Buff"..i.."Text"]:SetPoint("CENTER")
		_G[name.."Buff"..i.."Texture"] = _G[name.."Buff"..i]:CreateTexture(_G[name.."Buff"..i], "OVERLAY")
		_G[name.."Buff"..i.."Texture"]:SetInside(_G[name.."Buff"..i])
		_G[name.."Buff"..i.."Texture"]:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		_G[name.."Debuff"..i] = CreateFrame("Frame", _G[name.."Debuff"..i], frame)
		_G[name.."Debuff"..i]:Hide()
		_G[name.."Debuff"..i]:Size(30)
		_G[name.."Debuff"..i]:SetTemplate()
		_G[name.."Debuff"..i.."Text"] = _G[name.."Debuff"..i]:CreateFontString(nil, "OVERLAY")
		_G[name.."Debuff"..i.."Text"]:SetPoint("CENTER")
		_G[name.."Debuff"..i.."Texture"] = _G[name.."Debuff"..i]:CreateTexture(_G[name.."Debuff"..i], "OVERLAY")
		_G[name.."Debuff"..i.."Texture"]:SetInside(_G[name.."Debuff"..i])
		_G[name.."Debuff"..i.."Texture"]:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	end

	_G[name.."Buff1"]:SetPoint("TOPLEFT", frame, "TOPRIGHT", 5, 2)
	_G[name.."Buff2"]:SetPoint("TOPLEFT", _G[name.."Buff1"], "TOPRIGHT", 3, 0)
	_G[name.."Buff3"]:SetPoint("TOPLEFT", _G[name.."Buff2"], "TOPRIGHT", 3, 0)
	_G[name.."Debuff1"]:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 5, -2)
	_G[name.."Debuff2"]:SetPoint("BOTTOMLEFT", _G[name.."Debuff1"], "BOTTOMRIGHT", 3, 0)
	_G[name.."Debuff3"]:SetPoint("BOTTOMLEFT", _G[name.."Debuff2"], "BOTTOMRIGHT", 3, 0)
end

CreatePlayerHUD("TukuiPetBattleHUD_Pet1")
TukuiPetBattleHUD_Pet1:SetMovable(true)
TukuiPetBattleHUD_Pet1:EnableMouse(true)
TukuiPetBattleHUD_Pet1:RegisterForDrag("LeftButton")
TukuiPetBattleHUD_Pet1:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
TukuiPetBattleHUD_Pet1:SetScript("OnDragStop", function(self) self:StopMovingOrSizing()  end)
TukuiPetBattleHUD_Pet1:Point("RIGHT", UIParent, "BOTTOM", -200, 300)

CreatePlayerHUD("TukuiPetBattleHUD_Pet2")
TukuiPetBattleHUD_Pet2:SetParent(TukuiPetBattleHUD_Pet1)
TukuiPetBattleHUD_Pet2:Point("BOTTOM", TukuiPetBattleHUD_Pet1, "TOP", 0, 8)

CreatePlayerHUD("TukuiPetBattleHUD_Pet3")
TukuiPetBattleHUD_Pet3:SetParent(TukuiPetBattleHUD_Pet1)
TukuiPetBattleHUD_Pet3:Point("BOTTOM", TukuiPetBattleHUD_Pet2, "TOP", 0, 8)

local function CreateEnemyHUD(name, num)
	local width = 260
	local frame = CreateFrame("Frame", name, UIParent)
	frame:Hide()
	frame:Size(width, 60)
	frame:CreateBackdrop("Transparent")
	frame.backdrop:CreateShadow()
	frame:SetScript("OnShow", function()
		local targetID = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, num)
		local ownedString = C_PetJournal.GetOwnedBattlePetString(targetID)
		if not ownedString then
			frame.backdrop:SetBackdropBorderColor(1,0,0)
		else
			frame.backdrop:SetBackdropBorderColor(unpack(border))
		end
	end)

	_G[name.."IconBackdrop"] = CreateFrame("Frame", _G[name.."IconBackdrop"], frame)
	_G[name.."IconBackdrop"]:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
	_G[name.."IconBackdrop"]:CreateBackdrop()
	_G[name.."IconBackdrop"]:Size(40)
	_G[name.."IconBackdrop"]:SetScript("OnEnter", function(self,...)
		GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 2, 4)
		GameTooltip:ClearLines()
		local targetID = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, num)
		local ownedString = C_PetJournal.GetOwnedBattlePetString(targetID)
		if ownedString ~= nil then GameTooltip:AddLine(ownedString) end
		for i=1,C_PetJournal.GetNumPets(false) do 
			local petID, speciesID, _, _, level, _, _, _, _, petType, _, _, _, _, _, _, _ = C_PetJournal.GetPetInfoByIndex(i)

			if speciesID == targetID then
				local _, maxHealth, power, speed = C_PetJournal.GetPetStats(petID)
				if C_PetJournal.GetBattlePetLink(petID) then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(C_PetJournal.GetBattlePetLink(petID))
					GameTooltip:AddLine("Level "..level.."|r", 1, 1, 1)
					GameTooltip:AddLine(maxHealth, 1, 1, 1)
					GameTooltip:AddTexture("Interface\\AddOns\\PetBattleHUD\\TooltipHealthIcon")
					GameTooltip:AddLine(power, 1, 1, 1)
					GameTooltip:AddTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
					GameTooltip:AddLine(speed, 1, 1, 1)
					GameTooltip:AddTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
				end
			end
		end
		GameTooltip:Show()
	end)

	_G[name.."IconBackdrop"]:SetScript("OnLeave", function(self,...) GameTooltip:Hide() end)
	_G[name.."IconBackdropText"] = _G[name.."IconBackdrop"]:CreateFontString(nil, "OVERLAY")
	_G[name.."IconBackdropText"]:SetPoint("BOTTOMLEFT", 0, 2)

	_G[name.."IconBackdropTexture"] = _G[name.."IconBackdrop"]:CreateTexture(_G[name.."IconBackdropTexture"], "MEDIUM")
	_G[name.."IconBackdropTexture"]:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	_G[name.."IconBackdropTexture"]:SetInside(_G[name.."IconBackdrop"].backdrop)

	_G[name.."IconBackdropTextureDead"] = _G[name.."IconBackdrop"]:CreateTexture(_G[name.."IconBackdropTextureDead"], "OVERLAY")
	_G[name.."IconBackdropTextureDead"]:Hide()
	_G[name.."IconBackdropTextureDead"]:SetOutside(_G[name.."IconBackdrop"].backdrop, 8, 8)
	_G[name.."IconBackdropTextureDead"]:SetTexture("Interface\\AddOns\\PetBattleHUD\\Dead")

	_G[name.."IconPetType"] = CreateFrame("Frame", _G[name.."IconPetType"], _G[name.."IconBackdrop"])
	_G[name.."IconPetType"]:Size(32)
	_G[name.."IconPetType"]:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)

	_G[name.."IconPetTypeTexture"] =_G[name.."IconPetType"]:CreateTexture(_G[name.."IconPetTypeTexture"], "OVERLAY")
	_G[name.."IconPetTypeTexture"]:SetInside(_G[name.."IconPetType"])

	_G[name.."Health"] = CreateFrame('StatusBar', _G[name.."Health"], frame)
	_G[name.."Health"]:SetPoint("RIGHT", _G[name.."IconBackdrop"].backdrop, "LEFT", -4, 1)
	_G[name.."Health"]:Size(width-110, 11)
	_G[name.."Health"]:SetFrameLevel(frame:GetFrameLevel() + 2)
	_G[name.."Health"]:CreateBackdrop()
	_G[name.."Health"]:SetReverseFill(true)
	_G[name.."HealthText"] = _G[name.."Health"]:CreateFontString(nil, "OVERLAY")
	_G[name.."HealthText"]:SetPoint("TOP", 0, (1+offset))
	_G[name.."AtkPowerIcon"] = frame:CreateTexture(_G[name.."AtkPowerIcon"], "OVERLAY")
	_G[name.."AtkPowerIcon"]:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
	_G[name.."AtkPowerIcon"]:Size(16)
	_G[name.."AtkPowerIcon"]:SetPoint("TOPRIGHT", _G[name.."Health"].backdrop, "LEFT", -2, 8)
	_G[name.."AtkPowerIconText"] = _G[name.."Health"]:CreateFontString(nil, "OVERLAY")
	_G[name.."AtkPowerIconText"]:SetPoint("RIGHT", _G[name.."Health"].backdrop, "LEFT", -18, 0)
	_G[name.."NameText"] = frame:CreateFontString(nil, "OVERLAY")
	_G[name.."NameText"]:SetPoint("BOTTOMRIGHT", _G[name.."Health"].backdrop, "TOPRIGHT", 2, 4)

	_G[name.."Experience"] = CreateFrame('StatusBar', _G[name.."Experience"], frame)
	_G[name.."Experience"]:SetPoint("TOP", _G[name.."Health"], "BOTTOM", 0, -5)
	_G[name.."Experience"]:Size(width-110, 11)
	_G[name.."Experience"]:SetFrameLevel(frame:GetFrameLevel() + 2)
	_G[name.."Experience"]:CreateBackdrop()
	_G[name.."Experience"]:SetReverseFill(true)
	_G[name.."ExperienceText"] = _G[name.."Experience"]:CreateFontString(nil, "OVERLAY")
	_G[name.."ExperienceText"]:SetPoint("TOP", 0, (1+offset))
	_G[name.."AtkSpeedIcon"] = frame:CreateTexture(_G[name.."AtkSpeedIcon"], "OVERLAY")
	_G[name.."AtkSpeedIcon"]:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
	_G[name.."AtkSpeedIcon"]:Size(16)
	_G[name.."AtkSpeedIcon"]:SetTexCoord(1, 0, 1, 0)
	_G[name.."AtkSpeedIcon"]:SetPoint("TOPRIGHT", _G[name.."Experience"].backdrop, "LEFT", -2, 8)
	_G[name.."AtkSpeedIconText"] = _G[name.."Experience"]:CreateFontString(nil, "OVERLAY")
	_G[name.."AtkSpeedIconText"]:SetPoint("RIGHT", _G[name.."Experience"].backdrop, "LEFT", -18, 0)

	for i = 1, 3 do
		_G[name.."Buff"..i] = CreateFrame("Frame", _G[name.."Buff"..i], frame)
		_G[name.."Buff"..i]:Hide()
		_G[name.."Buff"..i]:Size(30)
		_G[name.."Buff"..i]:SetTemplate()
		_G[name.."Buff"..i.."Text"] = _G[name.."Buff"..i]:CreateFontString(nil, "OVERLAY")
		_G[name.."Buff"..i.."Text"]:SetPoint("CENTER")
		_G[name.."Buff"..i.."Texture"] = _G[name.."Buff"..i]:CreateTexture(_G[name.."Buff"..i], "OVERLAY")
		_G[name.."Buff"..i.."Texture"]:SetInside(_G[name.."Buff"..i])
		_G[name.."Buff"..i.."Texture"]:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		_G[name.."Debuff"..i] = CreateFrame("Frame", _G[name.."Debuff"..i], frame)
		_G[name.."Debuff"..i]:Hide()
		_G[name.."Debuff"..i]:Size(30)
		_G[name.."Debuff"..i]:SetTemplate()
		_G[name.."Debuff"..i.."Text"] = _G[name.."Debuff"..i]:CreateFontString(nil, "OVERLAY")
		_G[name.."Debuff"..i.."Text"]:SetPoint("CENTER")
		_G[name.."Debuff"..i.."Texture"] = _G[name.."Debuff"..i]:CreateTexture(_G[name.."Debuff"..i], "OVERLAY")
		_G[name.."Debuff"..i.."Texture"]:SetInside(_G[name.."Debuff"..i])
		_G[name.."Debuff"..i.."Texture"]:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	end

	_G[name.."Buff1"]:SetPoint("TOPRIGHT", frame, "TOPLEFT", -5, 2)
	_G[name.."Buff2"]:SetPoint("TOPRIGHT", _G[name.."Buff1"], "TOPLEFT", -3, 0)
	_G[name.."Buff3"]:SetPoint("TOPRIGHT", _G[name.."Buff2"], "TOPLEFT", -3, 0)
	_G[name.."Debuff1"]:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", -5, -2)
	_G[name.."Debuff2"]:SetPoint("BOTTOMRIGHT", _G[name.."Debuff1"], "BOTTOMLEFT", -3, 0)
	_G[name.."Debuff3"]:SetPoint("BOTTOMRIGHT", _G[name.."Debuff2"], "BOTTOMLEFT", -3, 0)
end

CreateEnemyHUD("TukuiPetBattleHUD_EnemyPet1", 1)
TukuiPetBattleHUD_EnemyPet1:SetMovable(true)
TukuiPetBattleHUD_EnemyPet1:EnableMouse(true)
TukuiPetBattleHUD_EnemyPet1:RegisterForDrag("LeftButton")
TukuiPetBattleHUD_EnemyPet1:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
TukuiPetBattleHUD_EnemyPet1:SetScript("OnDragStop", function(self) self:StopMovingOrSizing()  end)
TukuiPetBattleHUD_EnemyPet1:Point("LEFT", UIParent, "BOTTOM", 200, 300)

CreateEnemyHUD("TukuiPetBattleHUD_EnemyPet2", 2)
TukuiPetBattleHUD_EnemyPet2:SetParent(TukuiPetBattleHUD_EnemyPet1)
TukuiPetBattleHUD_EnemyPet2:Point("BOTTOM", TukuiPetBattleHUD_EnemyPet1, "TOP", 0, 8)

CreateEnemyHUD("TukuiPetBattleHUD_EnemyPet3", 3)
TukuiPetBattleHUD_EnemyPet3:SetParent(TukuiPetBattleHUD_EnemyPet1)
TukuiPetBattleHUD_EnemyPet3:Point("BOTTOM", TukuiPetBattleHUD_EnemyPet2, "TOP", 0, 8)

PetBattleFrame:HookScript("OnShow", function() TukuiPetBattleHUD_Pet1:Show() end)
PetBattleFrame:HookScript("OnHide", function()
	if not PBHShow then
		TukuiPetBattleHUD_Pet1:Hide()
	end
end)

local function PlayerPetUpdate()
	local font, fontsize, fontflag
	if ElvUI then
		font, fontsize, fontflag = A["media"].normFont, 12, "OUTLINE"
		normtex = A["media"].normTex
	else
		font, fontsize, fontflag = C["media"].pixelfont, 12, "MONOCHROMEOUTLINE"
		if AsphyxiaUI then
			if( A.client == "ruRU" ) then
				font = C["media"]["pixelfont_ru"]
				fontsize = 12
			else
				font = C["media"]["asphyxia"]
				fontsize = 10
			end
		end
		normtex = C["media"].normTex
	end
	for i = 1, 3 do
		local petID = C_PetJournal.GetPetLoadOutInfo(i)
		if petID == nil then return end
		local _, customName, level, xp, maxXp, _, _, name, icon, petType = C_PetJournal.GetPetInfoByPetID(C_PetJournal.GetPetLoadOutInfo(i))
		local hp, maxhp, power, speed, rarity = C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(i))
		local r, g, b = GetItemQualityColor(rarity-1)
		_G["TukuiPetBattleHUD_Pet"..i]:Show()
		if hp == 0 then
			_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropTexture"]:SetDesaturated(true)
			_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropTextureDead"]:Show()
		else
			_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropTexture"]:SetDesaturated(false)
			_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropTextureDead"]:Hide()
		end
		_G["TukuiPetBattleHUD_Pet"..i.."NameText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."NameText"]:SetText(customName or name)
		_G["TukuiPetBattleHUD_Pet"..i.."NameText"]:SetTextColor(r, g, b)
		_G["TukuiPetBattleHUD_Pet"..i.."IconBackdrop"].backdrop:SetBackdropBorderColor(r,g,b)
		_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropTexture"]:SetTexture(icon)
		_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropText"]:SetText(level)
		_G["TukuiPetBattleHUD_Pet"..i.."IconPetTypeTexture"]:SetTexture("Interface\\AddOns\\PetBattleHUD\\"..PET_TYPE_SUFFIX[petType])
		_G["TukuiPetBattleHUD_Pet"..i.."Health"]:SetStatusBarTexture(normtex)
		local normalized = hp/maxhp
		_G["TukuiPetBattleHUD_Pet"..i.."Health"]:GetStatusBarTexture():SetVertexColor(1-normalized, normalized, 0/255)
		_G["TukuiPetBattleHUD_Pet"..i.."HealthText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."Experience"]:SetStatusBarTexture(normtex)
		_G["TukuiPetBattleHUD_Pet"..i.."Experience"]:SetStatusBarColor(0.24,0.54,0.78)
		_G["TukuiPetBattleHUD_Pet"..i.."ExperienceText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."Buff1Text"]:SetFont(font, 20, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."Buff2Text"]:SetFont(font, 20, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."Buff3Text"]:SetFont(font, 20, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."Debuff1Text"]:SetFont(font, 20, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."Debuff2Text"]:SetFont(font, 20, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."Debuff3Text"]:SetFont(font, 20, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."AtkPowerIconText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."AtkSpeedIconText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."AtkPowerIconText"]:SetText(power)
		_G["TukuiPetBattleHUD_Pet"..i.."AtkSpeedIconText"]:SetText(speed)
		_G["TukuiPetBattleHUD_Pet"..i.."NameText"]:SetTextColor(r, g, b)
		_G["TukuiPetBattleHUD_Pet"..i.."Experience"]:SetMinMaxValues(0, maxXp)
		_G["TukuiPetBattleHUD_Pet"..i.."Experience"]:SetValue(xp)
		_G["TukuiPetBattleHUD_Pet"..i.."ExperienceText"]:SetText(xp.." / "..maxXp)
		_G["TukuiPetBattleHUD_Pet"..i.."Health"]:SetMinMaxValues(0, maxhp)
		_G["TukuiPetBattleHUD_Pet"..i.."Health"]:SetValue(hp)
		_G["TukuiPetBattleHUD_Pet"..i.."HealthText"]:SetText(hp.." / "..maxhp)
		TukuiPetBattleHUDInit = true
	end
end

local function EnemyPetUpdate()
	TukuiPetBattleHUD_EnemyPet1:Hide()
	local font, fontsize, fontflag
	if ElvUI then
		font, fontsize, fontflag = A["media"].normFont, 12, "OUTLINE"
		normtex = A["media"].normTex
	else
		font, fontsize, fontflag = C["media"].pixelfont, 12, "MONOCHROMEOUTLINE"
		if AsphyxiaUI then
			if( A.client == "ruRU" ) then
				font = C["media"]["pixelfont_ru"]
				fontsize = 12
			else
				font = C["media"]["asphyxia"]
				fontsize = 10
			end
		end
		normtex = C["media"].normTex
	end
	for i = 1, 3 do
		enemycustomName, enemyname = C_PetBattles.GetName(LE_BATTLE_PET_ENEMY, i)
		enemypower = C_PetBattles.GetPower(LE_BATTLE_PET_ENEMY, i)
		enemyspeed = C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, i)
		enemyxp, enemymaxXP = C_PetBattles.GetXP(LE_BATTLE_PET_ENEMY, i)
		enemylevel = C_PetBattles.GetLevel(LE_BATTLE_PET_ENEMY, i)
		enemyicon = C_PetBattles.GetIcon(LE_BATTLE_PET_ENEMY, i)
		enemytype = C_PetBattles.GetPetType(LE_BATTLE_PET_ENEMY, i)
		enemyquality = C_PetBattles.GetBreedQuality(LE_BATTLE_PET_ENEMY, i)
		enemyhp = C_PetBattles.GetHealth(LE_BATTLE_PET_ENEMY, i)
		enemymaxhp = C_PetBattles.GetMaxHealth(LE_BATTLE_PET_ENEMY, i)
		local er, eg, eb = GetItemQualityColor(enemyquality-1)
		local enemyframes = C_PetBattles.GetNumPets(LE_BATTLE_PET_ENEMY)
		if enemyframes == 1 then
			TukuiPetBattleHUD_EnemyPet1:Show()
		elseif enemyframes == 2 then
			TukuiPetBattleHUD_EnemyPet1:Show()
			TukuiPetBattleHUD_EnemyPet2:Show()
		elseif enemyframes == 3 then
			TukuiPetBattleHUD_EnemyPet1:Show()
			TukuiPetBattleHUD_EnemyPet2:Show()
			TukuiPetBattleHUD_EnemyPet3:Show()
		end
		_G["TukuiPetBattleHUD_EnemyPet"..i.."NameText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."NameText"]:SetText(enemycustomName or enemyname)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."NameText"]:SetTextColor(er, eg, eb)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."IconBackdrop"].backdrop:SetBackdropBorderColor(er,eg,eb)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."IconBackdropTexture"]:SetTexture(enemyicon)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."IconBackdropText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."IconBackdropText"]:SetText(enemylevel)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."IconPetTypeTexture"]:SetTexture("Interface\\AddOns\\PetBattleHUD\\"..PET_TYPE_SUFFIX[enemytype])
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Health"]:SetStatusBarTexture(normtex)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Health"]:SetStatusBarColor(0.11,0.66,0.11)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."HealthText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Experience"]:SetStatusBarTexture(normtex)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Experience"]:SetStatusBarColor(0.6,0,0.86)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."ExperienceText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."AtkPowerIconText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."AtkSpeedIconText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."AtkPowerIconText"]:SetText(enemypower)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."AtkSpeedIconText"]:SetText(enemyspeed)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."NameText"]:SetTextColor(er, eg, eb)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Experience"]:SetMinMaxValues(0, enemymaxXP)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Experience"]:SetValue(enemyxp)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."ExperienceText"]:SetText(enemyxp.." / "..enemymaxXP)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Health"]:SetMinMaxValues(0, enemymaxhp)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Health"]:SetValue(enemyhp)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."HealthText"]:SetText(enemyhp.." / "..enemymaxhp)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Buff1Text"]:SetFont(font, 20, fontflag)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Buff2Text"]:SetFont(font, 20, fontflag)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Buff3Text"]:SetFont(font, 20, fontflag)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Debuff1Text"]:SetFont(font, 20, fontflag)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Debuff2Text"]:SetFont(font, 20, fontflag)
		_G["TukuiPetBattleHUD_EnemyPet"..i.."Debuff3Text"]:SetFont(font, 20, fontflag)
		TukuiPetBattleEnemyHUDInit = true
	end
end

local function HUDSetupAuras(frame, owner, index)
	_G[frame.."Buff1"]:Hide()
	_G[frame.."Buff2"]:Hide()
	_G[frame.."Buff3"]:Hide()
	_G[frame.."Debuff1"]:Hide()
	_G[frame.."Debuff2"]:Hide()
	_G[frame.."Debuff3"]:Hide()
	for i = 1, 6 do
		auraID, instanceID, turnsRemaining, isBuff, casterOwner, casterIndex = C_PetBattles.GetAuraInfo(owner, index, i)
		if auraID then id, name, icon, maxCooldown, description = C_PetBattles.GetAbilityInfoByID(auraID) else return end
		if isBuff then
			if not _G[frame.."Buff1"]:IsShown() then
				_G[frame.."Buff1"]:Show()
				_G[frame.."Buff1"]:SetBackdropBorderColor(0,1,0)
				_G[frame.."Buff1"]:SetScript("OnEnter", function() PetBattleAbilityTooltip_Show("BOTTOMLEFT", self, "TOPLEFT", 0, 2) end)
				_G[frame.."Buff1"]:SetScript("OnLeave", function() PetBattlePrimaryAbilityTooltip:Hide() end)
				if turnsRemaining >= 0 then _G[frame.."Buff1Text"]:SetText(turnsRemaining) else _G[frame.."Buff1Text"]:SetText(" ") end
				_G[frame.."Buff1Texture"]:SetTexture(icon)
			elseif not _G[frame.."Buff2"]:IsShown() then
				_G[frame.."Buff2"]:Show()
				_G[frame.."Buff2"]:SetBackdropBorderColor(0,1,0)
				_G[frame.."Buff2"]:SetScript("OnEnter", function() PetBattleAbilityTooltip_Show("BOTTOMLEFT", self, "TOPLEFT", 0, 2) end)
				_G[frame.."Buff2"]:SetScript("OnLeave", function() PetBattlePrimaryAbilityTooltip:Hide() end)
				if turnsRemaining >= 0 then _G[frame.."Buff2Text"]:SetText(turnsRemaining) else _G[frame.."Buff2Text"]:SetText(" ") end
				_G[frame.."Buff2Texture"]:SetTexture(icon)
			elseif not _G[frame.."Buff3"]:IsShown() then
				_G[frame.."Buff3"]:Show()
				_G[frame.."Buff3"]:SetBackdropBorderColor(0,1,0)
				_G[frame.."Buff3"]:SetScript("OnEnter", function() PetBattleAbilityTooltip_Show("BOTTOMLEFT", self, "TOPLEFT", 0, 2) end)
				_G[frame.."Buff3"]:SetScript("OnLeave", function() PetBattlePrimaryAbilityTooltip:Hide() end)
				if turnsRemaining >= 0 then _G[frame.."Buff3Text"]:SetText(turnsRemaining) else _G[frame.."Buff3Text"]:SetText(" ") end
				_G[frame.."Buff3Texture"]:SetTexture(icon)
			end
		else
			if not _G[frame.."Debuff1"]:IsShown() then
				_G[frame.."Debuff1"]:Show()
				_G[frame.."Debuff1"]:SetBackdropBorderColor(1,0,0)
				_G[frame.."Debuff1"]:SetScript("OnEnter", function() PetBattleAbilityTooltip_Show("BOTTOMLEFT", self, "TOPLEFT", 0, 2) end)
				_G[frame.."Debuff1"]:SetScript("OnLeave", function() PetBattlePrimaryAbilityTooltip:Hide() end)
				if turnsRemaining >= 0 then _G[frame.."Debuff1Text"]:SetText(turnsRemaining) else _G[frame.."Debuff1Text"]:SetText(" ") end
				_G[frame.."Debuff1Texture"]:SetTexture(icon)
			elseif not _G[frame.."Debuff2"]:IsShown() then
				_G[frame.."Debuff2"]:Show()
				_G[frame.."Debuff2"]:SetBackdropBorderColor(1,0,0)
				_G[frame.."Debuff2"]:SetScript("OnEnter", function() PetBattleAbilityTooltip_Show("BOTTOMLEFT", self, "TOPLEFT", 0, 2) end)
				_G[frame.."Debuff2"]:SetScript("OnLeave", function() PetBattlePrimaryAbilityTooltip:Hide() end)
				if turnsRemaining >= 0 then _G[frame.."Debuff2Text"]:SetText(turnsRemaining) else _G[frame.."Debuff2Text"]:SetText(" ") end
				_G[frame.."Debuff2Texture"]:SetTexture(icon)
			elseif not _G[frame.."Debuff3"]:IsShown() then
				_G[frame.."Debuff3"]:Show()
				_G[frame.."Debuff3"]:SetBackdropBorderColor(1,0,0)
				_G[frame.."Debuff3"]:SetScript("OnEnter", function() PetBattleAbilityTooltip_Show("BOTTOMLEFT", self, "TOPLEFT", 0, 2) end)
				_G[frame.."Debuff3"]:SetScript("OnLeave", function() PetBattlePrimaryAbilityTooltip:Hide() end)
				if turnsRemaining >= 0 then _G[frame.."Debuff3Text"]:SetText(turnsRemaining) else _G[frame.."Debuff3Text"]:SetText(" ") end
				_G[frame.."Debuff3Texture"]:SetTexture(icon)
			end
		end
	end
end
TukuiPetBattleHUD = CreateFrame("Frame", nil, TukuiPetBattleHUD_Pet1)
TukuiPetBattleHUD:SetPoint("CENTER")
TukuiPetBattleHUD:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiPetBattleHUD:RegisterEvent("PET_BATTLE_CLOSE")
TukuiPetBattleHUD:RegisterEvent("PET_BATTLE_OPENING_START")
TukuiPetBattleHUD:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
	print("|cffC495DDTukui|r & |cff1784d1ElvUI |rPet Battle HUD by |cffD38D01Azilroka|r - Version: |cff1784d1"..GetAddOnMetadata("PetBattleHUD", "Version"))
	if PBHShow then TukuiPetBattleHUD_Pet1:Show() end
	self:SetScript("OnUpdate", function()
		local font, fontsize, fontflag
		if ElvUI then
			font, fontsize, fontflag = A["media"].normFont, 12, "OUTLINE"
			normtex = A["media"].normTex
		else
			font, fontsize, fontflag = C["media"].pixelfont, 12, "MONOCHROMEOUTLINE"
			if AsphyxiaUI then
				if( A.client == "ruRU" ) then
					font = C["media"]["pixelfont_ru"]
					fontsize = 12
				else
					font = C["media"]["asphyxia"]
					fontsize = 10
				end
			end
			normtex = C["media"].normTex
		end
		for i = 1, 3 do
			if C_PetBattles.IsInBattle() then
				if not TukuiPetBattleHUDInit then PlayerPetUpdate() end
				if not TukuiPetBattleEnemyHUDInit then EnemyPetUpdate() end
				if not oldenemy1power then oldenemy1power = C_PetBattles.GetPower(LE_BATTLE_PET_ENEMY, 1) end
				if not oldenemy1speed then oldenemy1speed = C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, 1) end
				if not oldenemy2power then oldenemy2power = C_PetBattles.GetPower(LE_BATTLE_PET_ENEMY, 2) end
				if not oldenemy2speed then oldenemy2speed = C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, 2) end
				if not oldenemy3power then oldenemy3power = C_PetBattles.GetPower(LE_BATTLE_PET_ENEMY, 3) end
				if not oldenemy3speed then oldenemy3speed = C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, 3) end
				PetBattleFrameXPBar:Hide()
				HUDSetupAuras("TukuiPetBattleHUD_Pet1", LE_BATTLE_PET_ALLY, 1)
				HUDSetupAuras("TukuiPetBattleHUD_Pet2", LE_BATTLE_PET_ALLY, 2)
				HUDSetupAuras("TukuiPetBattleHUD_Pet3", LE_BATTLE_PET_ALLY, 3)
				HUDSetupAuras("TukuiPetBattleHUD_EnemyPet1", LE_BATTLE_PET_ENEMY, 1)
				HUDSetupAuras("TukuiPetBattleHUD_EnemyPet2", LE_BATTLE_PET_ENEMY, 2)
				HUDSetupAuras("TukuiPetBattleHUD_EnemyPet3", LE_BATTLE_PET_ENEMY, 3)
				_G["TukuiPetBattleHUD_Pet"..i.."Health"]:SetMinMaxValues(0, C_PetBattles.GetMaxHealth(LE_BATTLE_PET_ALLY, i))
				_G["TukuiPetBattleHUD_Pet"..i.."Health"]:SetValue(C_PetBattles.GetHealth(LE_BATTLE_PET_ALLY, i))
				_G["TukuiPetBattleHUD_Pet"..i.."HealthText"]:SetText(C_PetBattles.GetHealth(LE_BATTLE_PET_ALLY, i).." / "..C_PetBattles.GetMaxHealth(LE_BATTLE_PET_ALLY, i))
				_G["TukuiPetBattleHUD_Pet"..i.."AtkPowerIconText"]:SetText(C_PetBattles.GetPower(LE_BATTLE_PET_ALLY, i))
				if C_PetBattles.GetPower(LE_BATTLE_PET_ALLY, i) > select(3,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(i))) then
					_G["TukuiPetBattleHUD_Pet"..i.."AtkPowerIconText"]:SetTextColor(0, 1, 0, 1)
				elseif C_PetBattles.GetPower(LE_BATTLE_PET_ALLY, i) < select(3,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(i))) then
					_G["TukuiPetBattleHUD_Pet"..i.."AtkPowerIconText"]:SetTextColor(1, 0, 0, 1)
				else
					_G["TukuiPetBattleHUD_Pet"..i.."AtkPowerIconText"]:SetTextColor(1, 1, 1, 1)
				end
				_G["TukuiPetBattleHUD_Pet"..i.."AtkSpeedIconText"]:SetText(C_PetBattles.GetSpeed(LE_BATTLE_PET_ALLY, i))
				if C_PetBattles.GetSpeed(LE_BATTLE_PET_ALLY, i) > select(4,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(i))) then
					_G["TukuiPetBattleHUD_Pet"..i.."AtkSpeedIconText"]:SetTextColor(0, 1, 0, 1)
				elseif C_PetBattles.GetSpeed(LE_BATTLE_PET_ALLY, i) < select(4,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(i))) then
					_G["TukuiPetBattleHUD_Pet"..i.."AtkSpeedIconText"]:SetTextColor(1, 0, 0, 1)
				else
					_G["TukuiPetBattleHUD_Pet"..i.."AtkSpeedIconText"]:SetTextColor(1, 1, 1, 1)
				end
				local normalizedally = C_PetBattles.GetHealth(LE_BATTLE_PET_ALLY, i) / C_PetBattles.GetMaxHealth(LE_BATTLE_PET_ALLY, i)
				_G["TukuiPetBattleHUD_Pet"..i.."Health"]:GetStatusBarTexture():SetVertexColor(1-normalizedally, normalizedally, 0/255)
				_G["TukuiPetBattleHUD_Pet"..i.."Experience"]:SetMinMaxValues(0, select(2,C_PetBattles.GetXP(LE_BATTLE_PET_ALLY, i)))
				_G["TukuiPetBattleHUD_Pet"..i.."Experience"]:SetValue(select(1,C_PetBattles.GetXP(LE_BATTLE_PET_ALLY, i)))
				_G["TukuiPetBattleHUD_Pet"..i.."ExperienceText"]:SetText(select(1,C_PetBattles.GetXP(LE_BATTLE_PET_ALLY, i)).." / "..select(2,C_PetBattles.GetXP(LE_BATTLE_PET_ALLY, i)))
				if C_PetBattles.GetHealth(LE_BATTLE_PET_ALLY, i) == 0 then
					_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropTexture"]:SetDesaturated(true)
					_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropTextureDead"]:Show()
				else
					_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropTexture"]:SetDesaturated(false)
					_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropTextureDead"]:Hide()
				end
				if C_PetBattles.GetHealth(LE_BATTLE_PET_ENEMY, i) == 0 then
					_G["TukuiPetBattleHUD_EnemyPet"..i.."IconBackdropTexture"]:SetDesaturated(true)
				else
					_G["TukuiPetBattleHUD_EnemyPet"..i.."IconBackdropTexture"]:SetDesaturated(false)
				end
				_G["TukuiPetBattleHUD_EnemyPet"..i.."Health"]:SetMinMaxValues(0, C_PetBattles.GetMaxHealth(LE_BATTLE_PET_ENEMY, i))
				_G["TukuiPetBattleHUD_EnemyPet"..i.."Health"]:SetValue(C_PetBattles.GetHealth(LE_BATTLE_PET_ENEMY, i))
				_G["TukuiPetBattleHUD_EnemyPet"..i.."HealthText"]:SetText(C_PetBattles.GetHealth(LE_BATTLE_PET_ENEMY, i).." / "..C_PetBattles.GetMaxHealth(LE_BATTLE_PET_ENEMY, i))
				_G["TukuiPetBattleHUD_EnemyPet"..i.."AtkPowerIconText"]:SetText(C_PetBattles.GetPower(LE_BATTLE_PET_ENEMY, i))

				if C_PetBattles.GetPower(LE_BATTLE_PET_ENEMY, 1) > oldenemy1power then
					TukuiPetBattleHUD_EnemyPet1AtkPowerIconText:SetTextColor(0, 1, 0, 1)
				elseif C_PetBattles.GetPower(LE_BATTLE_PET_ENEMY, 1) < oldenemy1power then
					TukuiPetBattleHUD_EnemyPet1AtkPowerIconText:SetTextColor(0, 1, 0, 1)
				else
					TukuiPetBattleHUD_EnemyPet1AtkPowerIconText:SetTextColor(1, 1, 1, 1)
				end
				if C_PetBattles.GetPower(LE_BATTLE_PET_ENEMY, 2) > oldenemy2power then
					TukuiPetBattleHUD_EnemyPet2AtkPowerIconText:SetTextColor(0, 1, 0, 1)
				elseif C_PetBattles.GetPower(LE_BATTLE_PET_ENEMY, 2) < oldenemy2power then
					TukuiPetBattleHUD_EnemyPet2AtkPowerIconText:SetTextColor(0, 1, 0, 1)
				else
					TukuiPetBattleHUD_EnemyPet2AtkPowerIconText:SetTextColor(1, 1, 1, 1)
				end
				if C_PetBattles.GetPower(LE_BATTLE_PET_ENEMY, 3) > oldenemy3power then
					TukuiPetBattleHUD_EnemyPet3AtkPowerIconText:SetTextColor(0, 1, 0, 1)
				elseif C_PetBattles.GetPower(LE_BATTLE_PET_ENEMY, 3) < oldenemy3power then
					TukuiPetBattleHUD_EnemyPet3AtkPowerIconText:SetTextColor(0, 1, 0, 1)
				else
					TukuiPetBattleHUD_EnemyPet3AtkPowerIconText:SetTextColor(1, 1, 1, 1)
				end

				_G["TukuiPetBattleHUD_EnemyPet"..i.."AtkSpeedIconText"]:SetText(C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, i))

				if C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, 1) > oldenemy1speed then
					TukuiPetBattleHUD_EnemyPet1AtkSpeedIconText:SetTextColor(0, 1, 0, 1)
				elseif C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, 1) < oldenemy1speed then
					TukuiPetBattleHUD_EnemyPet1AtkSpeedIconText:SetTextColor(0, 1, 0, 1)
				else
					TukuiPetBattleHUD_EnemyPet1AtkSpeedIconText:SetTextColor(1, 1, 1, 1)
				end
				if C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, 2) > oldenemy2speed then
					TukuiPetBattleHUD_EnemyPet2AtkSpeedIconText:SetTextColor(0, 1, 0, 1)
				elseif C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, 2) < oldenemy2speed then
					TukuiPetBattleHUD_EnemyPet2AtkSpeedIconText:SetTextColor(0, 1, 0, 1)
				else
					TukuiPetBattleHUD_EnemyPet2AtkSpeedIconText:SetTextColor(1, 1, 1, 1)
				end
				if C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, 3) > oldenemy3speed then
					TukuiPetBattleHUD_EnemyPet3AtkSpeedIconText:SetTextColor(0, 1, 0, 1)
				elseif C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, 3) < oldenemy3speed then
					TukuiPetBattleHUD_EnemyPet3AtkSpeedIconText:SetTextColor(0, 1, 0, 1)
				else
					TukuiPetBattleHUD_EnemyPet3AtkSpeedIconText:SetTextColor(1, 1, 1, 1)
				end
				if C_PetBattles.GetHealth(LE_BATTLE_PET_ENEMY, i) == 0 then
					_G["TukuiPetBattleHUD_EnemyPet"..i.."IconBackdropTexture"]:SetDesaturated(true)
					_G["TukuiPetBattleHUD_EnemyPet"..i.."IconBackdropTextureDead"]:Show()
				else
					_G["TukuiPetBattleHUD_EnemyPet"..i.."IconBackdropTexture"]:SetDesaturated(false)
					_G["TukuiPetBattleHUD_EnemyPet"..i.."IconBackdropTextureDead"]:Hide()
				end
				local normalizedenemy = C_PetBattles.GetHealth(LE_BATTLE_PET_ENEMY, i) / C_PetBattles.GetMaxHealth(LE_BATTLE_PET_ENEMY, i)
				_G["TukuiPetBattleHUD_EnemyPet"..i.."Health"]:GetStatusBarTexture():SetVertexColor(1-normalizedenemy, normalizedenemy, 0/255)
				_G["TukuiPetBattleHUD_EnemyPet"..i.."Experience"]:SetMinMaxValues(0, select(2,C_PetBattles.GetXP(LE_BATTLE_PET_ENEMY, i)))
				_G["TukuiPetBattleHUD_EnemyPet"..i.."Experience"]:SetValue(select(1,C_PetBattles.GetXP(LE_BATTLE_PET_ENEMY, i)))
				_G["TukuiPetBattleHUD_EnemyPet"..i.."ExperienceText"]:SetText(select(1,C_PetBattles.GetXP(LE_BATTLE_PET_ENEMY, i)).." / "..select(2,C_PetBattles.GetXP(LE_BATTLE_PET_ENEMY, i)))
			else
				if TukuiPetBattleHUD_Pet1:IsShown() then
					PlayerPetUpdate()
				end
			end
		end
	end)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	if event == "PET_BATTLE_CLOSE" or event == "PET_BATTLE_OPENING_START" then
		TukuiPetBattleEnemyHUDInit = nil
		oldenemy1power = nil
		oldenemy1speed = nil
		oldenemy2power = nil
		oldenemy2speed = nil
		oldenemy3power = nil
		oldenemy3speed = nil
		for i = 1, 3 do
			_G["TukuiPetBattleHUD_Pet"..i.."AtkPowerIconText"]:SetTextColor(1, 1, 1, 1)
			_G["TukuiPetBattleHUD_Pet"..i.."AtkSpeedIconText"]:SetTextColor(1, 1, 1, 1)
			_G["TukuiPetBattleHUD_EnemyPet"..i.."IconBackdropTexture"]:SetDesaturated(false)
			_G["TukuiPetBattleHUD_EnemyPet"..i.."IconBackdropTextureDead"]:Hide()
			_G["TukuiPetBattleHUD_Pet1Buff"..i]:Hide()
			_G["TukuiPetBattleHUD_Pet2Buff"..i]:Hide()
			_G["TukuiPetBattleHUD_Pet3Buff"..i]:Hide()
			_G["TukuiPetBattleHUD_Pet1Debuff"..i]:Hide()
			_G["TukuiPetBattleHUD_Pet2Debuff"..i]:Hide()
			_G["TukuiPetBattleHUD_Pet3Debuff"..i]:Hide()
			_G["TukuiPetBattleHUD_EnemyPet1Buff"..i]:Hide()
			_G["TukuiPetBattleHUD_EnemyPet2Buff"..i]:Hide()
			_G["TukuiPetBattleHUD_EnemyPet3Buff"..i]:Hide()
			_G["TukuiPetBattleHUD_EnemyPet1Debuff"..i]:Hide()
			_G["TukuiPetBattleHUD_EnemyPet2Debuff"..i]:Hide()
			_G["TukuiPetBattleHUD_EnemyPet3Debuff"..i]:Hide()
		end
		TukuiPetBattleHUD_EnemyPet3:Hide()
		TukuiPetBattleHUD_EnemyPet2:Hide()
		TukuiPetBattleHUD_EnemyPet1:Hide()
		EnemyPetUpdate()
	end
end)

PetBattleHUDCombatDetect = CreateFrame("Frame")
PetBattleHUDCombatDetect:RegisterEvent("PLAYER_REGEN_DISABLED")
PetBattleHUDCombatDetect:RegisterEvent("PLAYER_REGEN_ENABLED")
PetBattleHUDCombatDetect:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_DISABLED" or InCombatLockdown() then
		TukuiPetBattleHUD_Pet1:Hide()
	else
		if PBHShow then
			TukuiPetBattleHUD_Pet1:Show()
		end
	end
end)

SLASH_PBHUD1, SLASH_PBHUD2 = '/PBH', '/pbh'
function SlashCmdList.PBHUD(msg, editbox)
	if TukuiPetBattleHUD_Pet1:IsShown() then
		TukuiPetBattleHUD_Pet1:Hide()
		PBHShow = nil
	else
		TukuiPetBattleHUD_Pet1:Show()
		PBHShow = true
	end
end