local A, C = unpack(Tukui or ElvUI or AsphyxiaUI or DuffedUI)
local border
if ElvUI then
	border = A["media"]["bordercolor"]
else
	border = C["media"]["bordercolor"]
end

local TukuiPetBattleHUD_Pet1 = CreateFrame("Frame", "TukuiPetBattleHUD_Pet1", UIParent)
TukuiPetBattleHUD_Pet1:Hide()
TukuiPetBattleHUD_Pet1:SetMovable(true)
TukuiPetBattleHUD_Pet1:EnableMouse(true)
TukuiPetBattleHUD_Pet1:RegisterForDrag("LeftButton")
TukuiPetBattleHUD_Pet1:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
TukuiPetBattleHUD_Pet1:SetScript("OnDragStop", function(self) self:StopMovingOrSizing()  end)
TukuiPetBattleHUD_Pet1:Size(260, 60)
TukuiPetBattleHUD_Pet1:CreateBackdrop("Transparent")
TukuiPetBattleHUD_Pet1.backdrop:CreateShadow()
TukuiPetBattleHUD_Pet1:Point("RIGHT", UIParent, "BOTTOM", -200, 300)

local TukuiPetBattleHUD_Pet1IconBackdrop = CreateFrame("Frame", "TukuiPetBattleHUD_Pet1IconBackdrop", TukuiPetBattleHUD_Pet1)
TukuiPetBattleHUD_Pet1IconBackdrop:SetPoint("LEFT", TukuiPetBattleHUD_Pet1, "LEFT", 10, 0)
TukuiPetBattleHUD_Pet1IconBackdrop:CreateBackdrop()
TukuiPetBattleHUD_Pet1IconBackdrop:Size(40)
TukuiPetBattleHUD_Pet1IconBackdropText = TukuiPetBattleHUD_Pet1IconBackdrop:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet1IconBackdropText:SetPoint("BOTTOMRIGHT", TukuiPetBattleHUD_Pet1IconBackdrop.backdrop, "BOTTOMRIGHT", 0, 2)

local TukuiPetBattleHUD_Pet1IconBackdropTexture = TukuiPetBattleHUD_Pet1IconBackdrop:CreateTexture("TukuiPetBattleHUD_Pet1IconBackdropTexture", "MEDIUM")
TukuiPetBattleHUD_Pet1IconBackdropTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
TukuiPetBattleHUD_Pet1IconBackdropTexture:SetInside(TukuiPetBattleHUD_Pet1IconBackdrop.backdrop)

local TukuiPetBattleHUD_Pet1IconPetType = CreateFrame("Frame", "TukuiPetBattleHUD_Pet1IconPetType", TukuiPetBattleHUD_Pet1IconBackdrop)
TukuiPetBattleHUD_Pet1IconPetType:Size(32)
TukuiPetBattleHUD_Pet1IconPetType:SetPoint("TOPRIGHT", TukuiPetBattleHUD_Pet1, "TOPRIGHT", 0, 0)

local TukuiPetBattleHUD_Pet1IconPetTypeTexture = TukuiPetBattleHUD_Pet1IconPetType:CreateTexture("TukuiPetBattleHUD_Pet1IconPetTypeTexture", "OVERLAY")
TukuiPetBattleHUD_Pet1IconPetTypeTexture:SetInside(TukuiPetBattleHUD_Pet1IconPetType)

local TukuiPetBattleHUD_Pet1Health = CreateFrame('StatusBar', "TukuiPetBattleHUD_Pet1Health", TukuiPetBattleHUD_Pet1)
TukuiPetBattleHUD_Pet1Health:SetPoint("LEFT", TukuiPetBattleHUD_Pet1IconBackdrop.backdrop, "RIGHT", 4, 0)
TukuiPetBattleHUD_Pet1Health:Size(150, 10)
TukuiPetBattleHUD_Pet1Health:SetStatusBarColor(0.11,0.66,0.11)
TukuiPetBattleHUD_Pet1Health:SetFrameLevel(TukuiPetBattleHUD_Pet1:GetFrameLevel() + 2)
TukuiPetBattleHUD_Pet1Health:CreateBackdrop()
TukuiPetBattleHUD_Pet1HealthText = TukuiPetBattleHUD_Pet1Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet1HealthText:SetPoint("CENTER", TukuiPetBattleHUD_Pet1Health.backdrop, "CENTER", 0, 0)
TukuiPetBattleHUD_Pet1AtkPowerIcon = TukuiPetBattleHUD_Pet1:CreateTexture(nil, "OVERLAY")
TukuiPetBattleHUD_Pet1AtkPowerIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
TukuiPetBattleHUD_Pet1AtkPowerIcon:Size(16)
TukuiPetBattleHUD_Pet1AtkPowerIcon:SetPoint("TOPLEFT", TukuiPetBattleHUD_Pet1Health.backdrop, "RIGHT", 2, 8)
TukuiPetBattleHUD_Pet1AtkPowerIconText = TukuiPetBattleHUD_Pet1Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet1AtkPowerIconText:SetPoint("LEFT", TukuiPetBattleHUD_Pet1Health.backdrop, "RIGHT", 20, 2)
TukuiPetBattleHUD_Pet1NameText = TukuiPetBattleHUD_Pet1:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet1NameText:SetPoint("BOTTOMLEFT", TukuiPetBattleHUD_Pet1Health.backdrop, "TOPLEFT", 2, 2)

