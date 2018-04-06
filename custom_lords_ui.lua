require("custom_lords_util");
local CustomLordsModel = require("custom_lords_ui_model");

local TOTAL_TRAIT_POINTS = 2;
local MAX_TRAITS = 4;
local model = nil --: CUSTOM_LORDS_MODEL
local customLordFrame = nil --: FRAME

--v function(buttons: vector<TEXT_BUTTON>)
function setUpSingleButtonSelectedGroup(buttons)
    for i, button in ipairs(buttons) do
        button:RegisterForClick(
            function(context)
                for i, otherButton in ipairs(buttons) do
                    if button.name == otherButton.name then
                        otherButton:SetState("selected_hover");
                    else
                        otherButton:SetState("active");
                    end
                end
            end
        );
    end
end

--v function(lordType: string, lordTypeName: string, frame: FRAME) --> TEXT_BUTTON
function createLordTypeButton(lordType, lordTypeName, frame)
    local lordTypeButton = TextButton.new(lordType .. "Button", frame, "TEXT_TOGGLE", lordTypeName);
    lordTypeButton:Resize(300, lordTypeButton:Height());
    lordTypeButton:SetState("active");
    if lordType == "wh2_main_lzd_slann_mage_priest" and not CUSTOM_LORDS_CAN_RECRUIT_SLANN then
        lordTypeButton:SetDisabled(true);
    end
    return lordTypeButton;
end

--v function(factionName: string) --> vector<map<string,string>>
function calculateLordTypeData(factionName)
    local lordTypeData = {} --: vector<map<string,string>>
    local faction = get_faction(factionName);
    local factionSubculture = faction:subculture();
    local factionLordTypesTable = TABLES["faction_lord_types"] --: map<string, vector<map<string, string>>>
    for factionKey, factionLordTypeData in pairs(factionLordTypesTable) do
        for i, factionLordType in ipairs(factionLordTypeData) do
            if factionLordType["faction_type"] == "FACTION" then
                if factionKey == factionName then
                    table.insert(lordTypeData, factionLordType);
                end
            elseif factionLordType["faction_type"] == "SUBCULTURE" then
                if factionKey == factionSubculture then
                    table.insert(lordTypeData, factionLordType);
                end
            else
                output("Cannot match faction type: " .. factionLordType["faction_type"] .. " for key: " .. factionKey);
            end
        end
    end
    return lordTypeData;
end

--v function(currentFaction: string, frame: FRAME) --> vector<TEXT_BUTTON>
function createLordTypeButtons(currentFaction, frame)
    local buttons = {} --: vector<TEXT_BUTTON>
    for i, factionLordType in ipairs(calculateLordTypeData(currentFaction)) do
        local lordType = factionLordType["lord_type"];
        local button = createLordTypeButton(lordType, factionLordType["lord_type_name"], frame);
        if i == 1 then
            button:SetState("selected");
            model:SetSelectedLordType(lordType);
        end
        table.insert(buttons, button);
        button:RegisterForClick(
            function(context)
                model:SetSelectedLordType(lordType);
            end
        );
    end
    setUpSingleButtonSelectedGroup(buttons);
    return buttons;
end

--v function(skillSet: string, skillSetName: string, frame: FRAME) --> TEXT_BUTTON
function createSkillSetButton(skillSet, skillSetName, frame)
    local skillSetButton = TextButton.new(skillSet .. "Button", frame, "TEXT_TOGGLE", skillSetName);
    skillSetButton:Resize(300, skillSetButton:Height());
    skillSetButton:SetState("active");
    return skillSetButton;
end

--v function(lordType: string, frame: FRAME) --> vector<TEXT_BUTTON>
function createSkillSetButtons(lordType, frame)
    local buttons = {} --: vector<TEXT_BUTTON>
    local lordTypesTable = TABLES["lord_types"][lordType] --: vector<map<string, string>>
    if not lordTypesTable then
        lordTypesTable = {{key = lordType, skill_set = lordType .. "_default", skill_set_name = "Default", default_skill_set = "TRUE"}};
    end
    for i, lordTypeTable in ipairs(lordTypesTable) do
        local skillSet = lordTypeTable["skill_set"];
        local button = createSkillSetButton(skillSet, lordTypeTable["skill_set_name"], frame);
        if i == 1 then
            button:SetState("selected");
            model:SetSelectedSkillSet(skillSet);
        end
        table.insert(buttons, button);
        button:RegisterForClick(
            function(context)
                model:SetSelectedSkillSet(skillSet);
            end
        );
    end
    setUpSingleButtonSelectedGroup(buttons);
    return buttons;
