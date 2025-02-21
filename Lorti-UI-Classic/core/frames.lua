  --get the addon namespace
  local addon, ns = ...
  --get the config values
  local cfg = ns.cfg
  local dragFrameList = ns.dragFrameList

   local addonlist = {
	["Shadowed Unit Frames"] = true, 
	["PitBull Unit Frames 4.0"] = true, 
	["X-Perl UnitFrames"] = true, 
	["Z-Perl UnitFrames"] = true, 
	["EasyFrames"] = true, 
	["RougeUI"] = true, 
	["ElvUI"] = true, 
	["Uber UI Classic"] = true, 
	["whoaThickFrames_BCC"] = true, 
	["whoaUnitFrames_BCC"] = true, 
	["AbyssUI"] = true, 
	["KkthnxUI"] = true
   }

  -- v:SetVertexColor(.35, .35, .35) GREY
  -- v:SetVertexColor(.05, .05, .05) DARKEST

local events = {
	"PLAYER_LOGIN",
	"PLAYER_ENTERING_WORLD",
	"GROUP_ROSTER_UPDATE"
}

  ---------------------------------------
  -- ACTIONS
  ---------------------------------------

  -- REMOVING UGLY PARTS OF UI

local errormessage_blocks = {
	  'Способность пока недоступна',
	  'Выполняется другое действие',
	  'Невозможно делать это на ходу',
	  'Предмет пока недоступен',
	  'Недостаточно',
	  'Некого атаковать',
	  'Заклинание пока недоступно',
	  'У вас нет цели',
	  'Вы пока не можете этого сделать',

	  'Ability is not ready yet',
 	  'Another action is in progress',
	  'Can\'t attack while mounted',
	  'Can\'t do that while moving',
	  'Item is not ready yet',
	  'Not enough',
	  'Nothing to attack',
	  'Spell is not ready yet',
	  'You have no target',
	  'You can\'t do that yet',
	}

local function enable()
	local enable
	local onevent
	local uierrorsframe_addmessage
	local old_uierrosframe_addmessage

  	old_uierrosframe_addmessage = UIErrorsFrame.AddMessage
  	UIErrorsFrame.AddMessage = uierrorsframe_addmessage
end

local function uierrorsframe_addmessage (frame, text, red, green, blue, id)
  		for i,v in ipairs(errormessage_blocks) do
    			if text and text:match(v) then
      				return
    			end
  		end
  		old_uierrosframe_addmessage(frame, text, red, green, blue, id)
end

-- COLORING FRAMES
local CF=CreateFrame("Frame")
CF:RegisterEvent("PLAYER_ENTERING_WORLD")
CF:RegisterEvent("GROUP_ROSTER_UPDATE")

-- Classification
local function ApplyThickness()
	hooksecurefunc('TargetFrame_CheckClassification', function(self, forceNormalTexture)
		for addon in pairs(addonlist) do
			if IsAddOnLoaded(addon) then
				return
			end
		end
			local classification = UnitClassification(self.unit);
        if (classification == "worldboss" or classification == "elite") then
            self.borderTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\target\\Thick-Elite")
            self.borderTexture:SetVertexColor(1, 1, 1)
        elseif (classification == "rareelite") then
            self.borderTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\target\\Thick-Rare-Elite")
            self.borderTexture:SetVertexColor(1, 1, 1)
        elseif (classification == "rare") then
            self.borderTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\target\\Thick-Rare")
            self.borderTexture:SetVertexColor(1, 1, 1)
        else
            self.borderTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\unitframes\\UI-TargetingFrame")
            self.borderTexture:SetVertexColor(0.05, 0.05, 0.05)
        end
		end)

		--Player Name

		PlayerFrame.name:ClearAllPoints()
		PlayerFrame.name:SetPoint('TOP', PlayerFrameHealthBar, 0,15)
		
		--Rest Glow

		PlayerStatusTexture:SetTexture()
		PlayerRestGlow:SetAlpha(0)

		--Player Frame

		function LortiUIPlayerFrame(self)
			-- PlayerFrameTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\target\\Thick-UI-TargetingFrame");
			if Lorti.playername then
				self.name:Hide();
			else
				self.name:Show();
			end
			self.name:ClearAllPoints();
			self.name:SetPoint("CENTER", PlayerFrame, "CENTER",50.5, 36);
			self.healthbar:SetPoint("TOPLEFT",107,-24);
			self.healthbar:SetHeight(28);
			self.healthbar.LeftText:ClearAllPoints();
			self.healthbar.LeftText:SetPoint("LEFT",self.healthbar,"LEFT",8,0);
			self.healthbar.RightText:ClearAllPoints();
			self.healthbar.RightText:SetPoint("RIGHT",self.healthbar,"RIGHT",-5,0);
			self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 1, 0);
			self.manabar:SetPoint("TOPLEFT",108,-52);
			self.manabar:SetHeight(12);
			self.manabar.LeftText:ClearAllPoints();
			self.manabar.LeftText:SetPoint("LEFT",self.manabar,"LEFT",8,0);
			self.manabar.RightText:ClearAllPoints();
			self.manabar.RightText:SetPoint("RIGHT",self.manabar,"RIGHT",-5,0);
			self.manabar.TextString:SetPoint("CENTER",self.manabar,"CENTER",-1,0);
			PlayerFrameGroupIndicatorText:ClearAllPoints();
			PlayerFrameGroupIndicatorText:SetPoint("BOTTOMLEFT", PlayerFrame,"TOP",0,-20);
			PlayerFrameGroupIndicatorLeft:Hide();
			PlayerFrameGroupIndicatorMiddle:Hide();
			PlayerFrameGroupIndicatorRight:Hide();
			-- PlayerFrame:SetScale(1.3)
		end
	hooksecurefunc("PlayerFrame_ToPlayerArt", LortiUIPlayerFrame)
		
		--Target Frame

		function LortiUITargetFrame (self, forceNormalTexture)
			local classification = UnitClassification(self.unit);
			self.highLevelTexture:SetPoint("CENTER", self.levelText, "CENTER", 0,0);
			self.nameBackground:Hide();
			self.name:SetPoint("LEFT", self, 15, 36);
			self.healthbar:SetSize(110, 28);
			self.healthbar:SetPoint("TOPLEFT", 6, -23);
			self.manabar:SetPoint("TOPLEFT", 6, -52);
			self.manabar:SetSize(110, 12);
			self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 8, 0);
			self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -5, 0);
			self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0);
			self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 8, 0);
			self.manabar.RightText:ClearAllPoints();
			self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -5, 0);
			self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, 0);
			-- TargetFrame:SetScale(1.3)
			-- FocusFrame:SetScale(1.3)
			TargetFrameSpellBar.Text:SetFont(Lorti.fontFamily, Lorti.StringSize-2, "OUTLINE")
			FocusFrameSpellBar.Text:SetFont(Lorti.fontFamily, Lorti.StringSize-2, "OUTLINE")
			if ( forceNormalTexture ) then
				self.haveElite = nil;
				self.Background:SetSize(119,42);
				self.Background:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 7, 35);
			else
				self.haveElite = true;
				self.Background:SetSize(119,42);
			end
			self.healthbar.lockColor = true;
			
		end
		hooksecurefunc("TargetFrame_CheckClassification", LortiUITargetFrame)
		
		--Target of Target Frame Texture

		TargetFrameToTTextureFrameTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\unitframes\\UI-TargetofTargetFrame");
		TargetFrameToTHealthBar:SetHeight(8)
		FocusFrameToTTextureFrameTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\unitframes\\UI-TargetofTargetFrame");
		FocusFrameToTHealthBar:SetHeight(8)
end

local function Classify(self, forceNormalTexture)
		local classification = UnitClassification(self.unit);
		if ( classification == "minus" ) then
			self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Minus");
			self.borderTexture:SetVertexColor(.05, .05, .05)
			self.nameBackground:Hide();
			self.manabar.pauseUpdates = true;
			self.manabar:Hide();
			self.manabar.TextString:Hide();
			self.manabar.LeftText:Hide();
			self.manabar.RightText:Hide();
			forceNormalTexture = true;
		elseif ( classification == "worldboss" or classification == "elite" ) then
			self.borderTexture:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\target\\elite")
			self.borderTexture:SetVertexColor(1, 1, 1)
		elseif ( classification == "rareelite" ) then
			self.borderTexture:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\target\\rare-elite")
			self.borderTexture:SetVertexColor(1, 1, 1)
		elseif ( classification == "rare" ) then
			self.borderTexture:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\target\\rare")
			self.borderTexture:SetVertexColor(1, 1, 1)
		else
			self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
			self.borderTexture:SetVertexColor(.05, .05, .05)
		end
		
end

function LortiUIPlayerFrame(self)
		self.healthbar:SetPoint("TOPLEFT",108,-40);
		self.manabar:SetPoint("TOPLEFT",108,-52);
end


local function ColorRaid()
	if Lorti.applyblackborder then
		for g = 1, NUM_RAID_GROUPS do
			local group = _G["CompactRaidGroup"..g.."BorderFrame"]
			if group then
				for _, region in pairs({group:GetRegions()}) do
					if region:IsObjectType("Texture") then
						region:SetVertexColor(.05, .05, .05)
					end
				end
			end

			for m = 1, 5 do
				local frame = _G["CompactRaidGroup"..g.."Member"..m]
				if frame then
					groupcolored = true
					for _, region in pairs({frame:GetRegions()}) do
						if region:GetName():find("Border") then
							region:SetVertexColor(.05, .05, .05)
						end
					end
				end

				local frame = _G["CompactRaidFrame"..m]
					if frame then
						singlecolored = true
						for _, region in pairs({frame:GetRegions()}) do
							if region:GetName():find("Border") then
								region:SetVertexColor(.05, .05, .05)
							end
						end
					end
				end
			end
		
		for _, region in pairs({CompactRaidFrameContainerBorderFrame:GetRegions()}) do
			if region:IsObjectType("Texture") then
				region:SetVertexColor(.05, .05, .05)
			end
		end
	end
end
CF:SetScript("OnEvent", function(self, event)
		
		ColorRaid()
		if Lorti.applyblackborder then
		CF:SetScript("OnUpdate", function()
			if CompactRaidGroup1 and not groupcolored == true then
				ColorRaid()
			end
			if CompactRaidFrame1 and not singlecolored == true then
				ColorRaid()
			end
		end)
		CastingBarFrame.Border:SetVertexColor(0.05,0.05,0.05)
		end
		if event == "GROUP_ROSTER_UPDATE" then return end
		if not (IsAddOnLoaded("Shadowed Unit Frames")
				or IsAddOnLoaded("PitBull Unit Frames 4.0")
				or IsAddOnLoaded("X-Perl UnitFrames")) then

			for i, v in pairs({
				PlayerPVPIcon,
				TargetFrameTextureFramePVPIcon,
				FocusFrameTextureFramePVPIcon,
			}) do
				v:SetAlpha(0)
			end

			for i=1, 4 do
				_G["PartyMemberFrame"..i.."Portrait"]:AdjustPointsOffset(0, -2)
				_G["PartyMemberFrame"..i.."PVPIcon"]:SetAlpha(0)
				_G["PartyMemberFrame"..i.."NotPresentIcon"]:Hide()
				_G["PartyMemberFrame"..i.."NotPresentIcon"].Show = function() end
				_G["PartyMemberFrame"..i.."Name"]:SetFont(Lorti.fontFamily, Lorti.StringSize-2, "OUTLINE")
				-- _G["PartyMemberFrame"..i]:SetScale(1.6)
			end

			PlayerFrameGroupIndicator:SetAlpha(0)
			if Lorti.hitindicator then
				PlayerHitIndicator:SetText(nil)
				PlayerHitIndicator.SetText = function() end
				PetHitIndicator:SetText(nil)
				PetHitIndicator.SetText = function() end
			end			
		end
	end)