local TukuiPetBattleHUD_Pet1Experience = CreateFrame('StatusBar', "TukuiPetBattleHUD_Pet1Experience", TukuiPetBattleHUD_Pet1)
TukuiPetBattleHUD_Pet1Experience:SetPoint("TOP", TukuiPetBattleHUD_Pet1Health, "BOTTOM", 0, -5)
TukuiPetBattleHUD_Pet1Experience:Size(150, 10)
TukuiPetBattleHUD_Pet1Experience:SetFrameLevel(TukuiPetBattleHUD_Pet1:GetFrameLevel() + 2)
TukuiPetBattleHUD_Pet1Experience:CreateBackdrop()
TukuiPetBattleHUD_Pet1ExperienceText = TukuiPetBattleHUD_Pet1Experience:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet1ExperienceText:SetPoint("CENTER", TukuiPetBattleHUD_Pet1Experience.backdrop, "CENTER", 0, 0)
TukuiPetBattleHUD_Pet1AtkSpeedIcon = TukuiPetBattleHUD_Pet1:CreateTexture("TukuiPetBattleHUD_Pet1AtkSpeedIcon", "OVERLAY")
TukuiPetBattleHUD_Pet1AtkSpeedIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
TukuiPetBattleHUD_Pet1AtkSpeedIcon:Size(16)
TukuiPetBattleHUD_Pet1AtkSpeedIcon:SetPoint("TOPLEFT", TukuiPetBattleHUD_Pet1Experience.backdrop, "RIGHT", 2, 8)
TukuiPetBattleHUD_Pet1AtkSpeedIconText = TukuiPetBattleHUD_Pet1Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet1AtkSpeedIconText:SetPoint("LEFT", TukuiPetBattleHUD_Pet1Experience.backdrop, "RIGHT", 20, 0)

local TukuiPetBattleHUD_Pet2 = CreateFrame("Frame", "TukuiPetBattleHUD_Pet2", TukuiPetBattleHUD_Pet1)
TukuiPetBattleHUD_Pet2:Hide()
TukuiPetBattleHUD_Pet2:Size(260, 60)
TukuiPetBattleHUD_Pet2:CreateBackdrop("Transparent")
TukuiPetBattleHUD_Pet2.backdrop:CreateShadow()
TukuiPetBattleHUD_Pet2:Point("BOTTOM", TukuiPetBattleHUD_Pet1, "TOP", 0, 8)

local TukuiPetBattleHUD_Pet2IconBackdrop = CreateFrame("Frame", "TukuiPetBattleHUD_Pet2IconBackdrop", TukuiPetBattleHUD_Pet2)
TukuiPetBattleHUD_Pet2IconBackdrop:SetPoint("LEFT", TukuiPetBattleHUD_Pet2, "LEFT", 10, 0)
TukuiPetBattleHUD_Pet2IconBackdrop:CreateBackdrop()
TukuiPetBattleHUD_Pet2IconBackdrop:Size(40)
TukuiPetBattleHUD_Pet2IconBackdropText = TukuiPetBattleHUD_Pet2IconBackdrop:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet2IconBackdropText:SetPoint("BOTTOMRIGHT", TukuiPetBattleHUD_Pet2IconBackdrop.backdrop, "BOTTOMRIGHT", 0, 2)

local TukuiPetBattleHUD_Pet2IconBackdropTexture = TukuiPetBattleHUD_Pet2IconBackdrop:CreateTexture("TukuiPetBattleHUD_Pet2IconBackdropTexture", "OVERLAY")
TukuiPetBattleHUD_Pet2IconBackdropTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
TukuiPetBattleHUD_Pet2IconBackdropTexture:SetInside(TukuiPetBattleHUD_Pet2IconBackdrop.backdrop)

local TukuiPetBattleHUD_Pet2IconPetType = CreateFrame("Frame", "TukuiPetBattleHUD_Pet2IconPetType", TukuiPetBattleHUD_Pet2IconBackdrop)
TukuiPetBattleHUD_Pet2IconPetType:Size(32)
TukuiPetBattleHUD_Pet2IconPetType:SetPoint("TOPRIGHT", TukuiPetBattleHUD_Pet2, "TOPRIGHT", 0, 0)

local TukuiPetBattleHUD_Pet2IconPetTypeTexture = TukuiPetBattleHUD_Pet2IconPetType:CreateTexture("TukuiPetBattleHUD_Pet2IconPetTypeTexture", "OVERLAY")
TukuiPetBattleHUD_Pet2IconPetTypeTexture:SetInside(TukuiPetBattleHUD_Pet2IconPetType)

local TukuiPetBattleHUD_Pet2Health = CreateFrame('StatusBar', "TukuiPetBattleHUD_Pet2Health", TukuiPetBattleHUD_Pet2)
TukuiPetBattleHUD_Pet2Health:SetPoint("LEFT", TukuiPetBattleHUD_Pet2IconBackdrop.backdrop, "RIGHT", 4, 0)
TukuiPetBattleHUD_Pet2Health:Size(150, 10)
TukuiPetBattleHUD_Pet2Health:SetFrameLevel(TukuiPetBattleHUD_Pet2:GetFrameLevel() + 2)
TukuiPetBattleHUD_Pet2Health:CreateBackdrop()
TukuiPetBattleHUD_Pet2HealthText = TukuiPetBattleHUD_Pet2Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet2HealthText:SetPoint("CENTER", TukuiPetBattleHUD_Pet2Health, "CENTER", 0, 1)
TukuiPetBattleHUD_Pet2AtkPowerIcon = TukuiPetBattleHUD_Pet2:CreateTexture("TukuiPetBattleHUD_Pet2AtkPowerIcon", "OVERLAY")
TukuiPetBattleHUD_Pet2AtkPowerIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
TukuiPetBattleHUD_Pet2AtkPowerIcon:Size(16)
TukuiPetBattleHUD_Pet2AtkPowerIcon:SetPoint("TOPLEFT", TukuiPetBattleHUD_Pet2Health.backdrop, "RIGHT", 2, 8)
TukuiPetBattleHUD_Pet2AtkPowerIconText = TukuiPetBattleHUD_Pet2Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet2AtkPowerIconText:SetPoint("LEFT", TukuiPetBattleHUD_Pet2Health.backdrop, "RIGHT", 20, 2)
TukuiPetBattleHUD_Pet2NameText = TukuiPetBattleHUD_Pet2:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet2NameText:SetPoint("BOTTOMLEFT", TukuiPetBattleHUD_Pet2Health.backdrop, "TOPLEFT", 2, 2)