end

--v function(skillSetButtonContainer: CONTAINER)
function resetSkillSets(skillSetButtonContainer)
    skillSetButtonContainer:Clear();
    local buttonList = ListView.new("SkillSetList", customLordFrame, "HORIZONTAL");
    buttonList:Resize(customLordFrame:Width() - 55, 52);
    for i, button in ipairs(createSkillSetButtons(model.selectedLordType, customLordFrame)) do
        buttonList:AddComponent(button);
    end
    skillSetButtonContainer:AddComponent(buttonList);
    skillSetButtonContainer:Reposition();
end

--v function(traitEffectProperties: map<string, string>) --> (string, string)
function calculateImageAndToolTipForTraitEffectProperties(traitEffectProperties)
    local traitImagePath = nil --: string
    local traitDescription = nil --: string
    local colour = nil --: string
    local traitEffect = traitEffectProperties["effect"];
    local effectValue = tonumber(traitEffectProperties["value"]);
    local effects = TABLES["effects_tables"][traitEffect] --: map<string, string>
    if effectValue > 0 then
        traitImagePath = "ui/campaign ui/effect_bundles/" .. effects["icon"];
    else
        traitImagePath = "ui/campaign ui/effect_bundles/" .. effects["icon_negative"];
    end

    if (effects["is_positive_value_good"] == "True") == (effectValue > 0) then
        colour = "dark_g";
    else
        colour = "dark_r";
    end

    local effectDescriptionPath = "effects_description_" .. traitEffect;
    traitDescription = effect.get_localised_string(effectDescriptionPath);

    local effectSign = nil --: string
    if effectValue > 0 then
        effectSign = "+";
    else
        effectSign = "";
    end
    traitDescription = string.gsub(traitDescription, "%%%+n", effectSign .. tostring(effectValue));
    traitDescription = string.gsub(traitDescription, "%%%n", tostring(effectValue));    

    local traitEffectScope = traitEffectProperties["effect_scope"];
    local traitEffectScopePath = "campaign_effect_scopes_localised_text_" .. traitEffectScope;
    local traitEffectScopeDesc = effect.get_localised_string(traitEffectScopePath);        

    traitDescription = "[[col:" .. colour .. "]]" .. traitDescription .. traitEffectScopeDesc .. "[[/col]]";

    return traitImagePath, traitDescription;
end

--v function(trait: string, parent: COMPONENT_TYPE | CA_UIC, buttonCreationFunction: function(trait:string, parent: COMPONENT_TYPE | CA_UIC) --> BUTTON) --> CONTAINER
function createTraitRow(trait, parent, buttonCreationFunction)
    local traitRow = Container.new(FlowLayout.HORIZONTAL);
    local traitNameKey = "character_trait_levels_onscreen_name_" .. trait;
    local traitName = effect.get_localised_string(traitNameKey);
    local traitNameText = Text.new(trait .. "NameText", parent, "NORMAL", traitName);
    traitNameText:Resize(140, traitNameText:Height());
    traitRow:AddComponent(traitNameText);
    traitRow:AddGap(20);
    local traitEffectsContainer = Container.new(FlowLayout.VERTICAL);
    local traitEffects = TABLES["trait_level_effects_tables"][trait] --: vector<map<string, string>>
    for i, traitEffectProperties in ipairs(traitEffects) do
        local traitEffectContainer = Container.new(FlowLayout.HORIZONTAL);
        local traitImagePath, traitDescription = calculateImageAndToolTipForTraitEffectProperties(traitEffectProperties);
        local traitImage = Image.new(trait .. i .. "Image", parent, traitImagePath);
        traitEffectContainer:AddComponent(traitImage);
        local traitDesc = Text.new(trait .. i .. "NameDesc", parent, "NORMAL", traitDescription);
        traitEffectContainer:AddComponent(traitDesc);
        traitEffectsContainer:AddComponent(traitEffectContainer);
    end
    traitRow:AddComponent(traitEffectsContainer);
    traitRow:AddGap(20);
    local traitCost = tonumber(TABLES["traits"][trait]["trait_cost"]);
    local traitCostNumberText = nil --: string
    if traitCost > 0 then
        traitCostNumberText = "+" .. traitCost ..  " Trait Points";
    else
        traitCostNumberText = traitCost ..  " Trait Points";
    end
    local traitCostText = Text.new(trait .. "CostText", parent, "NORMAL", traitCostNumberText);
    traitCostText:Resize(100, traitCostText:Height());
    traitRow:AddComponent(traitCostText);
    traitRow:AddComponent(buttonCreationFunction(trait, parent));
    return traitRow;
