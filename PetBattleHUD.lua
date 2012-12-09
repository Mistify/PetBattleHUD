local A, C = unpack(Tukui or ElvUI or AsphyxiaUI or DuffedUI)
local border, offset
if ElvUI then
	border = A["media"]["bordercolor"]
	offset = -1
else
	border = C["media"]["bordercolor"]
	if not AsphyxiaUI then offset = 1 else offset = 0 end
end
local width = 260

local function CreatePlayerHUD(name)
	local frame = CreateFrame("Frame", name, UIParent)
	frame:Hide()
	frame:Size(260, 60)
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
end

CreatePlayerHUD("TukuiPetBattleHUD_Pet1")
TukuiPetBattleHUD_Pet1:SetMovable(true)
TukuiPetBattleHUD_Pet1:EnableMouse(true)
TukuiPetBattleHUD_Pet1:RegisterForDrag("LeftButton")
TukuiPetBattleHUD_Pet1:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
TukuiPetBattleHUD_Pet1:SetScript("OnDragStop", function(self) self:StopMovingOrSizing()  end)
TukuiPetBattleHUD_Pet1:Point("RIGHT", UIParent, "BOTTOM", -200, 300)

CreatePlayerHUD("TukuiPetBattleHUD_Pet2")
TukuiPetBattleHUD_Pet2:Point("BOTTOM", TukuiPetBattleHUD_Pet1, "TOP", 0, 8)

CreatePlayerHUD("TukuiPetBattleHUD_Pet3")
TukuiPetBattleHUD_Pet3:Point("BOTTOM", TukuiPetBattleHUD_Pet2, "TOP", 0, 8)

--- Enemy Frames

local TukuiPetBattleHUD_EnemyPet1 = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet1", UIParent)
TukuiPetBattleHUD_EnemyPet1:Hide()
TukuiPetBattleHUD_EnemyPet1:SetMovable(true)
TukuiPetBattleHUD_EnemyPet1:EnableMouse(true)
TukuiPetBattleHUD_EnemyPet1:RegisterForDrag("LeftButton")
TukuiPetBattleHUD_EnemyPet1:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
TukuiPetBattleHUD_EnemyPet1:SetScript("OnDragStop", function(self) self:StopMovingOrSizing()  end)
TukuiPetBattleHUD_EnemyPet1:Size(width, 60)
TukuiPetBattleHUD_EnemyPet1:CreateBackdrop("Transparent")
TukuiPetBattleHUD_EnemyPet1.backdrop:CreateShadow()
TukuiPetBattleHUD_EnemyPet1:SetScript("OnShow", function()
	local targetID = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, 1)
	local ownedString = C_PetJournal.GetOwnedBattlePetString(targetID)
	if not ownedString then
		TukuiPetBattleHUD_EnemyPet1.backdrop:SetBackdropBorderColor(1,0,0)
	else
		TukuiPetBattleHUD_EnemyPet1.backdrop:SetBackdropBorderColor(unpack(border))
	end
end)
TukuiPetBattleHUD_EnemyPet1:Point("LEFT", UIParent, "BOTTOM", 200, 300)

local TukuiPetBattleHUD_EnemyPet1IconBackdrop = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet1IconBackdrop", TukuiPetBattleHUD_EnemyPet1)
TukuiPetBattleHUD_EnemyPet1IconBackdrop:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet1, "RIGHT", -10, 0)
TukuiPetBattleHUD_EnemyPet1IconBackdrop:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet1IconBackdrop:Size(40)
TukuiPetBattleHUD_EnemyPet1IconBackdrop:SetScript("OnEnter", function(self,...)
	GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 2, 4)
	GameTooltip:ClearLines()
	local targetID = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, 1)
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
TukuiPetBattleHUD_EnemyPet1IconBackdrop:SetScript("OnLeave", function(self,...) GameTooltip:Hide() end)
TukuiPetBattleHUD_EnemyPet1IconBackdropText = TukuiPetBattleHUD_EnemyPet1IconBackdrop:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet1IconBackdropText:SetPoint("BOTTOMLEFT", 0, 2)

