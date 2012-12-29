if not (IsAddOnLoaded("Tukui") or IsAddOnLoaded("AsphyxiaUI") or IsAddOnLoaded("DuffedUI") or IsAddOnLoaded("ElvUI")) then return end
--Credits: Mike Zaitchik, Simca, Nullberri, Warla, and Ro 

local CPB = _G.C_PetBattles
local CPJ = _G.C_PetJournal
local abs = math.abs
local min = math.min

local breedCache = {}
local speciesCache = {}
local BasePetStatsArray = {}
local BreedStatsArray = {}
local cacheTime = true

local BreedData = PetJournalEnhanced and PetJournalEnhanced:GetModule("BreedData")
local BreedInfo = BreedInfo

local EMPTY_PET = "0x0000000000000000"

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function clamp(num,minVal,maxVal)
    return math.min(math.max(num,minVal),maxVal)
end

function PBHGetLevelBreakdown(petID)
    if not PetJournalEnhanced then return end
    if not petID or petID == EMPTY_PET then return 0,10,0 end

    local speciesID, _, level, _, _, _,_ ,_, _, _, _, _, _, _, canBattle = C_PetJournal.GetPetInfoByPetID(petID)

    if not canBattle then return 0,10,0 end
    local health, _, power, speed, rarity = C_PetJournal.GetPetStats(petID)

    local baseStatsIndex = BreedData.speciesToBaseStatProfile[speciesID]
    if not baseStatsIndex then return -1,10,0 end

    local baseStats = BreedData.baseStatsProfiles[baseStatsIndex]

    local breedBonusPerLevel = {
        clamp(round((((health-100)/5) / BreedData.qualityMultiplier[rarity]) - level*baseStats[1],1)/level,0,2),
        clamp(round((power / BreedData.qualityMultiplier[rarity]) - level*baseStats[2],1)/level,0,2),
        clamp(round((speed / BreedData.qualityMultiplier[rarity]) - level*baseStats[3],1)/level,0,2),
    }

    return breedBonusPerLevel
end

function PBHGetBreedID_Journal(nPetID)
    local nHealth, nMaxHP, nPower, nSpeed, nQuality = CPJ.GetPetStats(nPetID)
    local nSpeciesID, _, nLevel = CPJ.GetPetInfoByPetID(nPetID);

    nbreedID = PBHBPB_RetrieveBreedName(PBHBPB_CalculateBreedID(nSpeciesID, nQuality, nLevel, nMaxHP, nPower, nSpeed, false, false), nSpeciesID)

    return nbreedID
end

function PBHGetBreedID_Battle(index)
    local nSpeciesID = CPB.GetPetSpeciesID(2, index)
    local nLevel = CPB.GetLevel(2, index)
    local nMaxHP = CPB.GetMaxHealth(2, index)
    local nPower = CPB.GetPower(2, index)
    local nSpeed = CPB.GetSpeed(2, index)
    local nQuality = CPB.GetBreedQuality(2, index)
    local wild = false
    local flying = false
    if (CPB.IsWildBattle()) then
        wild = true
    end
    if (CPB.GetPetType(2, index) == 3) then
        flying = true
    end
    local nbreedID
    nbreedID = PBHBPB_RetrieveBreedName(PBHBPB_CalculateBreedID(nSpeciesID, nQuality, nLevel, nMaxHP, nPower, nSpeed, wild, flying), nSpeciesID)
    return nbreedID
end

function PBHBPB_CalculateBreedID(nSpeciesID, nQuality, nLevel, nMaxHP, nPower, nSpeed, wild, flying)
    local breedID, nQL, minQuality, maxQuality

    if nQuality == 0 then
        minQuality = 1
        maxQuality = 4
    else
        minQuality = nQuality
        maxQuality = nQuality
    end

    if not rawget(BasePetStatsArray, nSpeciesID) then return "NEW" end

    if nLevel < 5 and nQuality ~= 0 then

        local testarray = {}
        testarray[1] = 0
        testarray[2] = 0
        testarray[3] = 0
        testarray[4] = 0
        testarray[5] = 0
        testarray[6] = 0
        testarray[7] = 0
        testarray[10] = 0

        for nQuality = minQuality, maxQuality do
            nQL = (nQuality + 9) * nLevel

            for ibreed = 3, 12 do
                local hp = (BasePetStatsArray[nSpeciesID][1] + BreedStatsArray[ibreed][1]) * nQL / 10 * 5 + 100
                if (wild == true) then
                    testarray[1] = floor((PBHBPB_Round(hp, true) / 1.2))
                    testarray[4] = PBHBPB_Round(PBHBPB_Round(hp, true) / 1.2, true)
                    testarray[7] = floor((PBHBPB_Round(hp, false) / 1.2))
                    testarray[10] = PBHBPB_Round(PBHBPB_Round(hp, false) / 1.2, true)
                else
                    testarray[1] = PBHBPB_Round(hp, true)
                    testarray[4] = PBHBPB_Round(hp, false)
                end

                local power = (BasePetStatsArray[nSpeciesID][2] + BreedStatsArray[ibreed][2])* nQL / 10
                testarray[2] = PBHBPB_Round(power, true)
                testarray[5] = PBHBPB_Round(power, false)

                local speed = (BasePetStatsArray[nSpeciesID][3] + BreedStatsArray[ibreed][3])* nQL / 10
                if (flying == true) then
                    testarray[3] = PBHBPB_Round(speed * 1.5, true)
                    testarray[6] = PBHBPB_Round(speed * 1.5, false)
                else
                    testarray[3] = PBHBPB_Round(speed, true)
                    testarray[6] = PBHBPB_Round(speed, false)
                end

                if ((testarray[1] == nMaxHP) or (testarray[4] == nMaxHP) or (testarray[7] == nMaxHP) or (testarray[10] == nMaxHP)) and ((testarray[2] == nPower) or (testarray[5] == nPower)) and ((testarray[3] == nSpeed) or (testarray[6] == nSpeed)) then
                    breedID = ibreed
                end
                
                if breedID then break end
            end
        end

        if not breedID then breedID = "ERR-SIM" end
    else

        local ihp = BasePetStatsArray[nSpeciesID][1] * 10
        local ipower = BasePetStatsArray[nSpeciesID][2] * 10
        local ispeed = BasePetStatsArray[nSpeciesID][3] * 10

        local wildfactor = 1
        if wild then wildfactor = 1.2 end

        local thp = nMaxHP * 100
        local tpower = nPower * 100
        local tspeed = nSpeed * 100

        if flying then tspeed = tspeed / 1.5 end

        local current, lowest
        for i = minQuality, maxQuality do
            nQL = (i + 9) * nLevel

            local diff3 = abs(((ihp + 5) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 5) * nQL) - tpower) + abs(((ispeed + 5) * nQL) - tspeed)
            local diff4 = abs(((ihp + 0) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 20) * nQL) - tpower) + abs(((ispeed + 0) * nQL) - tspeed)
            local diff5 = abs(((ihp + 0) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 0) * nQL) - tpower) + abs(((ispeed + 20) * nQL) - tspeed)
            local diff6 = abs(((ihp + 20) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 0) * nQL) - tpower) + abs(((ispeed + 0) * nQL) - tspeed)
            local diff7 = abs(((ihp + 9) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 9) * nQL) - tpower) + abs(((ispeed + 0) * nQL) - tspeed)
            local diff8 = abs(((ihp + 0) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 9) * nQL) - tpower) + abs(((ispeed + 9) * nQL) - tspeed)
            local diff9 = abs(((ihp + 9) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 0) * nQL) - tpower) + abs(((ispeed + 9) * nQL) - tspeed)
            local diff10 = abs(((ihp + 4) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 9) * nQL) - tpower) + abs(((ispeed + 4) * nQL) - tspeed)
            local diff11 = abs(((ihp + 4) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 4) * nQL) - tpower) + abs(((ispeed + 9) * nQL) - tspeed)
            local diff12 = abs(((ihp + 9) * nQL * 5 + 10000) / wildfactor - thp) + abs(((ipower + 4) * nQL) - tpower) + abs(((ispeed + 4) * nQL) - tspeed)

            local current = min(diff3, diff4, diff5, diff6, diff7, diff8, diff9, diff10, diff11, diff12)

            if not lowest or current < lowest then
                lowest = current
                nQuality = i

                if (lowest == diff3) then breedID = 3
                elseif (lowest == diff4) then breedID = 4
                elseif (lowest == diff5) then breedID = 5
                elseif (lowest == diff6) then breedID = 6
                elseif (lowest == diff7) then breedID = 7
                elseif (lowest == diff8) then breedID = 8
                elseif (lowest == diff9) then breedID = 9
                elseif (lowest == diff10) then breedID = 10
                elseif (lowest == diff11) then breedID = 11
                elseif (lowest == diff12) then breedID = 12
                else return "ERR-HGH"
                end
            end
        end
    end

    if breedID then
        return breedID, nQuality
    else
        return "ERR-CAL"
    end