local TukuiPetBattleHUD_Pet2Experience = CreateFrame('StatusBar', "TukuiPetBattleHUD_Pet2Experience", TukuiPetBattleHUD_Pet2)
TukuiPetBattleHUD_Pet2Experience:SetPoint("TOP", TukuiPetBattleHUD_Pet2Health, "BOTTOM", 0, -5)
TukuiPetBattleHUD_Pet2Experience:Size(150, 10)
TukuiPetBattleHUD_Pet2Experience:SetFrameLevel(TukuiPetBattleHUD_Pet2:GetFrameLevel() + 2)
TukuiPetBattleHUD_Pet2Experience:CreateBackdrop()
TukuiPetBattleHUD_Pet2ExperienceText = TukuiPetBattleHUD_Pet2Experience:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet2ExperienceText:SetPoint("CENTER", TukuiPetBattleHUD_Pet2Experience.backdrop, "CENTER", 0, 1)
TukuiPetBattleHUD_Pet2AtkSpeedIcon = TukuiPetBattleHUD_Pet2:CreateTexture("TukuiPetBattleHUD_Pet2AtkSpeedIcon", "OVERLAY")
TukuiPetBattleHUD_Pet2AtkSpeedIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
TukuiPetBattleHUD_Pet2AtkSpeedIcon:Size(16)
TukuiPetBattleHUD_Pet2AtkSpeedIcon:SetPoint("TOPLEFT", TukuiPetBattleHUD_Pet2Experience.backdrop, "RIGHT", 2, 8)
TukuiPetBattleHUD_Pet2AtkSpeedIconText = TukuiPetBattleHUD_Pet2Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet2AtkSpeedIconText:SetPoint("LEFT", TukuiPetBattleHUD_Pet2Experience.backdrop, "RIGHT", 20, 0)

local TukuiPetBattleHUD_Pet3 = CreateFrame("Frame", "TukuiPetBattleHUD_Pet3", TukuiPetBattleHUD_Pet2)
TukuiPetBattleHUD_Pet3:Hide()
TukuiPetBattleHUD_Pet3:Size(260, 60)
TukuiPetBattleHUD_Pet3:CreateBackdrop("Transparent")
TukuiPetBattleHUD_Pet3.backdrop:CreateShadow()
TukuiPetBattleHUD_Pet3:Point("BOTTOM", TukuiPetBattleHUD_Pet2, "TOP", 0, 8)

local TukuiPetBattleHUD_Pet3IconBackdrop = CreateFrame("Frame", "TukuiPetBattleHUD_Pet3IconBackdrop", TukuiPetBattleHUD_Pet3)
TukuiPetBattleHUD_Pet3IconBackdrop:SetPoint("LEFT", TukuiPetBattleHUD_Pet3, "LEFT", 10, 0)
TukuiPetBattleHUD_Pet3IconBackdrop:CreateBackdrop()
TukuiPetBattleHUD_Pet3IconBackdrop:Size(40)
TukuiPetBattleHUD_Pet3IconBackdropText = TukuiPetBattleHUD_Pet3IconBackdrop:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet3IconBackdropText:SetPoint("BOTTOMRIGHT", TukuiPetBattleHUD_Pet3IconBackdrop.backdrop, "BOTTOMRIGHT", 0, 2)

local TukuiPetBattleHUD_Pet3IconBackdropTexture = TukuiPetBattleHUD_Pet3IconBackdrop:CreateTexture("TukuiPetBattleHUD_Pet3IconBackdropTexture", "OVERLAY")
TukuiPetBattleHUD_Pet3IconBackdropTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
TukuiPetBattleHUD_Pet3IconBackdropTexture:SetInside(TukuiPetBattleHUD_Pet3IconBackdrop.backdrop)

local TukuiPetBattleHUD_Pet3IconPetType = CreateFrame("Frame", "TukuiPetBattleHUD_Pet3IconPetType", TukuiPetBattleHUD_Pet3IconBackdrop)
TukuiPetBattleHUD_Pet3IconPetType:Size(32)
TukuiPetBattleHUD_Pet3IconPetType:SetPoint("TOPRIGHT", TukuiPetBattleHUD_Pet3, "TOPRIGHT", 0, 0)

local TukuiPetBattleHUD_Pet3IconPetTypeTexture = TukuiPetBattleHUD_Pet3IconPetType:CreateTexture("TukuiPetBattleHUD_Pet3IconPetTypeTexture", "OVERLAY")
TukuiPetBattleHUD_Pet3IconPetTypeTexture:SetInside(TukuiPetBattleHUD_Pet3IconPetType)

