if not (IsAddOnLoaded("Tukui") or IsAddOnLoaded("AsphyxiaUI") or IsAddOnLoaded("DuffedUI") or IsAddOnLoaded("ElvUI")) then return end
local A, C = unpack(Tukui or ElvUI or AsphyxiaUI or DuffedUI)
local PBH = ElvUI and A:NewModule('PetBattleHUD','AceEvent-3.0')
local LSM

local font, fontsize, fontflag, border, offset, normtex


if ElvUI then
	LSM = LibStub("LibSharedMedia-3.0");
	font, fontsize, fontflag = LSM:Fetch("font", A.db.general.font), 12, "OUTLINE"
	normtex = LSM:Fetch("statusbar", A.private.general.normTex)
	border = A["media"]["bordercolor"]
	offset = -1
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
	border = C["media"]["bordercolor"]
	normtex = C["media"].normTex
	if not AsphyxiaUI then offset = 1 else offset = 0 end
end

local function EnableMover(frame,isFriend)
	if ElvUI then
		A:CreateMover(frame, 
			isFriend and "BattlePetMover" or "EnemyBattlePetMover",
			isFriend and "Battle Pet Frames" or "Enemy Battle Pet Frames", 
			nil, nil, nil, "ALL,SOLO"
		)
	else
		frame:SetMovable(true)
		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
		frame:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
		frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing()  end)
	end
end

local function CheckOption(option)
	if ElvUI then
		if option == "PBHShow" then
			return A.db.petbattlehud["alwaysShow"]
		elseif option == "BlizzKill" then
			return A.db.petbattlehud["hideBlizzard"]
		elseif option == "GrowUp" then
			return A.db.petbattlehud["growUp"]
		elseif option == "ShowBreakdown" then
			return A.db.petbattlehud["showBreakdown"]
		end
	else
		return _G[option]
	end