end

function PBHBPB_RetrieveBreedName(breedID, species)
    if not breedID then return "ERR-ELY" end

    if (string.sub(tostring(breedID), 1, 3) == "ERR") or (tostring(breedID) == "??") or (tostring(breedID) == "NEW") then return breedID end

    local numbreedID = tonumber(breedID)
    local result = {}

    if (not PBHstridform) then
        PBHstridform = 3
    end
    
    if (PBHstridform == 1) then
        return numbreedID   
    elseif (PBHstridform == 5) and (species) then
        result[4] = tostring(BasePetStatsArray[species][1] + BreedStatsArray[numbreedID][1]) .. "/" .. tostring(BasePetStatsArray[species][2] + BreedStatsArray[numbreedID][2]) .. "/" .. tostring(BasePetStatsArray[species][3] + BreedStatsArray[numbreedID][3])
        return result[4]
    elseif (PBHstridform == 6) and (species) then
        result[5] = tostring(BasePetStatsArray[species][1]) .. "/" .. tostring(BasePetStatsArray[species][2]) .. "/" .. tostring(BasePetStatsArray[species][3])
        return result[5]
    end
    
    if (numbreedID == 3) then
        result[1] = "3/13"
        result[2] = "B/B"
        result[3] = "Balanced"
    elseif (numbreedID == 4) then
        result[1] = "4/14"
        result[2] = "P/P"
        result[3] = "Powerful"
    elseif (numbreedID == 5) then
        result[1] = "5/15"
        result[2] = "S/S"
        result[3] = "Speedy"
    elseif (numbreedID == 6) then
        result[1] = "6/16"
        result[2] = "H/H"
        result[3] = "Hulking"
    elseif (numbreedID == 7) then
        result[1] = "7/17"
        result[2] = "H/P"
        result[3] = "Brawny"
    elseif (numbreedID == 8) then
        result[1] = "8/18"
        result[2] = "P/S"
        result[3] = "Intense"
    elseif (numbreedID == 9) then
        result[1] = "9/19"
        result[2] = "H/S"
        result[3] = "Vigorous"
    elseif (numbreedID == 10) then
        result[1] = "10/20"
        result[2] = "P/B"
        result[3] = "Strong"
    elseif (numbreedID == 11) then
        result[1] = "11/21"
        result[2] = "S/B"
        result[3] = "Quick"
    elseif (numbreedID == 12) then
        result[1] = "12/22"
        result[2] = "H/B"
        result[3] = "Healthy"
    else
        result[1] = "ERR-NAM"
        result[2] = "ERR-NAM"
        result[3] = "ERR-NAM"
    end
    
    if (PBHstridform == 2) then
        return result[1]
    elseif (PBHstridform == 3) then
        return result[2]
    elseif (PBHstridform == 4) then
        return result[3]
    else
        return numbreedID
    end
end

local PBHBPB_Events = CreateFrame("FRAME", "PBHBPB_Events")
PBHBPB_Events:RegisterEvent("PET_BATTLE_OPENING_START")
PBHBPB_Events:RegisterEvent("PET_BATTLE_CLOSE")

local function PBHBPB_Events_OnEvent(self, event, ...)
    if (event == "PET_BATTLE_OPENING_START") then
        cacheTime = true
    elseif (event == "PET_BATTLE_CLOSE") then
        cacheTime = true
    end
end

PBHBPB_Events:SetScript("OnEvent", PBHBPB_Events_OnEvent)

function PBHBPB_Round(number, roundup)
    if not number then return end
    number = tostring(number)
    if not roundup then local roundup = true end
    
    if not string.find(number, "%.") then return tonumber(number) end
    
    local period = string.find(number, "%.")
    local decimal = tonumber(string.sub(number, period + 1, period + 1))
    local newnum = tonumber(string.sub(number, 1, period - 1))
    
    if (decimal == 5) then
            if (roundup == true) then
                newnum = newnum + 1
            end
    elseif (decimal > 5) then
        newnum = newnum + 1
    end     
    return newnum
end

BreedStatsArray[3] = {0.5, 0.5, 0.5}
BreedStatsArray[4] = {0, 2, 0}
BreedStatsArray[5] = {0, 0, 2}
BreedStatsArray[6] = {2, 0, 0}
BreedStatsArray[7] = {0.9, 0.9, 0}
BreedStatsArray[8] = {0, 0.9, 0.9}
BreedStatsArray[9] = {0.9, 0, 0.9}
BreedStatsArray[10] = {0.4, 0.9, 0.4}
BreedStatsArray[11] = {0.4, 0.4, 0.9}
BreedStatsArray[12] = {0.9, 0.4, 0.4}