local TukuiPetBattleHUD_Pet3Health = CreateFrame('StatusBar', "TukuiPetBattleHUD_Pet3Health", TukuiPetBattleHUD_Pet3)
TukuiPetBattleHUD_Pet3Health:SetPoint("LEFT", TukuiPetBattleHUD_Pet3IconBackdrop.backdrop, "RIGHT", 4, 0)
TukuiPetBattleHUD_Pet3Health:Size(150, 10)
TukuiPetBattleHUD_Pet3Health:SetFrameLevel(TukuiPetBattleHUD_Pet3:GetFrameLevel() + 2)
TukuiPetBattleHUD_Pet3Health:CreateBackdrop()
TukuiPetBattleHUD_Pet3HealthText = TukuiPetBattleHUD_Pet3Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet3HealthText:SetPoint("CENTER", TukuiPetBattleHUD_Pet3Health, "CENTER", 0, 1)
TukuiPetBattleHUD_Pet3AtkPowerIcon = TukuiPetBattleHUD_Pet3:CreateTexture("TukuiPetBattleHUD_Pet3AtkPowerIcon", "OVERLAY")
TukuiPetBattleHUD_Pet3AtkPowerIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
TukuiPetBattleHUD_Pet3AtkPowerIcon:Size(16)
TukuiPetBattleHUD_Pet3AtkPowerIcon:SetPoint("TOPLEFT", TukuiPetBattleHUD_Pet3Health.backdrop, "RIGHT", 2, 8)
TukuiPetBattleHUD_Pet3AtkPowerIconText = TukuiPetBattleHUD_Pet3Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet3AtkPowerIconText:SetPoint("LEFT", TukuiPetBattleHUD_Pet3Health.backdrop, "RIGHT", 20, 2)
TukuiPetBattleHUD_Pet3NameText = TukuiPetBattleHUD_Pet3:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet3NameText:SetPoint("BOTTOMLEFT", TukuiPetBattleHUD_Pet3Health.backdrop, "TOPLEFT", 2, 2)

local TukuiPetBattleHUD_Pet3Experience = CreateFrame('StatusBar', "TukuiPetBattleHUD_Pet3Experience", TukuiPetBattleHUD_Pet3)
TukuiPetBattleHUD_Pet3Experience:SetPoint("TOP", TukuiPetBattleHUD_Pet3Health, "BOTTOM", 0, -5)
TukuiPetBattleHUD_Pet3Experience:Size(150, 10)
TukuiPetBattleHUD_Pet3Experience:SetFrameLevel(TukuiPetBattleHUD_Pet3:GetFrameLevel() + 2)
TukuiPetBattleHUD_Pet3Experience:CreateBackdrop()
TukuiPetBattleHUD_Pet3ExperienceText = TukuiPetBattleHUD_Pet3Experience:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet3ExperienceText:SetPoint("CENTER", TukuiPetBattleHUD_Pet3Experience.backdrop, "CENTER", 0, 1)
TukuiPetBattleHUD_Pet3AtkSpeedIcon = TukuiPetBattleHUD_Pet3:CreateTexture("TukuiPetBattleHUD_Pet3AtkSpeedIcon", "OVERLAY")
TukuiPetBattleHUD_Pet3AtkSpeedIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
TukuiPetBattleHUD_Pet3AtkSpeedIcon:Size(16)
TukuiPetBattleHUD_Pet3AtkSpeedIcon:SetPoint("TOPLEFT", TukuiPetBattleHUD_Pet3Experience.backdrop, "RIGHT", 2, 8)
TukuiPetBattleHUD_Pet3AtkSpeedIconText = TukuiPetBattleHUD_Pet3Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_Pet3AtkSpeedIconText:SetPoint("LEFT", TukuiPetBattleHUD_Pet3Experience.backdrop, "RIGHT", 20, 0)

--- Enemy Frames

local TukuiPetBattleHUD_EnemyPet1 = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet1", UIParent)
TukuiPetBattleHUD_EnemyPet1:Hide()
TukuiPetBattleHUD_EnemyPet1:SetMovable(true)
TukuiPetBattleHUD_EnemyPet1:EnableMouse(true)
TukuiPetBattleHUD_EnemyPet1:RegisterForDrag("LeftButton")
TukuiPetBattleHUD_EnemyPet1:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
TukuiPetBattleHUD_EnemyPet1:SetScript("OnDragStop", function(self) self:StopMovingOrSizing()  end)
TukuiPetBattleHUD_EnemyPet1:Size(260, 60)
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
TukuiPetBattleHUD_EnemyPet1IconBackdropText:SetPoint("BOTTOMLEFT", TukuiPetBattleHUD_EnemyPet1IconBackdrop.backdrop, "BOTTOMLEFT", 4, 2)

local TukuiPetBattleHUD_EnemyPet1IconBackdropTexture = TukuiPetBattleHUD_EnemyPet1IconBackdrop:CreateTexture("TukuiPetBattleHUD_EnemyPet1IconBackdropTexture", "OVERLAY")
TukuiPetBattleHUD_EnemyPet1IconBackdropTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
TukuiPetBattleHUD_EnemyPet1IconBackdropTexture:SetInside(TukuiPetBattleHUD_EnemyPet1IconBackdrop.backdrop)

local TukuiPetBattleHUD_EnemyPet1IconPetType = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet1IconPetType", TukuiPetBattleHUD_EnemyPet1IconBackdrop)
TukuiPetBattleHUD_EnemyPet1IconPetType:Size(32)
TukuiPetBattleHUD_EnemyPet1IconPetType:SetPoint("TOPLEFT", TukuiPetBattleHUD_EnemyPet1, "TOPLEFT", 0, 0)

local TukuiPetBattleHUD_EnemyPet1IconPetTypeTexture = TukuiPetBattleHUD_EnemyPet1IconPetType:CreateTexture("TukuiPetBattleHUD_EnemyPet1IconPetTypeTexture", "OVERLAY")
TukuiPetBattleHUD_EnemyPet1IconPetTypeTexture:SetInside(TukuiPetBattleHUD_EnemyPet1IconPetType)