end

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function CreatePlayerHUD(name, owner, num)
	local width = 260
	local frame = CreateFrame("Frame", name, UIParent)
	frame:Hide()
	frame:Size(width, 60)
	frame:CreateBackdrop("Transparent")
	frame.backdrop:CreateShadow()
	frame:SetScript("OnUpdate", function(self)
		local petID = C_PetJournal.GetPetLoadOutInfo(num)
		if petID == nil then return end
		local _, customName, level, xp, maxXp, _, _, petname, icon, petType = C_PetJournal.GetPetInfoByPetID(C_PetJournal.GetPetLoadOutInfo(num))
		local hp, maxhp, power, speed, rarity = C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(num))
		if hp == 0 then	ReviveBattlePetButton:Show() BandageBattlePetButton:Show() end
		local r, g, b = GetItemQualityColor(rarity-1)
		if hp == 0 then
			_G[name.."IconBackdropTexture"]:SetDesaturated(true)
			_G[name.."IconBackdropTextureDead"]:Show()
		else
			_G[name.."IconBackdropTexture"]:SetDesaturated(false)
			_G[name.."IconBackdropTextureDead"]:Hide()
		end
		_G[name.."NameText"]:SetFont(font, fontsize, fontflag)
		_G[name.."NameText"]:SetTextColor(r, g, b)
		_G[name.."IconBackdrop"].backdrop:SetBackdropBorderColor(r,g,b)
		_G[name.."IconBackdropTexture"]:SetTexture(icon)
		_G[name.."IconBackdropText"]:SetFont(font, fontsize, fontflag)
		_G[name.."IconPetTypeTexture"]:SetTexture("Interface\\AddOns\\PetBattleHUD\\"..PET_TYPE_SUFFIX[petType])
		_G[name.."Health"]:SetStatusBarTexture(normtex)
		local normalized = hp/maxhp
		_G[name.."Health"]:GetStatusBarTexture():SetVertexColor(1-normalized, normalized, 0/255)
		_G[name.."HealthText"]:SetFont(font, fontsize, fontflag)
		_G[name.."Experience"]:SetStatusBarTexture(normtex)
		_G[name.."Experience"]:SetStatusBarColor(0.24,0.54,0.78)
		_G[name.."ExperienceText"]:SetFont(font, fontsize, fontflag)
		_G[name.."Buff1Text"]:SetFont(font, 20, fontflag)
		_G[name.."Buff2Text"]:SetFont(font, 20, fontflag)
		_G[name.."Buff3Text"]:SetFont(font, 20, fontflag)
		_G[name.."Debuff1Text"]:SetFont(font, 20, fontflag)
		_G[name.."Debuff2Text"]:SetFont(font, 20, fontflag)
		_G[name.."Debuff3Text"]:SetFont(font, 20, fontflag)
		_G[name.."AtkPowerIconText"]:SetFont(font, fontsize, fontflag)
		_G[name.."AtkSpeedIconText"]:SetFont(font, fontsize, fontflag)
		_G[name.."NameText"]:SetTextColor(r, g, b)
		_G[name.."NameText"]:SetText(customName or petname)
		_G[name.."IconBackdropText"]:SetText(level)
		if not C_PetBattles.IsInBattle() then
			_G[name.."AtkPowerIconText"]:SetText(power)
			_G[name.."AtkSpeedIconText"]:SetText(speed)
			_G[name.."ExperienceText"]:SetText(xp.." / "..maxXp)
			_G[name.."Experience"]:SetMinMaxValues(0, maxXp)
			_G[name.."Experience"]:SetValue(xp)
			_G[name.."Health"]:SetMinMaxValues(0, maxhp)
			_G[name.."Health"]:SetValue(hp)
			_G[name.."HealthText"]:SetText(hp.." / "..maxhp)
			_G[name.."AtkPowerIconText"]:SetTextColor(1, 1, 1, 1)
			_G[name.."AtkSpeedIconText"]:SetTextColor(1, 1, 1, 1)
			_G[name.."AtkSpeedIcon"]:SetVertexColor(1, 1, 0)
			for i = 1, 3 do
				_G[name.."Buff"..i]:Hide()
				_G[name.."Debuff"..i]:Hide()
			end
		else
			HUDSetupAuras(name, owner, num)
			_G[name.."Health"]:SetMinMaxValues(0, C_PetBattles.GetMaxHealth(owner, num))
			_G[name.."Health"]:SetValue(C_PetBattles.GetHealth(owner, num))
			_G[name.."HealthText"]:SetText(C_PetBattles.GetHealth(owner, num).." / "..C_PetBattles.GetMaxHealth(owner, num))
			_G[name.."AtkPowerIconText"]:SetText(C_PetBattles.GetPower(owner, num))
			_G[name.."AtkSpeedIconText"]:SetText(C_PetBattles.GetSpeed(owner, num))

			if C_PetBattles.GetPower(owner, num) > select(3,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(num))) then
				_G[name.."AtkPowerIconText"]:SetTextColor(0, 1, 0, 1)
			elseif C_PetBattles.GetPower(owner, num) < select(3,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(num))) then
				_G[name.."AtkPowerIconText"]:SetTextColor(1, 0, 0, 1)
			else
				_G[name.."AtkPowerIconText"]:SetTextColor(1, 1, 1, 1)
			end
				
			if C_PetBattles.GetSpeed(owner, num) > select(4,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(num))) then
				_G[name.."AtkSpeedIconText"]:SetTextColor(0, 1, 0, 1)
			elseif C_PetBattles.GetSpeed(owner, num) < select(4,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(num))) then
				_G[name.."AtkSpeedIconText"]:SetTextColor(1, 0, 0, 1)
			else
				_G[name.."AtkSpeedIconText"]:SetTextColor(1, 1, 1, 1)
			end
				
			local normalized = C_PetBattles.GetHealth(owner, num) / C_PetBattles.GetMaxHealth(owner, num)
			_G[name.."Health"]:GetStatusBarTexture():SetVertexColor(1-normalized, normalized, 0/255)
			_G[name.."Experience"]:SetMinMaxValues(0, select(2,C_PetBattles.GetXP(owner, num)))
			_G[name.."Experience"]:SetValue(select(1,C_PetBattles.GetXP(owner, num)))
			_G[name.."ExperienceText"]:SetText(select(1,C_PetBattles.GetXP(owner, num)).." / "..select(2,C_PetBattles.GetXP(owner, num)))
				
			if C_PetBattles.GetHealth(owner, num) == 0 then
				_G[name.."IconBackdropTexture"]:SetDesaturated(true)
				_G[name.."IconBackdropTextureDead"]:Show()
			else
				_G[name.."IconBackdropTexture"]:SetDesaturated(false)
				_G[name.."IconBackdropTextureDead"]:Hide()
			end
		end
	end)
	
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
	_G[name.."Health"].backdrop:SetBackdropColor(0,0,0,0)
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
	_G[name.."Experience"].backdrop:SetBackdropColor(0,0,0,0)
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

