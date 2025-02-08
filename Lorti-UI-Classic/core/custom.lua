local events = { 
	"PLAYER_LOGIN"
	}

local function MoveBuffs(buttonName, index)
	if (Lorti.bigbuff == true) then
		BuffFrame:ClearAllPoints()
		BuffFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -120, -10)
		BuffFrame:SetScale(1.6)
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