local Framecolor = CreateFrame("Frame")
Framecolor:RegisterEvent("ADDON_LOADED")
Framecolor:SetScript("OnEvent", function(self, event, addon)
if Lorti.applyblackborder then
	if not (IsAddOnLoaded("Shadowed Unit Frames") or IsAddOnLoaded("PitBull Unit Frames 4.0") or IsAddOnLoaded("X-Perl UnitFrames")) then
	   if (addon == "Lorti-UI-Classic") then
			
		for i,v in pairs({
			PlayerFrameAlternateManaBarBorder,
  			PlayerFrameAlternateManaBarLeftBorder,
			PlayerFrameAlternateManaBarRightBorder,
			PlayerFrameAlternatePowerBarBorder,
			PlayerFrameAlternatePowerBarLeftBorder,
			PlayerFrameAlternatePowerBarRightBorder,
			-- PlayerFrameTexture,
			TargetFrameTextureFrameTexture,
			TargetFrameToTTextureFrameTexture,
			PetFrameTexture,
			PartyMemberFrame1Texture,
			PartyMemberFrame2Texture,
			PartyMemberFrame3Texture,
			PartyMemberFrame4Texture,
			PartyMemberFrame1PetFrameTexture,
			PartyMemberFrame2PetFrameTexture,
			PartyMemberFrame3PetFrameTexture,
			PartyMemberFrame4PetFrameTexture,			 
			CastingBarFrame.Border,
			FocusFrameToTTextureFrameTexture,
			TargetFrameSpellBar.Border,
			FocusFrameSpellBar.Border,
			MirrorTimer1Border,
			MirrorTimer2Border,
			MirrorTimer3Border
		}) do
			v:SetVertexColor(.05, .05, .05)
		end
	
		for _, region in pairs({CompactRaidFrameManager:GetRegions()}) do
			if region:IsObjectType("Texture") then
				region:SetVertexColor(.05, .05, .05)
			end
		end

		for _, region in pairs({CompactRaidFrameManagerContainerResizeFrame:GetRegions()}) do
			if region:GetName():find("Border") then
				region:SetVertexColor(.05, .05, .05)
			end
		end
	end

	for i,v in pairs({
      		MainMenuBarLeftEndCap,
      		MainMenuBarRightEndCap,
      		StanceBarLeft,
      		StanceBarMiddle,
      		StanceBarRight
	}) do
   		v:SetVertexColor(.35, .35, .35)
	end

	for i,v in pairs({
		MinimapBorder,
		MinimapBorderTop,
		MiniMapMailBorder,
		MiniMapTrackingBorder,
		MiniMapBattlefieldBorder
	}) do
		v:SetVertexColor(.05, .05, .05)
   	end

	for i,v in pairs({
      		LootFrameBg,
	  	LootFrameRightBorder,
      		LootFrameLeftBorder,
		LootFrameTopBorder,
      		LootFrameBottomBorder,
		LootFrameTopRightCorner,
      		LootFrameTopLeftCorner,
      		LootFrameBotRightCorner,
      		LootFrameBotLeftCorner,
	  	LootFrameInsetInsetTopRightCorner,
	  	LootFrameInsetInsetTopLeftCorner,
	 	LootFrameInsetInsetBotRightCorner,
	  	LootFrameInsetInsetBotLeftCorner,
      		LootFrameInsetInsetRightBorder,
      		LootFrameInsetInsetLeftBorder,
      		LootFrameInsetInsetTopBorder,
      		LootFrameInsetInsetBottomBorder,
	  	LootFramePortraitFrame,
	  	ContainerFrame1BackgroundTop,
	  	ContainerFrame1BackgroundMiddle1,
	  	ContainerFrame1BackgroundBottom,
		ContainerFrame2BackgroundTop,
	  	ContainerFrame2BackgroundMiddle1,
	  	ContainerFrame2BackgroundBottom,
		ContainerFrame3BackgroundTop,
	  	ContainerFrame3BackgroundMiddle1,
	  	ContainerFrame3BackgroundBottom,
		ContainerFrame4BackgroundTop,
		ContainerFrame4BackgroundMiddle1,
		ContainerFrame4BackgroundBottom,
		ContainerFrame5BackgroundTop,
		ContainerFrame5BackgroundMiddle1,
		ContainerFrame5BackgroundBottom,
		ContainerFrame6BackgroundTop,
		ContainerFrame6BackgroundMiddle1,
		ContainerFrame6BackgroundBottom,
		ContainerFrame7BackgroundTop,
	  	ContainerFrame7BackgroundMiddle1,
	  	ContainerFrame7BackgroundBottom,
	  	ContainerFrame8BackgroundTop,
	  	ContainerFrame8BackgroundMiddle1,
	  	ContainerFrame8BackgroundBottom,
	  	ContainerFrame9BackgroundTop,
	  	ContainerFrame9BackgroundMiddle1,
	  	ContainerFrame9BackgroundBottom,
	  	ContainerFrame10BackgroundTop,
	  	ContainerFrame10BackgroundMiddle1,
	  	ContainerFrame10BackgroundBottom,
	  	ContainerFrame11BackgroundTop,
	  	ContainerFrame11BackgroundMiddle1,
	  	ContainerFrame11BackgroundBottom,
	  	MerchantFrameTopBorder,
	  	MerchantFrameBtnCornerRight,
	  	MerchantFrameBtnCornerLeft,
	 	MerchantFrameBottomRightBorder,
	  	MerchantFrameBottomLeftBorder,
	  	MerchantFrameButtonBottomBorder,
	  	MerchantFrameBg,
	}) do
   		v:SetVertexColor(.35, .35, .35)
	end

--BANK
local a, b, c, d, _, e = BankFrame:GetRegions()
for _, v in pairs({a, b, c, d, e

})do
   v:SetVertexColor(.35, .35, .35)

end

--Darker color stuff
for i,v in pairs({
      	LootFrameInsetBg,
      	LootFrameTitleBg,	
	MerchantFrameTitleBg,
	ArenaEnemyFrame1Texture,
	ArenaEnemyFrame2Texture,
	ArenaEnemyFrame3Texture,
	ArenaEnemyFrame4Texture,
	ArenaEnemyFrame5Texture,
}) do
   v:SetVertexColor(.05, .05, .05)
end

--PAPERDOLL/Characterframe
local a, b, c, d, _, e = PaperDollFrame:GetRegions()
for _, v in pairs({a, b, c, d, e

})do
   v:SetVertexColor(.35, .35, .35)

end

--Spellbook
local _, a, b, c, d = SpellBookFrame:GetRegions()
for _, v in pairs({a, b, c, d

}) do
    v:SetVertexColor(.35, .35, .35)
end



-- Skilltab
local a, b, c, d = SkillFrame:GetRegions()
for _, v in pairs({a, b, c ,d

}) do
     v:SetVertexColor(.35, .35, .35)
end
for _, v in pairs({ReputationDetailCorner, ReputationDetailDivider

}) do
     v:SetVertexColor(.35, .35, .35)
end
--Reputation Frame
local a, b, c, d = ReputationFrame:GetRegions()
for _, v in pairs({a, b, c, d

}) do
     v:SetVertexColor(.35, .35, .35)
end



-- HONOR

local a, b, c, d, e = PVPFrame:GetRegions()
for _, v in pairs({a, b, c, d, e 

}) do
   v:SetVertexColor(.35, .35, .35)
end

--Character Tabs

local a, b, c, d, e, f, g, h = CharacterFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d, e, f, g, h = CharacterFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d, e, f, g, h = CharacterFrameTab3:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d, e, f, g, h = CharacterFrameTab4:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d, e, f, g, h = CharacterFrameTab5:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end				



-- Social Frame
local a, b, c, d, e, f, g, _, i, j, k, l, n, o, p, q, r, _, _ = FriendsFrame:GetRegions()
for _, v in pairs({
	a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r,
	FriendsFrameInset:GetRegions(),
	WhoFrameListInset:GetRegions()
}) do
	v:SetVertexColor(.35, .35, .35)
end

FriendsFrameInsetInsetBottomBorder:SetVertexColor(0.35,0.35,0.35)
WhoFrameEditBoxInset:GetRegions():SetVertexColor(0.35,0.35,0.35)
WhoFrameDropDownLeft:SetVertexColor(0.5,0.5,0.5)
WhoFrameDropDownMiddle:SetVertexColor(0.5,0.5,0.5)
WhoFrameDropDownRight:SetVertexColor(0.5,0.5,0.5)

local a, b, c, d, e, f, g, h, i = WhoFrameEditBoxInset:GetRegions()
for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
	v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d, e, f, g, h = FriendsFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d, e, f, g, h = FriendsFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d, e, f, g, h = FriendsFrameTab3:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d, e, f, g, h = FriendsFrameTab4:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end
-- MERCHANT
local _, a, b, c, d, _, _, _, e, f, g, h, j, k = MerchantFrame:GetRegions()
for _, v in pairs({a, b, c ,d, e, f, g, h, j, k

}) do
   v:SetVertexColor(.35, .35, .35)
end

--MerchantPortrait
		   
																		   
for i, v in pairs({
    MerchantFramePortrait
}) do
   v:SetVertexColor(1, 1, 1)
end

--PETPAPERDOLL/PET Frame
local a, b, c, d, _, e = PetPaperDollFrame:GetRegions()
for _, v in pairs({a, b, c, d, e

})do
   v:SetVertexColor(.35, .35, .35)

end

-- SPELLBOOK
local _, a, b, c, d = SpellBookFrame:GetRegions()
for _, v in pairs({a, b, c, d}) do
     v:SetVertexColor(.35, .35, .35)
end

 SpellBookFrame.Material = SpellBookFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
 SpellBookFrame.Material:SetTexture[[Interface\AddOns\Lorti-UI-Classic\textures\quest\QuestBG.tga]]
 SpellBookFrame.Material:SetWidth(547)
 SpellBookFrame.Material:SetHeight(541)
 SpellBookFrame.Material:SetPoint('TOPLEFT', SpellBookFrame, 22, -74)
 SpellBookFrame.Material:SetVertexColor(.7, .7, .7)

-- TinyBook's SPELLBOOK
if (IsAddOnLoaded("TinyBook")) then
local _, a, b, c, d = TSB_SpellBookFrame:GetRegions()
for _, v in pairs({a, b, c, d}) do
     v:SetVertexColor(.35, .35, .35)
end

 TSB_SpellBookFrame.Material = TSB_SpellBookFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
 TSB_SpellBookFrame.Material:SetTexture[[Interface\AddOns\Lorti-UI-Classic\textures\quest\QuestBG.tga]]
 TSB_SpellBookFrame.Material:SetWidth(547)
 TSB_SpellBookFrame.Material:SetHeight(541)
 TSB_SpellBookFrame.Material:SetPoint('TOPLEFT', TSB_SpellBookFrame, 22, -74)
 TSB_SpellBookFrame.Material:SetVertexColor(.7, .7, .7)
end

-- Quest Log Frame
if (IsAddOnLoaded("WideQuestLog")) then
	QuestLogFrame.Material = QuestLogFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
	QuestLogFrame.Material:SetTexture[[Interface\AddOns\Lorti-UI-Classic\textures\quest\QuestBG.tga]]
	QuestLogFrame.Material:SetWidth(524)
	QuestLogFrame.Material:SetHeight(553)
	QuestLogFrame.Material:SetPoint('TOPLEFT', QuestLogDetailScrollFrame, -10, 0)
	QuestLogFrame.Material:SetVertexColor(.8, .8, .8)
else

	local _, _, a, b, c, d, _, _, _, e, f, g, h, j, k = QuestLogFrame:GetRegions()
	for _, v in pairs({a, b, c ,d, e, f, g, h, j, k}) do
		v:SetVertexColor(.35, .35, .35)
	end
 
	QuestLogFrame.Material = QuestLogFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
	QuestLogFrame.Material:SetTexture[[Interface\AddOns\Lorti-UI-Classic\textures\quest\QuestBG.tga]]
	QuestLogFrame.Material:SetWidth(514)
	QuestLogFrame.Material:SetHeight(400)
	QuestLogFrame.Material:SetPoint('TOPLEFT', QuestLogDetailScrollFrame, 0, 0)
	QuestLogFrame.Material:SetVertexColor(.8, .8, .8) 
end	

-- Gossip Frame
local a, b, c, d, e, f, g, h, i = GossipFrameGreetingPanel:GetRegions()
	for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

GossipFrameGreetingPanel.Material = GossipFrameGreetingPanel:CreateTexture(nil, 'OVERLAY', nil, 7)
GossipFrameGreetingPanel.Material:SetTexture[[Interface\AddOns\Lorti-UI-Classic\textures\quest\QuestBG.tga]]
GossipFrameGreetingPanel.Material:SetWidth(514)
GossipFrameGreetingPanel.Material:SetHeight(522)
GossipFrameGreetingPanel.Material:SetPoint('TOPLEFT', GossipFrameGreetingPanel, 22, -74)
GossipFrameGreetingPanel.Material:SetVertexColor(0.7,0.7,0.7)	

-- Quest Frame Reward panel
local a, b, c, d, e, f, g, h, i = QuestFrameRewardPanel:GetRegions()
	for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

QuestFrameRewardPanel.Material = QuestFrameRewardPanel:CreateTexture(nil, 'OVERLAY', nil, 7)
QuestFrameRewardPanel.Material:SetTexture[[Interface\AddOns\Lorti-UI-Classic\textures\quest\QuestBG.tga]]
QuestFrameRewardPanel.Material:SetWidth(514)
QuestFrameRewardPanel.Material:SetHeight(522)
QuestFrameRewardPanel.Material:SetPoint('TOPLEFT', QuestFrameRewardPanel, 22, -74)
QuestFrameRewardPanel.Material:SetVertexColor(0.7,0.7,0.7)

--Mailbox

for i, v in pairs({
	MailFrameBg,
    MailFrameBotLeftCorner,
	MailFrameBotRightCorner,
	MailFrameBottomBorder,
	MailFrameBtnCornerLeft,
	MailFrameBtnCornerRight,
	MailFrameButtonBottomBorder,
	MailFrameLeftBorder,
	MailFramePortraitFrame,
	MailFrameRightBorder,
	MailFrameTitleBg,
	MailFrameTopBorder,
	MailFrameTopLeftCorner,
	MailFrameTopRightCorner,
	MailFrameInsetInsetBottomBorder,
	MailFrameInsetInsetBotLeftCorner,
	MailFrameInsetInsetBotRightCorner,
	
}) do
   v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d, e, f, g, h = MailFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d, e, f, g, h = MailFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end
 --THINGS THAT SHOULD REMAIN THE REGULAR COLOR
for i,v in pairs({
	BankPortraitTexture,
	BankFrameTitleText,
	MerchantFramePortrait,
	WhoFrameTotals																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																													
}) do
   v:SetVertexColor(1, 1, 1)
end

for i,v in pairs({
	SlidingActionBarTexture0,
      	SlidingActionBarTexture1,
      	MainMenuBarTexture0,
      	MainMenuBarTexture1,
      	MainMenuBarTexture2,
      	MainMenuBarTexture3,
      	MainMenuMaxLevelBar0,
      	MainMenuMaxLevelBar1,
      	MainMenuMaxLevelBar2,
      	MainMenuMaxLevelBar3,
	MainMenuXPBarTexture0,
	MainMenuXPBarTexture1,
	MainMenuXPBarTexture2,
	MainMenuXPBarTexture3,
	MainMenuXPBarTexture4,
	ReputationWatchBar.StatusBar.WatchBarTexture0,
      	ReputationWatchBar.StatusBar.WatchBarTexture1,
      	ReputationWatchBar.StatusBar.WatchBarTexture2,
      	ReputationWatchBar.StatusBar.WatchBarTexture3,
	ReputationWatchBar.StatusBar.XPBarTexture0,
	ReputationWatchBar.StatusBar.XPBarTexture1,
	ReputationWatchBar.StatusBar.XPBarTexture2,
	ReputationWatchBar.StatusBar.XPBarTexture3,

	}) do

   v:SetVertexColor(.2, .2, .2)

end

	CompactRaidFrameManagerToggleButton:SetNormalTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\RaidPanel-Toggle")


	GameTooltip:SetBackdropBorderColor(.05, .05, .05)
	GameTooltip.SetBackdropBorderColor = function() end
	end


local a, b, c, d, e, f, g, h, i = QuestFrameDetailPanel:GetRegions()
	for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

QuestFrameDetailPanel.Material = QuestFrameDetailPanel:CreateTexture(nil, 'OVERLAY', nil, 7)
QuestFrameDetailPanel.Material:SetTexture[[Interface\AddOns\Lorti-UI-Classic\textures\quest\QuestBG.tga]]
QuestFrameDetailPanel.Material:SetWidth(514)
QuestFrameDetailPanel.Material:SetHeight(522)
QuestFrameDetailPanel.Material:SetPoint('TOPLEFT', QuestFrameDetailPanel, 22, -74)
QuestFrameDetailPanel.Material:SetVertexColor(0.7,0.7,0.7)

local a, b, c, d, e, f, g, h, i = QuestFrameProgressPanel:GetRegions()
	for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

QuestFrameProgressPanel.Material = QuestFrameProgressPanel:CreateTexture(nil, 'OVERLAY', nil, 7)
QuestFrameProgressPanel.Material:SetTexture[[Interface\AddOns\Lorti-UI-Classic\textures\quest\QuestBG.tga]]
QuestFrameProgressPanel.Material:SetWidth(514)
QuestFrameProgressPanel.Material:SetHeight(522)
QuestFrameProgressPanel.Material:SetPoint('TOPLEFT', QuestFrameProgressPanel, 22, -74)
QuestFrameProgressPanel.Material:SetVertexColor(0.7,0.7,0.7)

-- LFG/LFM Frame
if(LFGFrame ~= nil) then
LFGParentFrameBackground:SetVertexColor(0.35,0.35,0.35)

local a, b, c, d, e, f, g, h = LFGParentFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d, e, f, g, h = LFGParentFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end
end
-- Dropdown Lists

for i, v in pairs({
	DropDownList1MenuBackdrop.BottomEdge,
	DropDownList1MenuBackdrop.BottomLeftCorner,
	DropDownList1MenuBackdrop.BottomRightCorner,
	DropDownList1MenuBackdrop.LeftEdge,
	DropDownList1MenuBackdrop.RightEdge,
	DropDownList1MenuBackdrop.TopEdge,
	DropDownList1MenuBackdrop.TopLeftCorner,
	DropDownList1MenuBackdrop.TopRightCorner,
	DropDownList2MenuBackdrop.BottomEdge,
	DropDownList2MenuBackdrop.BottomLeftCorner,
	DropDownList2MenuBackdrop.BottomRightCorner,
	DropDownList2MenuBackdrop.LeftEdge,
	DropDownList2MenuBackdrop.RightEdge,
	DropDownList2MenuBackdrop.TopEdge,
	DropDownList2MenuBackdrop.TopLeftCorner,
	DropDownList2MenuBackdrop.TopRightCorner,
}) do
	v:SetVertexColor(0,0,0)
end

-- Color Picker Frame

for i, v in pairs({
	ColorPickerFrame.BottomEdge,
	ColorPickerFrame.BottomLeftCorner,
	ColorPickerFrame.BottomRightCorner,
	ColorPickerFrame.LeftEdge,
	ColorPickerFrame.RightEdge,
	ColorPickerFrame.TopEdge,
	ColorPickerFrame.TopLeftCorner,
	ColorPickerFrame.TopRightCorner,
	ColorPickerFrameHeader,
}) do
	v:SetVertexColor(0.35,0.35,0.35)
end

-- Keyring

local a, b, c, d = KeyRingButton:GetRegions()
	for _, v in pairs({b}) do
  		v:SetVertexColor(0.55,0.55,0.55)
end

-- Action Bar Arrows

local a, b, c, d = ActionBarUpButton:GetRegions()
	for _, v in pairs({a}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d = ActionBarDownButton:GetRegions()
	for _, v in pairs({a}) do
  		v:SetVertexColor(0.35,0.35,0.35)
end

MainMenuBarPageNumber:SetVertexColor(0.35,0.35,0.35)

-- Micro Buttons

local a, b, c, d = CharacterMicroButton:GetRegions()
	for _, v in pairs({b, c}) do
  		v:SetVertexColor(0.65,0.65,0.65)
end

local a, b, c, d = SpellbookMicroButton:GetRegions()
	for _, v in pairs({b}) do
  		v:SetVertexColor(0.65,0.65,0.65)
end

local a, b, c, d = TalentMicroButton:GetRegions()
	for _, v in pairs({b}) do
	  	v:SetVertexColor(0.65,0.65,0.65)
end

local a, b, c, d = QuestLogMicroButton:GetRegions()
	for _, v in pairs({b}) do
  		v:SetVertexColor(0.65,0.65,0.65)
end

local a, b, c, d = SocialsMicroButton:GetRegions()
	for _, v in pairs({b}) do
  		v:SetVertexColor(0.65,0.65,0.65)
end

local a, b, c, d = LFGMicroButton:GetRegions()
	for _, v in pairs({b}) do
  		v:SetVertexColor(0.65,0.65,0.65)
end

local a, b, c, d = MainMenuMicroButton:GetRegions()
	for _, v in pairs({c}) do
  		v:SetVertexColor(0.65,0.65,0.65)
end

local a, b, c, d = HelpMicroButton:GetRegions()
	for _, v in pairs({b}) do
  		v:SetVertexColor(0.65,0.65,0.65)
end

local a, b, c, d = MainMenuBarBackpackButton:GetRegions()
	for _, v in pairs({a, b, c, d}) do
  		v:SetVertexColor(0.65,0.65,0.65)
end

for i=0,3 do
	_G["CharacterBag"..i.."Slot"]:GetRegions()
	for _, v in pairs({a, b, c, d}) do
  		v:SetVertexColor(0.65,0.65,0.65)
end
end
-- local a, b, c, d = CharacterBag0Slot:GetRegions()
--	for _, v in pairs({a, b, c, d}) do
--  		v:SetVertexColor(0.65,0.65,0.65)
-- end
-- local a, b, c, d = CharacterBag1Slot:GetRegions()
--	for _, v in pairs({a, b, c, d}) do
--  		v:SetVertexColor(0.65,0.65,0.65)
-- end
-- local a, b, c, d = CharacterBag2Slot:GetRegions()
-- 	for _, v in pairs({a, b, c, d}) do
--  		v:SetVertexColor(0.65,0.65,0.65)
-- end
-- local a, b, c, d = CharacterBag3Slot:GetRegions()
-- 	for _, v in pairs({a, b, c, d}) do
--   		v:SetVertexColor(0.65,0.65,0.65)
-- end

local a, b, c, d = MiniMapWorldMapButton:GetRegions()
	for _, v in pairs({a, b, c, d}) do
  		v:SetVertexColor(0.65,0.65,0.65)
end

for i, v in pairs({
	PlayerTitleDropDownLeft,
	PlayerTitleDropDownMiddle,
	PlayerTitleDropDownRight,
	PlayerTitleDropDownButtonNormalTexture,
}) do
	v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d, e, f, g, h = BattlefieldFrame:GetRegions()
for _, v in pairs({b, c, d, e}) do
	v:SetVertexColor(0.35,0.35,0.35)
end

local a, b, c, d, e, f, g, h = ArenaFrame:GetRegions()
for _, v in pairs({b, c, d, e}) do
	v:SetVertexColor(0.35,0.35,0.35)
end

if(CraftFrame ~= nil) then
local a, b, c, d, e, f, g, h = CraftFrame:GetRegions()
for _, v in pairs({b, c, d, e}) do
	v:SetVertexColor(0.35,0.35,0.35)
end
end

if(TradeFrame ~= nil) then
local a, b, c, d, e, f, g, h = TradeFrame:GetRegions()
for _, v in pairs({b, c, d, e}) do
	v:SetVertexColor(0.35,0.35,0.35)
end
end

-- ItemSocketingFrame
if(ItemSocketingFrame ~= nil) then
	local a, b, c, d, e, f, g, h = ItemSocketingFrame:GetRegions()
	for _, v in pairs({a, b, d, e}) do
	v:SetVertexColor(0.35,0.35,0.35)
	end
end
	if addon == "Blizzard_TimeManager" then
		for _, v in pairs({StopwatchFrame:GetRegions()})do
			v:SetVertexColor(.35, .35, .35)
		end
		
		local a, b, c = StopwatchTabFrame:GetRegions()
		for _, v in pairs({a, b, c})do
			v:SetVertexColor(.35, .35, .35)
		end
		
		local a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r =  TimeManagerFrame:GetRegions()
		for _, v in pairs({a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r})do
			v:SetVertexColor(.35, .35, .35)
		end
		
		for _, v in pairs({TimeManagerFrameInset:GetRegions()})do
			v:SetVertexColor(.65, .65, .65)
		end
		
        TimeManagerClockButton:GetRegions():SetVertexColor(.05, .05, .05)	
	end
	
	--RECOLOR TALENTS
	
	if addon == "Blizzard_TalentUI" then
		local _, a, b, c, d, _, _, _, _, _, e, f, g = PlayerTalentFrame:GetRegions()
		
		for _, v in pairs({a, b, c, d, e, f, g})do
			v:SetVertexColor(.35, .35, .35)
		end
	end
	
	--RECOLOR TRADESKILL
	
	if addon == "Blizzard_TradeSkillUI" then
		local _, a, b, c, d, _, e, f, g, h = TradeSkillFrame:GetRegions()
		
		for _, v in pairs({ a, b, c, d, e, f, g, h})do
			v:SetVertexColor(.35, .35, .35)
		end
	end
	
	-- ClassTrainerFrame
	if addon == "Blizzard_TrainerUI" then
	local _, a, b, c, d, _, e, f, g, h = ClassTrainerFrame:GetRegions()
		
		for _, v in pairs({ a, b, c, d, e, f, g, h})do
			v:SetVertexColor(.35, .35, .35)
		end
	end
	
	-- MacroFrame
	if(MacroFrame ~= nil) then
	local a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r = MacroFrame:GetRegions()
		
		for _, v in pairs({a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r})do
			v:SetVertexColor(.35, .35, .35)
		end
	end
	-- InspectFrame/InspectTalentFrame/InspectPVPFrame
	if addon == "Blizzard_InspectUI" then
		local _, a, b, c, d, _, _, _, _, _, e, f, g = InspectTalentFrame:GetRegions()
		
		for _, v in pairs({a, b, c, d, e, f, g})do
			v:SetVertexColor(.35, .35, .35)
		end
	
		local a, b, c, d, _, e = InspectPaperDollFrame:GetRegions()
		for _, v in pairs({a, b, c, d, e})do
			v:SetVertexColor(.35, .35, .35)
		end
		
		local a, b, c, d, e = InspectPVPFrame:GetRegions()
		for _, v in pairs({a, b, c, d, e }) do
			v:SetVertexColor(.35, .35, .35)
		end
	end
	
	--UNREGISTER WHEN DONE 
											
	if (IsAddOnLoaded("Blizzard_TalentUI") and IsAddOnLoaded("Blizzard_InspectUI") and IsAddOnLoaded("Blizzard_TimeManager") and IsAddOnLoaded("Blizzard_TradeSkillUI") and IsAddOnLoaded("Lorti-UI-Classic")) then
	self:UnregisterEvent("ADDON_LOADED")
	Framecolor:SetScript("OnEvent", nil)
	end
end
end)

--Health and Mana Text Shadows

PlayerFrameHealthBar.TextString:SetShadowOffset(1,-1)
PlayerFrameHealthBar.TextString:SetShadowColor(0,0,0)
PlayerFrameHealthBar.LeftText:SetShadowOffset(1,-1)
PlayerFrameHealthBar.LeftText:SetShadowColor(0,0,0)
PlayerFrameHealthBar.RightText:SetShadowOffset(1,-1)
PlayerFrameHealthBar.RightText:SetShadowColor(0,0,0)

PlayerFrameManaBar.TextString:SetShadowOffset(1,-1)
PlayerFrameManaBar.TextString:SetShadowColor(0,0,0)
PlayerFrameManaBar.LeftText:SetShadowOffset(1,-1)
PlayerFrameManaBar.LeftText:SetShadowColor(0,0,0)
PlayerFrameManaBar.RightText:SetShadowOffset(1,-1)
PlayerFrameManaBar.RightText:SetShadowColor(0,0,0)

PetFrameHealthBar.TextString:SetShadowOffset(1,-1)
PetFrameHealthBar.TextString:SetShadowColor(0,0,0)
PetFrameHealthBar.LeftText:SetShadowOffset(1,-1)
PetFrameHealthBar.LeftText:SetShadowColor(0,0,0)
PetFrameHealthBar.RightText:SetShadowOffset(1,-1)
PetFrameHealthBar.RightText:SetShadowColor(0,0,0)

PetFrameManaBar.TextString:SetShadowOffset(1,-1)
PetFrameManaBar.TextString:SetShadowColor(0,0,0)
PetFrameManaBar.LeftText:SetShadowOffset(1,-1)
PetFrameManaBar.LeftText:SetShadowColor(0,0,0)
PetFrameManaBar.RightText:SetShadowOffset(1,-1)
PetFrameManaBar.RightText:SetShadowColor(0,0,0)

TargetFrameHealthBar.TextString:SetShadowOffset(1,-1)
TargetFrameHealthBar.TextString:SetShadowColor(0,0,0)
TargetFrameHealthBar.LeftText:SetShadowOffset(1,-1)
TargetFrameHealthBar.LeftText:SetShadowColor(0,0,0)
TargetFrameHealthBar.RightText:SetShadowOffset(1,-1)
TargetFrameHealthBar.RightText:SetShadowColor(0,0,0)

TargetFrameManaBar.TextString:SetShadowOffset(1,-1)
TargetFrameManaBar.TextString:SetShadowColor(0,0,0)
TargetFrameManaBar.LeftText:SetShadowOffset(1,-1)
TargetFrameManaBar.LeftText:SetShadowColor(0,0,0)
TargetFrameManaBar.RightText:SetShadowOffset(1,-1)
TargetFrameManaBar.RightText:SetShadowColor(0,0,0)

FocusFrameHealthBar.TextString:SetShadowOffset(1,-1)
FocusFrameHealthBar.TextString:SetShadowColor(0,0,0)
FocusFrameHealthBar.LeftText:SetShadowOffset(1,-1)
FocusFrameHealthBar.LeftText:SetShadowColor(0,0,0)
FocusFrameHealthBar.RightText:SetShadowOffset(1,-1)
FocusFrameHealthBar.RightText:SetShadowColor(0,0,0)

FocusFrameManaBar.TextString:SetShadowOffset(1,-1)
FocusFrameManaBar.TextString:SetShadowColor(0,0,0)
FocusFrameManaBar.LeftText:SetShadowOffset(1,-1)
FocusFrameManaBar.LeftText:SetShadowColor(0,0,0)
FocusFrameManaBar.RightText:SetShadowOffset(1,-1)
FocusFrameManaBar.RightText:SetShadowColor(0,0,0)

PetFrameManaBar.TextString:AdjustPointsOffset(0,4)
PetFrameManaBar.LeftText:AdjustPointsOffset(0,4)
PetFrameManaBar.RightText:AdjustPointsOffset(0,4)


	
--Target of Target And Pet Frame Alignments

TargetFrameToTBackground:AdjustPointsOffset(2,2)
TargetFrameToTPortrait:SetScale(1.1)
TargetFrameToTPortrait:AdjustPointsOffset(-3,3)
FocusFrameToTBackground:AdjustPointsOffset(2,2)
FocusFrameToTPortrait:SetScale(1.1)
FocusFrameToTPortrait:AdjustPointsOffset(-3,3)
PetFrameHealthBar:AdjustPointsOffset(-1,-1)
PetFrameManaBar:AdjustPointsOffset(-1,-1)

if ArenaEnemyFrame1 then
ArenaEnemyFrame1HealthBarText:SetShadowOffset(1,-1)
ArenaEnemyFrame1HealthBarText:SetShadowColor(0,0,0)
end
	
--Minimap Alignment & Hiding World Map Button and Top Border

MiniMapWorldMapButton:SetAlpha(0)
MinimapBorderTop:SetAlpha(0)
MinimapZoneText:SetPoint('CENTER', Minimap, 'TOP', 0, 10)
MinimapZoneText:SetShadowOffset(2,-2)
MinimapZoneText:SetShadowColor(0,0,0)

--Tooptip HP Bar Alignment

GameTooltipStatusBar:AdjustPointsOffset(0,8)
GameTooltipStatusBar:SetSize(1,2)

-- Reputation and XP bar hack to make it always shown

SetCVar("xpBarText", 1)

-- Show party pet
SetCVar("showPartyPets", 1)

-- Personal CVar
SetCVar("namenameplateSelectedScale", 1.15)
SetCVar("namenameplateGlobalScale", 1.1)



-- Helper function to create a font string
local function CreateText(name, parentName, parent, point, x, y)
    local fontString = parent:CreateFontString(parentName .. name, nil, "GameFontNormalSmall")
    fontString:SetPoint(point, parent, point, x, y)
    return fontString
end

-- Create dead/ghost/offline text frames on unit frames.
function ns.createDeadTextFrames()
	local L = {}
	local locale = GetLocale()

	if locale == "frFR" then
		L.GHOST   = "Fantôme"
	elseif locale == "deDE" then
		L.GHOST   = "Geist"
	elseif locale == "esES" or locale == "esMX" or locale == "itIT" or locale == "ptBR" then
		L.GHOST   = "Fantasma"
	elseif locale == "ruRU" then
		L.GHOST   = "Призрак"
	elseif locale == "zhCN" then
		L.GHOST   = "幽灵"
	elseif locale == "zhTW" then
		L.GHOST   = "幽靈"
	elseif locale == "koKR" then
		L.GHOST   = "유령"
	else
		L.GHOST   = "GHOST"
	end

	ns.LGhost = L.GHOST
    -- For the player frame:
    local deadText = CreateText("DeadText", "PlayerFrame", PlayerFrameHealthBar, "CENTER", 0, 0)
	deadText:SetFont(Lorti.fontFamily, Lorti.StringSize-2, "OUTLINE")
    deadText:SetText(DEAD)  -- using Blizzard's global constant for "Dead"
    local ghostText = CreateText("GhostText", "PlayerFrame", PlayerFrameHealthBar, "CENTER", 0, 0)
	ghostText:SetFont(Lorti.fontFamily, Lorti.StringSize-2, "OUTLINE")
    ghostText:SetText(L.GHOST)
    -- For the target frame:
    ghostText = CreateText("GhostText", "TargetFrame", TargetFrameHealthBar, "CENTER", 0, 0)
	ghostText:SetFont(Lorti.fontFamily, Lorti.StringSize-2, "OUTLINE")
    ghostText:SetText(L.GHOST)
    local offlineText = CreateText("OfflineText", "TargetFrame", TargetFrameHealthBar, "CENTER", 0, 0)
	offlineText:SetFont(Lorti.fontFamily, Lorti.StringSize-2, "OUTLINE")
    offlineText:SetText(PLAYER_OFFLINE)
    -- For the focus frame:
    ghostText = CreateText("GhostText", "FocusFrame", FocusFrameHealthBar, "CENTER", 0, 0)
	ghostText:SetFont(Lorti.fontFamily, Lorti.StringSize-2, "OUTLINE")
    ghostText:SetText(L.GHOST)
    offlineText = CreateText("OfflineText", "FocusFrame", FocusFrameHealthBar, "CENTER", 0, 0)
	offlineText:SetFont(Lorti.fontFamily, Lorti.StringSize-2, "OUTLINE")
    offlineText:SetText(PLAYER_OFFLINE)
	
	
	-- Create a font string on each PartyMemberFrame for status text if it doesn’t already exist.
local function CreatePartyDeadTexts()
    for i = 1, 4 do
        local frame = _G["PartyMemberFrame" .. i]
        if frame and not frame.DeadText then
            local deadText = frame:CreateFontString(frame:GetName().."DeadText", "OVERLAY", "GameFontNormalSmall")
            

            
            deadText:SetParent(UIParent)
			local scale = Lorti.partyFrameScale or 1.0

            -- Determine the position and font size based on the scale.
			if scale >= 2.0 then
                -- Very large scale (>= 2.0)
                deadText:SetPoint("CENTER", frame, "CENTER", 35, 16)
                deadText:SetFont(Lorti.fontFamily, Lorti.StringSize + 3, "OUTLINE")
			 elseif scale >= 1.8 then
                -- Large scale (1.8 to 1.99)
                deadText:SetPoint("CENTER", frame, "CENTER", 33, 16)
                deadText:SetFont(Lorti.fontFamily, Lorti.StringSize + 2, "OUTLINE")
            elseif scale >= 1.6 then
                -- Large scale (1.6 to 1.79)
                deadText:SetPoint("CENTER", frame, "CENTER", 30, 13)
                deadText:SetFont(Lorti.fontFamily, Lorti.StringSize + 1, "OUTLINE")
            elseif scale >= 1.4 then
                -- Large scale (>= 1.4 to 1.59)
                deadText:SetPoint("CENTER", frame, "CENTER", 27, 12)
                deadText:SetFont(Lorti.fontFamily, Lorti.StringSize, "OUTLINE")
            elseif scale >= 1.2 then
                -- Medium-large scale (1.2 to 1.39)
                deadText:SetPoint("CENTER", frame, "CENTER", 25, 10)
                deadText:SetFont(Lorti.fontFamily, Lorti.StringSize - 1, "OUTLINE")
            elseif scale >= 1.0 then
                -- Medium scale (1.0 to 1.19)
                deadText:SetPoint("CENTER", frame, "CENTER", 20, 8)
                deadText:SetFont(Lorti.fontFamily, Lorti.StringSize - 2, "OUTLINE")
            elseif scale >= 0.8 then
                -- Small-medium scale (0.8 to 0.99)
                deadText:SetPoint("CENTER", frame, "CENTER", 18, 7)
                deadText:SetFont(Lorti.fontFamily, Lorti.StringSize - 3, "OUTLINE")
            elseif scale >= 0.6 then
                -- Small scale (0.6 to 0.79)
                deadText:SetPoint("CENTER", frame, "CENTER", 13, 6)
                deadText:SetFont(Lorti.fontFamily, Lorti.StringSize - 6, "OUTLINE")
            else
                -- Very small scale (< 0.6)
                deadText:SetPoint("CENTER", frame, "CENTER", 10, 5)
                deadText:SetFont(Lorti.fontFamily, Lorti.StringSize - 8, "OUTLINE")
            end

            deadText:Hide()
            frame.DeadText = deadText
        end
    end
end


-- Update each party frame’s dead/ghost/offline text.
local function UpdatePartyDeadTexts()
    -- If the CompactPartyFrame exists, we assume that the standard PartyMemberFrame texts should be hidden.
    if not PartyMemberFrame1 or not PartyMemberFrame1:IsShown() then
        for i = 1, 4 do
            local frame = _G["PartyMemberFrame" .. i]
            if frame and frame.DeadText then
                frame.DeadText:Hide()
            end
        end
        return  -- exit since we don’t need to update the text for standard party frames
    end
	if IsInRaid() then
        for i = 1, 4 do
            local frame = _G["PartyMemberFrame" .. i]
            if frame and frame.DeadText then
                frame.DeadText:Hide()
            end
        end
        return
    end
    -- Otherwise, update the text on standard PartyMemberFrames.
    for i = 1, 4 do
        local frame = _G["PartyMemberFrame" .. i]
        if frame and frame.DeadText then
            if (not frame.unit) or (not UnitExists(frame.unit)) then
                frame.DeadText:Hide()
            else
                if not UnitIsConnected(frame.unit) then
                    frame.DeadText:SetText(PLAYER_OFFLINE)  -- Blizzard’s localized offline text.
                    frame.DeadText:Show()
                elseif UnitIsDead(frame.unit) then
                    frame.DeadText:SetText(DEAD)  -- Blizzard’s localized dead text.
                    frame.DeadText:Show()
                else
                    frame.DeadText:Hide()
                end
            end
        end
    end
end



-- Create and update party dead texts on login/entering world
local partyStatusFrame = CreateFrame("Frame")
partyStatusFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
partyStatusFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
partyStatusFrame:RegisterEvent("UNIT_HEALTH")
partyStatusFrame:RegisterEvent("UNIT_CONNECTION")
partyStatusFrame:SetScript("OnEvent", function(self, event, arg1)
    -- If the event is unit-specific, check that it applies to a party unit
    if (event == "UNIT_HEALTH" or event == "UNIT_CONNECTION") then
        if arg1 and string.find(arg1, "party") then
            UpdatePartyDeadTexts()
        end
    else
        UpdatePartyDeadTexts()
    end
end)

-- Call the creation function once on login
CreatePartyDeadTexts()

local function CheckPartyLayout()
    -- If PartyMemberFrame1 is not shown (or doesn’t exist),
    -- then hide the dead/ghost/offline texts on the party frames.
    if not (PartyMemberFrame1 and PartyMemberFrame1:IsShown()) then
        for i = 1, 4 do
            local frame = _G["PartyMemberFrame" .. i]
            if frame and frame.DeadText then
                frame.DeadText:Hide()
            end
        end
    end
    -- Schedule the next check after 1 second.
    C_Timer.After(1, CheckPartyLayout)
end

-- Start the repeating check.
CheckPartyLayout()
end

-- Player dead/ghost check: shows or hides the custom texts on the player frame.
function ns.playerDeadCheck()
    if UnitIsDead("player") then
        PlayerFrameDeadText:Show()
        PlayerFrameGhostText:Hide()
    elseif UnitIsGhost("player") then
        PlayerFrameDeadText:Hide()
        PlayerFrameGhostText:Show()
    else
        PlayerFrameDeadText:Hide()
        PlayerFrameGhostText:Hide()
    end

    if UnitExists("player") and (UnitIsDead("player") or UnitIsGhost("player")) then
		if PlayerFrame.healthbar then
            PlayerFrame.healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
        end
        for _, frame in ipairs({
            PlayerFrameHealthBarText, PlayerFrameHealthBar.LeftText, PlayerFrameHealthBar.RightText,
            PlayerFrameManaBar.LeftText, PlayerFrameManaBar.RightText, PlayerFrameTextureFrameManaBarText,
            PlayerFrameManaBar
        }) do
            if frame then frame:SetAlpha(0) end
        end
    else
        for _, frame in ipairs({
            PlayerFrameHealthBarText, PlayerFrameHealthBar.LeftText, PlayerFrameHealthBar.RightText,
            PlayerFrameManaBar.LeftText, PlayerFrameManaBar.RightText, PlayerFrameTextureFrameManaBarText,
            PlayerFrameManaBar
        }) do
            if frame then frame:SetAlpha(1) end
        end
    end
end

-- Target dead/ghost check: updates target frame text visibility.
function ns.targetDeadCheck()
    if UnitIsDead("target") then
		TargetFrameTextureFrameDeadText:SetPoint("CENTER", TargetFrameHealthBar, "CENTER", 0, 0)
		TargetFrameTextureFrameDeadText:SetFont(Lorti.fontFamily, Lorti.StringSize-2, "OUTLINE")
        TargetFrameGhostText:Hide()
        TargetFrameOfflineText:Hide()
    elseif UnitIsGhost("target") then
        TargetFrameGhostText:Show()
        TargetFrameOfflineText:Hide()
    elseif UnitIsPlayer("target") and not UnitIsConnected("target") then
        TargetFrameGhostText:Hide()
        TargetFrameOfflineText:Show()
    else
        TargetFrameGhostText:Hide()
        TargetFrameOfflineText:Hide()
    end
	
    if UnitExists("target") and (UnitIsDead("target") or UnitIsGhost("target") or not UnitIsConnected("target")) then
		if TargetFrame.healthbar then
            TargetFrame.healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
        end
        for _, frame in ipairs({
            TargetFrameTextureFrame.HealthBarText, TargetFrameHealthBar.LeftText, TargetFrameHealthBar.RightText,
            TargetFrameTextureFrame.ManaBarText, TargetFrameManaBar.LeftText, TargetFrameManaBar.RightText,
            TargetFrameManaBar
        }) do
            if frame then frame:SetAlpha(0) end
        end
    else
        for _, frame in ipairs({
            TargetFrameTextureFrame.HealthBarText, TargetFrameHealthBar.LeftText, TargetFrameHealthBar.RightText,
            TargetFrameTextureFrame.ManaBarText, TargetFrameManaBar.LeftText, TargetFrameManaBar.RightText,
            TargetFrameManaBar
        }) do
            if frame then frame:SetAlpha(1) end
        end
    end
end

-- Focus dead/ghost check: updates focus frame text visibility.
function ns.focusDeadCheck()
    if UnitIsDead("focus") then
		FocusFrameTextureFrameDeadText:SetPoint("CENTER", FocusFrameHealthBar, "CENTER", 0, 0)
		FocusFrameTextureFrameDeadText:SetFont(Lorti.fontFamily, Lorti.StringSize-2, "OUTLINE")
        FocusFrameGhostText:Hide()
        FocusFrameOfflineText:Hide()
    elseif UnitIsGhost("focus") then
        FocusFrameGhostText:Show()
        FocusFrameOfflineText:Hide()
    elseif UnitIsPlayer("focus") and not UnitIsConnected("focus") then
        FocusFrameGhostText:Hide()
        FocusFrameOfflineText:Show()
    else
        FocusFrameGhostText:Hide()
        FocusFrameOfflineText:Hide()
    end
	
    if UnitExists("focus") and (UnitIsDead("focus") or UnitIsGhost("focus") or not UnitIsConnected("focus")) then
		if FocusFrame.healthbar then
            FocusFrame.healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
        end
        for _, frame in ipairs({
            FocusFrameTextureFrame.HealthBarText, FocusFrameHealthBar.LeftText, FocusFrameHealthBar.RightText,
            FocusFrameManaBar.LeftText, FocusFrameManaBar.RightText, FocusFrameTextureFrameManaBarText,
            FocusFrameManaBar
        }) do
            if frame then frame:SetAlpha(0) end
        end
    else
        for _, frame in ipairs({
            FocusFrameTextureFrame.HealthBarText, FocusFrameHealthBar.LeftText, FocusFrameHealthBar.RightText,
            FocusFrameManaBar.LeftText, FocusFrameManaBar.RightText, FocusFrameTextureFrameManaBarText,
            FocusFrameManaBar
        }) do
            if frame then frame:SetAlpha(1) end
        end
    end
end

-- party font (credit Xyz)
-- Function to update (or remove) party health/mana texts based on unit status.
local function PartyStatusBarText()
    for i = 1, 4 do
        local partyFrame = _G["PartyMemberFrame" .. i]
        if partyFrame then
            -- Determine the unit for this party frame (use partyFrame.unit if set, or default to "partyX")
            local unit = partyFrame.unit or ("party" .. i)
            local name = _G["PartyMemberFrame" .. i .. "Name"]
            local parentFrame = name:GetParent()
            local healthBar = _G["PartyMemberFrame" .. i .. "HealthBar"]
            local manaBar = _G["PartyMemberFrame" .. i .. "ManaBar"]
            
            -- Try to retrieve already created font strings.
            local healthText = _G["PartyMemberFrame" .. i .. "HealthBarText"]
            local manaText = _G["PartyMemberFrame" .. i .. "ManaBarText"]
			local numSize = Lorti.NumSize or 12
			local font = Lorti.fontFamily or "Fonts\\FRIZQT__.TTF"
            -- If the unit exists, is connected, and is not dead or a ghost…
            if UnitExists(unit) and UnitIsConnected(unit) and not UnitIsDeadOrGhost(unit) then
                -- Create (or show) the health text.
                if not healthText then
                    healthText = parentFrame:CreateFontString("PartyMemberFrame" .. i .. "HealthBarText", "OVERLAY", "TextStatusBarText")
					healthText:SetPoint("CENTER", 18, 8.5)
                    SetTextStatusBarText(healthBar, healthText)
                    healthBar.TextString:SetFont(font, numSize - 4, "OUTLINE")
                    healthBar.TextString:SetShadowOffset(1, -1)
                    healthBar.TextString:SetShadowColor(0, 0, 0)
                else
                    healthText:Show()
                end

                -- Create (or show) the mana text.
                if not manaText then
                    manaText = parentFrame:CreateFontString("PartyMemberFrame" .. i .. "ManaBarText", "OVERLAY", "TextStatusBarText")
                    manaText:SetPoint("CENTER", 18, -2)
                    SetTextStatusBarText(manaBar, manaText)
                    manaBar.TextString:SetFont(font, numSize - 5, "OUTLINE")
                    manaBar.TextString:SetShadowOffset(1, -1)
                    manaBar.TextString:SetShadowColor(0, 0, 0)
                else
                    manaText:Show()
                end
            else
                -- If the unit is offline, dead, or a ghost, hide the texts.
                if healthText then
                    healthText:Hide()
                end
                if manaText then
                    manaText:Hide()
                end
            end
        end
    end
end

hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", function(statusFrame, textString, value, valueMin, valueMax)
    local unit = statusFrame.unit

	if unit and unit:match("^party%d+$") and UnitExists(unit) and UnitIsConnected(unit) and not UnitIsDeadOrGhost(unit) then
        local name = statusFrame:GetName() or ""
        if name:find("HealthBar") then
            textString:SetFont(Lorti.fontFamily, Lorti.NumSize - 4, "OUTLINE")
        elseif name:find("ManaBar") then
            textString:SetFont(Lorti.fontFamily, Lorti.NumSize - 5, "OUTLINE")
        else
            ApplyFonts()
        end

	end
    if unit and not UnitIsConnected(unit) then
        if statusFrame:GetName() and string.find(statusFrame:GetName(), "HealthBar") then
            -- textString:SetText(PLAYER_OFFLINE)
			textString:SetText("")
        else
            textString:SetText("")
        end
    elseif unit and UnitIsDeadOrGhost(unit) then
        if statusFrame:GetName() and string.find(statusFrame:GetName(), "HealthBar") then
            -- textString:SetText(DEAD)
			textString:SetText("")
        else
            textString:SetText("")
        end
    end
end)