local function CreateEnemyHUD(name, owner, num)
	local width = 260
	local frame = CreateFrame("Frame", name, UIParent)
	frame:Hide()
	frame:Size(width, 60)
	frame:CreateBackdrop("Transparent")
	frame.backdrop:CreateShadow()
	frame:SetScript("OnShow", function()
		local targetID = C_PetBattles.GetPetSpeciesID(owner, num)
		local enemyquality = C_PetBattles.GetBreedQuality(owner, num)
		local owned = C_PetJournal.GetOwnedBattlePetString(targetID)
		if owned == nil or owned == "Not Collected" then
			frame.backdrop:SetBackdropBorderColor(1,0,0)
		else
			frame.backdrop:SetBackdropBorderColor(unpack(border))
			if C_PetBattles.IsWildBattle(owner, num) then
				local ownedquality = PBHGetHighestQuality(targetID)
				if ownedquality ~= -1 then
					if ownedquality == nil then print("Owned Quality Breaking. Report issue to Azilroka.") return end
					if enemyquality == nil then print("Enemy Quality Breaking. Report issue to Azilroka.") return end
					if ownedquality < enemyquality then
						frame.backdrop:SetBackdropBorderColor(1,0.35,0)
					end
				end
			end
		end
	end)
	frame:SetScript("OnHide", function(self)
		_G[name.."IconBackdropTexture"]:SetDesaturated(false)
		_G[name.."IconBackdropTextureDead"]:Hide()
		_G[name.."AtkSpeedIcon"]:SetVertexColor(1, 1, 0)
		for i = 1, 3 do
			_G[name.."Buff"..i]:Hide()
			_G[name.."Debuff"..i]:Hide()
		end
		self.oldpower = nil
		self.oldspeed = nil
	end)
	frame:SetScript("OnUpdate", function(self)
		local enemycustomName, enemyname, enemypower, enemyspeed, enemyxp, enemymaxXP, enemylevel, enemyicon, enemytype, enemyquality, enemyhp, enemymaxhp, enemyspeciesID
		enemycustomName, enemyname = C_PetBattles.GetName(owner, num)
		enemypower = C_PetBattles.GetPower(owner, num)
		enemyspeed = C_PetBattles.GetSpeed(owner, num)
		enemyxp, enemymaxXP = C_PetBattles.GetXP(owner, num)
		enemylevel = C_PetBattles.GetLevel(owner, num)
		enemyicon = C_PetBattles.GetIcon(owner, num)
		enemytype = C_PetBattles.GetPetType(owner, num)
		enemyquality = C_PetBattles.GetBreedQuality(owner, num)
		enemyhp = C_PetBattles.GetHealth(owner, num)
		enemymaxhp = C_PetBattles.GetMaxHealth(owner, num)
		enemyspeciesID = C_PetBattles.GetPetSpeciesID(owner, num)
		local er, eg, eb = GetItemQualityColor(enemyquality-1)
		_G[name.."NameText"]:SetFont(font, fontsize, fontflag)
		_G[name.."NameText"]:SetText(enemycustomName or enemyname)
		_G[name.."NameText"]:SetTextColor(er, eg, eb)
		_G[name.."IconBackdrop"].backdrop:SetBackdropBorderColor(er,eg,eb)
		_G[name.."IconBackdropText"]:SetFont(font, fontsize, fontflag)
		_G[name.."IconBackdropText"]:SetText(enemylevel)
		_G[name.."IconBackdropTexture"]:SetTexture(enemyicon)
		_G[name.."IconPetTypeTexture"]:SetTexture("Interface\\AddOns\\PetBattleHUD\\"..PET_TYPE_SUFFIX[enemytype])
		_G[name.."Health"]:SetStatusBarTexture(normtex)
		_G[name.."Health"]:SetStatusBarColor(0.11,0.66,0.11)
		_G[name.."Health"]:SetMinMaxValues(0, enemymaxhp)
		_G[name.."Health"]:SetValue(enemyhp)
		_G[name.."HealthText"]:SetFont(font, fontsize, fontflag)
		_G[name.."HealthText"]:SetText(enemyhp.." / "..enemymaxhp)
		_G[name.."Experience"]:SetStatusBarTexture(normtex)
		_G[name.."Experience"]:SetStatusBarColor(0.6,0,0.86)
		_G[name.."Experience"]:SetMinMaxValues(0, enemymaxXP)
		_G[name.."Experience"]:SetValue(enemyxp)
		_G[name.."ExperienceText"]:SetFont(font, fontsize, fontflag)
		_G[name.."ExperienceText"]:SetText(enemyxp.." / "..enemymaxXP)
		_G[name.."AtkPowerIconText"]:SetFont(font, fontsize, fontflag)
		_G[name.."AtkSpeedIconText"]:SetFont(font, fontsize, fontflag)
		_G[name.."AtkPowerIconText"]:SetText(enemypower)
		_G[name.."AtkSpeedIconText"]:SetText(enemyspeed)
		_G[name.."Buff1Text"]:SetFont(font, 20, fontflag)
		_G[name.."Buff2Text"]:SetFont(font, 20, fontflag)
		_G[name.."Buff3Text"]:SetFont(font, 20, fontflag)
		_G[name.."Debuff1Text"]:SetFont(font, 20, fontflag)
		_G[name.."Debuff2Text"]:SetFont(font, 20, fontflag)
		_G[name.."Debuff3Text"]:SetFont(font, 20, fontflag)
		if not self.oldpower then self.oldpower = enemypower end
		if not self.oldspeed then self.oldspeed = enemyspeed end
		
		HUDSetupAuras(name, owner, num)
		
		if C_PetBattles.GetPower(owner, num) > self.oldpower then
			_G[name.."AtkPowerIconText"]:SetTextColor(0, 1, 0)
		elseif C_PetBattles.GetPower(owner, num) < self.oldpower then
			_G[name.."AtkPowerIconText"]:SetTextColor(1, 0, 0)
		else
			_G[name.."AtkPowerIconText"]:SetTextColor(1, 1, 1)
		end
		
		if C_PetBattles.GetSpeed(owner, num) > self.oldspeed then
			_G[name.."AtkSpeedIconText"]:SetTextColor(0, 1, 0)
		elseif C_PetBattles.GetSpeed(owner, num) < self.oldspeed then
			_G[name.."AtkSpeedIconText"]:SetTextColor(1, 0, 0)
		else
			_G[name.."AtkSpeedIconText"]:SetTextColor(1, 1, 1)
		end
		
		if C_PetBattles.GetHealth(owner, num) == 0 then
			_G[name.."IconBackdropTexture"]:SetDesaturated(true)
			_G[name.."IconBackdropTextureDead"]:Show()
		else
			_G[name.."IconBackdropTexture"]:SetDesaturated(false)
			_G[name.."IconBackdropTextureDead"]:Hide()
		end

		local normalized = C_PetBattles.GetHealth(owner, num) / C_PetBattles.GetMaxHealth(owner, num)
		_G[name.."Health"]:GetStatusBarTexture():SetVertexColor(1-normalized, normalized, 0/255)

		_G[name.."AtkSpeedIcon"]:SetVertexColor(1, 1, 0)
		_G[name.."AtkSpeedIcon"]:SetVertexColor(1, 1, 0)

		local activeally = C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY)
		local activeenemy = C_PetBattles.GetActivePet(LE_BATTLE_PET_ENEMY)
		if C_PetBattles.GetSpeed(LE_BATTLE_PET_ALLY, activeally) > C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, activeenemy) then
			_G["TukuiPetBattleHUD_Pet"..activeally.."AtkSpeedIcon"]:SetVertexColor(0, 1, 0)
			_G["TukuiPetBattleHUD_EnemyPet"..activeenemy.."AtkSpeedIcon"]:SetVertexColor(1, 0, 0)
		elseif C_PetBattles.GetSpeed(LE_BATTLE_PET_ALLY, activeally) < C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, activeenemy) then
			_G["TukuiPetBattleHUD_Pet"..activeally.."AtkSpeedIcon"]:SetVertexColor(1, 0, 0)
			_G["TukuiPetBattleHUD_EnemyPet"..activeenemy.."AtkSpeedIcon"]:SetVertexColor(0, 1, 0)
		end
	end)

	_G[name.."IconBackdrop"] = CreateFrame("Frame", _G[name.."IconBackdrop"], frame)
	_G[name.."IconBackdrop"]:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
	_G[name.."IconBackdrop"]:CreateBackdrop()
	_G[name.."IconBackdrop"]:Size(40)
	_G[name.."IconBackdrop"]:SetScript("OnEnter", function(self,...)
		GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 2, 4)
		GameTooltip:ClearLines()
		local targetID = C_PetBattles.GetPetSpeciesID(owner, num)
		GameTooltip:AddDoubleLine("Current Enemy", PBHGetBreedID_Battle(num), 1, 1, 1, 1, 1, 1)
		local ownedString = C_PetJournal.GetOwnedBattlePetString(targetID)
		if ownedString ~= nil then GameTooltip:AddLine(" ") GameTooltip:AddLine(ownedString) end
		for i=1,C_PetJournal.GetNumPets(false) do 
			local petID, speciesID, _, _, level, _, _, _, _, petType, _, _, _, _, _, _, _ = C_PetJournal.GetPetInfoByIndex(i)

			if speciesID == targetID then
				local _, maxHealth, power, speed = C_PetJournal.GetPetStats(petID)
				local speciesID = C_PetJournal.GetPetInfoByPetID(petID)
				if C_PetJournal.GetBattlePetLink(petID) then
					GameTooltip:AddLine(" ")
					GameTooltip:AddDoubleLine(C_PetJournal.GetBattlePetLink(petID), PBHGetBreedID_Journal(petID), 1, 1, 1, 1, 1, 1)
					GameTooltip:AddDoubleLine("Species ID", speciesID, 1, 1, 1, 1, 0, 0)
					GameTooltip:AddLine("Level "..level.."|r", 1, 1, 1)
					--if not PetJournalEnhanced or not CheckOption("ShowBreakdown") then
						GameTooltip:AddLine(maxHealth, 1, 1, 1)
						GameTooltip:AddTexture("Interface\\AddOns\\PetBattleHUD\\TooltipHealthIcon")
						GameTooltip:AddLine(power, 1, 1, 1)
						GameTooltip:AddTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
						GameTooltip:AddLine(speed, 1, 1, 1)
						GameTooltip:AddTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
					--[[else
						local BreedInfo = LibStub("LibPetBreedInfo-1.0")
						local h25, p25, s25, breedIndex, confidence = BreedInfo:Extrapolate(petID,25)
						local hpds, pbds, sbds = unpack(PBHGetLevelBreakdown(petID))
						local c1, c2, c3 = 1, 1, 0.8
						assert(type(confidence)=="number")
						if confidence > .15 then
							c1, c2, c3 = 1, .53, .53
						end
						GameTooltip:AddDoubleLine("Stats Per Level", 1, 1, 1)
						GameTooltip:AddDoubleLine(maxHealth, round(hpds,2), 1, 1, 1, 1, 1, 1)
						GameTooltip:AddTexture("Interface\\AddOns\\PetBattleHUD\\TooltipHealthIcon")
						GameTooltip:AddDoubleLine("At Level 25", h25, 1, 1, 1, c1, c2, c3)
						GameTooltip:AddDoubleLine(power, round(pbds, 2), 1, 1, 1, 1, 1, 1)
						GameTooltip:AddTexture("Interface\\AddOns\\PetBattleHUD\\TooltipAttackIcon")
						GameTooltip:AddDoubleLine("At Level 25", p25, 1, 1, 1, c1, c2, c3)
						GameTooltip:AddDoubleLine(speed, round(sbds, 2), 1, 1, 1, 1, 1, 1)
						GameTooltip:AddTexture("Interface\\AddOns\\PetBattleHUD\\TooltipSpeedIcon")
						GameTooltip:AddDoubleLine("At Level 25", s25, 1, 1, 1, c1, c2, c3)
						GameTooltip:AddDoubleLine("Breed Index", breedIndex, 1, 1, 1, 1, 1, 1)
						GameTooltip:AddDoubleLine("Confidence", confidence, 1, 1, 1, c1, c2, c3)
					end]]
				end
			end
		end
		GameTooltip:Show()
	end)

	_G[name.."IconBackdrop"]:SetScript("OnLeave", function(self,...) GameTooltip:Hide() end)
	_G[name.."IconBackdropText"] = _G[name.."IconBackdrop"]:CreateFontString(nil, "OVERLAY")
	_G[name.."IconBackdropText"]:SetPoint("BOTTOMLEFT", 2, 2)

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
	_G[name.."Health"].backdrop:SetBackdropColor(0,0,0,0)
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
	_G[name.."Experience"].backdrop:SetBackdropColor(0,0,0,0)
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

