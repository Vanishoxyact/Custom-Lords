require("custom_lords_util");
local CustomLordsModel = require("custom_lords_ui_model");
local CustomLordsAttributePanel = require("custom_lords_ui_attribute_panel");
local CustomLordsTraitFrame = require("custom_lords_ui_trait_frame");
local CustomLordsArtPanel = require("custom_lords_ui_art_panel");

local model = nil --: CUSTOM_LORDS_MODEL
local customLordFrame = nil --: FRAME

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
    local cost = model.baseCost;
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
        local remainingTraitPoints = calculateRemainingTraitPoints(model);
        if remainingTraitPoints < 0 then
            recuitButton:SetDisabled(true);
        end
    end
end

--v function(traitRowContainer: CONTAINER, frameContainer: CONTAINER, buttonCreationFunction: function(trait:string, parent: COMPONENT_TYPE | CA_UIC) --> BUTTON)
function resetSelectedTraits(traitRowContainer, frameContainer, buttonCreationFunction)
    --# assume parent: CA_UIC
    traitRowContainer:Clear();
    local traitsText = Text.new("TraitPointsText", customLordFrame, "NORMAL", "Trait Points Remaining: " .. calculateRemainingTraitPoints(model));
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

--v function()
    function destroyCustomLordFrame()
    local customLordFrame = Util.getComponentWithName("customLordFrame");
    --# assume customLordFrame: FRAME
    if customLordFrame then
        customLordFrame:Delete();
    end
end

--v function(recruitCallback: function(name: string, lordType: string, skillSet: string, attributes: map<string, int>, traits: vector<string>, artId: string), cost: number) --> FRAME
function createCustomLordFrameUi(recruitCallback, cost)
    model = CustomLordsModel.new();
    model:SetBaseCost(cost);
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

    local artPanel = CustomLordsArtPanel.new(model, customLordFrame);
    frameContainer:AddComponent(artPanel.artContainer);

    local traitsAttributesContainer = Container.new(FlowLayout.HORIZONTAL);
    local attributePanel = CustomLordsAttributePanel.new(model, customLordFrame);
    traitsAttributesContainer:AddComponent(attributePanel.attributesContainer);

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
                local traitSelectionFrame = CustomLordsTraitFrame.new(
                    model, customLordFrame,
                    function(addedTrait)
                        model:AddSelectedTrait(addedTrait);
                    end
                ).traitSelectionFrame;
                customLordFrame.uic:Adopt(traitSelectionFrame.uic:Address());
                Util.centreComponentOnScreen(traitSelectionFrame);
                customLordFrame:AddComponent(traitSelectionFrame);
            else
                existingFrame:SetVisible(true);
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
                model.selectedTraits,
                model.selectedArtId
            );
            destroyCustomLordFrame();
        end
    );
    updateRecruitButton();
    recuitContainer:AddComponent(recuitButton);

    local closeButton = Button.new("CustomLordFrameCloseButton", customLordFrame, "CIRCULAR", "ui/skins/warhammer2/icon_cross.png");
    closeButton:RegisterForClick(
        function(context)
            destroyCustomLordFrame();
        end
    );
    recuitContainer:AddComponent(closeButton);

    Util.centreComponentOnComponent(recuitContainer, customLordFrame);
    local xPos, yPos = recuitContainer:Position();
    recuitContainer:MoveTo(xPos, yPos + (customLordFrame:Height() / 2) - 50);

    customLordFrame.uic:PropagatePriority(100);
    return customLordFrame;
end