local TukuiPetBattleHUD_EnemyPet1IconBackdropTexture = TukuiPetBattleHUD_EnemyPet1IconBackdrop:CreateTexture("TukuiPetBattleHUD_EnemyPet1IconBackdropTexture", "MEDIUM")
TukuiPetBattleHUD_EnemyPet1IconBackdropTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
TukuiPetBattleHUD_EnemyPet1IconBackdropTexture:SetInside(TukuiPetBattleHUD_EnemyPet1IconBackdrop.backdrop)
local TukuiPetBattleHUD_EnemyPet1IconBackdropTextureDead = TukuiPetBattleHUD_EnemyPet1IconBackdrop:CreateTexture("TukuiPetBattleHUD_EnemyPet1IconBackdropTextureDead", "OVERLAY")
TukuiPetBattleHUD_EnemyPet1IconBackdropTextureDead:Hide()
TukuiPetBattleHUD_EnemyPet1IconBackdropTextureDead:SetOutside(TukuiPetBattleHUD_EnemyPet1IconBackdrop.backdrop, 8, 8)
TukuiPetBattleHUD_EnemyPet1IconBackdropTextureDead:SetTexture("Interface\\AddOns\\PetBattleHUD\\Dead")

local TukuiPetBattleHUD_EnemyPet1IconPetType = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet1IconPetType", TukuiPetBattleHUD_EnemyPet1IconBackdrop)
TukuiPetBattleHUD_EnemyPet1IconPetType:Size(32)
TukuiPetBattleHUD_EnemyPet1IconPetType:SetPoint("TOPLEFT", TukuiPetBattleHUD_EnemyPet1, "TOPLEFT", 0, 0)

local TukuiPetBattleHUD_EnemyPet1IconPetTypeTexture = TukuiPetBattleHUD_EnemyPet1IconPetType:CreateTexture("TukuiPetBattleHUD_EnemyPet1IconPetTypeTexture", "OVERLAY")
TukuiPetBattleHUD_EnemyPet1IconPetTypeTexture:SetInside(TukuiPetBattleHUD_EnemyPet1IconPetType)

local TukuiPetBattleHUD_EnemyPet1Health = CreateFrame('StatusBar', "TukuiPetBattleHUD_EnemyPet1Health", TukuiPetBattleHUD_EnemyPet1)
TukuiPetBattleHUD_EnemyPet1Health:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet1IconBackdrop.backdrop, "LEFT", -4, 1)
TukuiPetBattleHUD_EnemyPet1Health:Size(width-110, 11)
TukuiPetBattleHUD_EnemyPet1Health:SetFrameLevel(TukuiPetBattleHUD_EnemyPet1:GetFrameLevel() + 2)
TukuiPetBattleHUD_EnemyPet1Health:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet1Health:SetReverseFill(true)
TukuiPetBattleHUD_EnemyPet1HealthText = TukuiPetBattleHUD_EnemyPet1Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet1HealthText:SetPoint("TOP", 0, (1+offset))
TukuiPetBattleHUD_EnemyPet1AtkPowerIcon = TukuiPetBattleHUD_EnemyPet1:CreateTexture("TukuiPetBattleHUD_EnemyPet1AtkPowerIcon", "OVERLAY")
TukuiPetBattleHUD_EnemyPet1AtkPowerIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
TukuiPetBattleHUD_EnemyPet1AtkPowerIcon:Size(16)
TukuiPetBattleHUD_EnemyPet1AtkPowerIcon:SetPoint("TOPRIGHT", TukuiPetBattleHUD_EnemyPet1Health.backdrop, "LEFT", -2, 8)
TukuiPetBattleHUD_EnemyPet1AtkPowerIconText = TukuiPetBattleHUD_EnemyPet1Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet1AtkPowerIconText:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet1Health.backdrop, "LEFT", -18, 0)
TukuiPetBattleHUD_EnemyPet1NameText = TukuiPetBattleHUD_EnemyPet1:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet1NameText:SetPoint("BOTTOMRIGHT", TukuiPetBattleHUD_EnemyPet1Health.backdrop, "TOPRIGHT", 2, 4)