-- Create a frame to listen for party-related events.
local updatePartyStatusFrame = CreateFrame("Frame")
updatePartyStatusFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
updatePartyStatusFrame:RegisterEvent("UNIT_CONNECTION")
updatePartyStatusFrame:RegisterEvent("UNIT_HEALTH")
updatePartyStatusFrame:SetScript("OnEvent", function(self, event, arg1)
    -- For events that are unit-specific (like UNIT_HEALTH or UNIT_CONNECTION), only update if the unit is a party member.
    if (event == "UNIT_HEALTH" or event == "UNIT_CONNECTION") then
        if arg1 and string.find(arg1, "party") then
            PartyStatusBarText()
        end
    else
        -- For group roster changes, update all party frames.
        PartyStatusBarText()
    end
end)

-- Optionally, call the update function on login/initialization:
PartyStatusBarText()



-- Create a frame to listen to unit events.
local deadCheckFrame = CreateFrame("Frame")
deadCheckFrame:RegisterEvent("PLAYER_LOGIN")
deadCheckFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
deadCheckFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
deadCheckFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
deadCheckFrame:RegisterEvent("PLAYER_DEAD")
deadCheckFrame:RegisterEvent("PLAYER_UNGHOST")
deadCheckFrame:RegisterEvent("PLAYER_ALIVE")
deadCheckFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
deadCheckFrame:RegisterEvent("UNIT_HEALTH")
deadCheckFrame:RegisterEvent("UNIT_CONNECTION")
deadCheckFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- Create the dead/ghost/offline texts when the addon loads
        ns.createDeadTextFrames()
		
    elseif event == "PLAYER_ENTERING_WORLD" then
        ns.playerDeadCheck()
	
    elseif event == "PLAYER_TARGET_CHANGED" then
        ns.targetDeadCheck()

    elseif event == "PLAYER_FOCUS_CHANGED" then
        ns.focusDeadCheck()

    elseif event == "PLAYER_DEAD" then
        ns.playerDeadCheck()
        ns.focusDeadCheck()

    elseif event == "PLAYER_UNGHOST" then
        ns.playerDeadCheck()
        ns.targetDeadCheck()
        ns.focusDeadCheck()

    elseif event == "PLAYER_ALIVE" then
        ns.playerDeadCheck()
        ns.targetDeadCheck()
        ns.focusDeadCheck()

    end
