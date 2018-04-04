require("custom_lords_util");

local TOTAL_TRAIT_POINTS = 5;
local MAX_TRAITS = 4;

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

--v function(currentFaction: string, frame: FRAME) --> map<string, TEXT_BUTTON>
function createLordTypeButtons(currentFaction, frame)
    local buttons = {} --: vector<TEXT_BUTTON>
    local buttonsMap = {} --: map<string, TEXT_BUTTON>
    local first = true;
        for i, factionLordType in ipairs(calculateLordTypeData(currentFaction)) do
            local lordType = factionLordType["lord_type"];
            local button = createLordTypeButton(lordType, factionLordType["lord_type_name"], frame);
            if first then
                button:SetState("selected");
            end
            first = false;
            buttonsMap[lordType] = button;
            table.insert(buttons, button);
    end
    setUpSingleButtonSelectedGroup(buttons);
    return buttonsMap;
end

--v function(skillSet: string, skillSetName: string, frame: FRAME) --> TEXT_BUTTON
function createSkillSetButton(skillSet, skillSetName, frame)
    local skillSetButton = TextButton.new(skillSet .. "Button", frame, "TEXT_TOGGLE", skillSetName);
    skillSetButton:Resize(300, skillSetButton:Height());
    skillSetButton:SetState("active");
    return skillSetButton;
end

--v function(lordType: string, frame: FRAME) --> map<string, TEXT_BUTTON>
function createSkillSetButtons(lordType, frame)
    local buttons = {} --: vector<TEXT_BUTTON>
    local buttonsMap = {} --: map<string, TEXT_BUTTON>
    local lordTypesTable = TABLES["lord_types"][lordType] --: vector<map<string, string>>
    if not lordTypesTable then
        lordTypesTable = {{key = lordType, skill_set = lordType .. "_default", skill_set_name = "Default", default_skill_set = "TRUE"}};
    end
    for i, lordType in ipairs(lordTypesTable) do
        local skillSet = lordType["skill_set"];
        local button = createSkillSetButton(skillSet, lordType["skill_set_name"], frame);
        if i == 1 then
            button:SetState("selected");
        end
        buttonsMap[skillSet] = button;
        table.insert(buttons, button);
    end
    setUpSingleButtonSelectedGroup(buttons);
    return buttonsMap;
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

--v function(selectedTraits: vector<string>) --> number
function calculateRemainingTraitPoints(selectedTraits)
    local totalTraitPoints = tonumber(0);
    for i, trait in ipairs(selectedTraits) do
        local traitPointsForTrait = tonumber(TABLES["traits"][trait]["trait_cost"]);
        totalTraitPoints = totalTraitPoints + traitPointsForTrait;
    end
    return TOTAL_TRAIT_POINTS + totalTraitPoints;
end

--v function(currentTraits: vector<string>, addTraitCallback: function(string)) --> FRAME
function createTraitSelectionFrame(currentTraits, addTraitCallback)
    local traitSelectionFrame = Frame.new("traitSelectionFrame");
    traitSelectionFrame:SetTitle("Select the Trait to Add");
    local traitSelectionFrameContainer = Container.new(FlowLayout.VERTICAL);
    traitSelectionFrame:AddComponent(traitSelectionFrameContainer);
    traitSelectionFrame:AddCloseButton();
    local traitList = ListView.new("traitList", traitSelectionFrame);
    traitList:Resize(600, traitSelectionFrame:Height() - 200);
    local divider = createTraitDivider("SelectFrameTopDivider", traitList, traitSelectionFrame:Width());
    traitList:AddComponent(divider);
    local remainingTraitPoints = calculateRemainingTraitPoints(currentTraits);
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
            if remainingTraitPoints < tonumber(TABLES["traits"][trait]["trait_cost"]) then
                addTraitButton.uic:SetDisabled(true);
                addTraitButton.uic:SetOpacity(50);
            end
            addTraitButton:Resize(25, 25);
            return addTraitButton;
        end
        if not listContains(currentTraits, trait) then
            local traitRow = createTraitRow(trait, traitSelectionFrame, addTraitButtonFunction);
            traitList:AddContainer(traitRow);
            local divider = createTraitDivider(trait .. "Divider", traitList, traitSelectionFrame:Width());
            traitList:AddComponent(divider);
        end
    end
    
    traitSelectionFrameContainer:AddComponent(traitList);
    Util.centreComponentOnComponent(traitSelectionFrameContainer, traitSelectionFrame);
    return traitSelectionFrame;
end