end

--v function(name: string, parent: COMPONENT_TYPE | CA_UIC, width: number) --> IMAGE
function createTraitDivider(name, parent, width)
    local divider = Image.new(name, parent, "ui/skins/default/separator_line.png")
    divider:Resize(width, 2);
    return divider;
end

--v function() --> number
function calculateRemainingTraitPoints()
    local totalTraitPoints = tonumber(0);
    for i, trait in ipairs(model.selectedTraits) do
        local traitPointsForTrait = tonumber(TABLES["traits"][trait]["trait_cost"]);
        totalTraitPoints = totalTraitPoints + traitPointsForTrait;
    end
    return TOTAL_TRAIT_POINTS + totalTraitPoints;
end

--v function(addTraitCallback: function(string)) --> FRAME
function createTraitSelectionFrame(addTraitCallback)
    local traitSelectionFrame = Frame.new("traitSelectionFrame");
    traitSelectionFrame:SetTitle("Select the trait to add");
    local traitSelectionFrameContainer = Container.new(FlowLayout.VERTICAL);
    traitSelectionFrame:AddComponent(traitSelectionFrameContainer);
    traitSelectionFrame:AddCloseButton();
    local traitList = ListView.new("traitList", traitSelectionFrame, "VERTICAL");
    traitList:Resize(600, traitSelectionFrame:Height() - 200);
    local divider = createTraitDivider("SelectFrameTopDivider", traitList, traitSelectionFrame:Width());
    traitList:AddComponent(divider);
    local remainingTraitPoints = calculateRemainingTraitPoints();
    for trait, traitData in pairs(TABLES["traits"]) do
        local addTraitButtonFunction = function(
            trait, --: string
            parent --: COMPONENT_TYPE | CA_UIC
        )
            local addTraitButton = Button.new("addTraitButton" .. trait, parent, "SQUARE", "ui/skins/default/parchment_header_min.png");
            addTraitButton:RegisterForClick(
                function(context)
                    traitSelectionFrame:Delete();
                    addTraitCallback(trait);
                end
            )
            if remainingTraitPoints + tonumber(TABLES["traits"][trait]["trait_cost"]) < 0 then
                addTraitButton:SetDisabled(true);
            end
            addTraitButton:Resize(25, 25);
            return addTraitButton;
        end
        if not listContains(model.selectedTraits, trait) then
            local traitRow = createTraitRow(trait, traitSelectionFrame, addTraitButtonFunction);
            traitList:AddContainer(traitRow);
            local divider = createTraitDivider(trait .. "Divider", traitList, traitSelectionFrame:Width());
            traitList:AddComponent(divider);
        end
    end
    
    traitSelectionFrameContainer:AddComponent(traitList);
    Util.centreComponentOnComponent(traitSelectionFrameContainer, traitSelectionFrame);
    local x, y = traitSelectionFrameContainer:Position();
    return traitSelectionFrame;
end

--v function()
function updateAddTraitButton()
    local addTraitButton = Util.getComponentWithName("addTraitButton");
    --# assume addTraitButton: TEXT_BUTTON
    if #model.selectedTraits < MAX_TRAITS then
        addTraitButton:SetVisible(true);
    else
        addTraitButton:SetVisible(false);
    end
end

--v function() --> number
function calculateRecruitmentCost()
    local cost = 1000;
    for i, trait in ipairs(model.selectedTraits) do
        if trait == "wh2_main_trait_increased_cost" then
            cost = cost + 1000;
        end
    end
    return cost;
end