local TukuiPetBattleHUD_EnemyPet1Experience = CreateFrame('StatusBar', "TukuiPetBattleHUD_EnemyPet1Experience", TukuiPetBattleHUD_EnemyPet1)
TukuiPetBattleHUD_EnemyPet1Experience:SetPoint("TOP", TukuiPetBattleHUD_EnemyPet1Health, "BOTTOM", 0, -5)
TukuiPetBattleHUD_EnemyPet1Experience:Size(width-110, 11)
TukuiPetBattleHUD_EnemyPet1Experience:SetFrameLevel(TukuiPetBattleHUD_EnemyPet1:GetFrameLevel() + 2)
TukuiPetBattleHUD_EnemyPet1Experience:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet1Experience:SetReverseFill(true)
TukuiPetBattleHUD_EnemyPet1ExperienceText = TukuiPetBattleHUD_EnemyPet1Experience:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet1ExperienceText:SetPoint("TOP", 0, (1+offset))
TukuiPetBattleHUD_EnemyPet1AtkSpeedIcon = TukuiPetBattleHUD_EnemyPet1:CreateTexture("TukuiPetBattleHUD_EnemyPet1AtkSpeedIcon", "OVERLAY")
TukuiPetBattleHUD_EnemyPet1AtkSpeedIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
TukuiPetBattleHUD_EnemyPet1AtkSpeedIcon:Size(16)
TukuiPetBattleHUD_EnemyPet1AtkSpeedIcon:SetTexCoord(1, 0, 1, 0)
TukuiPetBattleHUD_EnemyPet1AtkSpeedIcon:SetPoint("TOPRIGHT", TukuiPetBattleHUD_EnemyPet1Experience.backdrop, "LEFT", -2, 8)
TukuiPetBattleHUD_EnemyPet1AtkSpeedIconText = TukuiPetBattleHUD_EnemyPet1Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet1AtkSpeedIconText:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet1Experience.backdrop, "LEFT", -18, 0)

local TukuiPetBattleHUD_EnemyPet2 = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet2", TukuiPetBattleHUD_EnemyPet1)
TukuiPetBattleHUD_EnemyPet2:Hide()
TukuiPetBattleHUD_EnemyPet2:Size(width, 60)
TukuiPetBattleHUD_EnemyPet2:CreateBackdrop("Transparent")
TukuiPetBattleHUD_EnemyPet2.backdrop:CreateShadow()
TukuiPetBattleHUD_EnemyPet2:Point("BOTTOM", TukuiPetBattleHUD_EnemyPet1, "TOP", 0, 8)
TukuiPetBattleHUD_EnemyPet2:SetScript("OnShow", function()
	local targetID = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, 2)
	local ownedString = C_PetJournal.GetOwnedBattlePetString(targetID)
	if not ownedString then
		TukuiPetBattleHUD_EnemyPet2.backdrop:SetBackdropBorderColor(1,0,0)
	else
		TukuiPetBattleHUD_EnemyPet2.backdrop:SetBackdropBorderColor(unpack(border))
	end
end)