local TukuiPetBattleHUD_EnemyPet1Health = CreateFrame('StatusBar', "TukuiPetBattleHUD_EnemyPet1Health", TukuiPetBattleHUD_EnemyPet1)
TukuiPetBattleHUD_EnemyPet1Health:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet1IconBackdrop.backdrop, "LEFT", -4, 0)
TukuiPetBattleHUD_EnemyPet1Health:Size(150, 10)
TukuiPetBattleHUD_EnemyPet1Health:SetFrameLevel(TukuiPetBattleHUD_EnemyPet1:GetFrameLevel() + 2)
TukuiPetBattleHUD_EnemyPet1Health:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet1Health:SetReverseFill(true)
TukuiPetBattleHUD_EnemyPet1HealthText = TukuiPetBattleHUD_EnemyPet1Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet1HealthText:SetPoint("CENTER", TukuiPetBattleHUD_EnemyPet1Health.backdrop, "CENTER", 0, 0)
TukuiPetBattleHUD_EnemyPet1AtkPowerIcon = TukuiPetBattleHUD_EnemyPet1:CreateTexture("TukuiPetBattleHUD_EnemyPet1AtkPowerIcon", "OVERLAY")
TukuiPetBattleHUD_EnemyPet1AtkPowerIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
TukuiPetBattleHUD_EnemyPet1AtkPowerIcon:Size(16)
TukuiPetBattleHUD_EnemyPet1AtkPowerIcon:SetPoint("TOPRIGHT", TukuiPetBattleHUD_EnemyPet1Health.backdrop, "LEFT", -2, 8)
TukuiPetBattleHUD_EnemyPet1AtkPowerIconText = TukuiPetBattleHUD_EnemyPet1Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet1AtkPowerIconText:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet1Health.backdrop, "LEFT", -18, 0)
TukuiPetBattleHUD_EnemyPet1NameText = TukuiPetBattleHUD_EnemyPet1:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet1NameText:SetPoint("BOTTOMRIGHT", TukuiPetBattleHUD_EnemyPet1Health.backdrop, "TOPRIGHT", 0, 2)

local TukuiPetBattleHUD_EnemyPet1Experience = CreateFrame('StatusBar', "TukuiPetBattleHUD_EnemyPet1Experience", TukuiPetBattleHUD_EnemyPet1)
TukuiPetBattleHUD_EnemyPet1Experience:SetPoint("TOP", TukuiPetBattleHUD_EnemyPet1Health, "BOTTOM", 0, -5)
TukuiPetBattleHUD_EnemyPet1Experience:Size(150, 10)
TukuiPetBattleHUD_EnemyPet1Experience:SetFrameLevel(TukuiPetBattleHUD_EnemyPet1:GetFrameLevel() + 2)
TukuiPetBattleHUD_EnemyPet1Experience:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet1Experience:SetReverseFill(true)
TukuiPetBattleHUD_EnemyPet1ExperienceText = TukuiPetBattleHUD_EnemyPet1Experience:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet1ExperienceText:SetPoint("CENTER", TukuiPetBattleHUD_EnemyPet1Experience.backdrop, "CENTER", 0, 0)
TukuiPetBattleHUD_EnemyPet1AtkSpeedIcon = TukuiPetBattleHUD_EnemyPet1:CreateTexture("TukuiPetBattleHUD_EnemyPet1AtkSpeedIcon", "OVERLAY")
TukuiPetBattleHUD_EnemyPet1AtkSpeedIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
TukuiPetBattleHUD_EnemyPet1AtkSpeedIcon:Size(16)
TukuiPetBattleHUD_EnemyPet1AtkSpeedIcon:SetPoint("TOPRIGHT", TukuiPetBattleHUD_EnemyPet1Experience.backdrop, "LEFT", -2, 8)
TukuiPetBattleHUD_EnemyPet1AtkSpeedIconText = TukuiPetBattleHUD_EnemyPet1Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet1AtkSpeedIconText:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet1Experience.backdrop, "LEFT", -18, 0)

local TukuiPetBattleHUD_EnemyPet2 = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet2", TukuiPetBattleHUD_EnemyPet1)
TukuiPetBattleHUD_EnemyPet2:Hide()
TukuiPetBattleHUD_EnemyPet2:Size(260, 60)
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
TukuiPetBattleHUD_EnemyPet2IconBackdropText:SetPoint("BOTTOMLEFT", TukuiPetBattleHUD_EnemyPet2IconBackdrop.backdrop, "BOTTOMLEFT", 4, 2)

local TukuiPetBattleHUD_EnemyPet2IconPetType = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet2IconPetType", TukuiPetBattleHUD_EnemyPet2IconBackdrop)
TukuiPetBattleHUD_EnemyPet2IconPetType:Size(32)
TukuiPetBattleHUD_EnemyPet2IconPetType:SetPoint("TOPLEFT", TukuiPetBattleHUD_EnemyPet2, "TOPLEFT", 0, 0)

local TukuiPetBattleHUD_EnemyPet2IconPetTypeTexture = TukuiPetBattleHUD_EnemyPet2IconPetType:CreateTexture("TukuiPetBattleHUD_EnemyPet2IconPetTypeTexture", "OVERLAY")
TukuiPetBattleHUD_EnemyPet2IconPetTypeTexture:SetInside(TukuiPetBattleHUD_EnemyPet2IconPetType)