--v function()
function updateRecruitButton()
    local recuitButton = Util.getComponentWithName("recruitButton");
    if recuitButton then
        --# assume recuitButton: TEXT_BUTTON
        local recruitCost = calculateRecruitmentCost();
        local recruitText = "Recruit " .. "([[img:icon_treasury]][[/img]]" .. recruitCost .. ")";
        recuitButton:SetButtonText(recruitText);
        local currentFaction = cm:model():world():faction_by_key(cm:get_local_faction());
        recuitButton:SetDisabled(currentFaction:treasury() < recruitCost);
        local remainingTraitPoints = calculateRemainingTraitPoints();
        if remainingTraitPoints < 0 then
            recuitButton:SetDisabled(true);
        end
    end
end

--v function(traitRowContainer: CONTAINER, frameContainer: CONTAINER, buttonCreationFunction: function(trait:string, parent: COMPONENT_TYPE | CA_UIC) --> BUTTON)
function resetSelectedTraits(traitRowContainer, frameContainer, buttonCreationFunction)
    --# assume parent: CA_UIC
    traitRowContainer:Clear();
    local traitsText = Text.new("TraitPointsText", customLordFrame, "NORMAL", "Trait Points Remaining: " .. calculateRemainingTraitPoints());
    traitRowContainer:AddComponent(traitsText);
    local divider = createTraitDivider("CurrentTraitsTopDivider", customLordFrame, 600);
    traitRowContainer:AddComponent(divider);
    for i, trait in ipairs(model.selectedTraits) do
        local traitRow = createTraitRow(trait, customLordFrame, buttonCreationFunction);
        traitRowContainer:AddComponent(traitRow);
        local divider = createTraitDivider(trait .. "Divider", customLordFrame, 600);
        traitRowContainer:AddComponent(divider);
    end
    frameContainer:Reposition();
    updateAddTraitButton();
    updateRecruitButton();
end

--v function() --> int
function calculateRemainingAttributePoints()
    local remainingPoints = 0 --: int
    for attribute, value in pairs(model.attributeValues) do
        remainingPoints = remainingPoints - value;
    end
    return remainingPoints;
end

--v function(attribute: string, value: int) --> string
function calculateEffectBundleForAttributeAndValue(attribute, value)
    local attributesTable = TABLES["attributes"] --: map<string, vector<map<string, string>>>
    for i, attributeTable in ipairs(attributesTable[attribute]) do
        if tonumber(attributeTable["attribute_value"]) == value then
            return attributeTable["effect_bundle"];
        end
    end
    output("Failed to find effect bundle for attribute: " .. attribute .. " with value: " .. value);
    return nil;
end

--v function(effectBundle: string) --> string
function calculateEffectForEffectBundle(effectBundle)
    local effectBundleToEffectTable = TABLES["effect_bundles_to_effects_junctions_tables"] --: map<string, vector<map<string, string>>>
    return effectBundleToEffectTable[effectBundle][1]["effect_key"];
end

--v function(effectBundle: string) --> number
function calculateEffectValueForEffectBundle(effectBundle)
    local effectBundleToEffectTable = TABLES["effect_bundles_to_effects_junctions_tables"] --: map<string, vector<map<string, string>>>
    return tonumber(effectBundleToEffectTable[effectBundle][1]["value"]);
end