end)

function ApplyFonts()
	local StringType = "OUTLINE"
	
	MinimapZoneText:SetFont(Lorti.fontFamily, Lorti.StringSize+2, StringType)

	TargetFrameTextureFrameName:SetFont(Lorti.fontFamily, Lorti.StringSize, StringType)
	PetName:SetFont(Lorti.fontFamily, Lorti.StringSize, StringType)
	PlayerName:SetFont(Lorti.fontFamily, Lorti.StringSize, StringType)
	FocusFrameTextureFrameName:SetFont(Lorti.fontFamily, Lorti.StringSize, StringType)
	TargetFrameToTTextureFrameName:SetFont(Lorti.fontFamily, Lorti.StringSize-2, StringType)
	FocusFrameToTTextureFrameName:SetFont(Lorti.fontFamily, Lorti.StringSize-2, StringType)

	CastingBarFrame.Text:SetFont(Lorti.fontFamily, Lorti.StringSize, StringType)

	PlayerFrameHealthBar.TextString:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	PlayerFrameHealthBar.LeftText:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	PlayerFrameHealthBar.RightText:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	
	PlayerFrameManaBar.TextString:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	PlayerFrameManaBar.LeftText:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	PlayerFrameManaBar.RightText:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	
	PetFrameHealthBar.TextString:SetFont(Lorti.fontFamily, Lorti.NumSize-2, StringType)
	PetFrameHealthBar.LeftText:SetFont(Lorti.fontFamily, Lorti.NumSize-2, StringType)
	PetFrameHealthBar.RightText:SetFont(Lorti.fontFamily, Lorti.NumSize-2, StringType)
	
	PetFrameManaBar.TextString:SetFont(Lorti.fontFamily, Lorti.NumSize-2, StringType)
	PetFrameManaBar.LeftText:SetFont(Lorti.fontFamily, Lorti.NumSize-2, StringType)
	PetFrameManaBar.RightText:SetFont(Lorti.fontFamily, Lorti.NumSize-2, StringType)
		
	TargetFrameHealthBar.TextString:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	TargetFrameHealthBar.LeftText:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	TargetFrameHealthBar.RightText:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	
	TargetFrameManaBar.TextString:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	TargetFrameManaBar.LeftText:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	TargetFrameManaBar.RightText:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)

	FocusFrameHealthBar.TextString:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	FocusFrameHealthBar.LeftText:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	FocusFrameHealthBar.RightText:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	
	FocusFrameManaBar.TextString:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	FocusFrameManaBar.LeftText:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	FocusFrameManaBar.RightText:SetFont(Lorti.fontFamily, Lorti.NumSize, StringType)
	
	
	local function ApplyFontsAndMoveFrames()
    -- Ensure the Blizzard_ArenaUI addon is loaded
    if not IsAddOnLoaded("Blizzard_ArenaUI") then
        LoadAddOn("Blizzard_ArenaUI")
    end
	
	if not Lorti.arenaframe then
		-- Iterate through each arena enemy frame (1 to 5)
		for i = 1, 5 do
			local arenaFrame = _G["ArenaEnemyFrame"..i]
			-- Get the frame by name
			if arenaFrame then
		
				local arenaFramename = _G["ArenaEnemyFrame"..i .. "Name"]
				local arenaFramehealth = _G["ArenaEnemyFrame"..i .. "HealthBar"]
				local arenaFramemana = _G["ArenaEnemyFrame"..i .. "ManaBar"]
				local arenaFramehealthtext = _G["ArenaEnemyFrame"..i .. "HealthBarText"]
				local arenaFramemanatext = _G["ArenaEnemyFrame"..i .. "ManaBarText"]
				local arenaFramecastbar = _G["ArenaEnemyFrame"..i .. "CastingBar"]
				
				arenaFrame:SetScale(2);
				-- Reposition the arena frame
				arenaFrame:ClearAllPoints() -- Clear any existing points
				arenaFrame:SetPoint("TOPLEFT", UIParent, "CENTER", 250 + (i * 100), 100) 
				arenaFramecastbar:SetScale(0.8);
				arenaFramename:SetFont(Lorti.fontFamily, Lorti.NumSize-3, StringType)
				arenaFramehealthtext:SetPoint("CENTER", arenaFramehealth, "CENTER", 2, 2)			
				arenaFramehealthtext:SetFont(Lorti.fontFamily, Lorti.NumSize-4, StringType)
				arenaFramemanatext:SetPoint("CENTER", arenaFramemana, "CENTER", 2, 1)
				arenaFramemanatext:SetFont(Lorti.fontFamily, Lorti.NumSize-4, StringType)
				
				arenaFramename:SetShadowOffset(1,-1)
				arenaFramename:SetShadowColor(0,0,0)
				arenaFramehealthtext:SetShadowOffset(1,-1)
				arenaFramehealthtext:SetShadowColor(0,0,0)
				arenaFramemanatext:SetShadowOffset(1,-1)
				arenaFramemanatext:SetShadowColor(0,0,0)
			end
		end
	else
		ArenaEnemyFrames:Hide()
	end