local TukuiPetBattleHUD_EnemyPet2IconBackdropTexture = TukuiPetBattleHUD_EnemyPet2IconBackdrop:CreateTexture("TukuiPetBattleHUD_EnemyPet2IconBackdropTexture", "OVERLAY")
TukuiPetBattleHUD_EnemyPet2IconBackdropTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
TukuiPetBattleHUD_EnemyPet2IconBackdropTexture:SetInside(TukuiPetBattleHUD_EnemyPet2IconBackdrop.backdrop)

local TukuiPetBattleHUD_EnemyPet2Health = CreateFrame('StatusBar', "TukuiPetBattleHUD_EnemyPet2Health", TukuiPetBattleHUD_EnemyPet2)
TukuiPetBattleHUD_EnemyPet2Health:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet2IconBackdrop.backdrop, "LEFT", -4, 0)
TukuiPetBattleHUD_EnemyPet2Health:Size(150, 10)
TukuiPetBattleHUD_EnemyPet2Health:SetFrameLevel(TukuiPetBattleHUD_EnemyPet2:GetFrameLevel() + 2)
TukuiPetBattleHUD_EnemyPet2Health:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet2Health:SetReverseFill(true)
TukuiPetBattleHUD_EnemyPet2HealthText = TukuiPetBattleHUD_EnemyPet2Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet2HealthText:SetPoint("CENTER", TukuiPetBattleHUD_EnemyPet2Health.backdrop, "CENTER", 0, 0)
TukuiPetBattleHUD_EnemyPet2AtkPowerIcon = TukuiPetBattleHUD_EnemyPet2:CreateTexture("TukuiPetBattleHUD_EnemyPet2AtkPowerIcon", "OVERLAY")
TukuiPetBattleHUD_EnemyPet2AtkPowerIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
TukuiPetBattleHUD_EnemyPet2AtkPowerIcon:Size(16)
TukuiPetBattleHUD_EnemyPet2AtkPowerIcon:SetPoint("TOPRIGHT", TukuiPetBattleHUD_EnemyPet2Health.backdrop, "LEFT", -2, 8)
TukuiPetBattleHUD_EnemyPet2AtkPowerIconText = TukuiPetBattleHUD_EnemyPet2Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet2AtkPowerIconText:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet2Health.backdrop, "LEFT", -18, 0)
TukuiPetBattleHUD_EnemyPet2NameText = TukuiPetBattleHUD_EnemyPet2:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet2NameText:SetPoint("BOTTOMRIGHT", TukuiPetBattleHUD_EnemyPet2Health.backdrop, "TOPRIGHT", 0, 2)

local TukuiPetBattleHUD_EnemyPet2Experience = CreateFrame('StatusBar', "TukuiPetBattleHUD_EnemyPet2Experience", TukuiPetBattleHUD_EnemyPet2)
TukuiPetBattleHUD_EnemyPet2Experience:SetPoint("TOP", TukuiPetBattleHUD_EnemyPet2Health, "BOTTOM", 0, -5)
TukuiPetBattleHUD_EnemyPet2Experience:Size(150, 10)
TukuiPetBattleHUD_EnemyPet2Experience:SetFrameLevel(TukuiPetBattleHUD_EnemyPet2:GetFrameLevel() + 2)
TukuiPetBattleHUD_EnemyPet2Experience:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet2Experience:SetReverseFill(true)
TukuiPetBattleHUD_EnemyPet2ExperienceText = TukuiPetBattleHUD_EnemyPet2Experience:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet2ExperienceText:SetPoint("CENTER", TukuiPetBattleHUD_EnemyPet2Experience.backdrop, "CENTER", 0, 0)
TukuiPetBattleHUD_EnemyPet2AtkSpeedIcon = TukuiPetBattleHUD_EnemyPet2:CreateTexture("TukuiPetBattleHUD_EnemyPet2AtkSpeedIcon", "OVERLAY")
TukuiPetBattleHUD_EnemyPet2AtkSpeedIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
TukuiPetBattleHUD_EnemyPet2AtkSpeedIcon:Size(16)
TukuiPetBattleHUD_EnemyPet2AtkSpeedIcon:SetPoint("TOPRIGHT", TukuiPetBattleHUD_EnemyPet2Experience.backdrop, "LEFT", -2, 8)
TukuiPetBattleHUD_EnemyPet2AtkSpeedIconText = TukuiPetBattleHUD_EnemyPet2Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet2AtkSpeedIconText:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet2Experience.backdrop, "LEFT", -18, 0)

local TukuiPetBattleHUD_EnemyPet3 = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet3", TukuiPetBattleHUD_EnemyPet2)
TukuiPetBattleHUD_EnemyPet3:Hide()
TukuiPetBattleHUD_EnemyPet3:Size(260, 60)
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
TukuiPetBattleHUD_EnemyPet3IconBackdropText:SetPoint("BOTTOMLEFT", TukuiPetBattleHUD_EnemyPet3IconBackdrop.backdrop, "BOTTOMLEFT", 4, 2)

local TukuiPetBattleHUD_EnemyPet3IconBackdropTexture = TukuiPetBattleHUD_EnemyPet3IconBackdrop:CreateTexture("TukuiPetBattleHUD_EnemyPet3IconBackdropTexture", "OVERLAY")
TukuiPetBattleHUD_EnemyPet3IconBackdropTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
TukuiPetBattleHUD_EnemyPet3IconBackdropTexture:SetInside(TukuiPetBattleHUD_EnemyPet3IconBackdrop.backdrop)