--v function(attribute: string, value: int, frame: FRAME) --> CONTAINER
function createAttributeRow(attribute, value, frame)
    local maxDiff = 4;
    local remainingPoints = calculateRemainingAttributePoints();
    local rowContainer = Container.new(FlowLayout.HORIZONTAL);
    local attributeEffectBundle = calculateEffectBundleForAttributeAndValue(attribute, value);
    local attributeEffect = calculateEffectForEffectBundle(attributeEffectBundle);

    local changeValue = calculateEffectValueForEffectBundle(attributeEffectBundle);
    local changeText = tostring(changeValue);
    if changeValue >= 0 then
        changeText = "+" .. changeText;
    end
    local attributeChangeText = Text.new("AttributeChangeText" .. attribute, frame, "NORMAL", changeText);
    attributeChangeText:Resize(35, 20);
    rowContainer:AddComponent(attributeChangeText);

    local effectImage = TABLES["effects_tables"][attributeEffect]["icon"];
    local attributeImage = Image.new("AttributeRowImage" .. attribute, frame, "ui/campaign ui/effect_bundles/" .. effectImage);
    rowContainer:AddComponent(attributeImage);
    rowContainer:AddGap(15);
    local decreaseButton = Button.new("AttributeDecreaseButton" .. attribute, frame, "SQUARE", "ui/skins/default/parchment_header_max.png");
    decreaseButton:Resize(25, 25);
    if value == maxDiff * -1 then
        decreaseButton:SetDisabled(true);
    end
    decreaseButton:RegisterForClick(
        function(context)
            model:SetAttributeValue(attribute, value - 1);
        end
    );
    rowContainer:AddComponent(decreaseButton);
    local maxDiff = 4;
    for i=-maxDiff,maxDiff do
        local attributePointIndicator = Image.new("AttributePointIndicator" .. attribute .. i, frame, "ui/skins/warhammer2/button_basic_hover.png");
        attributePointIndicator:Resize(25, 25);
        if i > value then
            attributePointIndicator:SetOpacity(50);
        end
        rowContainer:AddComponent(attributePointIndicator);
    end
    local increaseButton = Button.new("AttributeIncreaseButton" .. attribute, frame, "SQUARE", "ui/skins/default/parchment_header_min.png");
    increaseButton:Resize(25, 25);
    if value == maxDiff or remainingPoints <= 0 then
        increaseButton:SetDisabled(true);
    end
    increaseButton:RegisterForClick(
        function(context)
            model:SetAttributeValue(attribute, value + 1);
        end
    );

    rowContainer:AddComponent(increaseButton);
    rowContainer:AddGap(10);
    return rowContainer;
end

--v function(attributeContainer: CONTAINER, frame: FRAME)
function resetAttributeContainer(attributeContainer, frame)
    attributeContainer:Clear();
    local remainingAttributePointsText = Text.new("remainingAttributePointsText", frame, "NORMAL", "Attribute Points: " .. calculateRemainingAttributePoints());
    attributeContainer:AddComponent(remainingAttributePointsText);
    for attribute, value in pairs(model.attributeValues) do
        local attributeRow = createAttributeRow(attribute, value, frame);
        attributeContainer:AddComponent(attributeRow);
    end
    attributeContainer:Reposition();
end

