local LibStub = _G.LibStub
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")

local Name, ns = ...;
local Title = select(2,GetAddOnInfo(Name)):gsub("%s*v?[%d%.]+$","");
local cfg = ns.cfg

local customFontPath = "Fonts\\FRIZQT__.TTF"
local customFontSize = 12
local customFontFlags = "OUTLINE"

Lorti = { keyhide, macrohide, stealth, switchtimer, gloss, bigbuff, thickness, classbars, ClassPortraits, playerClassPortraits, classPortraitSet, playerClassPortraitSet, energytick, raidbuff, ColoredHP, ActionbarTexture, hitindicator, playername, playerFrameIndex, LortiTextureIndex, fontIndex, rangecolor, keypress, numerical, arenaframe, frameScale, partyFrameScale, fadeOutOfRange, spellqueue, applyblackborder }

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
	playerClassPortraits = true,
    energytick = false,
	raidbuff = false,
    ActionbarTexture = false,
    hitindicator = false,
    playername = false,
    playerFrameIndex = 1,
	LortiTextureIndex = 27,
	fontIndex = 12,
	classPortraitSet = 1,
	playerClassPortraitSet = 1,
	rangecolor = true,
	keypress = false,
	numerical = false,
	arenaframe = false,
	frameScale = 1.0,
	partyFrameScale = 1.0,
	fadeOutOfRange = true,
	spellqueue = false,
	applyblackborder = false,
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

-- Helper function to add tooltips to sliders
local function AddTooltipToSlider(slider, tooltipText)
    slider:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltipText, 1, 0.8, 0.3) -- Yellowish color for tooltips
        GameTooltip:Show()
    end)

    slider:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
end

-- Helper function to add tooltips to disabled buttons
local function AddTooltipToDisabledButton(button, tooltipText)
    -- Create an invisible frame to handle tooltips
    local tooltipFrame = CreateFrame("Frame", nil, button)
    tooltipFrame:SetAllPoints(button) -- Match the size and position of the button
    tooltipFrame:EnableMouse(true) -- Enable mouse interaction

    -- Add OnEnter and OnLeave scripts for tooltips
    tooltipFrame:SetScript("OnEnter", function(self)
        if not button:IsEnabled() then -- Only show tooltip if the button is disabled
            GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
            GameTooltip:SetText(tooltipText, 1, 0.8, 0.3) -- Yellowish color for tooltips
            GameTooltip:Show()
        end
    end)

    tooltipFrame:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    -- Store the tooltip frame in the button for future reference
    button.tooltipFrame = tooltipFrame
end

-- Helper function to remove tooltips when the button is enabled
local function RemoveTooltipFromButton(button)
    if button.tooltipFrame then
        button.tooltipFrame:SetScript("OnEnter", nil)
        button.tooltipFrame:SetScript("OnLeave", nil)
        button.tooltipFrame:EnableMouse(false) -- Disable mouse interaction
    end
end

local function UpdateClassPortraitDropdown()
    if Lorti.ClassPortraits then
        LibDD:UIDropDownMenu_EnableDropDown(classPortraitSelect)
    else
        LibDD:UIDropDownMenu_DisableDropDown(classPortraitSelect)
    end
	if Lorti.playerClassPortraits then
		LibDD:UIDropDownMenu_EnableDropDown(playerClassPortraitSelect)
    else
        LibDD:UIDropDownMenu_DisableDropDown(playerClassPortraitSelect)
    end