local TukuiPetBattleHUD_EnemyPet3IconPetType = CreateFrame("Frame", "TukuiPetBattleHUD_EnemyPet3IconPetType", TukuiPetBattleHUD_EnemyPet3IconBackdrop)
TukuiPetBattleHUD_EnemyPet3IconPetType:Size(32)
TukuiPetBattleHUD_EnemyPet3IconPetType:SetPoint("TOPLEFT", TukuiPetBattleHUD_EnemyPet3, "TOPLEFT", 0, 0)

local TukuiPetBattleHUD_EnemyPet3IconPetTypeTexture = TukuiPetBattleHUD_EnemyPet3IconPetType:CreateTexture("TukuiPetBattleHUD_EnemyPet3IconPetTypeTexture", "OVERLAY")
TukuiPetBattleHUD_EnemyPet3IconPetTypeTexture:SetInside(TukuiPetBattleHUD_EnemyPet3IconPetType)

local TukuiPetBattleHUD_EnemyPet3Health = CreateFrame('StatusBar', "TukuiPetBattleHUD_EnemyPet3Health", TukuiPetBattleHUD_EnemyPet3)
TukuiPetBattleHUD_EnemyPet3Health:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet3IconBackdrop.backdrop, "LEFT", -4, 0)
TukuiPetBattleHUD_EnemyPet3Health:Size(150, 10)
TukuiPetBattleHUD_EnemyPet3Health:SetFrameLevel(TukuiPetBattleHUD_EnemyPet3:GetFrameLevel() + 2)
TukuiPetBattleHUD_EnemyPet3Health:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet3Health:SetReverseFill(true)
TukuiPetBattleHUD_EnemyPet3HealthText = TukuiPetBattleHUD_EnemyPet3Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet3HealthText:SetPoint("CENTER", TukuiPetBattleHUD_EnemyPet3Health.backdrop, "CENTER", 0, 0)
TukuiPetBattleHUD_EnemyPet3AtkPowerIcon = TukuiPetBattleHUD_EnemyPet3:CreateTexture("TukuiPetBattleHUD_EnemyPet3AtkPowerIcon", "OVERLAY")
TukuiPetBattleHUD_EnemyPet3AtkPowerIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
TukuiPetBattleHUD_EnemyPet3AtkPowerIcon:Size(16)
TukuiPetBattleHUD_EnemyPet3AtkPowerIcon:SetPoint("TOPRIGHT", TukuiPetBattleHUD_EnemyPet3Health.backdrop, "LEFT", -2, 8)
TukuiPetBattleHUD_EnemyPet3AtkPowerIconText = TukuiPetBattleHUD_EnemyPet3Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet3AtkPowerIconText:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet3Health.backdrop, "LEFT", -18, 0)
TukuiPetBattleHUD_EnemyPet3NameText = TukuiPetBattleHUD_EnemyPet3:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet3NameText:SetPoint("BOTTOMRIGHT", TukuiPetBattleHUD_EnemyPet3Health.backdrop, "TOPRIGHT", 0, 2)

local TukuiPetBattleHUD_EnemyPet3Experience = CreateFrame('StatusBar', "TukuiPetBattleHUD_EnemyPet3Experience", TukuiPetBattleHUD_EnemyPet3)
TukuiPetBattleHUD_EnemyPet3Experience:SetPoint("TOP", TukuiPetBattleHUD_EnemyPet3Health, "BOTTOM", 0, -5)
TukuiPetBattleHUD_EnemyPet3Experience:Size(150, 10)
TukuiPetBattleHUD_EnemyPet3Experience:SetFrameLevel(TukuiPetBattleHUD_EnemyPet3:GetFrameLevel() + 2)
TukuiPetBattleHUD_EnemyPet3Experience:CreateBackdrop()
TukuiPetBattleHUD_EnemyPet3Experience:SetReverseFill(true)
TukuiPetBattleHUD_EnemyPet3ExperienceText = TukuiPetBattleHUD_EnemyPet3Experience:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet3ExperienceText:SetPoint("CENTER", TukuiPetBattleHUD_EnemyPet3Experience.backdrop, "CENTER", 0, 0)
TukuiPetBattleHUD_EnemyPet3AtkSpeedIcon = TukuiPetBattleHUD_EnemyPet3:CreateTexture("TukuiPetBattleHUD_EnemyPet3AtkSpeedIcon", "OVERLAY")
TukuiPetBattleHUD_EnemyPet3AtkSpeedIcon:SetTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
TukuiPetBattleHUD_EnemyPet3AtkSpeedIcon:Size(16)
TukuiPetBattleHUD_EnemyPet3AtkSpeedIcon:SetPoint("TOPRIGHT", TukuiPetBattleHUD_EnemyPet3Experience.backdrop, "LEFT", -2, 8)
TukuiPetBattleHUD_EnemyPet3AtkSpeedIconText = TukuiPetBattleHUD_EnemyPet3Health:CreateFontString(nil, "OVERLAY")
TukuiPetBattleHUD_EnemyPet3AtkSpeedIconText:SetPoint("RIGHT", TukuiPetBattleHUD_EnemyPet3Experience.backdrop, "LEFT", -18, 0)
--
PetBattleFrame:HookScript("OnShow", function() TukuiPetBattleHUD_Pet1:Show() end)
PetBattleFrame:HookScript("OnHide", function()
	TukuiPetBattleEnemyHUDInit = nil
	TukuiPetBattleHUD_EnemyPet1:Hide()
	if not PBHShow then
		TukuiPetBattleHUD_Pet1:Hide()
	end
end)