--v function(currentTraits: vector<string>)
function updateAddTraitButton(currentTraits)
    local addTraitButton = Util.getComponentWithName("addTraitButton");
    --# assume addTraitButton: TEXT_BUTTON
    if #currentTraits < MAX_TRAITS then
        addTraitButton:SetVisible(true);
    else
        addTraitButton:SetVisible(false);
    end
end

--v function(currentTraits: vector<string>, traitRowContainer: CONTAINER, parent: COMPONENT_TYPE | CA_UIC, buttonCreationFunction: function(trait:string, parent: COMPONENT_TYPE | CA_UIC) --> BUTTON)
function resetSelectedTraits(currentTraits, traitRowContainer, parent, buttonCreationFunction)
    output("Current traits: ");
    --# assume parent: CA_UIC
    traitRowContainer:Clear();
    local traitsText = Text.new("TraitPointsText", parent, "NORMAL", "Trait Points Remaining: " .. calculateRemainingTraitPoints(currentTraits));
    traitRowContainer:AddComponent(traitsText);
    local divider = createTraitDivider("CurrentTraitsTopDivider", parent, parent:Width());
    traitRowContainer:AddComponent(divider);
    for i, trait in ipairs(currentTraits) do
        local traitRow = createTraitRow(trait, parent, buttonCreationFunction);
        traitRowContainer:AddComponent(traitRow);
        local divider = createTraitDivider(trait .. "Divider", parent, parent:Width());
        traitRowContainer:AddComponent(divider);
        output(trait);
    end
    output("End current traits");
    updateAddTraitButton(currentTraits);
end

--v function(idToButtonMap: map<string, TEXT_BUTTON>) --> string
function findSelectedButton(idToButtonMap)
    local selectedId = nil --: string
    for id, button in pairs(idToButtonMap) do
        if button:IsSelected() then
            selectedId = id;
        end
    end
    return selectedId;
end

--v function(selectedTraits: vector<string>) --> number
function calculateRecruitmentCost(selectedTraits)
    local cost = 1000;
    for i, trait in ipairs(selectedTraits) do
        if trait == "wh2_main_trait_increased_cost" then
            cost = cost + 1000;
        end
    end
    return cost;
end

--v function(selectedTraits: vector<string>)
function updateRecruitButton(selectedTraits)
    local recuitButton = Util.getComponentWithName("recruitButton");
    --# assume recuitButton: TEXT_BUTTON
    local recruitCost = calculateRecruitmentCost(selectedTraits);
    local recruitText = "Recruit " .. "([[img:icon_treasury]][[/img]]" .. recruitCost;
    recuitButton:SetButtonText(recruitText);
    local currentFaction = cm:model():world():faction_by_key(cm:get_local_faction());
    if currentFaction:treasury() < recruitCost then
        recuitButton.uic:SetDisabled(true);
        recuitButton.uic:SetOpacity(50);
    else
        recuitButton.uic:SetDisabled(false);
        recuitButton.uic:SetOpacity(100);
    end
end

