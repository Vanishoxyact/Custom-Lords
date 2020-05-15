my_load_mod_script("custom_lords_util");
local CustomLordsModel = my_load_mod_script("custom_lords_ui_model");
local CustomLordsAttributePanel = my_load_mod_script("custom_lords_ui_attribute_panel");
local CustomLordsTraitFrame = my_load_mod_script("custom_lords_ui_trait_frame");
local CustomLordsArtPanel = my_load_mod_script("custom_lords_ui_art_panel");
local CustomLordsOptionsFrame = my_load_mod_script("custom_lords_ui_options_frame");

local model = nil --: CUSTOM_LORDS_MODEL
local customLordFrame = nil --: FRAME

--v function(lordType: string, lordTypeName: string, frame: FRAME) --> TEXT_BUTTON
function createLordTypeButton(lordType, lordTypeName, frame)
    local lordTypeButton = TextButton.new(lordType .. "Button", frame, "TEXT_TOGGLE_SMALL", lordTypeName);
    lordTypeButton:Resize(250, lordTypeButton:Height());
    lordTypeButton:SetState("active");
    if lordType == "wh2_main_lzd_slann_mage_priest" and not CUSTOM_LORDS_CAN_RECRUIT_SLANN then
        lordTypeButton:SetDisabled(true);
    end
    return lordTypeButton;
end

function canRecruitLordType(factionName, factionKey, factionLordType, agentType)
    local faction = cm:get_faction(factionName);
    local factionSubculture = faction:subculture();
    if factionLordType["faction_type"] == "FACTION" then
        if factionKey ~= factionName then
            return false;
        end
    elseif factionLordType["faction_type"] == "SUBCULTURE" then
        if factionKey ~= factionSubculture then
            return false;
        end
    else
        out("Cannot match faction type: " .. factionLordType["faction_type"] .. " for key: " .. factionKey);
        return false;
    end
    
    if not hasDlcForLord(factionLordType) then
        return false;
    end

    if agentType then
        local factionAgentPermittedSubtypesTables = TABLES["faction_agent_permitted_subtypes_tables"] --: map<string, vector<map<string, string>>>
        local factionAgentDataList = factionAgentPermittedSubtypesTables[factionName];
        local lordType = factionLordType["lord_type"];
        local lordTypeFound = false;
        for i, factionAgentData in ipairs(factionAgentDataList) do
            if factionAgentData["subtype"] == lordType then
                lordTypeFound = true;
                local foundAgentType = factionAgentData["agent"]
                if agentType == "general" then
                    if foundAgentType ~= "general" and foundAgentType ~= "colonel" then
                        return false;
                    end
                elseif foundAgentType ~= agentType then
                    return false;
                else
                    break;
                end
            end
        end
        if not lordTypeFound then
            out("Failed to find agent type for lord type: " .. lordType);
            return false;
        end
    end
    return true;
end

--v function(lordTypeData: map<string,string>) --> boolean
function hasDlcForLord(lordTypeData)
   local lordType = lordTypeData["lord_type"];
   local dlcLords = TABLES["dlc_lords"] --: map<string,string>
   if dlcLords[lordType] == nil then
      return true;
   else
      local requiredDlc = dlcLords[lordType]["required_dlc"];
      return cm:is_dlc_flag_enabled(requiredDlc);
   end
end

--v function(factionName: string) --> vector<map<string,string>>
function calculateLordTypeData(factionName, agentType)
    local lordTypeData = {} --: vector<map<string,string>>
    local factionLordTypesTable = TABLES["faction_lord_types"] --: map<string, vector<map<string, string>>>
    for factionKey, factionLordTypeData in pairs(factionLordTypesTable) do
        for i, factionLordType in ipairs(factionLordTypeData) do
            if canRecruitLordType(factionName, factionKey, factionLordType, agentType) then
                table.insert(lordTypeData, factionLordType);
            end
        end
    end
    return lordTypeData;
end

--v function(currentFaction: string, frame: FRAME) --> vector<TEXT_BUTTON>
function createLordTypeButtons(currentFaction, frame, agentType)
    local buttons = {} --: vector<TEXT_BUTTON>
    for i, factionLordType in ipairs(calculateLordTypeData(currentFaction, agentType)) do
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
    local skillSetButton = TextButton.new(skillSet .. "Button", frame, "TEXT_TOGGLE_SMALL", skillSetName);
    skillSetButton:Resize(200, skillSetButton:Height());
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
    buttonList:Resize(customLordFrame:Width() - 55, 35);
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
    if #model.selectedTraits < model.maxTraits then
        addTraitButton:SetDisabled(false);
    else
        addTraitButton:SetDisabled(true);
    end