function HUDSetupAuras(frame, owner, index)
	
	_G[frame.."Buff1"]:Hide()
	_G[frame.."Buff2"]:Hide()
	_G[frame.."Buff3"]:Hide()
	_G[frame.."Debuff1"]:Hide()
	_G[frame.."Debuff2"]:Hide()
	_G[frame.."Debuff3"]:Hide()
	for i = 1, 6 do
		local id, name, icon, maxCooldown, description, auraID, instanceID, turnsRemaining, isBuff, casterOwner, casterIndex
		auraID, instanceID, turnsRemaining, isBuff, casterOwner, casterIndex = C_PetBattles.GetAuraInfo(owner, index, i)
		if auraID then id, name, icon, maxCooldown, description = C_PetBattles.GetAbilityInfoByID(auraID) else return end
		if isBuff then
			if not _G[frame.."Buff1"]:IsShown() then
				_G[frame.."Buff1"]:Show()
				_G[frame.."Buff1"]:SetBackdropBorderColor(0,1,0)
				if turnsRemaining >= 0 then _G[frame.."Buff1Text"]:SetText(turnsRemaining) else _G[frame.."Buff1Text"]:SetText(" ") end
				_G[frame.."Buff1Texture"]:SetTexture(icon)
			elseif not _G[frame.."Buff2"]:IsShown() then
				_G[frame.."Buff2"]:Show()
				_G[frame.."Buff2"]:SetBackdropBorderColor(0,1,0)
				if turnsRemaining >= 0 then _G[frame.."Buff2Text"]:SetText(turnsRemaining) else _G[frame.."Buff2Text"]:SetText(" ") end
				_G[frame.."Buff2Texture"]:SetTexture(icon)
			elseif not _G[frame.."Buff3"]:IsShown() then
				_G[frame.."Buff3"]:Show()
				_G[frame.."Buff3"]:SetBackdropBorderColor(0,1,0)
				if turnsRemaining >= 0 then _G[frame.."Buff3Text"]:SetText(turnsRemaining) else _G[frame.."Buff3Text"]:SetText(" ") end
				_G[frame.."Buff3Texture"]:SetTexture(icon)
			end
		else
			if not _G[frame.."Debuff1"]:IsShown() then
				_G[frame.."Debuff1"]:Show()
				_G[frame.."Debuff1"]:SetBackdropBorderColor(1,0,0)
				if turnsRemaining >= 0 then _G[frame.."Debuff1Text"]:SetText(turnsRemaining) else _G[frame.."Debuff1Text"]:SetText(" ") end
				_G[frame.."Debuff1Texture"]:SetTexture(icon)
			elseif not _G[frame.."Debuff2"]:IsShown() then
				_G[frame.."Debuff2"]:Show()
				_G[frame.."Debuff2"]:SetBackdropBorderColor(1,0,0)
				if turnsRemaining >= 0 then _G[frame.."Debuff2Text"]:SetText(turnsRemaining) else _G[frame.."Debuff2Text"]:SetText(" ") end
				_G[frame.."Debuff2Texture"]:SetTexture(icon)
			elseif not _G[frame.."Debuff3"]:IsShown() then
				_G[frame.."Debuff3"]:Show()
				_G[frame.."Debuff3"]:SetBackdropBorderColor(1,0,0)
				if turnsRemaining >= 0 then _G[frame.."Debuff3Text"]:SetText(turnsRemaining) else _G[frame.."Debuff3Text"]:SetText(" ") end
				_G[frame.."Debuff3Texture"]:SetTexture(icon)
			end
		end
	end