end

-- Event handler to detect when the player enters an arena
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "Blizzard_ArenaUI" then
            -- Blizzard_ArenaUI has been loaded, apply changes
            ApplyFontsAndMoveFrames()
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Check if we are in an arena
        local _, instanceType = IsInInstance()
        if instanceType == "arena" then
            ApplyFontsAndMoveFrames()
        end
    end
end)
end


local function colour(statusbar, unit)
    if not statusbar then
        return
    end
    if unit then
        if UnitIsConnected(unit) and unit == statusbar.unit then
            if Lorti.ColoredHP and UnitIsEnemy("player", unit) then
                -- Set red health bar for enemy units
                statusbar:SetStatusBarColor(1, 0, 0)
            else
                if UnitIsPlayer(unit) and UnitClass(unit) then
                    if (Lorti.classbars == true and UnitExists(unit) and not UnitIsDead(unit) and not UnitIsDeadOrGhost(unit) and not UnitIsGhost(unit) and UnitIsConnected(unit)) then
                        local _, class = UnitClass(unit)
                        local c = RAID_CLASS_COLORS[class]
                        if c then
                            statusbar:SetStatusBarColor(c.r, c.g, c.b)
                        end
                    else
                        if (UnitIsFriend("player", unit) or UnitIsFriend("pet", unit)) then
                            statusbar:SetStatusBarColor(0, 1, 0)
                        else
                            statusbar:SetStatusBarColor(1, 0, 0)
                        end
                    end
                elseif (not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)) or (UnitIsPlayer(unit) and not UnitIsConnected(unit)) or (UnitIsDeadOrGhost(unit)) then
                    statusbar:SetStatusBarColor(.5, .5, .5)
                else
                    local red, green = UnitSelectionColor(unit)
                    if red == 0 then
                        statusbar:SetStatusBarColor(0, 1, 0)
                    elseif green == 0 then
                        statusbar:SetStatusBarColor(1, 0, 0)
                    else
                        statusbar:SetStatusBarColor(1, 1, 0)
                    end
                end
            end
        end
    end
end

hooksecurefunc("UnitFrameHealthBar_Update", colour)
hooksecurefunc("HealthBar_OnValueChanged", function(self)
    if not self:IsForbidden() then
        colour(self, self.unit)
    end
end)

-- Class portrait frames
local lastTargetToTGuid = nil
local lastFocusToTGuid = nil
local CP = {}

local function OnLoad()
    -- Initialize the class portraits
    if not Lorti.ClassPortraits then return end
	CP:CreateToTPortraits()

    -- Reposition the target-target and focus-target portraits
    if CP.TargetToTPortrait then
        CP.TargetToTPortrait:ClearAllPoints()
        CP.TargetToTPortrait:SetPoint("CENTER", TargetFrameToTPortrait, "CENTER")
    end

    if CP.FocusToTPortrait then
        CP.FocusToTPortrait:ClearAllPoints()
        CP.FocusToTPortrait:SetPoint("CENTER", FocusFrameToTPortrait, "CENTER")
    end
	
	-- Hide the default targettarget portrait
    if TargetFrameToT.portrait then
        TargetFrameToT.portrait:Hide()
    end

    -- Hide the default focustarget portrait
    if FocusFrameToT.portrait then
		FocusFrameToT.portrait:Hide()
	end
end



function CP:CreateToTPortraits()
    if not self.TargetToTPortrait then
        self.TargetToTPortrait = TargetFrameToT:CreateTexture(nil, "ARTWORK")
		local width, height = TargetFrameToT.portrait:GetSize() -- Get the current size
        width = width + 5
        height = height + 5
		
        self.TargetToTPortrait:SetSize(width, height)
        for i = 1, TargetFrameToT.portrait:GetNumPoints() do
            local point, relativeTo, relativePoint, x, y = TargetFrameToT.portrait:GetPoint(i)
            self.TargetToTPortrait:SetPoint(point, relativeTo, relativePoint, x, y)
        end
    end

    if not self.FocusToTPortrait then
        self.FocusToTPortrait = FocusFrameToT:CreateTexture(nil, "ARTWORK")
		local width, height = FocusFrameToT.portrait:GetSize()
        width = width + 5
        height = height + 5
		
        self.FocusToTPortrait:SetSize(width, height)
        for i = 1, FocusFrameToT.portrait:GetNumPoints() do
            local point, relativeTo, relativePoint, x, y = FocusFrameToT.portrait:GetPoint(i)
            self.FocusToTPortrait:SetPoint(point, relativeTo, relativePoint, x, y)
        end
    end
end

local CLASS_TEXTURE = "Interface\\AddOns\\Lorti-UI-Classic\\textures\\classportraits\\set%d\\%s.tga"

--Class Portraits
function ns.ApplyClassPortraits(self)
    -- Default to player frame if self is not provided
    if not self then
        self = {
            unit = "player",
            portrait = PlayerFrame.portrait
        }
    end

    -- Determine which class portrait set to use
    local classPortraitSet = self.unit == "player" and Lorti.playerClassPortraitSet or Lorti.classPortraitSet

    -- Exit early if class portraits are disabled for the current unit
    if (self.unit == "player" and not Lorti.playerClassPortraits) or 
       ((self.unit == "target" or self.unit == "focus") and not Lorti.ClassPortraits) or 
       self.unit == "pet" then
        return
    end

    -- Update the main portrait
    if self.portrait and not (self.unit == "targettarget" or self.unit == "focus-target") then
        if UnitIsPlayer(self.unit) then
            local _, class = UnitClass(self.unit)
            if class and UnitIsPlayer(self.unit) then
                self.portrait:SetTexture(CLASS_TEXTURE:format(classPortraitSet, class))
                if self.unit == "target" or self.unit == "focus" then
                    self.portrait:SetTexCoord(0, 1.06, 0, 1.06)
                end
            else
                self.portrait:SetTexture("")
                if self.unit == "target" or self.unit == "focus" then
                    self.portrait:SetTexCoord(0, 1, 0, 1)
                end
            end
        end
    end

    -- Handle target-target portrait
    if UnitExists("targettarget") then
        if UnitGUID("targettarget") ~= lastTargetToTGuid then
            lastTargetToTGuid = UnitGUID("targettarget")
            if CP.TargetToTPortrait then
                if UnitIsPlayer("targettarget") then
                    local _, class = UnitClass("targettarget")
                    CP.TargetToTPortrait:SetTexture(CLASS_TEXTURE:format(classPortraitSet, class))
                    CP.TargetToTPortrait:Show()
                else
                    CP.TargetToTPortrait:Hide()
                end
            end
        end
    else
        if CP.TargetToTPortrait then
            CP.TargetToTPortrait:Hide()
        end
        lastTargetToTGuid = nil
    end

    -- Handle focus-target portrait
    if UnitExists("focus-target") then
        if UnitGUID("focus-target") ~= lastFocusToTGuid then
            lastFocusToTGuid = UnitGUID("focus-target")
            if CP.FocusToTPortrait then
                if UnitIsPlayer("focus-target") then
                    local _, class = UnitClass("focus-target")
                    CP.FocusToTPortrait:SetTexture(CLASS_TEXTURE:format(classPortraitSet, class))
                    CP.FocusToTPortrait:Show()
                else
                    CP.FocusToTPortrait:Hide()
                end
            end
        end
    else
        if CP.FocusToTPortrait then
            CP.FocusToTPortrait:Hide()
        end
        lastFocusToTGuid = nil
    end