local TukuiPetBattleHUD_EnemyPet2IconBackdrop = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet2IconBackdrop", TukuiPetBattleHUD_EnemyPet2)
TukuiPetBattleHUD_EnemyPet2IconBackdrop:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet2, "RIGHT", -10, 0)
TukuiPetBattleHUD_EnemyPet2IconBackdrop:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet2IconBackdrop:Size(40)
TukuiPetBattleHUD_EnemyPet2IconBackdrop:SetScript("OnEnter", function(self,...)
	GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 2, 4)
	GameTooltip:ClearLines()

	local targetID = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, 2)
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
TukuiPetBattleHUD_EnemyPet2IconBackdrop:SetScript("OnLeave", function(self,...) GameTooltip:Hide() end)
TukuiPetBattleHUD_EnemyPet2IconBackdropText = TukuiPetBattleHUD_EnemyPet2IconBackdrop:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet2IconBackdropText:SetPoint("BOTTOMLEFT", 0, 2)

local TukuiPetBattleHUD_EnemyPet2IconPetType = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet2IconPetType", TukuiPetBattleHUD_EnemyPet2IconBackdrop)
TukuiPetBattleHUD_EnemyPet2IconPetType:Size(32)
TukuiPetBattleHUD_EnemyPet2IconPetType:SetPoint("TOPLEFT", TukuiPetBattleHUD_EnemyPet2, "TOPLEFT", 0, 0)

local TukuiPetBattleHUD_EnemyPet2IconPetTypeTexture = TukuiPetBattleHUD_EnemyPet2IconPetType:CreateTexture("TukuiPetBattleHUD_EnemyPet2IconPetTypeTexture", "OVERLAY")
TukuiPetBattleHUD_EnemyPet2IconPetTypeTexture:SetInside(TukuiPetBattleHUD_EnemyPet2IconPetType)

local TukuiPetBattleHUD_EnemyPet2IconBackdropTexture = TukuiPetBattleHUD_EnemyPet2IconBackdrop:CreateTexture("TukuiPetBattleHUD_EnemyPet2IconBackdropTexture", "MEDIUM")
TukuiPetBattleHUD_EnemyPet2IconBackdropTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
TukuiPetBattleHUD_EnemyPet2IconBackdropTexture:SetInside(TukuiPetBattleHUD_EnemyPet2IconBackdrop.backdrop)
local TukuiPetBattleHUD_EnemyPet2IconBackdropTextureDead = TukuiPetBattleHUD_EnemyPet2IconBackdrop:CreateTexture("TukuiPetBattleHUD_EnemyPet2IconBackdropTextureDead", "OVERLAY")
TukuiPetBattleHUD_EnemyPet2IconBackdropTextureDead:Hide()
TukuiPetBattleHUD_EnemyPet2IconBackdropTextureDead:SetOutside(TukuiPetBattleHUD_EnemyPet2IconBackdrop.backdrop, 8, 8)
TukuiPetBattleHUD_EnemyPet2IconBackdropTextureDead:SetTexture("Interface\\AddOns\\PetBattleHUD\\Dead")

local TukuiPetBattleHUD_EnemyPet2Health = CreateFrame('StatusBar', "TukuiPetBattleHUD_EnemyPet2Health", TukuiPetBattleHUD_EnemyPet2)
TukuiPetBattleHUD_EnemyPet2Health:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet2IconBackdrop.backdrop, "LEFT", -4, 1)
TukuiPetBattleHUD_EnemyPet2Health:Size(width-110, 11)
TukuiPetBattleHUD_EnemyPet2Health:SetFrameLevel(TukuiPetBattleHUD_EnemyPet2:GetFrameLevel() + 2)
TukuiPetBattleHUD_EnemyPet2Health:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet2Health:SetReverseFill(true)
TukuiPetBattleHUD_EnemyPet2HealthText = TukuiPetBattleHUD_EnemyPet2Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet2HealthText:SetPoint("TOP", 0, (1+offset))
TukuiPetBattleHUD_EnemyPet2AtkPowerIcon = TukuiPetBattleHUD_EnemyPet2:CreateTexture("TukuiPetBattleHUD_EnemyPet2AtkPowerIcon", "OVERLAY")
TukuiPetBattleHUD_EnemyPet2AtkPowerIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
TukuiPetBattleHUD_EnemyPet2AtkPowerIcon:Size(16)
TukuiPetBattleHUD_EnemyPet2AtkPowerIcon:SetPoint("TOPRIGHT", TukuiPetBattleHUD_EnemyPet2Health.backdrop, "LEFT", -2, 8)
TukuiPetBattleHUD_EnemyPet2AtkPowerIconText = TukuiPetBattleHUD_EnemyPet2Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet2AtkPowerIconText:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet2Health.backdrop, "LEFT", -18, 0)
TukuiPetBattleHUD_EnemyPet2NameText = TukuiPetBattleHUD_EnemyPet2:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet2NameText:SetPoint("BOTTOMRIGHT", TukuiPetBattleHUD_EnemyPet2Health.backdrop, "TOPRIGHT", 2, 4)