end

if ElvUI then
	local P = select(4,unpack(ElvUI))
	P.petbattlehud = {
		["alwaysShow"] = false,
		["hideBlizzard"] = false,
		["showBreakdown"] = true,
		["growUp"] = false
	}
	A.Options.args.petbattlehud = {
		type = "group",
		name = "Pet Battle HUD",
		order = 3,
		args = {
			header = {
				order = 1,
				type = "header",
				name = "Unit Frames for Pet Battles",
			},
			general = {
				order = 2,
				type = "group",
				name = "General",
				guiInline = true,
				get = function(info) return A.db.petbattlehud[ info[#info] ] end,
    			set = function(info,value) A.db.petbattlehud[ info[#info] ] = value; end, 
				args = {
					alwaysShow = {
						order = 1,
						type = "toggle",
						name = "Always Show",
						desc = "Always show the unit frames even when not in battle",
					},
					hideBlizzard = {
						order = 2,
						type = "toggle",
						name = "Hide Blizzard",
						desc = "Hide the Blizzard Pet Frames during battles",
		    			set = function(info,value) A.db.petbattlehud[ info[#info] ] = value; if not value then A:StaticPopup_Show("CONFIG_RL"); end end, 
					},
					showBreakdown = {
						order = 3,
						type = "toggle",
						name = "Show a breakdown of stats",
						desc = "Show a breakdown of stat bonus per level and stat prediction at Level 25",
					},
					growUp = {
						order = 4,
						type = "toggle",
						name = "Grow the frames upwards",
						desc = "Grow the frames from bottom for first pet upwards",
						set = function(info,value) A.db.petbattlehud[ info[#info] ] = value; A:StaticPopup_Show("CONFIG_RL") end, 
					},
				},
			},
		},
	}
else
	SLASH_PBH1 = "/pbh"
	SlashCmdList["PBH"] = function(arg)
		if arg == "KillBlizzardUI" then
			if BlizzKill then
				BlizzKill = nil
				print("Blizzard Pet Battle UI will show upon reload. /rl")
			else
				BlizzKill = true
				print("Killing Blizzard PetBattle UI...")
			end
		elseif arg == "show" or arg == "hide" then
			if TukuiPetBattleHUD_Pet1:IsShown() then
				HidePBH()
				PBHShow = nil
			else
				ShowPBH()
				PBHShow = true
			end
		elseif arg == "growup" or arg == "growdown" then
			if GrowUp then
				GrowUp = false
			else
				GrowUp = true
			end
			print("You must reload your UI for changes to take place. /rl")
		elseif arg == "breakdown" or arg == "showstats" then
			if ShowBreakdown then
				ShowBreakdown = false
			else
				ShowBreakdown = true
			end
		elseif arg == "" then
			print("Pet Battle HUD Options.")
			print("/pbh show or hide - Show/Hide Frames. (Permanent Show) ")
			print("/pbh KillBlizzardUI - Kills out the default Blizzard Pet Battle UI.")
			print("/pbh growup or growdown - Changes the anchors for the growth.")
		end
	end
end

function PBHGetHighestQuality(enemyspeciesID)
	local numPets = C_PetJournal.GetNumPets(PetJournal.isWild)
	local MaxQuality = -1
	for i = 1, numPets do
	local petID, speciesID = C_PetJournal.GetPetInfoByIndex(i, isWild)
		if speciesID == enemyspeciesID then
			local _, _, _, _, Quality = C_PetJournal.GetPetStats(petID)
			if Quality == nil then Quality = -1 end
			if MaxQuality < Quality then
				MaxQuality = Quality
			end
		end
	end
	return MaxQuality
end

local function UpdateHud(self)
	print("|cffC495DDTukui|r & |cff1784d1ElvUI |rPet Battle HUD by |cFFFF7D0AAzilroka|r - Version: |cff1784d1"..GetAddOnMetadata("PetBattleHUD", "Version").."|r Loaded!")
	local point, relativePoint, xcoord, ycoord
	if CheckOption("GrowUp") then
		point = "BOTTOM"
		relativePoint = "TOP"
		xcoord = 0
		ycoord = 8
	else
		point = "TOP"
		relativePoint = "BOTTOM"
		xcoord = 0
		ycoord = -8
	end
	
	TukuiPetBattleHUD_Pet2:SetPoint(point, TukuiPetBattleHUD_Pet1, relativePoint, xcoord, ycoord)
	TukuiPetBattleHUD_Pet3:SetPoint(point, TukuiPetBattleHUD_Pet2, relativePoint, xcoord, ycoord)
	
	TukuiPetBattleHUD_EnemyPet2:SetPoint(point, TukuiPetBattleHUD_EnemyPet1, relativePoint, xcoord, ycoord)
	TukuiPetBattleHUD_EnemyPet3:SetPoint(point, TukuiPetBattleHUD_EnemyPet2, relativePoint, xcoord, ycoord)
end

function HidePBH()
	TukuiPetBattleHUD_Pet1:Hide()
	TukuiPetBattleHUD_Pet2:Hide()
	TukuiPetBattleHUD_Pet3:Hide()
end

function ShowPBH()
	for i = 1, 3 do
		local petID = C_PetJournal.GetPetLoadOutInfo(i)
		if petID == nil then return end
		if CheckOption("PBHShow") then
			if i == 1 then TukuiPetBattleHUD_Pet1:Show() end
			if i == 2 then TukuiPetBattleHUD_Pet2:Show() end
			if i == 3 then TukuiPetBattleHUD_Pet3:Show() end
		end
	end
	if C_PetBattles.IsInBattle() then
		local allyframes = C_PetBattles.GetNumPets(LE_BATTLE_PET_ALLY)
		for i = 1, allyframes do
			_G["TukuiPetBattleHUD_Pet"..i]:Show()
		end
		local enemyframes = C_PetBattles.GetNumPets(LE_BATTLE_PET_ENEMY)
		for i = 1, enemyframes do
			_G["TukuiPetBattleHUD_EnemyPet"..i]:Show()
		end
	end
end

local function SetupPBH()
	CreatePlayerHUD("TukuiPetBattleHUD_Pet1", LE_BATTLE_PET_ALLY, 1)
	TukuiPetBattleHUD_Pet1:Point("RIGHT", UIParent, "BOTTOM", -200, 200)
	EnableMover(TukuiPetBattleHUD_Pet1, true)

	CreatePlayerHUD("TukuiPetBattleHUD_Pet2", LE_BATTLE_PET_ALLY, 2)
	TukuiPetBattleHUD_Pet2:SetParent(TukuiPetBattleHUD_Pet1)
	
	CreatePlayerHUD("TukuiPetBattleHUD_Pet3", LE_BATTLE_PET_ALLY, 3)
	TukuiPetBattleHUD_Pet3:SetParent(TukuiPetBattleHUD_Pet1)

	CreateEnemyHUD("TukuiPetBattleHUD_EnemyPet1", LE_BATTLE_PET_ENEMY, 1)
	TukuiPetBattleHUD_EnemyPet1:Point("LEFT", UIParent, "BOTTOM", 200, 200)
	EnableMover(TukuiPetBattleHUD_EnemyPet1, false)

	CreateEnemyHUD("TukuiPetBattleHUD_EnemyPet2", LE_BATTLE_PET_ENEMY, 2)
	TukuiPetBattleHUD_EnemyPet2:SetParent(TukuiPetBattleHUD_EnemyPet1)

	CreateEnemyHUD("TukuiPetBattleHUD_EnemyPet3", LE_BATTLE_PET_ENEMY, 3)
	TukuiPetBattleHUD_EnemyPet3:SetParent(TukuiPetBattleHUD_EnemyPet1)

	PetBattleFrame:HookScript("OnShow", function()
		if CheckOption("BlizzKill") then
			PetBattleFrameXPBar:Kill()
			PetBattleFrame.ActiveAlly:Kill()
			PetBattleFrame.Ally2:Kill()
			PetBattleFrame.Ally3:Kill()
			PetBattleFrame.ActiveEnemy:Kill()
			PetBattleFrame.Enemy2:Kill()
			PetBattleFrame.Enemy3:Kill()
			PetBattleFrame.TopVersusText:Kill()
		end
		ShowPBH()
		TukuiPetBattleHUD_EnemyPet1:Show()
	end)
	PetBattleFrame:HookScript("OnHide", function()
		TukuiPetBattleHUD_EnemyPet1:Hide()
		if not CheckOption("PBHShow") then
			HidePBH()
		end
	end)

	TukuiPetBattleHUD = CreateFrame("Frame")
	TukuiPetBattleHUD:SetPoint("CENTER")
	if not ElvUI then TukuiPetBattleHUD:RegisterEvent("PLAYER_ENTERING_WORLD") end
	TukuiPetBattleHUD:RegisterEvent("PET_BATTLE_CLOSE")
	TukuiPetBattleHUD:RegisterEvent("PLAYER_REGEN_DISABLED")
	TukuiPetBattleHUD:RegisterEvent("PLAYER_REGEN_ENABLED")
	TukuiPetBattleHUD:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			UpdateHud(self)
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
		if event == "PET_BATTLE_CLOSE" then
			TukuiPetBattleHUD_EnemyPet3:Hide()
			TukuiPetBattleHUD_EnemyPet2:Hide()
			TukuiPetBattleHUD_EnemyPet1:Hide()
		end
		if event == "PLAYER_REGEN_DISABLED" or InCombatLockdown() then
			HidePBH()
			ReviveBattlePetButton:Hide()
			BandageBattlePetButton:Hide()
		else
			ReviveBattlePetButton:Show()
			BandageBattlePetButton:Show()
			if CheckOption("PBHShow") then
				ShowPBH()
			end
		end
	end)
	TukuiPetBattleHUD:SetScript("OnUpdate", ShowPBH)
	
	local function CreateExtraActionButton(name, spellname, spelltype, spellid)
		local frame = CreateFrame("Button", name.."Button", UIParent, "SecureActionButtonTemplate")
		frame:Size(50)
		frame:SetAttribute("type", spelltype)
		frame:SetAttribute(spelltype, spellname)
		frame:SetTemplate("Default")
		frame:SetAlpha(0)
		frame:EnableMouse(false)
		
		local frameIcon = frame:CreateTexture(nil, "MEDIUM")
		if spelltype == "spell" then
			frameIcon:SetTexture(select(3, GetSpellInfo(spellid)))
		elseif spelltype == "item" then
			frameIcon:SetTexture(select(10, GetItemInfo(spellid)))
		end
		frameIcon:SetInside(frame)
		frameIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		
		local frameCooldown = CreateFrame("Cooldown", nil, frame)
		frameCooldown:SetAllPoints(frameIcon)
		frame.LastUpdate = 0
		frame:SetScript("OnUpdate", function(self, elapsed)
			self.LastUpdate = self.LastUpdate + elapsed
			local start, duration = GetSpellCooldown(spellid)
			if duration and duration > 1.5 then
				frameCooldown:SetCooldown(start, duration)
			end
			self.LastUpdate = 0
			if C_PetBattles.IsInBattle() then return end
			local petID = C_PetJournal.GetPetLoadOutInfo(1)
			if petID == nil then return end
			local hp1, hp2, hp3
			hp1 = C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(1))
			if C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(2)) ~= nil then hp2 = C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(2)) else hp2 = 1 end
			if C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(3)) ~= nil then hp3 = C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(3)) else hp3 = 1 end
			if not (hp1 == 0 or hp2 == 0 or hp3 == 0) then self:SetAlpha(0) self:EnableMouse(false) else self:SetAlpha(1) self:EnableMouse(true) end
		end)
	end
	
	CreateExtraActionButton("ReviveBattlePet", "Revive Battle Pets", "spell", 125439)
	ReviveBattlePetButton:SetPoint("RIGHT", BossButton or TukuiExtraActionBarFrameHolder or AsphyxiaUIExtraActionBarFrameHolder, "CENTER", -3, 0)
	
	CreateExtraActionButton("BandageBattlePet", "Battle Pet Bandage", "item", 86143)
	BandageBattlePetButton:SetPoint("LEFT", BossButton or TukuiExtraActionBarFrameHolder or AsphyxiaUIExtraActionBarFrameHolder, "CENTER", 3, 0)
	BandageBattlePetButtonText = BandageBattlePetButton:CreateFontString("BandageBattlePetButtonText", "OVERLAY")
	BandageBattlePetButtonText:SetFont(font, fontsize, fontflag)
	BandageBattlePetButtonText:SetPoint("BOTTOMRIGHT", BandageBattlePetButton, 0, 2)
	BandageBattlePetButton:HookScript("OnUpdate", function(self)
		local count = GetItemCount(86143)
		if count ~= 0 then
			BandageBattlePetButtonText:SetText(count)
		end
	end)
	
	hooksecurefunc("PetBattleAuraHolder_Update", function(self)
		if not CheckOption("BlizzKill") then return end
		if not self.petOwner or not self.petIndex then return end

		local nextFrame = 1
		for i=1, C_PetBattles.GetNumAuras(self.petOwner, self.petIndex) do
			local frame = self.frames[nextFrame]
			if not frame then return end
			
			frame.DebuffBorder:Hide()
			frame:Hide()
			frame.backdrop:Hide()
			frame.Icon:Hide()
			frame.Duration:SetText(turnsRemaining)
			nextFrame = nextFrame + 1
		end
	end)
end

if not ElvUI then
	SetupPBH()
else
	function PBH:Initialize()
		SetupPBH()
		UpdateHud(TukuiPetBattleHUD)
	end

	A:RegisterModule(PBH:GetName())
end