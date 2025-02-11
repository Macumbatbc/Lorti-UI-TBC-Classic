local Name, ns = ...;
local Title = select(2,GetAddOnInfo(Name)):gsub("%s*v?[%d%.]+$","");
local cfg = ns.cfg

Lorti = { keyhide, macrohide, stealth, switchtimer, gloss, bigbuff, thickness, classbars, ClassPortraits, energytick, raidbuff, ColoredHP, ActionbarTexture, hitindicator, playername, playerFrameIndex, LortiTextureIndex, fontIndex }

local default = {
    keyhide = false,
    macrohide = false,
    stealth = false,
    switchtimer = false,
    gloss = false,
    bigbuff = false,
    thickness = false,
    classbars = false,
	ColoredHP = false,
    ClassPortraits = false,
    energytick = false,
	raidbuff = false,
    ActionbarTexture = false,
    hitindicator = false,
    playername = false,
    playerFrameIndex = 1,
	LortiTextureIndex = 27,
	fontIndex = 12,
}


local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

local raidFixFrame = CreateFrame("Frame")
raidFixFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
raidFixFrame:RegisterEvent("PLAYER_LOGIN")
raidFixFrame:RegisterEvent("ADDON_LOADED")
raidFixFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
raidFixFrame:SetScript("OnEvent", function()
    SBTexturesDo()
end)


-- Function to create check buttons with tooltips
local function CheckBtn(title, desc, panel, onClick)
    local frame = CreateFrame("CheckButton", title, panel, "InterfaceOptionsCheckButtonTemplate")
    frame:SetScript("OnClick", function(self)
        local enabled = self:GetChecked()
        onClick(self, enabled and true or false)
    end)
    frame.text = _G[frame:GetName() .. "Text"]
    frame.text:SetText(title)
	frame.text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    frame.tooltipText = desc -- Set tooltip text here

    -- Add OnEnter and OnLeave scripts for tooltips
    frame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(self.tooltipText, 1, 0.8, 0.3)
        GameTooltip:Show()
    end)
    frame:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    return frame
end

function f:ADDON_LOADED()
    for i, j in pairs(default) do
        if type(j) == "table" then
            for k, v in pairs(j) do
                if Lorti[i][k] == nil then
                    Lorti[i][k] = v
                end
            end
        else
            if Lorti[i] == nil then
                Lorti[i] = j
            end
        end
    end
	if Lorti.SBTextureName == nil then
        Lorti.SBTextureName = "flat2"
		SBTexturesDo()
    end
	
	if Lorti.fontFamily == nil then
        Lorti.fontFamily = "Fonts\\FRIZQT__.TTF"
		SBTexturesDo()
    end
	
	if Lorti.StringSize == nil then
		Lorti.StringSize = 12
	end
	
	if Lorti.NumSize == nil then
		Lorti.NumSize = 12
	end
	
    if not f.options then
        f.options = f:CreateGUI()
    end
    f:UnregisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", nil)
	
	
	if LortiDB then
        Lorti.playerFrameIndex = LortiDB.playerFrameIndex or 1
		Lorti.LortiTextureIndex = LortiDB.LortiTextureIndex or 1
		Lorti.fontIndex = LortiDB.fontIndex or 1
		playerFrameDo()
		SBTexturesDo()
		fontStyleDo()
	elseif Lorti.playerFrameIndex == nil then
		Lorti.playerFrameIndex = 1
		playerFrameDo()
	elseif Lorti.LortiTextureIndex == nil then
		Lorti.LortiTextureIndex = 1
		SBTexturesDo()
	elseif Lorti.fontIndex == nil then
		Lorti.fontIndex = 1
		fontStyleDo()
    else
        LortiDB = {}
		playerFrameDo()
		SBTexturesDo()
		fontStyleDo()
    end
end

--[[ local function SetButtonFont(button, fontPath, fontSize, fontFlags)
    if button and button.text then
        button.text:SetFont(fontPath, fontSize, fontFlags)
    end
end ]]