end

--v function() --> number
function calculateRecruitmentCost()
    local cost = model.baseCost;
    for i, trait in ipairs(model.selectedTraits) do
        if trait == "wh2_main_trait_increased_cost_1" then
            cost = cost + 1000;
        elseif trait == "wh2_main_trait_increased_cost_2" then
            cost = cost + 3000;
        elseif trait == "wh2_main_trait_increased_cost_3" then
            cost = cost + 6000;
        elseif trait == "wh2_main_trait_increased_cost_4" then
            cost = cost + 10000;
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
    traitsText:Resize(traitsText:Width(), traitsText:Height()/2);
    traitRowContainer:AddComponent(traitsText);
    local traitList = ListView.new("MainPanelTraitList", customLordFrame, "VERTICAL");
    traitList:Resize(730, 220);
    traitRowContainer:AddComponent(traitList);
    local divider = createTraitDivider("CurrentTraitsTopDivider", customLordFrame, 600);
    traitList:AddComponent(divider);
    for i, trait in ipairs(model.selectedTraits) do
        local traitRow = createTraitRow(trait, customLordFrame, buttonCreationFunction);
        traitList:AddComponent(traitRow);
        local divider = createTraitDivider(trait .. "Divider", customLordFrame, 600);
        traitList:AddComponent(divider);
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
function createCustomLordFrameUi(recruitCallback, cost, agentType)
    model = CustomLordsModel.new();
    model:SetBaseCost(cost);
    customLordFrame = Frame.new("customLordFrame");
    customLordFrame:SetTitle("Create your custom Lord");
    local xRes, yRes = core:get_screen_resolution();
    customLordFrame:Resize(customLordFrame:Width() * 1.3 + 200, yRes - 100);
    Util.centreComponentOnScreen(customLordFrame);

    local frameContainer = Container.new(FlowLayout.VERTICAL);
    customLordFrame:AddComponent(frameContainer);
    local lordName = Text.new("lordName", customLordFrame, "HEADER", "Name your Lord");
    lordName:Resize(lordName:Width(), lordName:Height()/2);
    frameContainer:AddComponent(lordName);
    local lordNameTextBox = TextBox.new("lordNameTextBox", customLordFrame);
    frameContainer:AddComponent(lordNameTextBox);
    frameContainer:AddGap(10);

    local lordTypeText = Text.new("lordTypeText", customLordFrame, "HEADER", "Select your Lord's type");
    lordTypeText:Resize(lordTypeText:Width(), lordTypeText:Height()/2);
    frameContainer:AddComponent(lordTypeText);

    local lordTypeButtons = createLordTypeButtons(cm:get_local_faction(), customLordFrame, agentType);
    local buttonList = ListView.new("LordTypeList", customLordFrame, "HORIZONTAL");
    buttonList:Resize(customLordFrame:Width() - 55, 35);
    for i, button in pairs(lordTypeButtons) do
        buttonList:AddComponent(button);
    end
    frameContainer:AddComponent(buttonList);

    local skillSetText = Text.new("skillSetText", customLordFrame, "HEADER", "Select your Lord's skill-set");
    skillSetText:Resize(skillSetText:Width(), skillSetText:Height()/2);
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
    traitsText:Resize(traitsText:Width(), traitsText:Height()/2);
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
    traitsAttributesContainer:AddGap(70);
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

    local optionsButton = Button.new("CustomLordsOptionsButton", customLordFrame, "SQUARE", "ui/skins/default/icon_options_medium.png");
    customLordFrame:AddComponent(optionsButton);
    optionsButton:RegisterForClick(
            function(context)
                local existingFrame = Util.getComponentWithName("CustomLordOptionsFrame");
                --# assume existingFrame: FRAME
                if not existingFrame then
                    local optionsFrame = CustomLordsOptionsFrame.new(
                            model, customLordFrame,
                            function()
                                resetSelectedTraits(traitRowsContainer, frameContainer, removeTraitButtonFunction);
                            end
                    ).optionsFrame;
                    customLordFrame.uic:Adopt(optionsFrame.uic:Address());
                    Util.centreComponentOnScreen(optionsFrame);
                    customLordFrame:AddComponent(optionsFrame);
                else
                    existingFrame:SetVisible(true);
                end
            end
    );
    optionsButton:PositionRelativeTo(customLordFrame, 0, -50);

    Util.centreComponentOnComponent(recuitContainer, customLordFrame);
    local xPos, yPos = recuitContainer:Position();
    recuitContainer:MoveTo(xPos, yPos + (customLordFrame:Height() / 2) - 50);

    customLordFrame.uic:PropagatePriority(100);
    return customLordFrame;
end