local TukuiPetBattleHUD_EnemyPet2Experience = CreateFrame('StatusBar', "TukuiPetBattleHUD_EnemyPet2Experience", TukuiPetBattleHUD_EnemyPet2)
TukuiPetBattleHUD_EnemyPet2Experience:SetPoint("TOP", TukuiPetBattleHUD_EnemyPet2Health, "BOTTOM", 0, -5)
TukuiPetBattleHUD_EnemyPet2Experience:Size(width-110, 11)
TukuiPetBattleHUD_EnemyPet2Experience:SetFrameLevel(TukuiPetBattleHUD_EnemyPet2:GetFrameLevel() + 2)
TukuiPetBattleHUD_EnemyPet2Experience:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet2Experience:SetReverseFill(true)
TukuiPetBattleHUD_EnemyPet2ExperienceText = TukuiPetBattleHUD_EnemyPet2Experience:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet2ExperienceText:SetPoint("TOP", 0, (1+offset))
TukuiPetBattleHUD_EnemyPet2AtkSpeedIcon = TukuiPetBattleHUD_EnemyPet2:CreateTexture("TukuiPetBattleHUD_EnemyPet2AtkSpeedIcon", "OVERLAY")
TukuiPetBattleHUD_EnemyPet2AtkSpeedIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
TukuiPetBattleHUD_EnemyPet2AtkSpeedIcon:SetTexCoord(1, 0, 1, 0)
TukuiPetBattleHUD_EnemyPet2AtkSpeedIcon:Size(16)
TukuiPetBattleHUD_EnemyPet2AtkSpeedIcon:SetPoint("TOPRIGHT", TukuiPetBattleHUD_EnemyPet2Experience.backdrop, "LEFT", -2, 8)
TukuiPetBattleHUD_EnemyPet2AtkSpeedIconText = TukuiPetBattleHUD_EnemyPet2Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet2AtkSpeedIconText:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet2Experience.backdrop, "LEFT", -18, 0)

local TukuiPetBattleHUD_EnemyPet3 = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet3", TukuiPetBattleHUD_EnemyPet2)
TukuiPetBattleHUD_EnemyPet3:Hide()
TukuiPetBattleHUD_EnemyPet3:Size(width, 60)
TukuiPetBattleHUD_EnemyPet3:CreateBackdrop("Transparent")
TukuiPetBattleHUD_EnemyPet3.backdrop:CreateShadow()
TukuiPetBattleHUD_EnemyPet3:Point("BOTTOM", TukuiPetBattleHUD_EnemyPet2, "TOP", 0, 8)
TukuiPetBattleHUD_EnemyPet3:SetScript("OnShow", function()
	local targetID = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, 3)
	local ownedString = C_PetJournal.GetOwnedBattlePetString(targetID)
	if not ownedString then
		TukuiPetBattleHUD_EnemyPet3.backdrop:SetBackdropBorderColor(1,0,0)
	else
		TukuiPetBattleHUD_EnemyPet3.backdrop:SetBackdropBorderColor(unpack(border))
	end
end)