end

--Player, Target, and Target Name Background Bar Textures
--[[ local function ApplyFlatBars()
											
		FocusFrameNameBackground:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")
		TargetFrameNameBackground:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")
		PlayerFrame.healthbar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");
		TargetFrame.healthbar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");
		FocusFrame.healthbar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");
		--Party Frames Health Bar Textures

		for i=1, 4 do
			_G["PartyMemberFrame"..i.."HealthBar"]:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")
		end

		--Mirror Timers Textures (Breath meter, etc)

		MirrorTimer1StatusBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")
		MirrorTimer2StatusBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")
		MirrorTimer3StatusBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")

		--Castbar Bar Texture

		CastingBarFrame:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")

		--Pet Frame Bar Textures

		PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");
		TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");
		FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");

		--Tooltip Health Bar Texture

		GameTooltipStatusBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat")

		--XP and Rep Bar Textures

		ReputationWatchBar.StatusBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");
		MainMenuExpBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");

		--Mana Bar Texture

		function LortiUIManaTexture (manaBar)
			local powerType, powerToken, altR, altG, altB = UnitPowerType(manaBar.unit);
			local info = PowerBarColor[powerToken];
			if ( info ) then
				if ( not manaBar.lockColor ) then
						manaBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\flat");
				end
			end
		end
		hooksecurefunc("UnitFrameManaBar_UpdateType", LortiUIManaTexture)
end
]]

-- Spell Queue fix from RougeUI, credit for Xyz
local function SpellQueueFix()
    local _, _, latencyHome, latencyWorld = GetNetStats()
    local _, class = UnitClass("player")
    local value, currentLatency

    if (latencyHome or latencyWorld) == 0 then
        C_Timer.After(40, SpellQueueFix)
        return
    end

    if latencyHome >= latencyWorld then
        currentLatency = latencyHome
    elseif latencyWorld > latencyHome then
        currentLatency = latencyWorld
    end

    if class == "ROGUE" then
        value = 200 + currentLatency
        ConsoleExec("SpellQueueWindow " .. value)
    elseif class ~= "ROGUE" then
        value = 250 + currentLatency
        ConsoleExec("SpellQueueWindow " .. value)
    end
end

local function ScaleFrames()
	if Lorti.bigbuff == true then
		-- PlayerFrame:SetScale(1.3) 
		-- TargetFrame:SetScale(1.3) 
		-- FocusFrame:SetScale(1.3)
		-- for i=1,4 do _G["PartyMemberFrame"..i]:SetScale(1.6) end
		-- ComboFrame:SetScale(1.3)
	end
end

local frame3 = CreateFrame("FRAME")
frame3:RegisterEvent("GROUP_ROSTER_UPDATE")
frame3:RegisterEvent("PLAYER_TARGET_CHANGED")
frame3:RegisterEvent("PLAYER_FOCUS_CHANGED")
frame3:RegisterEvent("UNIT_FACTION")
local function eventHandler(self, event, ...)
        if UnitIsPlayer("target") then
                c = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
                TargetFrameNameBackground:SetVertexColor(0, 0, 0, 0.35)
        end
        if UnitIsPlayer("focus") then
                c = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
                FocusFrameNameBackground:SetVertexColor(0, 0, 0, 0.35)
        end
end
frame3:SetScript("OnEvent", eventHandler)

local function OnEvent(self, event)
	for addon in pairs(addonlist) do
		if IsAddOnLoaded(addon) then
			for _, v in pairs(events) do self:UnregisterEvent(v) end
			self:SetScript("OnEvent", nil)
			return
		end
	end
	
	if (event == "ADDON_LOADED") then
		OnLoad()
		enable()
		-- ScaleFrames()
		ApplyFonts()
		
		if Lorti.thickness then
            ApplyThickness()
        else
			hooksecurefunc("PlayerFrame_ToPlayerArt", LortiUIPlayerFrame)
            hooksecurefunc("TargetFrame_CheckClassification", Classify)
        end
		

		if Lorti.ClassPortraits or Lorti.playerClassPortraits then
			hooksecurefunc("UnitFramePortrait_Update", ns.ApplyClassPortraits)
		end
		if Lorti.ClassPortraits or Lorti.playerClassPortraits then
			hooksecurefunc("UnitFramePortrait_Update", function(self)
			ns.ApplyClassPortraits(self)
			end)
		end
		--[[ if Lorti.flatbars == true then
			ApplyFlatBars()
		end ]]
	
	end
	if event == "PLAYER_LOGIN" then
		if Lorti.spellqueue then
			self:RegisterEvent("PLAYER_ENTERING_WORLD")
			self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		end
	end
	if (event == "PLAYER_ENTERING_WORLD") then
		ApplyFonts()
		
		-- From RougeUI, credit to Xyz
		if Lorti.keypress then 
			SetCVar('ActionButtonUseKeyDown', 1)
		else
			SetCVar('ActionButtonUseKeyDown', 0)
		end
		-- if _G["CompactRaidFrame" .. i] then ???
		-- if CompactRaidGroup1 and not groupcolored == true then
		--	ColorRaid()
		-- end

		-- if CompactRaidFrame1 and not singlecolored == true then
		--	ColorRaid()
		-- end
		UpdateAddOnMemoryUsage()
		
		if Lorti.spellqueue then
            SpellQueueFix()
        end

        
    elseif event == "ZONE_CHANGED_NEW_AREA" then
        if Lorti.spellqueue then
            SpellQueueFix()
        end
    end

	
end

local e = CreateFrame("Frame")
e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("PLAYER_ENTERING_WORLD")
e:RegisterEvent("ADDON_LOADED")
e:RegisterEvent("GROUP_ROSTER_UPDATE")
for _, v in pairs(events) do e:RegisterEvent(v) end
e:SetScript("OnEvent", OnEvent)

--Raid Frames
local f = CreateFrame("Frame")
f:SetScript("OnEvent",function(self, event, ...)

local n, w, h = "CompactUnitFrameProfilesGeneralOptionsFrame"
h, w = _G[n .. "HeightSlider"], _G[n .. "WidthSlider"]
h:SetMinMaxValues(1, 200)
w:SetMinMaxValues(1, 200)

local function RaidFrameUpdate()
	local i, bar = 1
	repeat
    	bar = _G["CompactRaidFrame" .. i .. "HealthBar"]
		bar2 = _G["CompactPartyFrameMember" .. i .. "HealthBar"]
		rbar = _G["CompactRaidFrame" .. i .. "PowerBar"]
		Divider = _G["CompactRaidFrame" .. i .. "HorizDivider"]
		vleftseparator = _G["CompactRaidFrame" .. i .. "VertLeftBorder"]
		vrightseparator = _G["CompactRaidFrame" .. i .. "VertRightBorder"]
		htopseparator = _G["CompactRaidFrame" .. i .. "HorizTopBorder"]
		hbotseparator = _G["CompactRaidFrame" .. i .. "HorizBottomBorder"]
		name = _G["CompactRaidFrame" .. i .. "Name"]
		name2 = _G["CompactPartyFrameMember" .. i .. "Name"]
    if bar2 then
		name2:SetFont(Lorti.fontFamily, Lorti.StringSize, "OUTLINE")
	end
	if bar then
		bar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\Raid-Bar-Hp-Fill")
		rbar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\Raid-Bar-Resource-Fill")
	
		vleftseparator:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\Raid-VSeparator")
		vrightseparator:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\Raid-VSeparator")
		htopseparator:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\Raid-HSeparator")
		hbotseparator:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\Raid-HSeparator")
		Divider:SetVertexColor(.3, .3, .3)
		name:SetFont(Lorti.fontFamily, Lorti.StringSize, "OUTLINE")
		
		name:SetPoint('TOPLEFT', bar, 2, -2)
    end
    i = i + 1
  until not bar
end

	if CompactRaidFrameContainer_AddUnitFrame then
    self:UnregisterAllEvents()
		hooksecurefunc("CompactRaidFrameContainer_AddUnitFrame", RaidFrameUpdate)
		CompactRaidFrameContainerBorderFrameBorderTopLeft:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\RaidBorder-UpperLeft")
		CompactRaidFrameContainerBorderFrameBorderTop:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\RaidBorder-UpperMiddle")
		CompactRaidFrameContainerBorderFrameBorderTopRight:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\RaidBorder-UpperRight")
		CompactRaidFrameContainerBorderFrameBorderLeft:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\RaidBorder-Left")
		CompactRaidFrameContainerBorderFrameBorderRight:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\RaidBorder-Right")
		CompactRaidFrameContainerBorderFrameBorderBottomLeft:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\RaidBorder-BottomLeft")
		CompactRaidFrameContainerBorderFrameBorderBottom:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\RaidBorder-BottomMiddle")
		CompactRaidFrameContainerBorderFrameBorderBottomRight:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\raid\\RaidBorder-BottomRight")
    end

-- Party frames
function LortiPartyFrames()
	local useCompact = GetCVarBool("useCompactPartyFrames");
	if IsInGroup(player) and (not IsInRaid(player)) and (not useCompact) then
		for i = 1, 4 do
			
			
			-- _G["PartyMemberFrame"..i.."Name"]:SetSize(75,10);
			_G["PartyMemberFrame"..i.."Texture"]:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\unitframes\\UI-PartyFrame");
			_G["PartyMemberFrame"..i.."Flash"]:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\unitframes\\UI-PARTYFRAME-FLASH");
			_G["PartyMemberFrame"..i.."HealthBar"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."HealthBar"]:SetPoint("TOPLEFT", 45, -13);
			_G["PartyMemberFrame"..i.."HealthBar"]:SetHeight(12);
			_G["PartyMemberFrame"..i.."ManaBar"]:ClearAllPoints();
			_G["PartyMemberFrame"..i.."ManaBar"]:SetPoint("TOPLEFT", 45, -26);
			_G["PartyMemberFrame"..i.."ManaBar"]:SetHeight(5);
			-- _G["PartyMemberFrame"..i.."HealthBarTextLeft"]:ClearAllPoints();
			-- _G["PartyMemberFrame"..i.."HealthBarTextLeft"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."HealthBar"], "LEFT", 0, 0);
			-- _G["PartyMemberFrame"..i.."HealthBarTextRight"]:ClearAllPoints();
			-- _G["PartyMemberFrame"..i.."HealthBarTextRight"]:SetPoint("RIGHT", _G["PartyMemberFrame"..i.."HealthBar"], "RIGHT", 0, 0);
			-- _G["PartyMemberFrame"..i.."ManaBarTextLeft"]:ClearAllPoints();
			-- _G["PartyMemberFrame"..i.."ManaBarTextLeft"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."ManaBar"], "LEFT", 0, 0);
			-- _G["PartyMemberFrame"..i.."ManaBarTextRight"]:ClearAllPoints();
			-- _G["PartyMemberFrame"..i.."ManaBarTextRight"]:SetPoint("RIGHT", _G["PartyMemberFrame"..i.."ManaBar"], "RIGHT", 0, 0);
			-- _G["PartyMemberFrame"..i.."HealthBarText"]:ClearAllPoints();
			-- _G["PartyMemberFrame"..i.."HealthBarText"]:SetPoint("CENTER", _G["PartyMemberFrame"..i.."HealthBar"], "CENTER", 0, 0);
			-- _G["PartyMemberFrame"..i.."ManaBarText"]:ClearAllPoints();
			-- _G["PartyMemberFrame"..i.."ManaBarText"]:SetPoint("CENTER", _G["PartyMemberFrame"..i.."ManaBar"], "CENTER", 0, 0);
		end
	end
end
hooksecurefunc("UnitFrame_Update", LortiPartyFrames)
hooksecurefunc("PartyMemberFrame_ToPlayerArt", LortiPartyFrames)

local function RepositionPartyFrames()
    -- Adjust these base offsets as needed.
    local baseX = 300  -- distance from the left edge
    local baseY = 100  -- distance from the bottom edge
    local spacing = 10  -- space between frames

    for i = 1, 4 do
        local frame = _G["PartyMemberFrame" .. i]
        if frame then
            frame:ClearAllPoints()
            -- Anchor each party frame to UIParent.
            -- Here, the first party frame is positioned at (baseX, baseY),
            -- and subsequent frames are moved upward by the frame's height plus a little spacing.
			
            local height = frame:GetHeight() -- fallback height if GetHeight() is nil
			local scale = Lorti.partyFrameScale or 1.0

			if scale >= 1.99 then
                -- Very large scale (>= 2.0)
                frame:SetPoint("CENTER", CompactRaidFrameManagerToggleButton, "CENTER", 70, -5 - (height + spacing) * (i - 1))
			elseif scale >= 1.79 then
                -- Large scale (1.80 to 1.99)
                frame:SetPoint("CENTER", CompactRaidFrameManagerToggleButton, "CENTER", 70, -10 - (height + spacing) * (i - 1))
            elseif scale >= 1.59 then
                -- Medium-large scale (1.60 to 1.79)
                frame:SetPoint("CENTER", CompactRaidFrameManagerToggleButton, "CENTER", 75, -15 - (height + spacing) * (i - 1))
            elseif scale >= 1.39 then
                -- Large scale (1.40 to 1.59)
                frame:SetPoint("CENTER", CompactRaidFrameManagerToggleButton, "CENTER", 75, -20 - (height + spacing) * (i - 1))
            elseif scale >= 1.19 then
                -- Medium-large scale (1.20 to 1.39)
                frame:SetPoint("CENTER", CompactRaidFrameManagerToggleButton, "CENTER", 75, -25 - (height + spacing) * (i - 1))
            elseif scale >= 0.89 then
                -- Medium scale (0.9 to 1.9)
                frame:SetPoint("CENTER", CompactRaidFrameManagerToggleButton, "CENTER", 80, -35 - (height + spacing) * (i - 1))
            elseif scale >= 0.6 then
                -- Small scale (0.6 to 0.89)
                frame:SetPoint("CENTER", CompactRaidFrameManagerToggleButton, "CENTER", 85, -30 - (height + spacing) * (i - 1))
            else
                -- Very small scale (< 0.6)
                frame:SetPoint("CENTER", CompactRaidFrameManagerToggleButton, "CENTER", 90, -25 - (height + spacing) * (i - 1))
            end
        end
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
    RepositionPartyFrames()
end)

-- From RougeUI modified to show mana ticks, credit to Xyz
if Lorti.energytick then
    local events = {
        "PLAYER_LOGIN",
        "PLAYER_REGEN_DISABLED",
        "PLAYER_REGEN_ENABLED",
        "UPDATE_SHAPESHIFT_FORM",
        "COMBAT_LOG_EVENT_UNFILTERED",
        "UNIT_POWER_UPDATE",
        "UNIT_SPELLCAST_STOP",
        "UNIT_SPELLCAST_SUCCEEDED"
    }

    local last_energy_tick = GetTime()
    local last_mana_tick = GetTime()
    local last_energy_value = 0
    local last_mana_value = 0
    local externalManaGainTimestamp = 0
    local TimeSinceLastUpdate = 0
    local ONUPDATE_INTERVAL = 0.01
    local manaRegenStartTime = 0
	local isInFiveSecondRule = false

	-- Track the start time of mana regeneration delay