function PlayerPetUpdate()
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
		_G["TukuiPetBattleHUD_Pet"..i.."NameText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."NameText"]:SetText(customName or name)
		_G["TukuiPetBattleHUD_Pet"..i.."NameText"]:SetTextColor(r, g, b)
		_G["TukuiPetBattleHUD_Pet"..i.."IconBackdrop"].backdrop:SetBackdropBorderColor(r,g,b)
		_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropTexture"]:SetTexture(icon)
		_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."IconBackdropText"]:SetText(level)
		_G["TukuiPetBattleHUD_Pet"..i.."IconPetTypeTexture"]:SetTexture("Interface\\AddOns\\PetBattleHUD\\"..PET_TYPE_SUFFIX[petType])
		_G["TukuiPetBattleHUD_Pet"..i.."Health"]:SetStatusBarTexture(normtex)
		_G["TukuiPetBattleHUD_Pet"..i.."Health"]:SetStatusBarColor(0.11,0.66,0.11)
		_G["TukuiPetBattleHUD_Pet"..i.."HealthText"]:SetFont(font, fontsize, fontflag)
		_G["TukuiPetBattleHUD_Pet"..i.."Experience"]:SetStatusBarTexture(normtex)
		_G["TukuiPetBattleHUD_Pet"..i.."Experience"]:SetStatusBarColor(0.6,0,0.86)
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
		TukuiPetBattleHUD_EnemyPet1:Hide()
		TukuiPetBattleHUDInit = true
	end
end

function EnemyPetUpdate()
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

TukuiPetBattleHUD = CreateFrame("Frame", nil, TukuiPetBattleHUD_Pet1)
TukuiPetBattleHUD:SetPoint("CENTER")
TukuiPetBattleHUD:RegisterEvent("COMPANION_UPDATE")
TukuiPetBattleHUD:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiPetBattleHUD:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
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
			if not TukuiPetBattleHUDInit then PlayerPetUpdate() end
			if C_PetBattles.IsInBattle() then
				if not TukuiPetBattleEnemyHUDInit then EnemyPetUpdate() end
				PetBattleFrameXPBar:Hide()
				_G["TukuiPetBattleHUD_Pet"..i.."Health"]:SetMinMaxValues(0, C_PetBattles.GetMaxHealth(LE_BATTLE_PET_ALLY, i))
				_G["TukuiPetBattleHUD_Pet"..i.."Health"]:SetValue(C_PetBattles.GetHealth(LE_BATTLE_PET_ALLY, i))
				_G["TukuiPetBattleHUD_Pet"..i.."HealthText"]:SetText(C_PetBattles.GetHealth(LE_BATTLE_PET_ALLY, i).." / "..C_PetBattles.GetMaxHealth(LE_BATTLE_PET_ALLY, i))
				_G["TukuiPetBattleHUD_Pet"..i.."AtkPowerIconText"]:SetText(C_PetBattles.GetPower(LE_BATTLE_PET_ALLY, i))
				_G["TukuiPetBattleHUD_Pet"..i.."AtkSpeedIconText"]:SetText(C_PetBattles.GetSpeed(LE_BATTLE_PET_ALLY, i))

				_G["TukuiPetBattleHUD_EnemyPet"..i.."Health"]:SetMinMaxValues(0, C_PetBattles.GetMaxHealth(LE_BATTLE_PET_ENEMY, i))
				_G["TukuiPetBattleHUD_EnemyPet"..i.."Health"]:SetValue(C_PetBattles.GetHealth(LE_BATTLE_PET_ENEMY, i))
				_G["TukuiPetBattleHUD_EnemyPet"..i.."HealthText"]:SetText(C_PetBattles.GetHealth(LE_BATTLE_PET_ENEMY, i).." / "..C_PetBattles.GetMaxHealth(LE_BATTLE_PET_ENEMY, i))
				_G["TukuiPetBattleHUD_EnemyPet"..i.."AtkPowerIconText"]:SetText(C_PetBattles.GetPower(LE_BATTLE_PET_ENEMY, i))
				_G["TukuiPetBattleHUD_EnemyPet"..i.."AtkSpeedIconText"]:SetText(C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, i))
			end
		end
	end)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	if event == "COMPANION_UPDATE" then
		if TukuiPetBattleHUD_Pet1:IsShown() then
			PlayerPetUpdate()
		end
	end
end)

PetBattleHUDCombatDetect = CreateFrame("Frame")
PetBattleHUDCombatDetect:RegisterEvent("PLAYER_REGEN_DISABLED")
PetBattleHUDCombatDetect:RegisterEvent("PLAYER_REGEN_ENABLED")
PetBattleHUDCombatDetect:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_DISABLED" or InCombatLockdown() then
		TukuiPetBattleHUD_Pet1:Hide()
	else
		TukuiPetBattleHUD_Pet1:Show()
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

	PetBattleFrame.EnemyPadDebuffFrame:ClearAllPoints()
	PetBattleFrame.EnemyPadBuffFrame:ClearAllPoints()
	PetBattleFrame.AllyPadDebuffFrame:ClearAllPoints()
	PetBattleFrame.AllyPadBuffFrame:ClearAllPoints()
	PetBattleFrame.EnemyPadDebuffFrame:SetPoint("BOTTOMLEFT", TukuiPetBattleHUD_EnemyPet1, "BOTTOMRIGHT", -9, 0)
	PetBattleFrame.EnemyPadBuffFrame:SetPoint("TOPLEFT", TukuiPetBattleHUD_EnemyPet1, "TOPRIGHT", -9, 0)
	PetBattleFrame.AllyPadDebuffFrame:SetPoint("TOPRIGHT", TukuiPetBattleHUD_Pet1, "TOPLEFT", 8, 0)
	PetBattleFrame.AllyPadBuffFrame:SetPoint("BOTTOMRIGHT", TukuiPetBattleHUD_Pet1, "BOTTOMLEFT", 8, 0)
]]