local TukuiPetBattleHUD_EnemyPet3IconBackdrop = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet3IconBackdrop", TukuiPetBattleHUD_EnemyPet3)
TukuiPetBattleHUD_EnemyPet3IconBackdrop:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet3, "RIGHT", -10, 0)
TukuiPetBattleHUD_EnemyPet3IconBackdrop:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet3IconBackdrop:Size(40)
TukuiPetBattleHUD_EnemyPet3IconBackdrop:SetScript("OnEnter", function(self,...)
	GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 2, 4)
	GameTooltip:ClearLines()

	local targetID = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, 3)
	local ownedString = C_PetJournal.GetOwnedBattlePetString(targetID)
	if ownedString ~= nil then GameTooltip:AddLine(ownedString) end
	for i=1,C_PetJournal.GetNumPets(false) do 
		local petID, speciesID, _, _, level, _, _, _, _, petType, _, _, _, _, _, _, _ = C_PetJournal.GetPetInfoByIndex(i)
		
		if speciesID == targetID then
			local _, maxHealth, power, speed = C_PetJournal.GetPetStats(petID)
			if C_PetJournal.GetBattlePetLink(petID) then
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
TukuiPetBattleHUD_EnemyPet3IconBackdrop:SetScript("OnLeave", function(self,...) GameTooltip:Hide() end)
TukuiPetBattleHUD_EnemyPet3IconBackdropText = TukuiPetBattleHUD_EnemyPet3IconBackdrop:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet3IconBackdropText:SetPoint("BOTTOMLEFT", 0, 2)

local TukuiPetBattleHUD_EnemyPet3IconBackdropTexture = TukuiPetBattleHUD_EnemyPet3IconBackdrop:CreateTexture("TukuiPetBattleHUD_EnemyPet3IconBackdropTexture", "MEDIUM")
TukuiPetBattleHUD_EnemyPet3IconBackdropTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
TukuiPetBattleHUD_EnemyPet3IconBackdropTexture:SetInside(TukuiPetBattleHUD_EnemyPet3IconBackdrop.backdrop)
local TukuiPetBattleHUD_EnemyPet3IconBackdropTextureDead = TukuiPetBattleHUD_EnemyPet3IconBackdrop:CreateTexture("TukuiPetBattleHUD_EnemyPet3IconBackdropTextureDead", "OVERLAY")
TukuiPetBattleHUD_EnemyPet3IconBackdropTextureDead:Hide()
TukuiPetBattleHUD_EnemyPet3IconBackdropTextureDead:SetOutside(TukuiPetBattleHUD_EnemyPet3IconBackdrop.backdrop, 8, 8)
TukuiPetBattleHUD_EnemyPet3IconBackdropTextureDead:SetTexture("Interface\\AddOns\\PetBattleHUD\\Dead")

local TukuiPetBattleHUD_EnemyPet3IconPetType = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet3IconPetType", TukuiPetBattleHUD_EnemyPet3IconBackdrop)
TukuiPetBattleHUD_EnemyPet3IconPetType:Size(32)
TukuiPetBattleHUD_EnemyPet3IconPetType:SetPoint("TOPLEFT", TukuiPetBattleHUD_EnemyPet3, "TOPLEFT", 0, 0)

local TukuiPetBattleHUD_EnemyPet3IconPetTypeTexture = TukuiPetBattleHUD_EnemyPet3IconPetType:CreateTexture("TukuiPetBattleHUD_EnemyPet3IconPetTypeTexture", "OVERLAY")
TukuiPetBattleHUD_EnemyPet3IconPetTypeTexture:SetInside(TukuiPetBattleHUD_EnemyPet3IconPetType)