local function OnSpellCastSucceeded()
    -- Set the start time for the 5-second mana regen delay
	last_mana_tick = GetTime()
    manaRegenStartTime = GetTime()
    isInFiveSecondRule = true
	-- print("Spell cast detected! Resetting mana tick timer. New last_mana_tick:", last_mana_tick)
end
    -- Function to set the tick marker position
    -- Function to set the tick marker position
local function SetTickValue(self, elapsed, resourceType)
    local x = self:GetWidth() -- Width of the mana bar
    local position = 0

    if resourceType == "mana" then
        -- Calculate the spark position based on the elapsed time
        position = (x * elapsed) / 5.13 -- Use 5-second interval during the delay
        if not isInFiveSecondRule then
            position = (x * elapsed) / 2.02 -- Use 2-second interval after the delay
        end
    elseif resourceType == "energy" then
        -- Energy tick logic remains unchanged
        position = (x * elapsed) / 2.02
    end

    -- Clamp the position to the width of the bar
    if position < x then
        if resourceType == "energy" and self.energy then
            self.energy.spark:Show()
            self.energy.spark:SetPoint("CENTER", self, "LEFT", position, 0)
        elseif resourceType == "mana" and self.mana then
            self.mana.spark:Show()
            self.mana.spark:SetPoint("CENTER", self, "LEFT", position, 0)
        end
    end
end


-- OnUpdate function
local function OnUpdate(self, elapsed)
    local time = GetTime()
    TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed

    if TimeSinceLastUpdate >= ONUPDATE_INTERVAL then
        TimeSinceLastUpdate = 0

        -- Energy Tick (unchanged)
        if time >= last_energy_tick + 2.02 then
            last_energy_tick = time
        end
        SetTickValue(self:GetParent(), time - last_energy_tick, "energy")

        -- Mana Tick with 5-second rule
        if isInFiveSecondRule then
            -- During the 5-second delay, use a 5-second tick interval
            if time >= last_mana_tick + 5.13 then
                last_mana_tick = time
               -- print("Mana tick (5-second rule):", last_mana_tick)
            end
            -- End the 5-second rule after 5 seconds
            if time >= manaRegenStartTime + 5.13 then
                isInFiveSecondRule = false
               -- print("5-second rule ended. Resuming normal 2-second ticks.")
            end
        else
            -- After the delay, resume 2-second mana ticks
            if time >= last_mana_tick + 2.02 then
                last_mana_tick = time
               -- print("Mana tick (normal):", last_mana_tick)
            end
        end
        SetTickValue(self:GetParent(), time - last_mana_tick, "mana")
    end
end

    -- Function to update Energy
    local function UpdateEnergy()
        local energy = UnitPower("player", 3)
        local maxEnergy = UnitPowerMax("player", 3)
        local time = GetTime()

        if time - externalManaGainTimestamp < 0.02 then
            externalManaGainTimestamp = 0
            return
        end

        if ((energy == last_energy_value + 20 or energy == last_energy_value + 21 or 
             energy == last_energy_value + 40 or energy == last_energy_value + 41) and energy ~= maxEnergy) then
            last_energy_tick = time
        end

        last_energy_value = energy
    end

    -- Function to update Mana
    local function UpdateMana()
        local mana = UnitPower("player", 0)
        local maxMana = UnitPowerMax("player", 0)
        local time = GetTime()

        if time - externalManaGainTimestamp < 0.02 then
            externalManaGainTimestamp = 0
            return
        end

        if mana > last_mana_value then
            last_mana_tick = time
        end

        last_mana_value = mana
    end

    -- Function to add Energy & Mana Tick Indicators
    local function AddTicks()
        -- Energy
        if not PlayerFrameManaBar.energy then
            PlayerFrameManaBar.energy = CreateFrame("Statusbar", "PlayerFrameManaBar_energy", PlayerFrameManaBar)
            PlayerFrameManaBar.energy.spark = PlayerFrameManaBar.energy:CreateTexture(nil, "OVERLAY")
            PlayerFrameManaBar.energy.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
            PlayerFrameManaBar.energy.spark:SetSize(32, 32)
            PlayerFrameManaBar.energy.spark:SetPoint("CENTER", PlayerFrameManaBar, 0, 0)
            PlayerFrameManaBar.energy.spark:SetBlendMode("ADD")
            PlayerFrameManaBar.energy.spark:SetAlpha(0.4) -- Initial state: dimmed
        end

        -- Mana
        if not PlayerFrameManaBar.mana then
            PlayerFrameManaBar.mana = CreateFrame("Statusbar", "PlayerFrameManaBar_mana", PlayerFrameManaBar)
            PlayerFrameManaBar.mana.spark = PlayerFrameManaBar.mana:CreateTexture(nil, "OVERLAY")
            PlayerFrameManaBar.mana.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
            PlayerFrameManaBar.mana.spark:SetSize(32, 32)
            PlayerFrameManaBar.mana.spark:SetPoint("CENTER", PlayerFrameManaBar, 0, 0)
            PlayerFrameManaBar.mana.spark:SetBlendMode("ADD")
            PlayerFrameManaBar.mana.spark:SetAlpha(0.4) -- Initial state: dimmed
        end

        PlayerFrameManaBar.energy:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
        PlayerFrameManaBar.mana:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")

        if not PlayerFrameManaBar.energy:GetScript("OnUpdate") then
            PlayerFrameManaBar.energy:SetScript("OnUpdate", OnUpdate)
        end
    end

    local function RealTick()
        local _, eventType, _, _, _, sourceFlags, _, _, _, destFlags, _, spellID = CombatLogGetCurrentEventInfo()
        if not (eventType == "SPELL_PERIODIC_ENERGIZE" or eventType == "SPELL_ENERGIZE") then return end

        local isDestPlayer = CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_ME)
        if isDestPlayer then
            externalManaGainTimestamp = GetTime()
        end
    end
	 local _, class = UnitClass("player")
    local function OnEvent(self, event, ...)
    -- Check for energy and mana tick classes
    if class == "ROGUE" or class == "DRUID" then
        -- Show Energy Spark for ROGUE and DRUID in Cat Form
        if PlayerFrameManaBar.energy then
            local powerType = UnitPowerType("player")
            if powerType == 3 then -- Energy (Cat Form)
                PlayerFrameManaBar.energy.spark:SetAlpha(1)
            else
                PlayerFrameManaBar.energy.spark:SetAlpha(0)
            end
        end
    else
        -- Hide Energy Spark for other classes
        if PlayerFrameManaBar.energy then
            PlayerFrameManaBar.energy.spark:SetAlpha(0)
        end
    end

    -- Mana Ticks for MAGE, PRIEST, WARLOCK, HUNTER, SHAMAN, PALADIN, and DRUID
    if class == "MAGE" or class == "PRIEST" or class == "WARLOCK" or 
       class == "HUNTER" or class == "SHAMAN" or class == "PALADIN" or 
       class == "DRUID" then
        if PlayerFrameManaBar.mana then
            local powerType = UnitPowerType("player")
            if powerType == 0 then -- Mana (caster forms, Moonkin Form, etc.)
                PlayerFrameManaBar.mana.spark:SetAlpha(1)
            else
                PlayerFrameManaBar.mana.spark:SetAlpha(0)
            end
        end
    else
        -- Hide Mana Spark for other classes
        if PlayerFrameManaBar.mana then
            PlayerFrameManaBar.mana.spark:SetAlpha(0)
        end
    end

    if not (Lorti.energytick and (class == "ROGUE" or class == "DRUID" or
        class == "MAGE" or class == "PRIEST" or class == "WARLOCK" or 
        class == "HUNTER" or class == "SHAMAN" or class == "PALADIN")) then
        self:UnregisterAllEvents()
        self:SetScript("OnEvent", nil)
        return
    end

    if event == "PLAYER_LOGIN" then
        AddTicks()
        self:UnregisterEvent("PLAYER_LOGIN")
    elseif event == "PLAYER_REGEN_DISABLED" then
        if PlayerFrameManaBar.energy then PlayerFrameManaBar.energy.spark:SetAlpha(1) end
        if PlayerFrameManaBar.mana then PlayerFrameManaBar.mana.spark:SetAlpha(0.4) end
    elseif event == "PLAYER_REGEN_ENABLED" then
        if PlayerFrameManaBar.energy then PlayerFrameManaBar.energy.spark:SetAlpha(1) end
        if PlayerFrameManaBar.mana then PlayerFrameManaBar.mana.spark:SetAlpha(0.4) end
    elseif event == "UPDATE_SHAPESHIFT_FORM" and class == "DRUID" then
        -- Update spark visibility based on Druid form
        if PlayerFrameManaBar.energy then
            local powerType = UnitPowerType("player")
            if powerType == 3 then -- Energy (Cat Form)
                PlayerFrameManaBar.energy.spark:SetAlpha(1)
                PlayerFrameManaBar.mana.spark:SetAlpha(0)
            else
                PlayerFrameManaBar.energy.spark:SetAlpha(0)
                PlayerFrameManaBar.mana.spark:SetAlpha(1)
            end
        end
    elseif event == "UNIT_POWER_UPDATE" then
        UpdateEnergy()
        UpdateMana()
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        -- Handle spell cast success
        OnSpellCastSucceeded()
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        RealTick()
    end
end

    local e = CreateFrame("Frame")
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript("OnEvent", OnEvent)
end

--[[ if Lorti.smooth then
local smoothing = {}
local floor = math.floor
local mabs = math.abs
local min, max = math.min, math.max
local UnitGUID = UnitGUID
local ONUPDATE_INTERVAL = 0.01
local TimeSinceLastUpdate = 0

local barstosmooth = {
	PlayerFrameHealthBar = "player",
	PlayerFrameManaBar = "player",
	PetFrameHealthBar = "pet",
	PetFrameManaBar = "pet",
	TargetFrameHealthBar = "target",
	TargetFrameManaBar = "target",
	FocusFrameHealthBar = "focus",
	FocusFrameManaBar = "focus",
	PartyMemberFrame1HealthBar = "party1",
	PartyMemberFrame1ManaBar = "party1",
	PartyMemberFrame2HealthBar = "party2",
	PartyMemberFrame2ManaBar = "party2",
	PartyMemberFrame3HealthBar = "party3",
	PartyMemberFrame3ManaBar = "party3",
	PartyMemberFrame4HealthBar = "party4",
	PartyMemberFrame4ManaBar = "party4"
}

local smoothframe = CreateFrame("Frame")
smoothframe:RegisterEvent("ADDON_LOADED")

local function isPlate(frame)
	local name = frame:GetName()
	if name and name:find("NamePlate") then
		return true
	end

	return false
end

local function AnimationTick()
	local limit = .33
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + min((value - cur) /3, max(value - cur, limit))

		if new ~= new then
			new = value
		end

		bar:SetValue_(floor(new))
		if cur == value or mabs(new - value) < 2 then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end

local function SmoothSetValue(self, value)
	self.finalValue = value
	if self.unitType then
		local guid = UnitGUID(self.unitType)
		if (value == self:GetValue() or (not guid or guid ~= self.lastGuid)) then
			smoothing[self] = nil
			self:SetValue_(value)
		else
			smoothing[self] = value
		end
		self.lastGuid = guid
	else
		local _, max = self:GetMinMaxValues()
		if (value == self:GetValue() or (self._max and self._max ~= max)) then
			smoothing[self] = nil
			self:SetValue_(value)
		else
			smoothing[self] = value
		end
		self._max = max
	end
end

local function SmoothBar(bar)
	if not bar.SetValue_ then
		bar.SetValue_ = bar.SetValue
		bar.SetValue = SmoothSetValue
	end
end

local function onUpdate(self, elapsed)
	TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
	if TimeSinceLastUpdate >= ONUPDATE_INTERVAL then
		TimeSinceLastUpdate = 0
		local frames = {WorldFrame:GetChildren()}
		for _, plate in ipairs(frames) do
			if not plate:IsForbidden() and isPlate(plate) and C_NamePlate.GetNamePlates() and plate:IsVisible() then
				local v = plate:GetChildren()
				if  v.healthBar then
					SmoothBar(v.healthBar)
				end
			end
		end

		for k,v in pairs (barstosmooth) do
			if _G[k] then
				SmoothBar(_G[k])
				_G[k]:SetScript("OnHide", function() _G[k].lastGuid = nil; _G[k].max_ = nil end)
				if v ~= "" then
					_G[k].unitType = v
				end
			end
		end
		AnimationTick()
	end
end

smoothframe:SetScript("OnEvent", function(self, event)
	if event == "ADDON_LOADED" then
		smoothframe:HookScript("OnUpdate", onUpdate)
	end
	self:UnregisterEvent("ADDON_LOADED")
	self:SetScript("OnEvent", nil)
end);

end

]]


--[[
if Lorti.raidbuff then
-- This function updates the buffs for a given unit.
function RefreshBuffs(parent, unit, maxBuffs, filter, showAll)
    -- Assume that the buff container's parent is the raid frame.
    local raidFrame = parent:GetParent()

    -- Define native dimensions (adjust these if needed)
    local NATIVE_UNIT_FRAME_HEIGHT = 36
    local NATIVE_UNIT_FRAME_WIDTH = 72

    -- Get the current size of the raid frame.
    local raidWidth, raidHeight = raidFrame:GetSize()

    -- Compute the scale factor (use the smaller ratio to keep proportions).
    local componentScale = math.min(raidHeight / NATIVE_UNIT_FRAME_HEIGHT, raidWidth / NATIVE_UNIT_FRAME_WIDTH)

    -- Define a default buff size (Blizzard uses 11 in its default setup).
    local defaultBuffSize = 11
    local iconSize = math.floor(defaultBuffSize * componentScale)

    for i = 1, maxBuffs do
        local buff = parent["Buff"..i]
        if not buff then
            buff = CreateFrame("Frame", parent:GetName().."Buff"..i, parent, "TargetBuffFrameTemplate")
            buff:SetSize(iconSize, iconSize)
            parent["Buff"..i] = buff

            -- Position the buffs. Here we place the first buff at the top-right,
            -- and subsequent buffs to its left (adjust as needed).
            if i == 1 then
                buff:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)
            else
                buff:SetPoint("RIGHT", parent["Buff"..(i-1)], "LEFT", -2, 0)
            end

            -- Create a cooldown frame if one doesn't exist.
            if not buff.cooldown then
                buff.cooldown = CreateFrame("Cooldown", buff:GetName().."Cooldown", buff, "CooldownFrameTemplate")
                buff.cooldown:SetAllPoints(buff)
            end
        else
            -- Update the buff size in case the raid frame has changed.
            buff:SetSize(iconSize, iconSize)
        end

        -- Retrieve aura information.
        local name, icon, count, debuffType, duration, expirationTime = UnitAura(unit, i, "HELPFUL")
        if name then
            local iconTexture = _G[buff:GetName().."Icon"]
            local countText   = _G[buff:GetName().."Count"]

            if iconTexture then
                iconTexture:SetTexture(icon)
            end
            if countText then
                countText:SetText((count and count > 1) and count or "")
            end

            buff:Show()

            -- Set up the cooldown swipe if the aura has a duration.
            if buff.cooldown then
                if duration and duration > 0 then
                    buff.cooldown:Show()
                    CooldownFrame_Set(buff.cooldown, expirationTime - duration, duration, true)
                else
                    buff.cooldown:Hide()
                end
            end
			buff:EnableMouse(false)
        else
            buff:Hide()
        end
    end
	
	-- Update Raid Buffs (this runs on each UNIT_AURA event for raid members)
local raidBuffUpdater = CreateFrame("Frame")
raidBuffUpdater:RegisterEvent("UNIT_AURA")
raidBuffUpdater:RegisterEvent("GROUP_ROSTER_UPDATE")  -- optionally update on roster changes
raidBuffUpdater:SetScript("OnEvent", function(self, event, unit)
  
  
  for i = 1, MAX_RAID_MEMBERS do
    local raidFrame = _G["CompactRaidFrame" .. i]
    if raidFrame and raidFrame.unit then
      if not raidFrame.BuffFrame then
        local buffFrame = CreateFrame("Frame", raidFrame:GetName().."BuffFrame", raidFrame)
        buffFrame:SetSize(100, 20)  -- adjust as needed
        buffFrame:SetPoint("BOTTOMRIGHT", raidFrame, "TOPRIGHT", -2, -40)
        buffFrame:SetFrameLevel(raidFrame:GetFrameLevel() + 20)
        raidFrame.BuffFrame = buffFrame
      end

      -- This call will update up to 20 buffs (with no extra filter, so all helpful buffs)
      RefreshBuffs(raidFrame.BuffFrame, raidFrame.unit, 20, nil, 1)
    end
  end
end)
end
end
]]