--v function(recruitCallback: function(name: string, lordType: string, skillSet: string, traits: vector<string>)) --> FRAME
function createCustomLordFrameUi(recruitCallback)
    local customLordFrame = Frame.new("customLordFrame");
    customLordFrame:SetTitle("Create your custom Lord");
    customLordFrame:Resize(customLordFrame:Width(), customLordFrame:Height() * 1.5);
    customLordFrame:MoveTo(50, 100);

    local frameContainer = Container.new(FlowLayout.VERTICAL);    
    customLordFrame:AddComponent(frameContainer);
    local lordName = Text.new("lordName", customLordFrame, "HEADER", "Name your Lord");
    frameContainer:AddComponent(lordName);
    local lordNameTextBox = TextBox.new("lordNameTextBox", customLordFrame);
    frameContainer:AddComponent(lordNameTextBox);

    local lordTypeText = Text.new("lordTypeText", customLordFrame, "HEADER", "Select your Lord type");
    frameContainer:AddComponent(lordTypeText);

    local lordTypeButtons = createLordTypeButtons(cm:get_local_faction(), customLordFrame);
    local buttonContainer = Container.new(FlowLayout.HORIZONTAL);
    for i, button in pairs(lordTypeButtons) do
        buttonContainer:AddComponent(button);
    end
    frameContainer:AddComponent(buttonContainer);

    local skillSetText = Text.new("skillSetText", customLordFrame, "HEADER", "Select your Lord skill-set");
    frameContainer:AddComponent(skillSetText);

    local skillSetButtonsContainer = Container.new(FlowLayout.HORIZONTAL);
    local lordTypeToSkillSetButtons = {} --: map<string, vector<TEXT_BUTTON>>
    local skillSetToButtonMap = {} --: map<string, TEXT_BUTTON>
    for lordType, lordTypeButton in pairs(lordTypeButtons) do
        lordTypeToSkillSetButtons[lordType] = {};
        local skillSetButtons = createSkillSetButtons(lordType, customLordFrame);
        for skillSet, skillSetButton in pairs(skillSetButtons) do
            skillSetButtonsContainer:AddComponent(skillSetButton);
            table.insert(lordTypeToSkillSetButtons[lordType], skillSetButton);
            skillSetToButtonMap[skillSet] = skillSetButton;
            if lordTypeButton:CurrentState() == "selected" then
                skillSetButton:SetVisible(true);
            else
                skillSetButton:SetVisible(false);
            end
        end
    end
    for lordType, lordTypeButton in pairs(lordTypeButtons) do
        lordTypeButton:RegisterForClick(
            function(context)
                for otherLordType, skillSetButtons in pairs(lordTypeToSkillSetButtons) do
                    for i, skillSetButton in ipairs(skillSetButtons) do
                        if otherLordType == lordType then
                            skillSetButton:SetVisible(true);
                        else
                            skillSetButton:SetVisible(false);
                        end
                    end
                end
                frameContainer:Reposition();
            end
        );
    end
    frameContainer:AddComponent(skillSetButtonsContainer);

    local traitsText = Text.new("traitsText", customLordFrame, "HEADER", "Select your Lord traits");
    frameContainer:AddComponent(traitsText);

    local selectedTraits = {} --: vector<string>
    table.insert(selectedTraits, "wh2_main_trait_defeated_teclis");
    local traitToRow = {} --: map<string, CONTAINER>    
    local traitRowsContainer = Container.new(FlowLayout.VERTICAL);  

    local removeTraitButtonFunction = nil --: function(string, COMPONENT_TYPE | CA_UIC) --> BUTTON
    removeTraitButtonFunction = function(
        trait, --: string
        parent --: COMPONENT_TYPE | CA_UIC
    )
        local removeTraitButton = Button.new("removeTraitButton" .. trait, parent, "SQUARE", "ui/skins/default/parchment_header_max.png");
        removeTraitButton:RegisterForClick(
            function(context)
                removeFromList(selectedTraits, trait);
                resetSelectedTraits(selectedTraits, traitRowsContainer, customLordFrame, removeTraitButtonFunction);
                frameContainer:PositionRelativeTo(customLordFrame, 20, 20);
                updateRecruitButton(selectedTraits);
            end
        )
        removeTraitButton:Resize(25, 25);
        return removeTraitButton;
    end

    frameContainer:AddComponent(traitRowsContainer);

    local addTraitButton = TextButton.new("addTraitButton", customLordFrame, "TEXT", "Add Trait");
    addTraitButton:RegisterForClick(
        function(context)
            local existingFrame = Util.getComponentWithName("traitSelectionFrame");
            --# assume existingFrame: FRAME
            if not existingFrame then
                local traitSelectionFrame = createTraitSelectionFrame(selectedTraits, 
                    function(addedTrait)
                        table.insert(selectedTraits, addedTrait);
                        resetSelectedTraits(selectedTraits, traitRowsContainer, customLordFrame, removeTraitButtonFunction);
                        frameContainer:PositionRelativeTo(customLordFrame, 20, 20);
                        updateRecruitButton(selectedTraits);
                    end
                );
                customLordFrame.uic:Adopt(traitSelectionFrame.uic:Address());
                traitSelectionFrame:PositionRelativeTo(customLordFrame, customLordFrame:Width()-300, 0);
            end
        end
    );
    frameContainer:AddComponent(addTraitButton);

    resetSelectedTraits(selectedTraits, traitRowsContainer, customLordFrame, removeTraitButtonFunction);
    frameContainer:PositionRelativeTo(customLordFrame, 20, 20);

    local recuitContainer = Container.new(FlowLayout.HORIZONTAL);
    customLordFrame:AddComponent(recuitContainer);
    local recuitButton = TextButton.new("recruitButton", customLordFrame, "TEXT", "");
    recuitButton:RegisterForClick(
        function(context)
            recruitCallback(
                lordNameTextBox.uic:GetStateText(),
                findSelectedButton(lordTypeButtons),
                findSelectedButton(skillSetToButtonMap),
                selectedTraits
            );
            customLordFrame:Delete();
        end
    );
    updateRecruitButton(selectedTraits);
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