local TukuiPetBattleHUD_EnemyPet3Health = CreateFrame('StatusBar', "TukuiPetBattleHUD_EnemyPet3Health", TukuiPetBattleHUD_EnemyPet3)
TukuiPetBattleHUD_EnemyPet3Health:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet3IconBackdrop.backdrop, "LEFT", -4, 1)
TukuiPetBattleHUD_EnemyPet3Health:Size(width-110, 11)
TukuiPetBattleHUD_EnemyPet3Health:SetFrameLevel(TukuiPetBattleHUD_EnemyPet3:GetFrameLevel() + 2)
TukuiPetBattleHUD_EnemyPet3Health:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet3Health:SetReverseFill(true)
TukuiPetBattleHUD_EnemyPet3HealthText = TukuiPetBattleHUD_EnemyPet3Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet3HealthText:SetPoint("TOP", 0, (1+offset))
TukuiPetBattleHUD_EnemyPet3AtkPowerIcon = TukuiPetBattleHUD_EnemyPet3:CreateTexture("TukuiPetBattleHUD_EnemyPet3AtkPowerIcon", "OVERLAY")
TukuiPetBattleHUD_EnemyPet3AtkPowerIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
TukuiPetBattleHUD_EnemyPet3AtkPowerIcon:Size(16)
TukuiPetBattleHUD_EnemyPet3AtkPowerIcon:SetPoint("TOPRIGHT", TukuiPetBattleHUD_EnemyPet3Health.backdrop, "LEFT", -2, 8)
TukuiPetBattleHUD_EnemyPet3AtkPowerIconText = TukuiPetBattleHUD_EnemyPet3Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet3AtkPowerIconText:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet3Health.backdrop, "LEFT", -18, 0)
TukuiPetBattleHUD_EnemyPet3NameText = TukuiPetBattleHUD_EnemyPet3:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet3NameText:SetPoint("BOTTOMRIGHT", TukuiPetBattleHUD_EnemyPet3Health.backdrop, "TOPRIGHT", 2, 4)

local TukuiPetBattleHUD_EnemyPet3Experience = CreateFrame('StatusBar', "TukuiPetBattleHUD_EnemyPet3Experience", TukuiPetBattleHUD_EnemyPet3)
TukuiPetBattleHUD_EnemyPet3Experience:SetPoint("TOP", TukuiPetBattleHUD_EnemyPet3Health, "BOTTOM", 0, -5)
TukuiPetBattleHUD_EnemyPet3Experience:Size(width-110, 11)
TukuiPetBattleHUD_EnemyPet3Experience:SetFrameLevel(TukuiPetBattleHUD_EnemyPet3:GetFrameLevel() + 2)
TukuiPetBattleHUD_EnemyPet3Experience:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet3Experience:SetReverseFill(true)
TukuiPetBattleHUD_EnemyPet3ExperienceText = TukuiPetBattleHUD_EnemyPet3Experience:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet3ExperienceText:SetPoint("TOP", 0, (1+offset))
TukuiPetBattleHUD_EnemyPet3AtkSpeedIcon = TukuiPetBattleHUD_EnemyPet3:CreateTexture("TukuiPetBattleHUD_EnemyPet3AtkSpeedIcon", "OVERLAY")
TukuiPetBattleHUD_EnemyPet3AtkSpeedIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
TukuiPetBattleHUD_EnemyPet3AtkSpeedIcon:SetTexCoord(1, 0, 1, 0)
TukuiPetBattleHUD_EnemyPet3AtkSpeedIcon:Size(16)
TukuiPetBattleHUD_EnemyPet3AtkSpeedIcon:SetPoint("TOPRIGHT", TukuiPetBattleHUD_EnemyPet3Experience.backdrop, "LEFT", -2, 8)
TukuiPetBattleHUD_EnemyPet3AtkSpeedIconText = TukuiPetBattleHUD_EnemyPet3Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet3AtkSpeedIconText:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet3Experience.backdrop, "LEFT", -18, 0)
--
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
		TukuiPetBattleEnemyHUDInit = true
	end
end