BasePetStatsArray[39] = {8.5, 7.5, 8}
BasePetStatsArray[40] = {7, 8.5, 8.5}
BasePetStatsArray[41] = {7, 8.5, 8.5}
BasePetStatsArray[42] = {6.5, 9, 8.5}
BasePetStatsArray[43] = {7, 9, 8}
BasePetStatsArray[44] = {7, 8.5, 8.5}
BasePetStatsArray[45] = {7, 8.5, 8.5}
BasePetStatsArray[46] = {7.5, 7.5, 9}
BasePetStatsArray[47] = {8, 7.5, 8.5}
BasePetStatsArray[49] = {9, 7, 8}
BasePetStatsArray[50] = {9, 8, 7}
BasePetStatsArray[51] = {8.5, 8, 7.5}
BasePetStatsArray[52] = {8, 8, 8}
BasePetStatsArray[55] = {8.5, 7, 8.5}
BasePetStatsArray[56] = {8.5, 9, 6.5}
BasePetStatsArray[57] = {8.5, 7.5, 8}
BasePetStatsArray[58] = {7, 9, 8}
BasePetStatsArray[59] = {8.5, 8, 7.5}
BasePetStatsArray[64] = {8.5, 7.5, 8}
BasePetStatsArray[65] = {8.5, 7.5, 8}
BasePetStatsArray[67] = {8, 8, 8}
BasePetStatsArray[68] = {8, 8, 8}
BasePetStatsArray[69] = {7.5, 7.5, 9}
BasePetStatsArray[70] = {8, 7.5, 8.5}
BasePetStatsArray[71] = {8, 8, 8}
BasePetStatsArray[72] = {8, 7, 9}
BasePetStatsArray[73] = {8, 8, 8}
BasePetStatsArray[74] = {7.5, 7.5, 9}
BasePetStatsArray[75] = {7.5, 8.5, 8}
BasePetStatsArray[77] = {8, 8, 8}
BasePetStatsArray[78] = {7.5, 8.5, 8}
BasePetStatsArray[83] = {8.5, 7.5, 8}
BasePetStatsArray[84] = {8, 8, 8}
BasePetStatsArray[85] = {8.5, 7.5, 8}
BasePetStatsArray[86] = {8.5, 7.5, 8}
BasePetStatsArray[87] = {8, 8.5, 7.5}
BasePetStatsArray[89] = {8, 8, 8}
BasePetStatsArray[90] = {7, 8.5, 8.5}
BasePetStatsArray[92] = {8, 8, 8}
BasePetStatsArray[93] = {6.5, 9, 8.5}
BasePetStatsArray[94] = {7, 7, 10}
BasePetStatsArray[95] = {8, 8, 8}
BasePetStatsArray[106] = {8.5, 7.5, 8}
BasePetStatsArray[107] = {8, 8, 8}
BasePetStatsArray[111] = {8, 8, 8}
BasePetStatsArray[114] = {8.5, 8.5, 7}
BasePetStatsArray[115] = {8, 8, 8}
BasePetStatsArray[116] = {8, 8, 8}
BasePetStatsArray[117] = {8, 8, 8}
BasePetStatsArray[118] = {8, 8, 8}
BasePetStatsArray[119] = {8, 8, 8}
BasePetStatsArray[120] = {8, 8, 8}
BasePetStatsArray[121] = {8, 8, 8}
BasePetStatsArray[122] = {8, 8, 8}
BasePetStatsArray[124] = {8, 8, 8}
BasePetStatsArray[125] = {8, 8, 8}
BasePetStatsArray[126] = {8, 8, 8}
BasePetStatsArray[127] = {8, 7.5, 8.5}
BasePetStatsArray[128] = {8, 8, 8}
BasePetStatsArray[130] = {8, 8, 8}
BasePetStatsArray[131] = {8, 7.5, 8.5}
BasePetStatsArray[132] = {9, 8, 7}
BasePetStatsArray[136] = {8, 8, 8}
BasePetStatsArray[137] = {8, 7, 9}
BasePetStatsArray[138] = {8.5, 7.5, 8}
BasePetStatsArray[139] = {7.5, 8.5, 8}
BasePetStatsArray[140] = {8, 8.5, 7.5}
BasePetStatsArray[141] = {7.5, 7.5, 9}
BasePetStatsArray[142] = {8, 8.5, 7.5}
BasePetStatsArray[143] = {7.5, 8.5, 8}
BasePetStatsArray[144] = {7.5, 7.5, 9}
BasePetStatsArray[145] = {8.5, 7.5, 8}
BasePetStatsArray[146] = {7.5, 8, 8.5}
BasePetStatsArray[149] = {7.5, 7, 9.5}
BasePetStatsArray[153] = {8, 8, 8}
BasePetStatsArray[155] = {8, 8, 8}
BasePetStatsArray[156] = {8, 8, 8}
BasePetStatsArray[157] = {8, 8, 8}
BasePetStatsArray[158] = {8, 8, 8}
BasePetStatsArray[159] = {8, 8, 8}
BasePetStatsArray[160] = {8, 8, 8}
BasePetStatsArray[162] = {8, 8.5, 7.5}
BasePetStatsArray[163] = {8, 8.5, 7.5}
BasePetStatsArray[164] = {8, 8.5, 7.5}
BasePetStatsArray[165] = {8.5, 7.5, 8}
BasePetStatsArray[166] = {8.5, 8.5, 7}
BasePetStatsArray[167] = {9, 7.5, 7.5}
BasePetStatsArray[168] = {8.5, 7.5, 8}
BasePetStatsArray[169] = {8, 8, 8}
BasePetStatsArray[170] = {8, 8, 8}
BasePetStatsArray[171] = {8, 8, 8}
BasePetStatsArray[172] = {7.5, 8.5, 8}
BasePetStatsArray[173] = {8, 8.5, 7.5}
BasePetStatsArray[174] = {8, 8.5, 7.5}
BasePetStatsArray[175] = {7.5, 8.5, 8}
BasePetStatsArray[179] = {8.5, 8, 7.5}
BasePetStatsArray[180] = {8.5, 8, 7.5}
BasePetStatsArray[183] = {8, 8, 8}
BasePetStatsArray[186] = {7.5, 8.5, 8}
BasePetStatsArray[187] = {8.5, 8.5, 7}
BasePetStatsArray[188] = {8.5, 8.5, 7}
BasePetStatsArray[189] = {8, 8, 8}
BasePetStatsArray[190] = {8.5, 8.5, 7}
BasePetStatsArray[191] = {8.5, 7.5, 8}
BasePetStatsArray[192] = {8, 8, 8}
BasePetStatsArray[193] = {8, 8.5, 7.5}
BasePetStatsArray[194] = {8, 8, 8}
BasePetStatsArray[195] = {7.5, 7.5, 9}
BasePetStatsArray[196] = {8.5, 8, 7.5}
BasePetStatsArray[197] = {7.5, 8, 8.5}
BasePetStatsArray[198] = {8, 8, 8}
BasePetStatsArray[199] = {8, 8, 8}
BasePetStatsArray[200] = {8, 7, 9}
BasePetStatsArray[201] = {8, 8, 8}
BasePetStatsArray[202] = {8, 8, 8}
BasePetStatsArray[203] = {8, 7, 9}
BasePetStatsArray[204] = {8, 8, 8}
BasePetStatsArray[205] = {8, 8, 8}
BasePetStatsArray[206] = {8.5, 8.5, 7}
BasePetStatsArray[207] = {8, 8, 8}
BasePetStatsArray[209] = {8, 8, 8}
BasePetStatsArray[210] = {8, 8, 8}
BasePetStatsArray[211] = {8.5, 8, 7.5}
BasePetStatsArray[212] = {8, 8, 8}
BasePetStatsArray[213] = {8, 8, 8}
BasePetStatsArray[214] = {8, 8, 8}
BasePetStatsArray[215] = {8.5, 7.5, 8}
BasePetStatsArray[216] = {8, 8, 8}
BasePetStatsArray[217] = {8, 8, 8}
BasePetStatsArray[218] = {8.5, 7.5, 8}
BasePetStatsArray[220] = {8, 8, 8}
BasePetStatsArray[224] = {7, 8.5, 8.5}
BasePetStatsArray[225] = {8, 8, 8}
BasePetStatsArray[226] = {8, 8, 8}
BasePetStatsArray[227] = {8, 8, 8}
BasePetStatsArray[228] = {8, 8, 8}
BasePetStatsArray[229] = {8, 8, 8}
BasePetStatsArray[231] = {8.5, 8, 7.5}
BasePetStatsArray[232] = {7, 8.5, 8.5}
BasePetStatsArray[233] = {7, 8.5, 8.5}
BasePetStatsArray[234] = {7, 8.5, 8.5}
BasePetStatsArray[235] = {7, 8.5, 8.5}
BasePetStatsArray[236] = {7.5, 8.5, 8}
BasePetStatsArray[237] = {7, 8.5, 8.5}
BasePetStatsArray[238] = {7, 8.5, 8.5}
BasePetStatsArray[239] = {8, 8, 8}
BasePetStatsArray[240] = {8.5, 8.5, 7}
BasePetStatsArray[241] = {8, 8, 8}
BasePetStatsArray[242] = {7.5, 8.5, 8}
BasePetStatsArray[243] = {9, 9, 6}
BasePetStatsArray[244] = {8.5, 9, 6.5}
BasePetStatsArray[245] = {8, 8, 8}
BasePetStatsArray[246] = {8, 8, 8}
BasePetStatsArray[247] = {8, 8, 8}
BasePetStatsArray[248] = {8, 8, 8}
BasePetStatsArray[249] = {8.5, 8.5, 7}
BasePetStatsArray[250] = {7.5, 9, 7.5}
BasePetStatsArray[251] = {8.5, 8.5, 7}
BasePetStatsArray[253] = {8, 8, 8}
BasePetStatsArray[254] = {8, 8, 8}
BasePetStatsArray[255] = {7.5, 9, 7.5}
BasePetStatsArray[256] = {8, 9, 7}
BasePetStatsArray[257] = {8, 8, 8}
BasePetStatsArray[258] = {8.5, 9, 6.5}
BasePetStatsArray[259] = {8.5, 7.5, 8}
BasePetStatsArray[260] = {8, 8.5, 7.5}
BasePetStatsArray[261] = {8.5, 7.5, 8}
BasePetStatsArray[262] = {8.5, 7.5, 8}
BasePetStatsArray[264] = {8.5, 8.5, 7}
BasePetStatsArray[265] = {9.5, 8, 6.5}
BasePetStatsArray[266] = {8.5, 8.5, 7}
BasePetStatsArray[267] = {8, 8, 8}
BasePetStatsArray[268] = {8.5, 9, 6.5}
BasePetStatsArray[270] = {8.5, 8.5, 7}
BasePetStatsArray[271] = {8, 7.5, 8.5}
BasePetStatsArray[272] = {9, 7.5, 7.5}
BasePetStatsArray[277] = {8.5, 7.5, 8}
BasePetStatsArray[278] = {8, 8, 8}
BasePetStatsArray[279] = {8, 8, 8}
BasePetStatsArray[280] = {8, 8, 8}
BasePetStatsArray[281] = {8, 8, 8}
BasePetStatsArray[282] = {8, 8, 8}
BasePetStatsArray[283] = {8, 8, 8}
BasePetStatsArray[285] = {8, 9, 7}
BasePetStatsArray[286] = {9, 8, 7}
BasePetStatsArray[287] = {8, 7.5, 8.5}
BasePetStatsArray[289] = {9.5, 8.5, 6}
BasePetStatsArray[291] = {9, 7.5, 7.5}
BasePetStatsArray[292] = {8, 8, 8}
BasePetStatsArray[293] = {8, 8, 8}
BasePetStatsArray[294] = {8, 8, 8}
BasePetStatsArray[296] = {8, 8, 8}
BasePetStatsArray[297] = {8, 9.5, 6.5}
BasePetStatsArray[298] = {8, 8, 8}
BasePetStatsArray[301] = {7, 8.5, 8.5}
BasePetStatsArray[302] = {8.5, 8.5, 7}
BasePetStatsArray[303] = {7, 8.5, 8.5}
BasePetStatsArray[306] = {7, 8.5, 8.5}
BasePetStatsArray[307] = {8, 8, 8}
BasePetStatsArray[308] = {8, 8, 8}
BasePetStatsArray[309] = {6.5, 9, 8.5}
BasePetStatsArray[310] = {8, 8, 8}
BasePetStatsArray[311] = {8.5, 8, 7.5}
BasePetStatsArray[316] = {8.5, 7.5, 8}
BasePetStatsArray[317] = {8.5, 8.5, 7}
BasePetStatsArray[318] = {7.5, 8.5, 8}
BasePetStatsArray[319] = {6.5, 9, 8.5}
BasePetStatsArray[320] = {8.5, 7.5, 8}
BasePetStatsArray[321] = {8, 8, 8}
BasePetStatsArray[323] = {8, 8, 8}
BasePetStatsArray[325] = {7.5, 9, 7.5}
BasePetStatsArray[328] = {8, 8, 8}
BasePetStatsArray[329] = {8, 8, 8}
BasePetStatsArray[330] = {8, 8, 8}
BasePetStatsArray[331] = {8, 8, 8}
BasePetStatsArray[332] = {8, 8, 8}
BasePetStatsArray[333] = {8, 8, 8}
BasePetStatsArray[335] = {9, 7.5, 7.5}
BasePetStatsArray[336] = {8, 8, 8}
BasePetStatsArray[337] = {8, 8, 8}
BasePetStatsArray[338] = {8.5, 7.5, 8}
BasePetStatsArray[339] = {8, 8, 8}
BasePetStatsArray[340] = {8, 8, 8}
BasePetStatsArray[341] = {8, 8, 8}
BasePetStatsArray[342] = {8, 8, 8}
BasePetStatsArray[343] = {7, 8.5, 8.5}
BasePetStatsArray[344] = {8.5, 8, 7.5}
BasePetStatsArray[345] = {8, 8.5, 7.5}
BasePetStatsArray[346] = {8, 8, 8}
BasePetStatsArray[347] = {8, 8.75, 7.25}
BasePetStatsArray[348] = {8.5, 8.5, 7}
BasePetStatsArray[354] = {8, 8, 8}
BasePetStatsArray[374] = {8, 8, 8}
BasePetStatsArray[375] = {8, 8, 8}
BasePetStatsArray[378] = {8, 7, 9}
BasePetStatsArray[379] = {8, 7.5, 8.5}
BasePetStatsArray[380] = {8, 8, 8}
BasePetStatsArray[381] = {8, 8, 8}
BasePetStatsArray[382] = {8, 8, 8}
BasePetStatsArray[383] = {8, 7.5, 8.5}
BasePetStatsArray[384] = {8, 8, 8}
BasePetStatsArray[385] = {8, 7.5, 8.5}
BasePetStatsArray[386] = {8, 7.5, 8.5}
BasePetStatsArray[387] = {7.5, 8, 8.5}
BasePetStatsArray[388] = {8.5, 8, 7.5}
BasePetStatsArray[389] = {8.5, 7.5, 8}
BasePetStatsArray[390] = {8, 7.5, 8.5}
BasePetStatsArray[391] = {8, 7, 9}
BasePetStatsArray[392] = {8, 7.5, 8.5}
BasePetStatsArray[393] = {8.5, 7, 8.5}
BasePetStatsArray[394] = {8, 8, 8}
BasePetStatsArray[395] = {8.5, 8, 7.5}
BasePetStatsArray[396] = {7, 8.5, 8.5}
BasePetStatsArray[397] = {8, 8, 8}
BasePetStatsArray[398] = {8, 7.5, 8.5}
BasePetStatsArray[399] = {7.5, 8, 8.5}
BasePetStatsArray[400] = {7, 8.5, 8.5}
BasePetStatsArray[401] = {8.5, 8, 7.5}
BasePetStatsArray[402] = {8.5, 8, 7.5}
BasePetStatsArray[403] = {7.5, 8, 8.5}
BasePetStatsArray[404] = {8, 7.5, 8.5}
BasePetStatsArray[405] = {7.5, 8, 8.5}
BasePetStatsArray[406] = {8.5, 7.5, 8}
BasePetStatsArray[407] = {7, 8.5, 8.5}
BasePetStatsArray[408] = {7.5, 8, 8.5}
BasePetStatsArray[409] = {7, 8, 9}
BasePetStatsArray[410] = {8, 7.5, 8.5}
BasePetStatsArray[411] = {8, 8, 8}
BasePetStatsArray[412] = {7, 8.5, 8.5}
BasePetStatsArray[414] = {8, 8, 8}
BasePetStatsArray[415] = {7.5, 8.5, 8}
BasePetStatsArray[416] = {8, 8, 8}
BasePetStatsArray[417] = {8, 7.5, 8.5}
BasePetStatsArray[418] = {7.5, 8, 8.5}
BasePetStatsArray[419] = {8.5, 7.5, 8}
BasePetStatsArray[420] = {8.5, 7.5, 8}
BasePetStatsArray[421] = {8, 8.5, 7.5}
BasePetStatsArray[422] = {7.5, 8.5, 8}
BasePetStatsArray[423] = {8.5, 8.5, 7}
BasePetStatsArray[424] = {8.5, 7, 8.5}
BasePetStatsArray[425] = {7.5, 8, 8.5}
BasePetStatsArray[427] = {7, 8.5, 8.5}
BasePetStatsArray[428] = {7, 8.5, 8.5}
BasePetStatsArray[429] = {7.5, 8.5, 8}
BasePetStatsArray[430] = {8, 8.5, 7.5}
BasePetStatsArray[431] = {7.5, 8, 8.5}
BasePetStatsArray[432] = {8, 8, 8}
BasePetStatsArray[433] = {7.5, 8, 8.5}
BasePetStatsArray[434] = {8, 8, 8}
BasePetStatsArray[437] = {8, 8, 8}
BasePetStatsArray[438] = {7.5, 8, 8.5}
BasePetStatsArray[439] = {8.5, 8, 7.5}
BasePetStatsArray[440] = {8, 8, 8}
BasePetStatsArray[441] = {8, 7, 9}
BasePetStatsArray[442] = {9, 6.5, 8.5}
BasePetStatsArray[443] = {8, 8, 8}
BasePetStatsArray[444] = {8, 8, 8}
BasePetStatsArray[445] = {8, 8, 8}
BasePetStatsArray[446] = {8.5, 8, 7.5}
BasePetStatsArray[447] = {8, 7.5, 8.5}
BasePetStatsArray[448] = {8, 7, 9}
BasePetStatsArray[449] = {8, 8, 8}
BasePetStatsArray[450] = {9, 8, 7}
BasePetStatsArray[452] = {8, 8, 8}
BasePetStatsArray[453] = {9, 8, 7}
BasePetStatsArray[454] = {8, 7.5, 8.5}
BasePetStatsArray[455] = {8, 8, 8}
BasePetStatsArray[456] = {8, 8.5, 7.5}
BasePetStatsArray[457] = {9, 8, 7}
BasePetStatsArray[458] = {8.5, 8.5, 7}
BasePetStatsArray[459] = {7, 8.5, 8.5}
BasePetStatsArray[460] = {7.5, 8.5, 8}
BasePetStatsArray[461] = {9, 8, 7}
BasePetStatsArray[462] = {8, 8, 8}
BasePetStatsArray[463] = {9, 9, 6}
BasePetStatsArray[464] = {8, 8, 8}
BasePetStatsArray[465] = {7, 8.5, 8.5}
BasePetStatsArray[466] = {7.5, 8, 8.5}
BasePetStatsArray[467] = {7.5, 8.5, 8}
BasePetStatsArray[468] = {7.5, 8.5, 8}
BasePetStatsArray[469] = {7, 8.5, 8.5}
BasePetStatsArray[470] = {7, 8.5, 8.5}
BasePetStatsArray[471] = {8.5, 7.5, 8}
BasePetStatsArray[472] = {8.5, 7.5, 8}
BasePetStatsArray[473] = {9, 7.5, 7.5}
BasePetStatsArray[474] = {6, 8, 10}
BasePetStatsArray[475] = {8.5, 7, 8.5}
BasePetStatsArray[476] = {7.5, 7.5, 9}
BasePetStatsArray[477] = {7.5, 7.5, 9}
BasePetStatsArray[478] = {8.5, 8, 7.5}
BasePetStatsArray[479] = {8, 6.5, 9.5}
BasePetStatsArray[480] = {8, 8.5, 7.5}
BasePetStatsArray[482] = {7.5, 8, 8.5}
BasePetStatsArray[483] = {8.5, 7.5, 8}
BasePetStatsArray[484] = {7, 8.5, 8.5}
BasePetStatsArray[485] = {9, 7.5, 7.5}
BasePetStatsArray[486] = {8, 7.5, 8.5}
BasePetStatsArray[487] = {8, 8, 8}
BasePetStatsArray[488] = {7.5, 8, 8.5}
BasePetStatsArray[489] = {8, 8.5, 7.5}
BasePetStatsArray[491] = {7, 9, 8}
BasePetStatsArray[492] = {8, 8.5, 7.5}
BasePetStatsArray[493] = {9.5, 8.5, 6}
BasePetStatsArray[494] = {8, 8, 8}
BasePetStatsArray[495] = {8.5, 7.5, 8}
BasePetStatsArray[496] = {9.5, 8.5, 6}
BasePetStatsArray[497] = {8.5, 7, 8.5}
BasePetStatsArray[498] = {8.5, 8, 7.5}
BasePetStatsArray[499] = {8, 7.5, 8.5}
BasePetStatsArray[500] = {8, 8, 8}
BasePetStatsArray[502] = {8.5, 7.5, 8}
BasePetStatsArray[503] = {7.5, 7.5, 9}
BasePetStatsArray[504] = {8, 8.5, 7.5}
BasePetStatsArray[505] = {7.5, 8, 8.5}
BasePetStatsArray[506] = {7, 8.5, 8.5}
BasePetStatsArray[507] = {7.5, 8.5, 8}
BasePetStatsArray[508] = {8, 8, 8}
BasePetStatsArray[509] = {8, 8, 8}
BasePetStatsArray[510] = {8.5, 7.5, 8}
BasePetStatsArray[511] = {7.5, 8, 8.5}
BasePetStatsArray[512] = {7.5, 8.5, 8}
BasePetStatsArray[513] = {8, 8, 8}
BasePetStatsArray[514] = {8, 8, 8}
BasePetStatsArray[515] = {8, 8, 8}
BasePetStatsArray[517] = {8, 8, 8}
BasePetStatsArray[518] = {9, 8.5, 6.5}
BasePetStatsArray[519] = {8.5, 8, 7.5}
BasePetStatsArray[521] = {7, 9, 8}
BasePetStatsArray[523] = {9, 8, 7}
BasePetStatsArray[525] = {8, 8, 8}
BasePetStatsArray[528] = {7.5, 8, 8.5}
BasePetStatsArray[529] = {8, 8, 8}
BasePetStatsArray[530] = {8, 8, 8}
BasePetStatsArray[532] = {8.5, 9, 6.5}
BasePetStatsArray[534] = {7.5, 8.5, 8}
BasePetStatsArray[535] = {8, 8, 8}
BasePetStatsArray[536] = {8.5, 8, 7.5}
BasePetStatsArray[537] = {8.5, 8, 7.5}
BasePetStatsArray[538] = {8.5, 8.5, 7}
BasePetStatsArray[539] = {8, 7.5, 8.5}
BasePetStatsArray[540] = {8, 7.5, 8.5}
BasePetStatsArray[541] = {8.5, 7, 8.5}
BasePetStatsArray[542] = {8.5, 7.5, 8}
BasePetStatsArray[543] = {7.5, 8.5, 8}
BasePetStatsArray[544] = {8.5, 8.5, 7}
BasePetStatsArray[545] = {8, 8, 8}
BasePetStatsArray[546] = {7.5, 8.5, 8}
BasePetStatsArray[547] = {8, 7, 9}
BasePetStatsArray[548] = {7.5, 8.5, 8}
BasePetStatsArray[549] = {8, 8, 8}
BasePetStatsArray[550] = {8, 7.5, 8.5}
BasePetStatsArray[552] = {7.5, 8.5, 8}
BasePetStatsArray[553] = {8, 7.5, 8.5}
BasePetStatsArray[554] = {7.5, 8.5, 8}
BasePetStatsArray[555] = {8.5, 7, 8.5}
BasePetStatsArray[556] = {7.5, 8.5, 8}
BasePetStatsArray[557] = {7.5, 8.5, 8}
BasePetStatsArray[558] = {8, 8, 8}
BasePetStatsArray[559] = {7.5, 9, 7.5}
BasePetStatsArray[560] = {8.5, 7.5, 8}
BasePetStatsArray[562] = {7.5, 8, 8.5}
BasePetStatsArray[564] = {9.5, 7.5, 7}
BasePetStatsArray[565] = {8.5, 7.5, 8}
BasePetStatsArray[566] = {7.5, 7.5, 9}
BasePetStatsArray[567] = {7.5, 8, 8.5}
BasePetStatsArray[568] = {9.5, 8.5, 6}
BasePetStatsArray[569] = {8.5, 7.5, 8}
BasePetStatsArray[570] = {8, 8, 8}
BasePetStatsArray[571] = {7.5, 8, 8.5}
BasePetStatsArray[572] = {8.5, 8, 7.5}
BasePetStatsArray[573] = {9, 7, 8}
BasePetStatsArray[626] = {7.5, 8, 8.5}
BasePetStatsArray[627] = {8.5, 8.5, 7}
BasePetStatsArray[628] = {8.5, 8, 7.5}
BasePetStatsArray[629] = {8.5, 8, 7.5}
BasePetStatsArray[630] = {8, 8, 8}
BasePetStatsArray[631] = {7.5, 8, 8.5}
BasePetStatsArray[632] = {7.5, 8, 8.5}
BasePetStatsArray[633] = {8, 8, 8}
BasePetStatsArray[634] = {7, 8.5, 8.5}
BasePetStatsArray[635] = {7.5, 8, 8.5}
BasePetStatsArray[637] = {8, 8, 8}
BasePetStatsArray[638] = {8.5, 7, 8.5}
BasePetStatsArray[639] = {8, 7.5, 8.5}
BasePetStatsArray[640] = {8, 7, 9}
BasePetStatsArray[641] = {8, 7, 9}
BasePetStatsArray[644] = {8, 7.5, 8.5}
BasePetStatsArray[645] = {8, 8, 8}
BasePetStatsArray[646] = {8, 8, 8}
BasePetStatsArray[647] = {8, 8, 8}
BasePetStatsArray[648] = {9, 7.5, 7.5}
BasePetStatsArray[649] = {9, 7.5, 7.5}
BasePetStatsArray[650] = {8.5, 8, 7.5}
BasePetStatsArray[652] = {8, 8, 8}
BasePetStatsArray[665] = {7.5, 8.5, 8}
BasePetStatsArray[666] = {8, 8, 8}
BasePetStatsArray[671] = {8, 8, 8}
BasePetStatsArray[675] = {8, 7.5, 8.5}
BasePetStatsArray[677] = {8, 8, 8}
BasePetStatsArray[678] = {8, 8, 8}
BasePetStatsArray[679] = {8, 8, 8}
BasePetStatsArray[680] = {8, 8, 8}
BasePetStatsArray[699] = {7, 8.5, 8.5}
BasePetStatsArray[702] = {8.5, 7.5, 8}
BasePetStatsArray[703] = {8, 8, 8}
BasePetStatsArray[705] = {8, 8.5, 7.5}
BasePetStatsArray[706] = {8, 8, 8}
BasePetStatsArray[707] = {8, 8, 8}
BasePetStatsArray[708] = {8, 7.5, 8.5}
BasePetStatsArray[709] = {8, 7.5, 8.5}
BasePetStatsArray[710] = {8, 8, 8}
BasePetStatsArray[711] = {8, 8, 8}
BasePetStatsArray[712] = {8, 8, 8}
BasePetStatsArray[713] = {9, 7.5, 7.5}
BasePetStatsArray[714] = {7, 8.5, 8.5}
BasePetStatsArray[715] = {8, 8, 8}
BasePetStatsArray[716] = {7, 8.5, 8.5}
BasePetStatsArray[717] = {7.5, 8.5, 8}
BasePetStatsArray[718] = {8, 8, 8}
BasePetStatsArray[722] = {7.5, 8.5, 8}
BasePetStatsArray[723] = {9, 7.5, 7.5}
BasePetStatsArray[724] = {8, 8, 8}
BasePetStatsArray[725] = {8, 8, 8}
BasePetStatsArray[726] = {7, 8.5, 8.5}
BasePetStatsArray[727] = {8, 8, 8}
BasePetStatsArray[728] = {8, 8, 8}
BasePetStatsArray[729] = {8, 7, 9}
BasePetStatsArray[730] = {8, 7, 9}
BasePetStatsArray[731] = {7, 8.5, 8.5}
BasePetStatsArray[732] = {8, 8.5, 7.5}
BasePetStatsArray[733] = {8, 8, 8}
BasePetStatsArray[737] = {6.5, 8, 9.5}
BasePetStatsArray[739] = {7, 8, 9}
BasePetStatsArray[740] = {8, 7.5, 8.5}
BasePetStatsArray[741] = {8, 8, 8}
BasePetStatsArray[742] = {8, 8, 8}
BasePetStatsArray[743] = {9.5, 8.5, 6}
BasePetStatsArray[744] = {8.5, 7, 8.5}
BasePetStatsArray[745] = {8, 8, 8}
BasePetStatsArray[746] = {8.5, 9, 6.5}
BasePetStatsArray[747] = {7.5, 8.5, 8}
BasePetStatsArray[748] = {8, 8.5, 7.5}
BasePetStatsArray[749] = {8, 8, 8}
BasePetStatsArray[750] = {8, 8, 8}
BasePetStatsArray[751] = {8, 7.5, 8.5}
BasePetStatsArray[752] = {9, 7.5, 7.5}
BasePetStatsArray[753] = {7.5, 8.5, 8}
BasePetStatsArray[754] = {8, 8, 8}
BasePetStatsArray[755] = {9, 6.5, 8.5}
BasePetStatsArray[756] = {8.5, 7, 8.5}
BasePetStatsArray[757] = {8.5, 8, 7.5}
BasePetStatsArray[758] = {7.5, 8.5, 8}
BasePetStatsArray[792] = {8, 8.5, 7.5}
BasePetStatsArray[800] = {8, 8, 8}
BasePetStatsArray[802] = {8.5, 8.5, 7}
BasePetStatsArray[817] = {8.5, 8, 7.5}
BasePetStatsArray[818] = {8, 8.5, 7.5}
BasePetStatsArray[819] = {7.5, 8.5, 8}
BasePetStatsArray[820] = {8, 8, 8}
BasePetStatsArray[821] = {8, 8, 8}
BasePetStatsArray[823] = {8, 8, 8}
BasePetStatsArray[824] = {8, 8, 8}
BasePetStatsArray[825] = {8, 8, 8}
BasePetStatsArray[826] = {8, 8, 8}
BasePetStatsArray[827] = {8, 8, 8}
BasePetStatsArray[828] = {8, 8, 8}
BasePetStatsArray[829] = {8, 8, 8}
BasePetStatsArray[830] = {8, 8, 8}
BasePetStatsArray[831] = {8, 8, 8}
BasePetStatsArray[832] = {8, 8, 8}
BasePetStatsArray[833] = {8, 8, 8}
BasePetStatsArray[834] = {8.5, 8, 7.5}
BasePetStatsArray[835] = {8, 8, 8}
BasePetStatsArray[836] = {7.5, 7, 9.5}
BasePetStatsArray[837] = {8.5, 8, 7.5}
BasePetStatsArray[838] = {8, 8, 8}
BasePetStatsArray[844] = {8, 8.5, 7.5}
BasePetStatsArray[845] = {8, 8, 8}
BasePetStatsArray[846] = {6, 8, 10}
BasePetStatsArray[847] = {8, 8, 8}
BasePetStatsArray[848] = {8, 7, 9}
BasePetStatsArray[849] = {8, 8, 8}
BasePetStatsArray[850] = {8, 8, 8}
BasePetStatsArray[851] = {7.5, 8, 8.5}
BasePetStatsArray[855] = {7.5, 8.5, 8}
BasePetStatsArray[856] = {8, 8, 8}
BasePetStatsArray[868] = {8, 8, 8}
BasePetStatsArray[872] = {8, 8, 8}
BasePetStatsArray[873] = {8, 8, 8}
BasePetStatsArray[874] = {8, 8, 8}
BasePetStatsArray[875] = {8, 8, 8}
BasePetStatsArray[876] = {8, 8, 8}
BasePetStatsArray[877] = {8, 8, 8}
BasePetStatsArray[878] = {8, 8, 8}
BasePetStatsArray[879] = {8, 8, 8}
BasePetStatsArray[880] = {8, 8, 8}
BasePetStatsArray[881] = {8, 8, 8}
BasePetStatsArray[882] = {8, 8, 8}
BasePetStatsArray[883] = {8, 8, 8}
BasePetStatsArray[884] = {8, 8, 8}
BasePetStatsArray[885] = {8, 8, 8}
BasePetStatsArray[886] = {8, 8, 8}
BasePetStatsArray[887] = {8, 8, 8}
BasePetStatsArray[888] = {8, 8, 8}
BasePetStatsArray[889] = {8, 8, 8}
BasePetStatsArray[890] = {8, 8, 8}
BasePetStatsArray[891] = {8, 8, 8}
BasePetStatsArray[892] = {8, 8, 8}
BasePetStatsArray[893] = {8, 8, 8}
BasePetStatsArray[894] = {8, 8, 8}
BasePetStatsArray[895] = {8, 8, 8}
BasePetStatsArray[896] = {8, 8, 8}
BasePetStatsArray[897] = {8, 8, 8}
BasePetStatsArray[898] = {8, 8, 8}
BasePetStatsArray[899] = {8, 8, 8}
BasePetStatsArray[900] = {8, 8, 8}
BasePetStatsArray[901] = {8, 8, 8}
BasePetStatsArray[902] = {8, 8, 8}
BasePetStatsArray[903] = {7.5, 9, 7.5}
BasePetStatsArray[904] = {8, 8, 8}
BasePetStatsArray[905] = {8, 8, 8}
BasePetStatsArray[906] = {8, 8, 8}
BasePetStatsArray[907] = {8, 8, 8}
BasePetStatsArray[908] = {8, 8, 8}
BasePetStatsArray[909] = {8, 8, 8}
BasePetStatsArray[911] = {8, 8.5, 7.5}
BasePetStatsArray[912] = {8, 8.5, 7.5}
BasePetStatsArray[913] = {8, 8.5, 7.5}
BasePetStatsArray[915] = {8, 8, 8}
BasePetStatsArray[916] = {8, 8, 8}
BasePetStatsArray[917] = {8, 8, 8}
BasePetStatsArray[921] = {8, 8, 8}
BasePetStatsArray[922] = {8, 8, 8}
BasePetStatsArray[923] = {8.5, 7.5, 8}
BasePetStatsArray[924] = {8, 8, 8}
BasePetStatsArray[925] = {8, 8, 8}
BasePetStatsArray[926] = {8, 8, 8}
BasePetStatsArray[927] = {8, 8, 8}
BasePetStatsArray[928] = {8, 8, 8}
BasePetStatsArray[929] = {8, 8, 8}
BasePetStatsArray[931] = {8, 8, 8}
BasePetStatsArray[932] = {8, 8, 8}
BasePetStatsArray[933] = {8, 8, 8}
BasePetStatsArray[934] = {8, 8, 8}
BasePetStatsArray[935] = {8, 8, 8}
BasePetStatsArray[936] = {8, 8, 8}
BasePetStatsArray[937] = {8, 8, 8}
BasePetStatsArray[938] = {8, 8, 8}
BasePetStatsArray[939] = {8, 8, 8}
BasePetStatsArray[941] = {8, 8, 8}
BasePetStatsArray[942] = {8, 8, 8}
BasePetStatsArray[943] = {8, 8, 8}
BasePetStatsArray[944] = {8, 8, 8}
BasePetStatsArray[945] = {8, 8, 8}
BasePetStatsArray[946] = {8, 8, 8}
BasePetStatsArray[947] = {8, 8, 8}
BasePetStatsArray[948] = {8, 8, 8}
BasePetStatsArray[949] = {8, 8, 8}
BasePetStatsArray[950] = {8, 8, 8}
BasePetStatsArray[951] = {8, 8, 8}
BasePetStatsArray[952] = {8, 8, 8}
BasePetStatsArray[953] = {8, 8, 8}
BasePetStatsArray[954] = {8, 8, 8}
BasePetStatsArray[955] = {8, 8, 8}
BasePetStatsArray[956] = {8, 8, 8}
BasePetStatsArray[957] = {8, 8, 8}
BasePetStatsArray[958] = {8, 8, 8}
BasePetStatsArray[959] = {8, 8, 8}
BasePetStatsArray[960] = {8, 8, 8}
BasePetStatsArray[961] = {8, 8, 8}
BasePetStatsArray[962] = {8, 8, 8}
BasePetStatsArray[963] = {8, 8, 8}
BasePetStatsArray[964] = {8, 8, 8}
BasePetStatsArray[965] = {8, 8, 8}
BasePetStatsArray[966] = {8, 8, 8}
BasePetStatsArray[967] = {8, 8, 8}
BasePetStatsArray[968] = {8, 8, 8}
BasePetStatsArray[969] = {8, 8, 8}
BasePetStatsArray[970] = {8, 8, 8}
BasePetStatsArray[971] = {8, 8, 8}
BasePetStatsArray[972] = {8, 8, 8}
BasePetStatsArray[973] = {8, 8, 8}
BasePetStatsArray[974] = {8, 8, 8}
BasePetStatsArray[975] = {8, 8, 8}
BasePetStatsArray[976] = {8, 8, 8}
BasePetStatsArray[977] = {8.5, 8.5, 8.5}
BasePetStatsArray[978] = {8.5, 8.5, 8.5}
BasePetStatsArray[979] = {8.5, 8.5, 8.5}
BasePetStatsArray[980] = {8.5, 8.5, 8.5}
BasePetStatsArray[981] = {8.5, 8.5, 8.5}
BasePetStatsArray[982] = {8.5, 8.5, 8.5}
BasePetStatsArray[983] = {8.5, 8.5, 8.5}
BasePetStatsArray[984] = {8.5, 8.5, 8.5}
BasePetStatsArray[985] = {8.5, 8.5, 8.5}
BasePetStatsArray[986] = {8.5, 8.5, 8.5}
BasePetStatsArray[987] = {8.5, 8.5, 8.5}
BasePetStatsArray[988] = {8.5, 8.5, 8.5}
BasePetStatsArray[989] = {8, 8, 8}
BasePetStatsArray[990] = {8, 8, 8}
BasePetStatsArray[991] = {8, 8, 8}
BasePetStatsArray[992] = {8, 8, 8}
BasePetStatsArray[993] = {8, 8, 8}
BasePetStatsArray[994] = {8, 8, 8}
BasePetStatsArray[995] = {8, 8, 8}
BasePetStatsArray[996] = {8, 8, 8}
BasePetStatsArray[997] = {8, 8, 8}
BasePetStatsArray[998] = {8, 8, 8}
BasePetStatsArray[999] = {8, 8, 8}
BasePetStatsArray[1000] = {8, 8, 8}
BasePetStatsArray[1001] = {8, 8, 8}
BasePetStatsArray[1002] = {9, 9, 9}
BasePetStatsArray[1003] = {9, 9, 9}
BasePetStatsArray[1004] = {8, 8, 8}
BasePetStatsArray[1005] = {8, 8, 8}
BasePetStatsArray[1006] = {8, 8, 8}
BasePetStatsArray[1007] = {8, 8, 8}
BasePetStatsArray[1008] = {8, 8, 8}
BasePetStatsArray[1009] = {8, 8, 8}
BasePetStatsArray[1010] = {8, 8, 8}
BasePetStatsArray[1011] = {8, 8, 8}
BasePetStatsArray[1012] = {8, 8, 8}
BasePetStatsArray[1013] = {9, 7.5, 7.5}
BasePetStatsArray[1039] = {7.5, 7.5, 9}
BasePetStatsArray[1040] = {8, 8, 8}
BasePetStatsArray[1042] = {6.75, 10.5, 6.75}
BasePetStatsArray[1061] = {8, 8, 8}
BasePetStatsArray[1062] = {8, 7.5, 8.5}
BasePetStatsArray[1063] = {8.5, 8.5, 7}
BasePetStatsArray[1065] = {8.5, 8.5, 7}
BasePetStatsArray[1066] = {8, 8, 8}
BasePetStatsArray[1067] = {8.5, 7.5, 8}
BasePetStatsArray[1068] = {8, 8, 8}
BasePetStatsArray[1073] = {8, 8, 8}
BasePetStatsArray[1117] = {7, 8.5, 8.5}
BasePetStatsArray[1124] = {8, 8, 8}
BasePetStatsArray[1125] = {8, 8, 8}
BasePetStatsArray[1126] = {8, 8, 8}
BasePetStatsArray[1127] = {7.5, 8.5, 8}
BasePetStatsArray[1128] = {8, 8, 8}
BasePetStatsArray[1129] = {8, 8, 8}
BasePetStatsArray[1130] = {8, 8, 8}
BasePetStatsArray[1131] = {8, 8, 8}
BasePetStatsArray[1132] = {8, 8, 8}
BasePetStatsArray[1133] = {8, 8, 8}
BasePetStatsArray[1134] = {8, 8, 8}
BasePetStatsArray[1135] = {8, 8, 8}
BasePetStatsArray[1136] = {8, 8, 8}
BasePetStatsArray[1137] = {8, 8, 8}
BasePetStatsArray[1138] = {8, 8, 8}
BasePetStatsArray[1139] = {8, 8, 8}
BasePetStatsArray[1140] = {8, 8, 8}
BasePetStatsArray[1141] = {8, 8, 8}
BasePetStatsArray[1142] = {8.5, 7.5, 8}
BasePetStatsArray[1143] = {8, 8, 8}
BasePetStatsArray[1144] = {8, 8, 8}
BasePetStatsArray[1145] = {8, 8, 8}
BasePetStatsArray[1146] = {8, 8, 8}
BasePetStatsArray[1147] = {8, 8, 8}
BasePetStatsArray[1149] = {8, 8, 8}
BasePetStatsArray[1150] = {8, 8, 8}
BasePetStatsArray[1151] = {8, 8, 8}
BasePetStatsArray[1152] = {7.5, 8.5, 8}
BasePetStatsArray[1153] = {8, 8, 8}
BasePetStatsArray[1154] = {8, 8, 8}
BasePetStatsArray[1155] = {8, 8.5, 7.5}
BasePetStatsArray[1156] = {8, 8, 8}
BasePetStatsArray[1157] = {8, 8, 8}
BasePetStatsArray[1158] = {8, 8, 8}
BasePetStatsArray[1159] = {7.5, 8.5, 8}
BasePetStatsArray[1160] = {8.5, 8, 7.5}
BasePetStatsArray[1161] = {8, 8.5, 7.5}
BasePetStatsArray[1162] = {7, 9, 8}
BasePetStatsArray[1163] = {9, 8, 7}
BasePetStatsArray[1164] = {7.5, 8, 8.5}
BasePetStatsArray[1165] = {8, 8.5, 7.5}
BasePetStatsArray[1166] = {8, 8.5, 7.5}
BasePetStatsArray[1167] = {8, 8.5, 7.5}
BasePetStatsArray[1168] = {8, 8, 8}