function f:CreateGUI()
    local Panel=CreateFrame("Frame", nil, InterfaceOptionsPanelContainer); 
	do
        Panel.name=Title;
        InterfaceOptions_AddCategory(Panel);--	Panel Registration

        local title=Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
		title:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE") 
        title:SetPoint("TOPLEFT", 230,-15);
        title:SetText(Title);
		title:SetTextColor(0.1, 1, 0.5, 1) 
		title:SetShadowColor(0, 0, 0) 
		title:SetShadowOffset(1, -1) 

	local Reload = CreateFrame("Button", nil, Panel, "UIPanelButtonTemplate")
	Reload:SetPoint("TOPLEFT", 480, -520)
	Reload:SetWidth(120)
	Reload:SetHeight(25)
	Reload:SetText("Save & Reload")
	Reload:SetScript(
		"OnClick",
		function(self, button, down)
			ReloadUI()
		end
	)
	
	local SeparatorTitle = Panel:CreateTexture(nil, "BACKGROUND")
	SeparatorTitle:SetSize(500, 1) -- Width of the panel, height of 1 pixel
	SeparatorTitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -170, -10)
	SeparatorTitle:SetColorTexture(0.3, 0.3, 0.3, 1) -- Gray color for the line
	
	local HotKeyButton = CheckBtn("Hide hotkeys", "Hide hotkeys on action bars", Panel, function(self, value)
            Lorti.keyhide = value
        end)
    HotKeyButton:SetPoint("TOPLEFT", SeparatorTitle, "BOTTOMLEFT", -10, -10)
	HotKeyButton:SetChecked(Lorti.keyhide)	
	-- SetButtonFont(HotKeyButton, "Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
	HotKeyButton.text:SetTextColor(1, 0.8, 0, 1)
	
    

    local StealthButton = CheckBtn("Stealth stance bar", "Disable stealth stance bar switching for rogues", Panel, function(self, value)
            Lorti.stealth = value
        end)
    StealthButton:SetPoint("TOPLEFT", HotKeyButton, "BOTTOMLEFT", 300, 27) 
	StealthButton:SetChecked(Lorti.stealth)
	StealthButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local MacroButton = CheckBtn("Hide macro text", "Hide macro text on action bars", Panel, function(self, value)
            Lorti.macrohide = value
        end)
    MacroButton:SetPoint("TOPLEFT", StealthButton, "BOTTOMLEFT", -300, 0) 
	MacroButton:SetChecked(Lorti.macrohide)
	MacroButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local SwitchtimerButton = CheckBtn("Default Buff timer position", "Use Blizzard's default Buff timer position on player's Buffs and Debuffs", Panel, function(self, value)
            Lorti.switchtimer = value
        end)
    SwitchtimerButton:SetPoint("TOPLEFT", MacroButton, "BOTTOMLEFT", 300, 27) 
	SwitchtimerButton:SetChecked(Lorti.switchtimer)
	SwitchtimerButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local GlossyButton = CheckBtn("Gloss on buttons", "Enable High Gloss on action bars buttons", Panel, function(self, value)
            Lorti.gloss = value
        end)
    GlossyButton:SetPoint("TOPLEFT", SwitchtimerButton, "BOTTOMLEFT", -300, 0) 
	GlossyButton:SetChecked(Lorti.gloss)
	GlossyButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local BigbuffButton = CheckBtn("Scale buffs and frames", "Change the scale of Player's BuffFrame/PartyFrames to 1.6, PlayerFrame/TargetFrame/FocusFrame to 1.3", Panel, function(self, value)
            Lorti.bigbuff = value
        end)
    BigbuffButton:SetPoint("TOPLEFT", GlossyButton, "BOTTOMLEFT", 300, 27) 
	BigbuffButton:SetChecked(Lorti.bigbuff)
	BigbuffButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local ClassBarsButton = CheckBtn("Class colored health bars", "Color the unit frames Health bars based on the class of the players", Panel, function(self, value)
            Lorti.classbars = value
        end)
    ClassBarsButton:SetPoint("TOPLEFT", BigbuffButton, "BOTTOMLEFT", -300, 0)
	ClassBarsButton:SetChecked(Lorti.classbars)
	ClassBarsButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local ThickFramesButton = CheckBtn("Thick Frames", "Thick Frames", Panel, function(self, value)
            Lorti.thickness = value
        end)
    ThickFramesButton:SetPoint("TOPLEFT", ClassBarsButton, "BOTTOMLEFT", 300, 27)
	ThickFramesButton:SetChecked(Lorti.thickness)
	ThickFramesButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local ColoredHPButton = CheckBtn("Red health bars", "Color in red the Health Bars for enemies players (if Class Health Bars is enabled)", Panel, function(self, value)
            Lorti.ColoredHP = value
        end)
    ColoredHPButton:SetPoint("TOPLEFT", ThickFramesButton, "BOTTOMLEFT", -300, 0)
	ColoredHPButton:SetChecked(Lorti.ColoredHP)
	ColoredHPButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local ClassPortraitsButton = CheckBtn("Class Portraits", "Enable Class Portraits on Target and Focus Frames", Panel, function(self, value)
            Lorti.ClassPortraits = value
        end)
    ClassPortraitsButton:SetPoint("TOPLEFT", ColoredHPButton, "BOTTOMLEFT", 300, 27)
	ClassPortraitsButton:SetChecked(Lorti.ClassPortraits)
	ClassPortraitsButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local HitindicatorButton = CheckBtn("Hide Hit indicator", "Hide PlayerFrame hit indicator", Panel, function(self, value)
            Lorti.hitindicator = value
        end)
    HitindicatorButton:SetPoint("TOPLEFT", ClassPortraitsButton, "BOTTOMLEFT", -300, 0)
	HitindicatorButton:SetChecked(Lorti.hitindicator)
	HitindicatorButton.text:SetTextColor(1, 0.8, 0, 1)
	
	 local ActionbarTextureButton = CheckBtn("Hide background", "Hide gryphons and actionbar, menu, bags background", Panel, function(self, value)
            Lorti.ActionbarTexture = value
        end)
    ActionbarTextureButton:SetPoint("TOPLEFT", HitindicatorButton, "BOTTOMLEFT", 300, 27)
	ActionbarTextureButton:SetChecked(Lorti.ActionbarTexture)
	ActionbarTextureButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local EnergyButton = CheckBtn("Energy/Mana ticks", "Enable Energy and/or Mana ticks or both if you are a druid", Panel, function(self, value)
            Lorti.energytick = value
        end)
    EnergyButton:SetPoint("TOPLEFT", ActionbarTextureButton, "BOTTOMLEFT", -300, 0)
	EnergyButton:SetChecked(Lorti.energytick)
	EnergyButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local PlayernameButton = CheckBtn("Hide player name", "Hide the name of the Player unit frame", Panel, function(self, value)
            Lorti.playername = value
        end)
    PlayernameButton:SetPoint("TOPLEFT", EnergyButton, "BOTTOMLEFT", 300, 27)
	PlayernameButton:SetChecked(Lorti.playername)
	PlayernameButton.text:SetTextColor(1, 0.8, 0, 1)
	
	--[[ local RaidBuffButton = CheckBtn("Raid Buffs", "Show all Buffs on Raid Frames, not only yours (Disable Party Buffs option to avoid conflict!)", Panel, function(self, value)
            Lorti.raidbuff = value
        end)
    RaidBuffButton:SetPoint("TOPLEFT", PlayernameButton, "BOTTOMLEFT", -300, 0)
	RaidBuffButton:SetChecked(Lorti.raidbuff)
	RaidBuffButton.text:SetTextColor(1, 0.8, 0, 1) ]]
	
	
	local Separator = Panel:CreateTexture(nil, "BACKGROUND")
	Separator:SetSize(500, 1) -- Width of the panel, height of 1 pixel
	Separator:SetPoint("TOPLEFT", EnergyButton, "BOTTOMLEFT", 10, -10)
	Separator:SetColorTexture(0.3, 0.3, 0.3, 1) -- Gray color for the line
	
	-- Player Frame Selector Title
    local playerFrameTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerFrameTitle:SetPoint("TOPLEFT", Separator, "BOTTOMLEFT", 30, -10) 
    playerFrameTitle:SetText("Player Frame Style:")
	
	CreateFrame("Button", "playerFrameSelect", Panel, "UIDropDownMenuTemplate")
	playerFrameSelect:ClearAllPoints()
	playerFrameSelect:SetPoint("TOPLEFT", playerFrameTitle, "BOTTOMLEFT", -40, -10) 

	local playerFrameList = {
		"Normal",
		"Elite",
		"Rare",
		"Rare Elite",
	}

	local function OnClick(self)
		UIDropDownMenu_SetSelectedID(playerFrameSelect, self:GetID())
        Lorti.playerFrameIndex = self:GetID()
        LortiDB.playerFrameIndex = Lorti.playerFrameIndex
        playerFrameDo(self)
	end
	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(playerFrameList) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = k
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end
	UIDropDownMenu_Initialize(playerFrameSelect, initialize)
	UIDropDownMenu_SetWidth(playerFrameSelect, 150);
	UIDropDownMenu_SetButtonWidth(playerFrameSelect, 170)
	UIDropDownMenu_JustifyText(playerFrameSelect, "LEFT")
	-- Set the default selection based on saved variables
		if Lorti.playerFrameIndex then
			UIDropDownMenu_SetSelectedID(playerFrameSelect, Lorti.playerFrameIndex)
		else
			UIDropDownMenu_SetSelectedID(playerFrameSelect, 1)
		end
	
	
	-- Add a label for the font selector
	local fontLabel = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	fontLabel:SetPoint("TOPLEFT", playerFrameSelect, "BOTTOMLEFT", 400, 54)
	fontLabel:SetText("Font select:")

	-- Create the dropdown menu for fonts.
	CreateFrame("Button", "fontSelector", Panel, "UIDropDownMenuTemplate")
	fontSelector:ClearAllPoints()
	fontSelector:SetPoint("TOPLEFT", fontLabel, "BOTTOMLEFT", -40, -10)

	local fontList = {
		"Accidental Presidency",
		"Action_Man",
		"BigNoodleTitling",
		"CalibriBold",
		"Continuum",
		"Continuum_Medium",
		"DejaVuLGCSans",
		"DieDieDie",
		"DorisPP",
		"Expressway",
		"Favourite",
		"Friz-Quadrata",
		"FuturaPTBold",
		"HarryPotter",
		"Homespun",
		"Hooge",
		"Myriad-Pro",
		"Prototype",
		"PT-Sans-Narrow-Bold",
		"PT-Sans-Narrow-Regular",
		"RobotoMono",
		"SFCovington",
		}

	local function OnFontClick(self)
		UIDropDownMenu_SetSelectedID(fontSelector, self:GetID())
		Lorti.fontIndex = self:GetID()
		LortiDB.fontIndex = Lorti.fontIndex
	
		if Lorti.fontIndex == 1 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\Accidental Presidency.ttf"
		elseif Lorti.fontIndex == 2 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\Action_Man.ttf"
		elseif Lorti.fontIndex == 3 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\BigNoodleTitling.ttf"
		elseif Lorti.fontIndex == 4 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\CalibriBold.ttf"
		elseif Lorti.fontIndex == 5 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\Continuum.ttf"
		elseif Lorti.fontIndex == 6 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\Continuum_Medium.ttf"
		elseif Lorti.fontIndex == 7 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\DejaVuLGCSans.ttf"
		elseif Lorti.fontIndex == 8 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\DieDieDie.ttf"
		elseif Lorti.fontIndex == 9 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\DorisPP.ttf"
		elseif Lorti.fontIndex == 10 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\Expressway.ttf"
		elseif Lorti.fontIndex == 11 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\Favourite.ttf"
		elseif Lorti.fontIndex == 12 then
			Lorti.fontFamily = "Fonts\\FRIZQT__.TTF"
		elseif Lorti.fontIndex == 13 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\FuturaPTBold.ttf"
		elseif Lorti.fontIndex == 14 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\HarryPotter.ttf"
		elseif Lorti.fontIndex == 15 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\Homespun.ttf"
		elseif Lorti.fontIndex == 16 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\Hooge.ttf"
		elseif Lorti.fontIndex == 17 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\Myriad-Pro.ttf"
		elseif Lorti.fontIndex == 18 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\Prototype.ttf"
		elseif Lorti.fontIndex == 19 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\PT-Sans-Narrow-Bold.ttf"
		elseif Lorti.fontIndex == 20 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\PT-Sans-Narrow-Regular.ttf"
		elseif Lorti.fontIndex == 21 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\RobotoMono.ttf"
		elseif Lorti.fontIndex == 22 then
			Lorti.fontFamily = "Interface\\Addons\\Lorti-UI-Classic\\textures\\font\\SFCovington.ttf"
		end
		fontStyleDo()  -- apply the new font style
	end

	local function FontInitialize(self, level)
    local selectedID = UIDropDownMenu_GetSelectedID(fontSelector) or 1
    for k, v in ipairs(fontList) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = v
        info.value = k
        info.func = OnFontClick
        info.checked = (k == selectedID)  -- Only the button with index equal to the selected ID is checked
        UIDropDownMenu_AddButton(info, level)
    end
end


	UIDropDownMenu_Initialize(fontSelector, FontInitialize)
	UIDropDownMenu_SetWidth(fontSelector, 100)
	UIDropDownMenu_JustifyText(fontSelector, "LEFT")
	UIDropDownMenu_SetButtonWidth(fontSelector, 124)
	if not UIDropDownMenu_GetSelectedID(fontSelector) then
		UIDropDownMenu_SetSelectedID(fontSelector, 1)
	end
	UIDropDownMenu_SetSelectedID(fontSelector, Lorti.fontIndex or 1)

	
	-- Status Bar Texture Selector Title
	local statusBarTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	statusBarTitle:SetPoint("TOPLEFT", playerFrameSelect, "BOTTOMLEFT", 220, 54) 
	statusBarTitle:SetText("Status Bar Texture:")

	-- Create the dropdown menu
	CreateFrame("Button", "statusBarSelect", Panel, "UIDropDownMenuTemplate")
	statusBarSelect:ClearAllPoints()
	statusBarSelect:SetPoint("TOPLEFT", statusBarTitle, "BOTTOMLEFT", -40, -10)

	local statusBarTextures = {
		"Whoa",
		"Blizzard",
		"65%",
		"Ace",
		"Aluminium",
		"Banto",
		"Cracked",
		"Glaze",
		"Lite Step",
		"Metal",
		"Neon",
		"Otravi",
		"Perl",
		"Shiny",
		"Smooth",
		"Striped",
		"Swag",
		"flat",
		"elvui",
		"gradient",
		"tukui",
		"blinkii",
		"kuinameplate",
		"smoothv2",
		"ToxiUI-dark",
		"Wglass",
		"flat2",
	}

	local function OnClick(self)
    UIDropDownMenu_SetSelectedID(statusBarSelect, self:GetID())
    Lorti.LortiTextureIndex = self:GetID()
    LortiDB.LortiTextureIndex = Lorti.LortiTextureIndex

    if Lorti.LortiTextureIndex == 1 then
        Lorti.SBTextureName = "whoa";
    elseif Lorti.LortiTextureIndex == 2 then
        Lorti.SBTextureName = "blizzard";
    elseif Lorti.LortiTextureIndex == 3 then
        Lorti.SBTextureName = "65";
    elseif Lorti.LortiTextureIndex == 4 then
        Lorti.SBTextureName = "ace";
    elseif Lorti.LortiTextureIndex == 5 then
        Lorti.SBTextureName = "aluminium";
    elseif Lorti.LortiTextureIndex == 6 then
        Lorti.SBTextureName = "banto";
    elseif Lorti.LortiTextureIndex == 7 then
        Lorti.SBTextureName = "cracked";
    elseif Lorti.LortiTextureIndex == 8 then
        Lorti.SBTextureName = "glaze";
    elseif Lorti.LortiTextureIndex == 9 then
        Lorti.SBTextureName = "liteStep";
    elseif Lorti.LortiTextureIndex == 10 then
        Lorti.SBTextureName = "metal";
    elseif Lorti.LortiTextureIndex == 11 then
        Lorti.SBTextureName = "neon";
    elseif Lorti.LortiTextureIndex == 12 then
        Lorti.SBTextureName = "otravi";
    elseif Lorti.LortiTextureIndex == 13 then
        Lorti.SBTextureName = "perl";
    elseif Lorti.LortiTextureIndex == 14 then
        Lorti.SBTextureName = "shiny";
    elseif Lorti.LortiTextureIndex == 15 then
        Lorti.SBTextureName = "smooth";
    elseif Lorti.LortiTextureIndex == 16 then
        Lorti.SBTextureName = "striped";
    elseif Lorti.LortiTextureIndex == 17 then
        Lorti.SBTextureName = "swag";
	elseif Lorti.LortiTextureIndex == 18 then
		Lorti.SBTextureName = "flat";
	elseif Lorti.LortiTextureIndex == 19 then
		Lorti.SBTextureName = "elvui";
	elseif Lorti.LortiTextureIndex == 20 then
		Lorti.SBTextureName = "gradient";
	elseif Lorti.LortiTextureIndex == 21 then
		Lorti.SBTextureName = "tukui";
	elseif Lorti.LortiTextureIndex == 22 then
		Lorti.SBTextureName = "blinkii";
	elseif Lorti.LortiTextureIndex == 23 then
		Lorti.SBTextureName = "kuinameplate";
	elseif Lorti.LortiTextureIndex == 24 then
		Lorti.SBTextureName = "smoothv2";
	elseif Lorti.LortiTextureIndex == 25 then
		Lorti.SBTextureName = "ToxiUI-dark";
	elseif Lorti.LortiTextureIndex == 26 then
		Lorti.SBTextureName = "Wglass";
	elseif Lorti.LortiTextureIndex == 27 then
		Lorti.SBTextureName = "flat2";
    end

    SBTexturesDo(self)
end
	local function initialize(self, level)
    local info = UIDropDownMenu_CreateInfo()
    for k, v in pairs(statusBarTextures) do
        info = UIDropDownMenu_CreateInfo()
        info.text = v
        info.value = k
        info.func = OnClick
        UIDropDownMenu_AddButton(info, level)
    end
	
end

	UIDropDownMenu_Initialize(statusBarSelect, initialize)
	UIDropDownMenu_SetWidth(statusBarSelect, 150)
	UIDropDownMenu_SetButtonWidth(statusBarSelect, 170)
	UIDropDownMenu_JustifyText(statusBarSelect, "LEFT")

	-- Set the default selection based on saved variables
	if Lorti.LortiTextureIndex then
		UIDropDownMenu_SetSelectedID(statusBarSelect, Lorti.LortiTextureIndex)
	else
		UIDropDownMenu_SetSelectedID(statusBarSelect, 1)
	end
	
	-- Name Size
	local StringSizeTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	StringSizeTitle:SetPoint("TOPLEFT", playerFrameSelect, "BOTTOMLEFT", 70, -15)
	StringSizeTitle:SetText("Name Text Font Size:")
	
	local name = "StringSizeSlider"
        local template = "OptionsSliderTemplate"
        local StringSizeSlider = CreateFrame("Slider", name, Panel, template)
        StringSizeSlider:SetPoint("TOPLEFT", StringSizeTitle, "BOTTOMLEFT", -10, -17)
        StringSizeSlider.textLow = _G[name.."Low"]
        StringSizeSlider.textHigh = _G[name.."High"]
        StringSizeSlider.text = _G[name.."Text"]
        StringSizeSlider:SetMinMaxValues(8, 16)
        StringSizeSlider.minValue, StringSizeSlider.maxValue = StringSizeSlider:GetMinMaxValues()
        StringSizeSlider.textLow:SetText(StringSizeSlider.minValue)
        StringSizeSlider.textHigh:SetText(StringSizeSlider.maxValue)
        StringSizeSlider:SetValue(Lorti.StringSize)
        StringSizeSlider.text:SetText("Size: "..StringSizeSlider:GetValue(Lorti.StringSize))
        StringSizeSlider:SetValueStep(1)
        StringSizeSlider:SetObeyStepOnDrag(true);
        StringSizeSlider:SetScript("OnValueChanged", function(self,event,arg1)
            StringSizeSlider.text:SetText("Size: "..StringSizeSlider:GetValue(Lorti.StringSize))
            Lorti.StringSize = StringSizeSlider:GetValue()
            ApplyFonts()
        end)
	
	-- Numerical size
	local NumSizeTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	NumSizeTitle:SetPoint("TOPLEFT", StringSizeTitle, "BOTTOMLEFT", 230, 12)
	NumSizeTitle:SetText("Numericals Text Font Size:")
	
	local name = "NumSizeSlider"
        local template = "OptionsSliderTemplate"
        local NumSizeSlider = CreateFrame("Slider", name, Panel, template)
        NumSizeSlider:SetPoint("TOPLEFT", NumSizeTitle, "BOTTOMLEFT", -10, -17)
        NumSizeSlider.textLow = _G[name.."Low"]
        NumSizeSlider.textHigh = _G[name.."High"]
        NumSizeSlider.text = _G[name.."Text"]
        NumSizeSlider:SetMinMaxValues(8, 16)
        NumSizeSlider.minValue, NumSizeSlider.maxValue = NumSizeSlider:GetMinMaxValues()
        NumSizeSlider.textLow:SetText(NumSizeSlider.minValue)
        NumSizeSlider.textHigh:SetText(NumSizeSlider.maxValue)
        NumSizeSlider:SetValue(Lorti.NumSize)
        NumSizeSlider.text:SetText("Size: "..NumSizeSlider:GetValue(Lorti.NumSize))
        NumSizeSlider:SetValueStep(1)
        NumSizeSlider:SetObeyStepOnDrag(true);
        NumSizeSlider:SetScript("OnValueChanged", function(self,event,arg1)
            NumSizeSlider.text:SetText("Size: "..NumSizeSlider:GetValue(Lorti.NumSize))
            Lorti.NumSize = NumSizeSlider:GetValue()
            ApplyFonts()
        end)
	
		-- Frames centering / restore.

		-- Create a font string for the positioning options title.
		local positionOptions = Panel:CreateFontString("mainOptions", "OVERLAY", "GameFontNormal")
		positionOptions:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
		positionOptions:SetText("Positioning options:")
		positionOptions:SetPoint("TOPLEFT", Separator, "BOTTOMLEFT", 150, -160)

		-- Create a font string for additional info.
		local centerBttnInfo = Panel:CreateFontString("centerBttnInfo", "OVERLAY", "GameFontNormal")
		centerBttnInfo:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
		centerBttnInfo:SetText("Center player and target frames middle screen.")
		centerBttnInfo:SetPoint("TOPLEFT", positionOptions, "BOTTOMLEFT", -60, -10)

		-- Create the "Center frames" button.
		local centerBttn = CreateFrame("Button", "centerButton", Panel, "UIPanelButtonTemplate")
		centerBttn:SetSize(100, 25)
		centerBttn:SetText("Center frames")
		centerBttn:SetPoint("TOPLEFT", centerBttnInfo, "BOTTOMLEFT", 30, -10)
		centerBttn:SetScript("OnClick", function()
		local x, y = -20, -150
			for i, f in ipairs({PlayerFrame, TargetFrame}) do
				f:ClearAllPoints()
				f:SetPoint(i == 1 and "RIGHT" or "LEFT", UIParent, "CENTER", i == 1 and x or -x, y)
				f:SetUserPlaced(true)
			end
		end)

		-- Create the "Reset frames" button.
		local resetBttn = CreateFrame("Button", "resetButton", Panel, "UIPanelButtonTemplate")
		resetBttn:SetSize(100, 25)
		resetBttn:SetText("Reset frames")
		resetBttn:SetPoint("TOPLEFT", centerBttn, "BOTTOMLEFT", 120, 25)
		resetBttn:SetScript("OnClick", function()
		PlayerFrame_ResetUserPlacedPosition()
		TargetFrame_ResetUserPlacedPosition()
		end)

	
	end
	return Panel
end

function playerFrameDo()
	local frameType;
	if Lorti.playerFrameIndex == 1 then
		frameType = "UI-TargetingFrame";
	elseif Lorti.playerFrameIndex == 2 then
		frameType = "Elite"
	elseif Lorti.playerFrameIndex == 3 then
		frameType = "Rare"
	elseif Lorti.playerFrameIndex == 4 then
		frameType = "Rare-Elite"
	else
		frameType = "UI-TargetingFrame";
	end
	if Lorti.thickness then
        PlayerFrameTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\target\\Thick-"..frameType);
    else
        PlayerFrameTexture:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\target\\"..frameType);
    end
end

function SBTexturesDo()
	-- print("SBTextureName:", Lorti.SBTextureName) -- Debug statement
	for i, v in pairs ({ PlayerFrameHealthBar, PlayerFrameManaBar, PlayerFrameHealthBar.AnimatedLossBar, PlayerFrameAlternateManaBar,
		TargetFrameHealthBar, TargetFrameManaBar, TargetFrameToTHealthBar,
		-- TargetFrameNameBackground,
		PetFrameHealthBar, PetFrameManaBar, 
		FocusFrameHealthBar, FocusFrameManaBar, FocusFrameToTHealthBar, 
		MirrorTimer1StatusBar, MirrorTimer2StatusBar, MirrorTimer3StatusBar, GameTooltipStatusBar, ReputationWatchBar.StatusBar, MainMenuExpBar, CastingBarFrame	}) do
		v:SetStatusBarTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\statusbar\\"..Lorti.SBTextureName); end
	for i, v in pairs ({ PlayerFrameMyHealPredictionBar, }) do
		v:SetTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\statusbar\\"..Lorti.SBTextureName); end
	for i = 1, 4 do
		if _G["PartyMemberFrame"..i] then
			_G["PartyMemberFrame"..i.."HealthBar"]:SetStatusBarTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\statusbar\\"..Lorti.SBTextureName);
			_G["PartyMemberFrame"..i.."ManaBar"]:SetStatusBarTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\statusbar\\"..Lorti.SBTextureName)
		end
		if _G["CompactRaidFrame" .. i] then
			_G["CompactRaidFrame"..i.."HealthBar"]:SetStatusBarTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\statusbar\\"..Lorti.SBTextureName);
			_G["CompactRaidFrame"..i.."PowerBar"]:SetStatusBarTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\statusbar\\"..Lorti.SBTextureName)
		end
	end
	function LortiUIManaTexture (manaBar)
			local powerType, powerToken, altR, altG, altB = UnitPowerType(manaBar.unit);
			local info = PowerBarColor[powerToken];
			if ( info ) then
				if ( not manaBar.lockColor ) then
						manaBar:SetStatusBarTexture("Interface\\Addons\\Lorti-UI-Classic\\textures\\statusbar\\"..Lorti.SBTextureName);
				end
			end
		end
		hooksecurefunc("UnitFrameManaBar_UpdateType", LortiUIManaTexture)
		
	if CompactRaidFrameContainer_AddUnitFrame then
		hooksecurefunc("CompactRaidFrameContainer_AddUnitFrame", function(unitFrame)
			if unitFrame and unitFrame.HealthBar then
				unitFrame.HealthBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\statusbar\\" .. Lorti.SBTextureName)
			end
			if unitFrame and unitFrame.PowerBar then
				unitFrame.PowerBar:SetStatusBarTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\statusbar\\" .. Lorti.SBTextureName)
			end
		end)
	end

end

function fontStyleDo()
    local newFont = Lorti.fontFamily
    if not newFont then
        newFont = "Fonts\\FRIZQT__.TTF"  -- fallback font if needed
    end
    -- List the frames you want to update
    local framesToUpdate = {
        PlayerFrameHealthBarText,
        PlayerFrameHealthBarTextLeft,
        PlayerFrameHealthBarTextRight,
        PlayerFrameManaBarTextLeft,
        PlayerFrameManaBarTextRight,
        PlayerFrameManaBarText,
        TargetFrameTextureFrame.HealthBarText,
        TargetFrameTextureFrame.HealthBarTextLeft,
        TargetFrameTextureFrame.HealthBarTextRight,
        TargetFrameTextureFrame.ManaBarText,
        TargetFrameTextureFrame.ManaBarTextLeft,
        TargetFrameTextureFrame.ManaBarTextRight,
		TargetFrameSpellBar,
        FocusFrameTextureFrame.HealthBarText,
        FocusFrameTextureFrame.HealthBarTextLeft,
        FocusFrameTextureFrame.HealthBarTextRight,
        FocusFrameTextureFrame.ManaBarText,
        FocusFrameTextureFrame.ManaBarTextLeft,
        FocusFrameTextureFrame.ManaBarTextRight,
		FocusFrameSpellBar,
        PetFrameHealthBarText,
        PetFrameHealthBarTextLeft,
        PetFrameHealthBarTextRight,
        PetFrameManaBarText,
        PetFrameManaBarTextLeft,
        PetFrameManaBarTextRight,
    }

    for _, frame in ipairs(framesToUpdate) do
        if frame and frame.GetFont then
            local currentFont, currentSize, currentFlags = frame:GetFont()
            -- Reapply using the new font family but keep the same size and flags
            frame:SetFont(newFont, currentSize, currentFlags)
        end
    end
	
	-- Update party member name frames
    for i = 1, 4 do
        local partyNameFrame = _G["PartyMemberFrame" .. i .. "Name"]
        if partyNameFrame and partyNameFrame.GetFont then
            local currentFont, currentSize, currentFlags = partyNameFrame:GetFont()
            partyNameFrame:SetFont(newFont, currentSize, currentFlags)
        end
    end

    -- Update raid frame name fields using the container’s unitFrames
    if CompactRaidFrameContainer and CompactRaidFrameContainer.unitFrames then
        for _, unitFrame in ipairs(CompactRaidFrameContainer.unitFrames) do
            if unitFrame.Name and unitFrame.Name.GetFont then
                local currentFont, currentSize, currentFlags = unitFrame.Name:GetFont()
                unitFrame.Name:SetFont(newFont, currentSize, currentFlags)
            end
        end
    else
        -- Fallback: loop over a fixed range (if for some reason unitFrames isn’t available)
        for i = 1, 40 do
            local raidNameFrame = _G["CompactRaidFrame" .. i .. "Name"]
            if raidNameFrame and raidNameFrame.GetFont then
                local currentFont, currentSize, currentFlags = raidNameFrame:GetFont()
                raidNameFrame:SetFont(newFont, currentSize, currentFlags)
            end
        end
    end
	
	if CompactRaidFrameContainer_Update then
    hooksecurefunc("CompactRaidFrameContainer_Update", function()
        fontStyleDo()
    end)
end
end