--v function(recruitCallback: function(name: string, lordType: string, skillSet: string, attributes: map<string, int>, traits: vector<string>)) --> FRAME
function createCustomLordFrameUi(recruitCallback)
    model = CustomLordsModel.new();
    model:RegisterForEventType("LORD_TYPES_CHANGE");
    customLordFrame = Frame.new("customLordFrame");
    customLordFrame:SetTitle("Create your custom Lord");
    local xRes, yRes = core:get_screen_resolution();
    customLordFrame:Resize(customLordFrame:Width() * 1.3, yRes - 100);
    Util.centreComponentOnScreen(customLordFrame);

    local frameContainer = Container.new(FlowLayout.VERTICAL);
    customLordFrame:AddComponent(frameContainer);
    local lordName = Text.new("lordName", customLordFrame, "HEADER", "Name your Lord");
    frameContainer:AddComponent(lordName);
    local lordNameTextBox = TextBox.new("lordNameTextBox", customLordFrame);
    frameContainer:AddComponent(lordNameTextBox);
    frameContainer:AddGap(10);

    local lordTypeText = Text.new("lordTypeText", customLordFrame, "HEADER", "Select your Lord's type");
    frameContainer:AddComponent(lordTypeText);

    local lordTypeButtons = createLordTypeButtons(cm:get_local_faction(), customLordFrame);
    local buttonList = ListView.new("LordTypeList", customLordFrame, "HORIZONTAL");
    buttonList:Resize(customLordFrame:Width() - 55, 52);
    for i, button in pairs(lordTypeButtons) do
        buttonList:AddComponent(button);
    end
    frameContainer:AddComponent(buttonList);

    local skillSetText = Text.new("skillSetText", customLordFrame, "HEADER", "Select your Lord's skill-set");
    frameContainer:AddComponent(skillSetText);

    local skillSetButtonContainer = Container.new(FlowLayout.VERTICAL);
    resetSkillSets(skillSetButtonContainer);
    model:RegisterForEvent(
        "SELECTED_LORD_TYPE_CHANGE", 
        function()
            resetSkillSets(skillSetButtonContainer);
        end
    );
    frameContainer:AddComponent(skillSetButtonContainer);

    local traitsAttributesContainer = Container.new(FlowLayout.HORIZONTAL);
    local attributesContainer = Container.new(FlowLayout.VERTICAL);
    local attributesText = Text.new("attributesText", customLordFrame, "HEADER", "Define your Lord's attributes");
    attributesContainer:AddComponent(attributesText);
    local attributesTable = TABLES["attributes"] --: map<string, vector<map<string, string>>>
    for attribute, table in pairs(attributesTable) do
        model:SetAttributeValue(attribute, 0);
    end
    local attributeRowContainer = Container.new(FlowLayout.VERTICAL);
    resetAttributeContainer(attributeRowContainer, customLordFrame);
    model:RegisterForEvent(
        "ATTRIBUTE_VALUE_CHANGE", 
        function()
            resetAttributeContainer(attributeRowContainer, customLordFrame);
        end
    );
    attributesContainer:AddComponent(attributeRowContainer);
    traitsAttributesContainer:AddComponent(attributesContainer);

    local traitsContainer = Container.new(FlowLayout.VERTICAL);
    local traitsText = Text.new("traitsText", customLordFrame, "HEADER", "Select your Lord's traits");
    traitsContainer:AddComponent(traitsText);
    local traitRowsContainer = Container.new(FlowLayout.VERTICAL);
    local removeTraitButtonFunction = nil --: function(string, COMPONENT_TYPE | CA_UIC) --> BUTTON
    removeTraitButtonFunction = function(
        trait, --: string
        parent --: COMPONENT_TYPE | CA_UIC
    )
        local removeTraitButton = Button.new("removeTraitButton" .. trait, parent, "SQUARE", "ui/skins/default/parchment_header_max.png");
        removeTraitButton:RegisterForClick(
            function(context)
                model:RemoveSelectedTrait(trait);
            end
        )
        removeTraitButton:Resize(25, 25);
        return removeTraitButton;
    end

    model:RegisterForEvent(
        "SELECTED_TRAITS_CHANGE", 
        function()
            resetSelectedTraits(traitRowsContainer, frameContainer, removeTraitButtonFunction);
        end
    );

    traitsContainer:AddComponent(traitRowsContainer);

    local addTraitButton = TextButton.new("addTraitButton", customLordFrame, "TEXT", "Add Trait");
    addTraitButton:RegisterForClick(
        function(context)
            local existingFrame = Util.getComponentWithName("traitSelectionFrame");
            --# assume existingFrame: FRAME
            if not existingFrame then
                local traitSelectionFrame = createTraitSelectionFrame( 
                    function(addedTrait)
                        model:AddSelectedTrait(addedTrait);
                    end
                );
                customLordFrame.uic:Adopt(traitSelectionFrame.uic:Address());
                Util.centreComponentOnScreen(traitSelectionFrame);
            end
        end
    );

    traitsContainer:AddComponent(addTraitButton);
    traitsAttributesContainer:AddGap(100);
    traitsAttributesContainer:AddComponent(traitsContainer);
    frameContainer:AddComponent(traitsAttributesContainer);

    resetSelectedTraits(traitRowsContainer, frameContainer, removeTraitButtonFunction);
    frameContainer:PositionRelativeTo(customLordFrame, 20, 20);

    local recuitContainer = Container.new(FlowLayout.HORIZONTAL);
    customLordFrame:AddComponent(recuitContainer);
    local recuitButton = TextButton.new("recruitButton", customLordFrame, "TEXT", "");
    recuitButton:RegisterForClick(
        function(context)
            recruitCallback(
                lordNameTextBox.uic:GetStateText(),
                model.selectedLordType,
                model.selectedSkillSet,
                model.attributeValues,
                model.selectedTraits
            );
            customLordFrame:Delete();
        end
    );
    updateRecruitButton();
    recuitContainer:AddComponent(recuitButton);

    local closeButton = Button.new("CustomLordFrameCloseButton", customLordFrame, "CIRCULAR", "ui/skins/warhammer2/icon_cross.png");
    closeButton:RegisterForClick(
        function(context)
            customLordFrame:Delete();
        end
    );
    recuitContainer:AddComponent(closeButton);

    Util.centreComponentOnComponent(recuitContainer, customLordFrame);
    local xPos, yPos = recuitContainer:Position();
    recuitContainer:MoveTo(xPos, yPos + (customLordFrame:Height() / 2) - 50);

    customLordFrame.uic:PropagatePriority(100);
    return customLordFrame;
end