end

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
	
	if Lorti.frameScale == nil then
		Lorti.frameScale = 1.0
	end
	
	if Lorti.partyFrameScale == nil then
		Lorti.partyFrameScale = 1.0
	end
	
	if not Lorti.classPortraitSet then
        Lorti.classPortraitSet = 1
    end
	if not Lorti.playerClassPortraitSet then
        Lorti.playerClassPortraitSet = 1
    end
    if not f.options then
        f.options = f:CreateGUI()
    end
	
	
	UpdateClassPortraitDropdown()
	
    f:UnregisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", nil)
	
	
	-- Apply saved scales
    PlayerFrame:SetScale(Lorti.frameScale or 1.0)
    TargetFrame:SetScale(Lorti.frameScale or 1.0)
    FocusFrame:SetScale(Lorti.frameScale or 1.0)
	ComboFrame:SetScale(Lorti.frameScale or 1.0)
	
	-- Apply party frame scale
    for i = 1, 4 do
        local frame = _G["PartyMemberFrame" .. i]
        if frame then
            frame:SetScale(Lorti.partyFrameScale or 1.0)
        end
    end
	
	if LortiDB then
        Lorti.playerFrameIndex = LortiDB.playerFrameIndex or 1
		Lorti.LortiTextureIndex = LortiDB.LortiTextureIndex or 1
		Lorti.fontIndex = LortiDB.fontIndex or 1
		Lorti.classPortraitSet = LortiDB.classPortraitSet or 1
		Lorti.playerClassPortraitSet = LortiDB.playerClassPortraitSet or 1
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
	elseif Lorti.classPortraitSet == nil then
		Lorti.classPortraitSet = 1
	elseif Lorti.playerClassPortraitSet == nil then
		Lorti.playerClassPortraitSet = 1	
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
	SeparatorTitle:SetSize(600, 1) -- Width of the panel, height of 1 pixel
	SeparatorTitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -220, -10)
	SeparatorTitle:SetColorTexture(0.3, 0.3, 0.3, 1) -- Gray color for the line
	
	local ActionBarTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    ActionBarTitle:SetPoint("TOPLEFT", SeparatorTitle, "BOTTOMLEFT", 40, -10) 
    ActionBarTitle:SetText("Action Bar:")
	ActionBarTitle:SetTextColor(0, 0.8, 1, 1)
	
	local HotKeyButton = CheckBtn("Hide hotkeys", "Hide hotkeys on action bars", Panel, function(self, value)
            Lorti.keyhide = value
        end)
    HotKeyButton:SetPoint("TOPLEFT", ActionBarTitle, "BOTTOMLEFT", -25, -5)
	HotKeyButton:SetChecked(Lorti.keyhide)	
	-- SetButtonFont(HotKeyButton, "Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
	HotKeyButton.text:SetTextColor(1, 0.8, 0, 1)

    local StealthButton = CheckBtn("Stealth stance bar", "Disable stealth stance bar switching for rogues", Panel, function(self, value)
            Lorti.stealth = value
        end)
    StealthButton:SetPoint("TOPLEFT", HotKeyButton, "BOTTOMLEFT", 200, 27) 
	StealthButton:SetChecked(Lorti.stealth)
	StealthButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local MacroButton = CheckBtn("Hide macro text", "Hide macro text on action bars", Panel, function(self, value)
            Lorti.macrohide = value
        end)
    MacroButton:SetPoint("TOPLEFT", StealthButton, "BOTTOMLEFT", 200, 27) 
	MacroButton:SetChecked(Lorti.macrohide)
	MacroButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local GlossyButton = CheckBtn("Gloss on buttons", "Enable High Gloss on action bars buttons", Panel, function(self, value)
            Lorti.gloss = value
        end)
    GlossyButton:SetPoint("TOPLEFT", MacroButton, "BOTTOMLEFT", -400, 0)
	GlossyButton:SetChecked(Lorti.gloss)
	GlossyButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local ActionbarTextureButton = CheckBtn("Hide background", "Hide gryphons and actionbar, menu, bags background", Panel, function(self, value)
            Lorti.ActionbarTexture = value
        end)
    ActionbarTextureButton:SetPoint("TOPLEFT", GlossyButton, "BOTTOMLEFT", 200, 27)
	ActionbarTextureButton:SetChecked(Lorti.ActionbarTexture)
	ActionbarTextureButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local RangecolorButton = CheckBtn("Range Color", "Color your action buttons when out of range or out of mana", Panel, function(self, value)
            Lorti.rangecolor = value
        end)
    RangecolorButton:SetPoint("TOPLEFT", ActionbarTextureButton, "BOTTOMLEFT", 200, 27)
	RangecolorButton:SetChecked(Lorti.rangecolor)
	RangecolorButton.text:SetTextColor(1, 0.8, 0, 1)
	
	
	local KeypressButton = CheckBtn("Cast on key down", "Enable cast spells when you press on your keyboard instead of when you release it", Panel, function(self, value)
            Lorti.keypress = value
        end)
    KeypressButton:SetPoint("TOPLEFT", RangecolorButton, "BOTTOMLEFT", -400, 0)
	KeypressButton:SetChecked(Lorti.keypress)
	KeypressButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local SpellQueueButton = CheckBtn("Spell Queue Window", "Adjust Spell Queue value based on current latency", Panel, function(self, value)
            Lorti.spellqueue = value
        end)
    SpellQueueButton:SetPoint("TOPLEFT", KeypressButton, "BOTTOMLEFT", 200, 27)
	SpellQueueButton:SetChecked(Lorti.spellqueue)
	SpellQueueButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local SeparatorActionBar = Panel:CreateTexture(nil, "BACKGROUND")
	SeparatorActionBar:SetSize(600, 1) 
	SeparatorActionBar:SetPoint("TOPLEFT", KeypressButton, "BOTTOMLEFT", -15, -5)
	SeparatorActionBar:SetColorTexture(0.3, 0.3, 0.3, 1) 
	
	local UnitFrameTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    UnitFrameTitle:SetPoint("TOPLEFT", SeparatorActionBar, "BOTTOMLEFT", 35, -10) 
    UnitFrameTitle:SetText("Unit Frames:")
	UnitFrameTitle:SetTextColor(0, 0.8, 1, 1)
	
	local ThickFramesButton = CheckBtn("Thick Frames", "Thick Frames", Panel, function(self, value)
            Lorti.thickness = value
        end)
    ThickFramesButton:SetPoint("TOPLEFT", UnitFrameTitle, "BOTTOMLEFT", -20, -5)
	ThickFramesButton:SetChecked(Lorti.thickness)
	ThickFramesButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local ColoredHPButton
	local ClassBarsButton = CheckBtn("Class health bars", "Color the unit frames Health bars based on the class of the players", Panel, function(self, value)
            Lorti.classbars = value
			Lorti.ColoredHP = false
			if value then
				ColoredHPButton:Enable() 
				ColoredHPButton.text:SetTextColor(1, 0.8, 0, 1) 
				RemoveTooltipFromButton(ColoredHPButton)
			else
				ColoredHPButton:Disable() 
				ColoredHPButton:SetChecked(false)
				ColoredHPButton.text:SetTextColor(0.5, 0.5, 0.5, 1) 
				AddTooltipToDisabledButton(ColoredHPButton, "Color in red the Health Bars for enemy players (if Class Health Bars is enabled)")
			end
        end)
    ClassBarsButton:SetPoint("TOPLEFT", ThickFramesButton, "BOTTOMLEFT", 200, 27)
	ClassBarsButton:SetChecked(Lorti.classbars)
	ClassBarsButton.text:SetTextColor(1, 0.8, 0, 1)
	
	ColoredHPButton = CheckBtn("Red health bars", "Color in red the Health Bars for enemy players (if Class Health Bars is enabled)", Panel, function(self, value)
            if not Lorti.classbars then
				-- Prevent ColoredHPButton from being checked if ClassBarsButton is not enabled
				self:SetChecked(false)
				return
			end
			Lorti.ColoredHP = value
        end)
    ColoredHPButton:SetPoint("TOPLEFT", ClassBarsButton, "BOTTOMLEFT", 200, 27)
	ColoredHPButton:SetChecked(Lorti.ColoredHP)
	ColoredHPButton.text:SetTextColor(1, 0.8, 0, 1)
	-- Initial update of button states
	if Lorti.classbars then
		ClassBarsButton:SetChecked(true)
		ColoredHPButton:Enable()
		ColoredHPButton.text:SetTextColor(1, 0.8, 0, 1)
		RemoveTooltipFromButton(ColoredHPButton)
	else
		ClassBarsButton:SetChecked(false)
		ColoredHPButton:Disable()
		ColoredHPButton:SetChecked(false)
		ColoredHPButton.text:SetTextColor(0.5, 0.5, 0.5, 1)
		AddTooltipToDisabledButton(ColoredHPButton, "Color in red the Health Bars for enemy players (if Class Health Bars is enabled)")
	end
	
	local PlayerClassPortraitsButton = CheckBtn("Player Class Portrait", "Enable Class Portrait for the Player Frame only", Panel, function(self, value)
            Lorti.playerClassPortraits = value
			UpdateClassPortraitDropdown()
        end)
    PlayerClassPortraitsButton:SetPoint("TOPLEFT", ColoredHPButton, "BOTTOMLEFT", -400, 0)
	PlayerClassPortraitsButton:SetChecked(Lorti.playerClassPortraits)
	PlayerClassPortraitsButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local ClassPortraitsButton = CheckBtn("Other Class Portraits", "Enable Class Portraits on Target, Focus and Party Frames", Panel, function(self, value)
            Lorti.ClassPortraits = value
			UpdateClassPortraitDropdown()
        end)
    ClassPortraitsButton:SetPoint("TOPLEFT", PlayerClassPortraitsButton, "BOTTOMLEFT", 0, 0)
	ClassPortraitsButton:SetChecked(Lorti.ClassPortraits)
	ClassPortraitsButton.text:SetTextColor(1, 0.8, 0, 1)
	
	
	
	local HitindicatorButton = CheckBtn("Hide Hit indicator", "Hide PlayerFrame hit indicator", Panel, function(self, value)
            Lorti.hitindicator = value
        end)
    HitindicatorButton:SetPoint("TOPLEFT", ClassPortraitsButton, "BOTTOMLEFT", 0, -5)
	HitindicatorButton:SetChecked(Lorti.hitindicator)
	HitindicatorButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local PlayernameButton = CheckBtn("Hide player name", "Hide the name of the Player unit frame", Panel, function(self, value)
            Lorti.playername = value
        end)
    PlayernameButton:SetPoint("TOPLEFT", HitindicatorButton, "BOTTOMLEFT", 200, 27)
	PlayernameButton:SetChecked(Lorti.playername)
	PlayernameButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local NumericalButton = CheckBtn("Shorten numeric value", "Display current health instead of current health/max health, and shorten NUMERIC HP to one decimal", Panel, function(self, value)
            Lorti.numerical = value
        end)
    NumericalButton:SetPoint("TOPLEFT", PlayernameButton, "BOTTOMLEFT", 200, 27)
	NumericalButton:SetChecked(Lorti.numerical)
	NumericalButton.text:SetTextColor(1, 0.8, 0, 1) 
	
	local EnergyButton = CheckBtn("Energy/Mana ticks", "Enable Energy and/or Mana ticks or both if you are a druid", Panel, function(self, value)
            Lorti.energytick = value
        end)
    EnergyButton:SetPoint("TOPLEFT", HitindicatorButton, "BOTTOMLEFT", 0, 0)
	EnergyButton:SetChecked(Lorti.energytick)
	EnergyButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local ApplyblackButton = CheckBtn("Black borders", "Apply black border on all frames, recommended if you don't use blp files, but i advice you the blp files.", Panel, function(self, value)
            Lorti.applyblackborder = value
        end)
    ApplyblackButton:SetPoint("TOPLEFT", EnergyButton, "BOTTOMLEFT", 200, 27)
	ApplyblackButton:SetChecked(Lorti.applyblackborder)
	ApplyblackButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local SeparatorUnitFrames = Panel:CreateTexture(nil, "BACKGROUND")
	SeparatorUnitFrames:SetSize(600, 1) 
	SeparatorUnitFrames:SetPoint("TOPLEFT", EnergyButton, "BOTTOMLEFT", -15, -110)
	SeparatorUnitFrames:SetColorTexture(0.3, 0.3, 0.3, 1) 
	
	local OtherTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    OtherTitle:SetPoint("TOPLEFT", SeparatorUnitFrames, "BOTTOMLEFT", 35, -10) 
    OtherTitle:SetText("Other:")
	OtherTitle:SetTextColor(0, 0.8, 1, 1)
	
	local SwitchtimerButton = CheckBtn("Buff timer position", "Use Blizzard's default Buff timer position on player's Buffs and Debuffs", Panel, function(self, value)
            Lorti.switchtimer = value
        end)
    SwitchtimerButton:SetPoint("TOPLEFT", OtherTitle, "BOTTOMLEFT", -20, -5) 
	SwitchtimerButton:SetChecked(Lorti.switchtimer)
	SwitchtimerButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local BigbuffButton = CheckBtn("Scale Player buffs", "Change the size of the Player's BuffFrame to 1.6", Panel, function(self, value)
            Lorti.bigbuff = value
        end)
    BigbuffButton:SetPoint("TOPLEFT", SwitchtimerButton, "BOTTOMLEFT", 200, 27) 
	BigbuffButton:SetChecked(Lorti.bigbuff)
	BigbuffButton.text:SetTextColor(1, 0.8, 0, 1)
	
	local ArenaframeButton = CheckBtn("Remove Arena Frames", "Remove default arena frames in arena", Panel, function(self, value)
            Lorti.arenaframe = value
        end)
    ArenaframeButton:SetPoint("TOPLEFT", BigbuffButton, "BOTTOMLEFT", 200, 27)
	ArenaframeButton:SetChecked(Lorti.arenaframe)
	ArenaframeButton.text:SetTextColor(1, 0.8, 0, 1)
	
	
	
	--[[ local SmoothButton = CheckBtn("Smooth health/mana bars", "Enable smooth animated health and mana bars", Panel, function(self, value)
            Lorti.smooth = value
        end)
    SmoothButton:SetPoint("TOPLEFT", PlayernameButton, "BOTTOMLEFT", -300, 0)
	SmoothButton:SetChecked(Lorti.smooth)
	SmoothButton.text:SetTextColor(1, 0.8, 0, 1)
	
	 local RaidBuffButton = CheckBtn("Raid Buffs", "Show all Buffs on Raid Frames, not only yours (Disable Party Buffs option to avoid conflict!)", Panel, function(self, value)
            Lorti.raidbuff = value
        end)
    RaidBuffButton:SetPoint("TOPLEFT", PlayernameButton, "BOTTOMLEFT", -300, 0)
	RaidBuffButton:SetChecked(Lorti.raidbuff)
	RaidBuffButton.text:SetTextColor(1, 0.8, 0, 1) ]]
	
	
	--[[ local Separator = Panel:CreateTexture(nil, "BACKGROUND")
	Separator:SetSize(500, 1) 
	Separator:SetPoint("TOPLEFT", SwitchtimerButton, "BOTTOMLEFT", 30, -10)
	Separator:SetColorTexture(0.3, 0.3, 0.3, 1) ]]
	
	local function AddDropdownTooltip(dropdown, tooltipText)
		dropdown:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(tooltipText, 1, 0.8, 0.3) -- Yellowish color for tooltips
			GameTooltip:Show()
		end)

		dropdown:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
	
	-- Player Frame Selector Title
    local playerFrameTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    playerFrameTitle:SetPoint("TOPLEFT", ClassPortraitsButton, "BOTTOMLEFT", 400, 0) 
    playerFrameTitle:SetText("")
	
	local playerFrameSelect = LibDD:Create_UIDropDownMenu("playerFrameSelect", Panel)
	playerFrameSelect:ClearAllPoints()
	playerFrameSelect:SetPoint("TOPLEFT", playerFrameTitle, "BOTTOMLEFT", -15, 53) 
	AddDropdownTooltip(playerFrameSelect, "Select the style of the chain around the Player Frame.")
	
	local playerFrameList = {
		"Normal",
		"Elite",
		"Rare",
		"Rare Elite",
		"Boss",
	}

	local function OnClick(self)
		LibDD:UIDropDownMenu_SetSelectedID(playerFrameSelect, self:GetID())
        Lorti.playerFrameIndex = self:GetID()
        LortiDB.playerFrameIndex = Lorti.playerFrameIndex
        playerFrameDo(self)
	end
	local function initialize(self, level)
		local info = LibDD:UIDropDownMenu_CreateInfo()
		for k,v in pairs(playerFrameList) do
			info = LibDD:UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = k
			info.func = OnClick
			LibDD:UIDropDownMenu_AddButton(info, level)
		end
	end
	LibDD:UIDropDownMenu_Initialize(playerFrameSelect, initialize)
	LibDD:UIDropDownMenu_SetWidth(playerFrameSelect, 150);
	LibDD:UIDropDownMenu_SetButtonWidth(playerFrameSelect, 170)
	LibDD:UIDropDownMenu_JustifyText(playerFrameSelect, "LEFT")
	-- Set the default selection based on saved variables
		if Lorti.playerFrameIndex then
			LibDD:UIDropDownMenu_SetSelectedID(playerFrameSelect, Lorti.playerFrameIndex)
		else
			LibDD:UIDropDownMenu_SetSelectedID(playerFrameSelect, 1)
		end
	
	
	-- Add a label for the font selector
	local fontLabel = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	fontLabel:SetPoint("TOPLEFT", EnergyButton, "BOTTOMLEFT", 30, 0)
	fontLabel:SetText("")
	
	-- Create the dropdown menu for fonts.
	local fontSelector = LibDD:Create_UIDropDownMenu("fontSelector", Panel)
	fontSelector:ClearAllPoints()
	fontSelector:SetPoint("TOPLEFT", fontLabel, "BOTTOMLEFT", -40, -10)
	AddDropdownTooltip(fontSelector, "Choose a font for Health and Mana text.")
	
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
		LibDD:UIDropDownMenu_SetSelectedID(fontSelector, self:GetID())
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
		local selectedID = LibDD:UIDropDownMenu_GetSelectedID(fontSelector) or 1
		for k, v in ipairs(fontList) do
			local info = LibDD:UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = k
			info.func = OnFontClick
			info.checked = (k == selectedID)  -- Only the button with index equal to the selected ID is checked
			LibDD:UIDropDownMenu_AddButton(info, level)
		end
	end


	LibDD:UIDropDownMenu_Initialize(fontSelector, FontInitialize)
	LibDD:UIDropDownMenu_SetWidth(fontSelector, 100)
	LibDD:UIDropDownMenu_JustifyText(fontSelector, "LEFT")
	LibDD:UIDropDownMenu_SetButtonWidth(fontSelector, 124)
	if not LibDD:UIDropDownMenu_GetSelectedID(fontSelector) then
		LibDD:UIDropDownMenu_SetSelectedID(fontSelector, 1)
	end
	LibDD:UIDropDownMenu_SetSelectedID(fontSelector, Lorti.fontIndex or 1)

	
	-- Status Bar Texture Selector Title
	local statusBarTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	statusBarTitle:SetPoint("TOPLEFT", ClassPortraitsButton, "BOTTOMLEFT", 400,50) 
	statusBarTitle:SetText("")

	-- Create the dropdown menu
	local statusBarSelect = LibDD:Create_UIDropDownMenu("statusBarSelect", Panel)
	statusBarSelect:ClearAllPoints()
	statusBarSelect:SetPoint("TOPLEFT", statusBarTitle, "BOTTOMLEFT", -15, -23)
	AddDropdownTooltip(statusBarSelect, "Select the texture for all the Unit Frames status bars.")
	
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
		LibDD:UIDropDownMenu_SetSelectedID(statusBarSelect, self:GetID())
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
		local info = LibDD:UIDropDownMenu_CreateInfo()
		for k, v in pairs(statusBarTextures) do
			info = LibDD:UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = k
			info.func = OnClick
			LibDD:UIDropDownMenu_AddButton(info, level)
		end
	end

	LibDD:UIDropDownMenu_Initialize(statusBarSelect, initialize)
	LibDD:UIDropDownMenu_SetWidth(statusBarSelect, 150)
	LibDD:UIDropDownMenu_SetButtonWidth(statusBarSelect, 170)
	LibDD:UIDropDownMenu_JustifyText(statusBarSelect, "LEFT")

	-- Set the default selection based on saved variables
	if Lorti.LortiTextureIndex then
		LibDD:UIDropDownMenu_SetSelectedID(statusBarSelect, Lorti.LortiTextureIndex)
	else
		LibDD:UIDropDownMenu_SetSelectedID(statusBarSelect, 1)
	end
	
	
	-- Class Portrait Selector Title
	local classPortraitTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	classPortraitTitle:SetPoint("TOPLEFT", ClassPortraitsButton, "BOTTOMLEFT", 200, 50)
	classPortraitTitle:SetText("")

	-- Create the dropdown menu
	local classPortraitSelect = LibDD:Create_UIDropDownMenu("classPortraitSelect", Panel)
	classPortraitSelect:ClearAllPoints()
	classPortraitSelect:SetPoint("TOPLEFT", classPortraitTitle, "BOTTOMLEFT", -15, -23)
	AddDropdownTooltip(classPortraitSelect, "Choose the class portrait texture for Target, Focus and Party Frames.")
	
	-- List of available class portrait sets
	local classPortraitSets = {
		"High Definition",
		"RougeUI",
		"Modern",
		"KkthnxUI",
		"Hearthstone",
		"ElvUI",
		"Experimental",
		"JiberishUI",
	}

	-- Function to handle selection
	local function OnClassPortraitClick(self)
		LibDD:UIDropDownMenu_SetSelectedID(classPortraitSelect, self:GetID())
		Lorti.classPortraitSet = self:GetID()
		LortiDB.classPortraitSet = Lorti.classPortraitSet

		-- Refresh class portraits with the new set
		hooksecurefunc("UnitFramePortrait_Update", ns.ApplyClassPortraits)
		ns.ApplyClassPortraits() -- Call without arguments
	end

	-- Initialize the dropdown menu
	local function ClassPortraitInitialize(self, level)
		local selectedID = LibDD:UIDropDownMenu_GetSelectedID(classPortraitSelect) or 1
		for k, v in ipairs(classPortraitSets) do
			local info = LibDD:UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = k
			info.func = OnClassPortraitClick
			info.checked = (k == selectedID) -- Highlight the currently selected item
			LibDD:UIDropDownMenu_AddButton(info, level)
		end
	end

	LibDD:UIDropDownMenu_Initialize(classPortraitSelect, ClassPortraitInitialize)
	LibDD:UIDropDownMenu_SetWidth(classPortraitSelect, 150)
	LibDD:UIDropDownMenu_SetButtonWidth(classPortraitSelect, 170)
	LibDD:UIDropDownMenu_JustifyText(classPortraitSelect, "LEFT")
	
	-- Set the default selection based on saved variables
	if Lorti.classPortraitSet then
		LibDD:UIDropDownMenu_SetSelectedID(classPortraitSelect, Lorti.classPortraitSet)
	else
		LibDD:UIDropDownMenu_SetSelectedID(classPortraitSelect, 1)
	end
	
	-- Player Class Portrait Selector Title
	local playerClassPortraitTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	playerClassPortraitTitle:SetPoint("TOPLEFT", PlayerClassPortraitsButton, "BOTTOMLEFT", 200, 50)
	playerClassPortraitTitle:SetText("")

	-- Create the dropdown menu for Player
	local playerClassPortraitSelect = LibDD:Create_UIDropDownMenu("playerClassPortraitSelect", Panel)
	playerClassPortraitSelect:ClearAllPoints()
	playerClassPortraitSelect:SetPoint("TOPLEFT", playerClassPortraitTitle, "BOTTOMLEFT", -15, -23)
	AddDropdownTooltip(playerClassPortraitSelect, "Choose the class portrait texture for the Player Frame.")
	
	-- Function to handle selection for Player
	local function OnPlayerClassPortraitClick(self)
		LibDD:UIDropDownMenu_SetSelectedID(playerClassPortraitSelect, self:GetID())
		Lorti.playerClassPortraitSet = self:GetID()
		LortiDB.playerClassPortraitSet = Lorti.playerClassPortraitSet

		-- Refresh class portraits with the new set
		hooksecurefunc("UnitFramePortrait_Update", ns.ApplyClassPortraits)
		ns.ApplyClassPortraits() -- Call without arguments
	end

	-- Initialize the dropdown menu for Player
	local function PlayerClassPortraitInitialize(self, level)
		local selectedID = LibDD:UIDropDownMenu_GetSelectedID(playerClassPortraitSelect) or 1
		for k, v in ipairs(classPortraitSets) do
			local info = LibDD:UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = k
			info.func = OnPlayerClassPortraitClick
			info.checked = (k == selectedID) -- Highlight the currently selected item
			LibDD:UIDropDownMenu_AddButton(info, level)
		end
	end

	LibDD:UIDropDownMenu_Initialize(playerClassPortraitSelect, PlayerClassPortraitInitialize)
	LibDD:UIDropDownMenu_SetWidth(playerClassPortraitSelect, 150)
	LibDD:UIDropDownMenu_SetButtonWidth(playerClassPortraitSelect, 170)
	LibDD:UIDropDownMenu_JustifyText(playerClassPortraitSelect, "LEFT")

	-- Set the default selection based on saved variables
	if Lorti.playerClassPortraitSet then
		LibDD:UIDropDownMenu_SetSelectedID(playerClassPortraitSelect, Lorti.playerClassPortraitSet)
	else
		LibDD:UIDropDownMenu_SetSelectedID(playerClassPortraitSelect, 1)
	end

	-- Name Size
	local StringSizeTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	StringSizeTitle:SetPoint("TOPLEFT", fontSelector, "BOTTOMLEFT", 223, 45)
	-- StringSizeTitle:SetText("")
	StringSizeTitle:SetText("Name Text Font Size:")  
	
	local name = "StringSizeSlider"
        local template = "OptionsSliderTemplate"
        local StringSizeSlider = CreateFrame("Slider", name, Panel, template)
       -- StringSizeSlider:SetPoint("TOPLEFT", StringSizeTitle, "BOTTOMLEFT", 15, -23)
		StringSizeSlider:SetPoint("TOPLEFT", StringSizeTitle, "BOTTOMLEFT", -10, -15)
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
		AddTooltipToSlider(StringSizeSlider, "Adjust the font size of the unit frame names.")
		
	-- Numerical size
	local NumSizeTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	NumSizeTitle:SetPoint("TOPLEFT", StringSizeTitle, "BOTTOMLEFT", 190, 12)
	-- NumSizeTitle:SetText("")
	NumSizeTitle:SetText("Numericals Text Font Size:")
	
	local name = "NumSizeSlider"
        local template = "OptionsSliderTemplate"
        local NumSizeSlider = CreateFrame("Slider", name, Panel, template)
        -- NumSizeSlider:SetPoint("TOPLEFT", NumSizeTitle, "BOTTOMLEFT", -15, -34)
		NumSizeSlider:SetPoint("TOPLEFT", NumSizeTitle, "BOTTOMLEFT", 5, -15)
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
		AddTooltipToSlider(NumSizeSlider, "Adjust the font size of numerical values (e.g., health and mana).")
		-- Frames centering / restore.

		-- Create a font string for the positioning options title.
		local positionOptions = Panel:CreateFontString("mainOptions", "OVERLAY", "GameFontNormal")
		positionOptions:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
		positionOptions:SetText("Positioning options:")
		positionOptions:SetPoint("TOPLEFT", SwitchtimerButton, "BOTTOMLEFT", 150, -10)

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

		
		-- Player/Target/Focus Frame Scale Slider
    local FrameScaleTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    FrameScaleTitle:SetPoint("TOPLEFT", fontSelector, "BOTTOMLEFT", 10, -10)
    -- FrameScaleTitle:SetText("")
	FrameScaleTitle:SetText("Player/Target/Focus Scale:")
	
    local FrameScaleSlider = CreateFrame("Slider", "FrameScaleSlider", Panel, "OptionsSliderTemplate")
    -- FrameScaleSlider:SetPoint("TOPLEFT", FrameScaleTitle, "BOTTOMLEFT", 20, -17)
	FrameScaleSlider:SetPoint("TOPLEFT", FrameScaleTitle, "BOTTOMLEFT", 10, -15)
    FrameScaleSlider.textLow = _G["FrameScaleSliderLow"]
    FrameScaleSlider.textHigh = _G["FrameScaleSliderHigh"]
    FrameScaleSlider.text = _G["FrameScaleSliderText"]
    FrameScaleSlider:SetMinMaxValues(0.5, 2.0)
    FrameScaleSlider:SetValueStep(0.05)
    FrameScaleSlider:SetObeyStepOnDrag(true)
    FrameScaleSlider:SetValue(Lorti.frameScale or 1.0)
    FrameScaleSlider.textLow:SetText("0.5x")
    FrameScaleSlider.textHigh:SetText("2.0x")
    FrameScaleSlider.text:SetText("Scale: " .. string.format("%.2f", FrameScaleSlider:GetValue()))
    FrameScaleSlider:SetScript("OnValueChanged", function(self, value)
        self.text:SetText("Scale: " .. string.format("%.2f", value))
        Lorti.frameScale = value
        PlayerFrame:SetScale(value)
        TargetFrame:SetScale(value)
        FocusFrame:SetScale(value)
    end)
	AddTooltipToSlider(FrameScaleSlider, "Adjust the scale of the Player, Target, and Focus frames.")
	
	-- Party Frame Scale Slider
    local PartyFrameScaleTitle = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    PartyFrameScaleTitle:SetPoint("TOPLEFT", FrameScaleTitle, "BOTTOMLEFT", 215, 10)
    -- PartyFrameScaleTitle:SetText("")
	PartyFrameScaleTitle:SetText("Party Frames Scale:")
	
    local PartyFrameScaleSlider = CreateFrame("Slider", "PartyFrameScaleSlider", Panel, "OptionsSliderTemplate")
    -- PartyFrameScaleSlider:SetPoint("TOPLEFT", PartyFrameScaleTitle, "BOTTOMLEFT", 13, -25)
	PartyFrameScaleSlider:SetPoint("TOPLEFT", PartyFrameScaleTitle, "BOTTOMLEFT", -13, -15)
    PartyFrameScaleSlider.textLow = _G["PartyFrameScaleSliderLow"]
    PartyFrameScaleSlider.textHigh = _G["PartyFrameScaleSliderHigh"]
    PartyFrameScaleSlider.text = _G["PartyFrameScaleSliderText"]
    PartyFrameScaleSlider:SetMinMaxValues(0.5, 2.0)
    PartyFrameScaleSlider:SetValueStep(0.05)
    PartyFrameScaleSlider:SetObeyStepOnDrag(true)
    PartyFrameScaleSlider:SetValue(Lorti.partyFrameScale or 1.0)
    PartyFrameScaleSlider.textLow:SetText("0.5x")
    PartyFrameScaleSlider.textHigh:SetText("2.0x")
    PartyFrameScaleSlider.text:SetText("Scale: " .. string.format("%.2f", PartyFrameScaleSlider:GetValue()))
    PartyFrameScaleSlider:SetScript("OnValueChanged", function(self, value)
        self.text:SetText("Scale: " .. string.format("%.2f", value))
        Lorti.partyFrameScale = value
        for i = 1, 4 do
            local frame = _G["PartyMemberFrame" .. i]
            if frame then
                frame:SetScale(value)
            end
        end
    end)
	AddTooltipToSlider(PartyFrameScaleSlider, "Adjust the scale of the Party frames.")
	
	end
	return Panel
end

function playerFrameDo()
	local frameType;
	if Lorti.playerFrameIndex == 1 then
		frameType = "UI-TargetingFrame";
	elseif Lorti.playerFrameIndex == 2 then
		frameType = "elite"
	elseif Lorti.playerFrameIndex == 3 then
		frameType = "rare"
	elseif Lorti.playerFrameIndex == 4 then
		frameType = "rare-Elite"
	elseif Lorti.playerFrameIndex == 5 then
		frameType = "Boss"
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