-- Custom number formatting function
local function true_format(value)
    if value > 1e7 then return (math.floor(value / 1e6)) .. 'm'
    elseif value > 1e6 then return (math.floor((value / 1e6) * 10) / 10) .. 'm'
    elseif value > 1e4 then return (math.floor(value / 1e3)) .. 'k'
    elseif value > 1e3 then return (math.floor((value / 1e3) * 10) / 10) .. 'k'
    else return tostring(value) end
end

-- Function to update health text to show only current health
local function New_TextStatusBar_UpdateTextString(statusFrame, textString, value, valueMin, valueMax)
    -- Hide left and right text if they exist
    if statusFrame.LeftText and statusFrame.RightText then
        statusFrame.LeftText:SetText("")
        statusFrame.RightText:SetText("")
        statusFrame.LeftText:Hide()
        statusFrame.RightText:Hide()
    end

    -- Check if the status frame should display text
    if valueMax > 0 and not statusFrame.pauseUpdates then
        -- Only show the current health value
        if value and valueMax > 0 then
            statusFrame.isZero = nil
            textString:Show()
            textString:SetText(--[[true_format]](value))
        end
    else
        -- Hide the text if no valid values are available
        textString:Hide()
        textString:SetText("")
        if not statusFrame.alwaysShow then
            statusFrame:Hide()
        else
            statusFrame:SetValue(0)
        end
    end

    -- Handle dead/ghost units
    if UnitIsDeadOrGhost("target") then
        for _, v in pairs({TargetFrameHealthBar, TargetFrameManaBar}) do
            if v.TextString then
                v.TextString:SetText("")
            end
            if v.LeftText then
                v.LeftText:SetText("")
            end
            if v.RightText then
                v.RightText:SetText("")
            end
        end
    end
end

-- Hook into the default TextStatusBar_UpdateTextString function
local function CTextStatusBar_UpdateTextString(textStatusBar)
    if not textStatusBar or not textStatusBar.TextString then return end

    -- Ensure useSimpleValue is enabled
    if textStatusBar.useSimpleValue then
        local value = textStatusBar.finalValue or textStatusBar:GetValue()
        local valueMin, valueMax = textStatusBar:GetMinMaxValues()
        New_TextStatusBar_UpdateTextString(textStatusBar, textStatusBar.TextString, value, valueMin, valueMax)
    end
end

-- Ensure useSimpleValue is set for all relevant frames
local function SetupFrames()
    -- Player Frame
    if PlayerFrameHealthBar then
        PlayerFrameHealthBar.useSimpleValue = true
    end
	if PlayerFrameManaBar then
		PlayerFrameManaBar.useSimpleValue = true
	end
	
    -- Target Frame
    if TargetFrameHealthBar then
        TargetFrameHealthBar.useSimpleValue = true
    end
	if TargetFrameManaBar then
		TargetFrameManaBar.useSimpleValue = true
	end
	
    -- Pet Frame
    if PetFrameHealthBar then
        PetFrameHealthBar.useSimpleValue = true
    end
	if PetFrameManaBar then
		PetFrameManaBar.useSimpleValue = true
	end
    -- Focus Frame
    if FocusFrameHealthBar then
        FocusFrameHealthBar.useSimpleValue = true
    end
	if FocusFrameManaBar then
		FocusFrameManaBar.useSimpleValue = true
	end

    -- Party Frames
    for i = 1, 4 do
        local partyFramehealth = _G["PartyMemberFrame" .. i .. "HealthBar"]
        if partyFramehealth then
            partyFramehealth.useSimpleValue = true
        end
		local partyFramemana = _G["PartyMemberFrame" .. i .. "ManaBar"]
        if partyFramemana then
            partyFramemana.useSimpleValue = true
        end
    end
end

-- Main initialization
local CF = CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" and Lorti.numerical then
        -- Set up frames
        SetupFrames()
		
        -- Hook into the default function
        hooksecurefunc("TextStatusBar_UpdateTextString", CTextStatusBar_UpdateTextString)
    end

    -- Unregister the event after setup
    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)
end)

-- From RougeUI, credit to Xyz
if Lorti.rangecolor then
-- Range recolor by Xyz
local IsUsableAction, GetActionCount, IsConsumableAction = IsUsableAction, GetActionCount, IsConsumableAction
local IsStackableAction, IsActionInRange, RANGE_INDICATOR = IsStackableAction, IsActionInRange, RANGE_INDICATOR

local function Usable(button, r, g, b, a)
    local action = button.action
    local icon = button.icon

    if not action or not icon then
        return
    end

    local isUsable, notEnoughMana = IsUsableAction(action)
    local count = GetActionCount(action)

    if isUsable then
        -- if (r ~= 1.0 or g ~= 1.0 or b ~= 1.0 or a ~= 1.0) or icon:IsDesaturated() then
        icon:SetVertexColor(1.0, 1.0, 1.0, 1.0)
        icon:SetDesaturated(false)
        --  end
    elseif notEnoughMana then
        -- if ((mfloor(r * 100) / 100) ~= 0.3 or (mfloor(g * 100) / 100) ~= 0.3 or (mfloor(b * 100) / 100) ~= 0.3 or a ~= 1.0) or not icon:IsDesaturated() then
        icon:SetVertexColor(0.3, 0.3, 0.3, 1.0)
        icon:SetDesaturated(true)
        -- end
    elseif (IsConsumableAction(action) or IsStackableAction(action)) and count == 0 then
        if not icon:IsDesaturated() then
            icon:SetDesaturated(true)
        end
    else
        if UnitExists("target") or UnitExists("focus") then
            -- if ((mfloor(r * 100) / 100) ~= 0.4 or (mfloor(g * 100) / 100) ~= 0.4 or (mfloor(b * 100) / 100) ~= 0.4 or a ~= 1.0) or not icon:IsDesaturated() then
            icon:SetVertexColor(0.4, 0.4, 0.4, 1.0)
            icon:SetDesaturated(true)
            --  end
        else
            --   if r ~= 1.0 or b ~= 1.0 or g ~= 1.0 or a ~= 1.0 then
            icon:SetVertexColor(1.0, 1.0, 1.0, 1.0)
            icon:SetDesaturated(false)
            --  end
        end
    end
end

local function RangeIndicator(self, checksRange, inRange)
    if self and not self:IsVisible() then
        return
    end

    if checksRange == nil and inRange == nil then
        local valid = IsActionInRange(self.action);
        checksRange = (valid ~= nil)
        inRange = checksRange and valid;
    end

    local r, g, b, a = self.icon:GetVertexColor()

    if checksRange and not inRange then
        -- if r ~= 1.0 or ((mceil(g * 100) / 100) ~= 0.35 or (mceil(b * 100) / 100) ~= 0.35 or (mceil(a * 100) / 100) ~= 0.75) or not self.icon:IsDesaturated() then
        self.icon:SetVertexColor(1.0, 0.35, 0.35, 0.99)
        self.icon:SetDesaturated(true)
        -- end
    else
        if self:GetName():match("PetActionButton%d") then
            self.icon:SetVertexColor(1.0, 1.0, 1.0, 1.0)
            self.icon:SetDesaturated(false)
            return
        end
        Usable(self, r, g, b, a)
    end
end
		if not (IsAddOnLoaded("Bartender4") or IsAddOnLoaded("tullaRange")) then
            hooksecurefunc("ActionButton_UpdateRangeIndicator", RangeIndicator)
            hooksecurefunc("ActionButton_UpdateUsable", RangeIndicator)
        end
end

-- Druid mana bar from LeatrixPlus
local _, class = UnitClass("player")
if class == "DRUID" then
    -- Set up constants for the additional power bar
    RunScript([[
        ADDITIONAL_POWER_BAR_NAME = "MANA"
        ADDITIONAL_POWER_BAR_INDEX = 0
        ALT_MANA_BAR_PAIR_DISPLAY_INFO = { DRUID = { [Enum.PowerType.Rage] = true; [Enum.PowerType.Energy] = true } }
    ]])

    -- Alternate Power Bar Functions (copied from Blizzard's AlternatePowerBar.lua)
    local function AlternatePowerBar_Initialize(self)
        if not (self.powerName and self.powerIndex) then
            self.powerName = ADDITIONAL_POWER_BAR_NAME
            self.powerIndex = ADDITIONAL_POWER_BAR_INDEX
        end

        local parent = self:GetParent()
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        self:RegisterUnitEvent("UNIT_DISPLAYPOWER", parent.unit)
        self:RegisterUnitEvent("UNIT_MAXPOWER", parent.unit)
        self:RegisterUnitEvent("UNIT_POWER_UPDATE", parent.unit)

        local color = PowerBarColor[self.powerName]
        self:SetStatusBarColor(color.r, color.g, color.b)
    end

    local function AlternatePowerBar_UpdateMaxValue(self)
        self:SetMinMaxValues(0, UnitPowerMax(self:GetParent().unit, self.powerIndex))
    end

    local function AlternatePowerBar_UpdateValue(self)
		local currentPower = UnitPower(self:GetParent().unit, self.powerIndex)
		if Lorti.numerical then
			self.TextString:SetText(--[[true_format]](currentPower)) -- Use your custom formatting function
        else
			self:SetValue(currentPower)
		end
		self:SetValue(currentPower)
    end
	
    local function AlternatePowerBar_UpdatePowerType(self)
        local unit = self:GetParent().unit
        local _, class = UnitClass(unit)
        local show = (UnitPowerMax(unit, self.powerIndex) > 0 and ALT_MANA_BAR_PAIR_DISPLAY_INFO[class] and ALT_MANA_BAR_PAIR_DISPLAY_INFO[class][UnitPowerType(unit)])
        self.pauseUpdates = not show
        if show then AlternatePowerBar_UpdateValue(self) end
        self:SetShown(show)
    end

    local function AlternatePowerBar_OnLoad(self)
        self.textLockable = 1
        self.cvar = "statusText"
        self.cvarLabel = "STATUS_TEXT_PLAYER"
        self.capNumericDisplay = true
        AlternatePowerBar_Initialize(self)
        TextStatusBar_Initialize(self)
    end

    local function AlternatePowerBar_OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_MAXPOWER" then
            AlternatePowerBar_UpdateMaxValue(self)
        end
        if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_DISPLAYPOWER" then
            AlternatePowerBar_UpdatePowerType(self)
        end
        if event == "UNIT_POWER_UPDATE" and self:IsShown() then
            AlternatePowerBar_UpdateValue(self)
        end
        TextStatusBar_OnEvent(self, event, ...)
    end

    local function AlternatePowerBar_OnUpdate(self, elapsed)
        AlternatePowerBar_UpdateValue(self)
    end

    -- Create the Druid Mana Bar
    local bar = CreateFrame("StatusBar", nil, PlayerFrame, "TextStatusBar")
    bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    bar:SetStatusBarColor(0, 0, 1) -- Blue color for mana
    bar:SetSize(110, 12)
    bar:SetPoint("BOTTOMLEFT", 112, 24)

    -- Background
    bar.DefaultBackground = bar:CreateTexture(nil, "BACKGROUND")
    bar.DefaultBackground:SetColorTexture(0, 0, 0, 0.5)
    bar.DefaultBackground:SetAllPoints(bar)

    -- Borders (optional, only if you want them)
    local chainR, chainG, chainB = 0.86, 0.70, 0.12
    bar.DefaultBorder = bar:CreateTexture(nil, "OVERLAY")
    bar.DefaultBorder:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\UI-CharacterFrame-GroupIndicator.blp")
    bar.DefaultBorder:SetTexCoord(0.125, 0.25, 1, 0)
    bar.DefaultBorder:SetHeight(16)
    bar.DefaultBorder:SetPoint("TOPLEFT", 4, 0)
    bar.DefaultBorder:SetPoint("TOPRIGHT", -4, 0)
    bar.DefaultBorder:SetVertexColor(chainR, chainG, chainB)

    bar.DefaultBorderLeft = bar:CreateTexture(nil, "OVERLAY")
    bar.DefaultBorderLeft:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\UI-CharacterFrame-GroupIndicator.blp")
    bar.DefaultBorderLeft:SetTexCoord(0, 0.125, 1, 0)
    bar.DefaultBorderLeft:SetSize(16, 16)
    bar.DefaultBorderLeft:SetPoint("TOPLEFT", -12, 0)
    bar.DefaultBorderLeft:SetVertexColor(chainR, chainG, chainB)

    bar.DefaultBorderRight = bar:CreateTexture(nil, "OVERLAY")
    bar.DefaultBorderRight:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\UI-CharacterFrame-GroupIndicator.blp")
    bar.DefaultBorderRight:SetTexCoord(0.125, 0, 1, 0)
    bar.DefaultBorderRight:SetSize(16, 16)
    bar.DefaultBorderRight:SetPoint("TOPRIGHT", 12, 0)
    bar.DefaultBorderRight:SetVertexColor(chainR, chainG, chainB)

    -- Text Strings
    bar.TextString = bar:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
    bar.TextString:SetPoint("CENTER")
    bar.LeftText = bar:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
    bar.LeftText:SetPoint("LEFT")
    bar.RightText = bar:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
    bar.RightText:SetPoint("RIGHT")

    -- Font Settings
    bar.TextString:SetFont(Lorti.fontFamily, Lorti.NumSize-2, "OUTLINE")
    bar.LeftText:SetFont(Lorti.fontFamily, Lorti.NumSize-2, "OUTLINE")
    bar.RightText:SetFont(Lorti.fontFamily, Lorti.NumSize-2, "OUTLINE")

    -- Shadow Effects
    bar.TextString:SetShadowOffset(1, -1)
    bar.TextString:SetShadowColor(0, 0, 0)
    bar.LeftText:SetShadowOffset(1, -1)
    bar.LeftText:SetShadowColor(0, 0, 0)
    bar.RightText:SetShadowOffset(1, -1)
    bar.RightText:SetShadowColor(0, 0, 0)

    -- Scripts
    bar:SetScript("OnEvent", AlternatePowerBar_OnEvent)
    bar:SetScript("OnUpdate", AlternatePowerBar_OnUpdate)
    AlternatePowerBar_OnLoad(bar)
end


end)
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED")