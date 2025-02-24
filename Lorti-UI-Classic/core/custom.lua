local events = { 
	"PLAYER_LOGIN"
	}

local function MoveBuffs(buttonName, index)
	if (Lorti.bigbuff == true) then
		if not (IsAddOnLoaded("DFMinimap")) then
			BuffFrame:ClearAllPoints()
			BuffFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -120, -10)
			BuffFrame:SetScale(1.6)
		else
			BuffFrame:SetScale(1.6)
		end
	end
	if not Lorti.bigbuff and (IsAddOnLoaded("DFMinimap")) then
		
			BuffFrame:ClearAllPoints()
			BuffFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -220, -10)
			
	end
end
hooksecurefunc("UIParent_UpdateTopFramePositions", MoveBuffs)

local function OtherFunctions()
	if (Lorti.stealth == true) then
		if select(2, UnitClass("player")) == "ROGUE" then    
		HasBonusActionBar = function() return false end end
	end
end

local function OnEvent(self, event)
	if (event == "PLAYER_LOGIN") then
		OtherFunctions()
	else 
		return nil
	end
end

local f = CreateFrame("Frame")
for _, v in pairs(events) do f:RegisterEvent(v) end
f:SetScript('OnEvent', OnEvent)