local function SetupAuras()
	for i = 1, C_PetBattles.GetNumAuras(LE_BATTLE_PET_ALLY, 1) do
			
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
--[[ DO NOT ENABLE THIS UNLESS YOU KNOW WHAT THE HELL YOUR DOING
hooksecurefunc("PetBattleAuraHolder_Update", function(self)
	if not self.petOwner or not self.petIndex then return end
	for i = 1, C_PetBattles.GetNumAuras(owner, index)
	auraID, instanceID, turnsRemaining, isBuff, casterOwner, casterIndex = C_PetBattles.GetAuraInfo(owner, index, auraindex)
	if ( auraID ) then
	local id, name, icon, maxCooldown, description = C_PetBattles.GetAbilityInfoByID(auraID);

	C_PetBattles.GetAbilityInfoByID(id)
	local nextFrame = 1
	for i=1, C_PetBattles.GetNumAuras(self.petOwner, self.petIndex) do
		local auraID, instanceID, turnsRemaining, isBuff = C_PetBattles.GetAuraInfo(self.petOwner, self.petIndex, i)
		if (isBuff and self.displayBuffs) or (not isBuff and self.displayDebuffs) then
			local frame = self.frames[nextFrame]
			if self.petOwner == LE_BATTLE_PET_ALLY then
				hudframe = _G["TukuiPetBattleHUD_Pet"..i]
			else
				hudframe = _G["TukuiPetBattleHUD_EnemyPet"..i]
			end
			-- always hide the border
			frame.DebuffBorder:Hide()
			if ( nextFrame == 1 ) then
				frame:SetPoint("TOPLEFT", hudframe, "TOPRIGHT", -4, 0);
			elseif ( (nextFrame - 1) % numPerRow == 0 ) then
				frame:SetPoint("TOPLEFT", self.frames[nextFrame - numPerRow], "TOPRIGHT", -4, 0);
			else
				frame:SetPoint("TOPLEFT", self.frames[nextFrame - 1], "TOPRIGHT", -4, 0);
	                end

			if not frame.isSkinned then
				frame:CreateBackdrop()
				frame.backdrop:SetOutside(frame.Icon)
				frame.Icon:SetTexCoord(.1,.9,.1,.9)
			end

			if isBuff then
				frame.backdrop:SetBackdropBorderColor(0, 1, 0)
			else
				frame.backdrop:SetBackdropBorderColor(1, 0, 0)
			end
			
			if turnsRemaining > 0 then
				frame.Duration:SetText(turnsRemaining)
			end
			
			frame.Duration:SetFont(C.media.font, 14, "OUTLINE")
			frame.Duration:ClearAllPoints()
			frame.Duration:SetPoint("CENTER", frame.Icon, "CENTER", 1, 0)
		
			nextFrame = nextFrame + 1
		end
	end
end)
	TukuiPetBattleHUD_Pet1IconBackdropTexture:SetDesaturated()
	PetBattleFrame.EnemyPadDebuffFrame:ClearAllPoints()
	PetBattleFrame.EnemyPadBuffFrame:ClearAllPoints()
	PetBattleFrame.AllyPadDebuffFrame:ClearAllPoints()
	PetBattleFrame.AllyPadBuffFrame:ClearAllPoints()
	PetBattleFrame.EnemyPadDebuffFrame:SetPoint("BOTTOMLEFT", TukuiPetBattleHUD_EnemyPet1, "BOTTOMRIGHT", -9, 0)
	PetBattleFrame.EnemyPadBuffFrame:SetPoint("TOPLEFT", TukuiPetBattleHUD_EnemyPet1, "TOPRIGHT", -9, 0)
	PetBattleFrame.AllyPadDebuffFrame:SetPoint("TOPRIGHT", TukuiPetBattleHUD_Pet1, "TOPLEFT", 8, 0)
	PetBattleFrame.AllyPadBuffFrame:SetPoint("BOTTOMRIGHT", TukuiPetBattleHUD_Pet1, "BOTTOMLEFT", 8, 0)
]]