require("custom_lords_tables");
require("custom_lords_util");

local TOTAL_TRAIT_POINTS = 5;

--v function(buttons: vector<TEXT_BUTTON>)
function setUpSingleButtonSelectedGroup(buttons)
    for i, button in ipairs(buttons) do
        button:RegisterForClick(button.name .. "SelectListener",
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

--v function(lordType: string, frame: FRAME) --> TEXT_BUTTON
function createLordTypeButton(lordType, frame)
    local lordTypeButton = TextButton.new(lordType .. "Button", frame, "TEXT_TOGGLE", LORD_TYPE_NAMES[lordType]);
    lordTypeButton:Resize(300, lordTypeButton:Height());
    lordTypeButton:SetState("active");
    return lordTypeButton;
end

--v function(currentFaction: string, frame: FRAME) --> map<string, TEXT_BUTTON>
function createLordTypeButtons(currentFaction, frame)
    local buttons = {} --: vector<TEXT_BUTTON>
    local buttonsMap = {} --: map<string, TEXT_BUTTON>
    for i, lordType in ipairs(FACTION_LORD_TYPES[currentFaction]) do
        local button = createLordTypeButton(lordType, frame);
        if i == 1 then
            button:SetState("selected");
        end
        buttonsMap[lordType] = button;
        table.insert(buttons, button);
    end
    setUpSingleButtonSelectedGroup(buttons);
    return buttonsMap;
end

--v function(skillSet: string, frame: FRAME) --> TEXT_BUTTON
function createSkillSetButton(skillSet, frame)
    local skillSetButton = TextButton.new(skillSet .. "Button", frame, "TEXT_TOGGLE", SKILL_SETS_NAMES[skillSet]);
    skillSetButton:Resize(300, skillSetButton:Height());
    skillSetButton:SetState("active");
    return skillSetButton;
end

--v function(lordType: string, frame: FRAME) --> map<string, TEXT_BUTTON>
function createSkillSetButtons(lordType, frame)
    local buttons = {} --: vector<TEXT_BUTTON>
    local buttonsMap = {} --: map<string, TEXT_BUTTON>
    for i, skillSet in ipairs(LORD_SKILL_SETS[lordType]) do
        local button = createSkillSetButton(skillSet, frame);
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
    local traitCost = Text.new(trait .. "CostText", parent, "NORMAL", TRAIT_COSTS[trait] .. " Trait Points");
    traitCost:Resize(100, traitCost:Height());
    traitRow:AddComponent(traitCost);
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
        local traitPointsForTrait = TRAIT_COSTS[trait];
        totalTraitPoints = totalTraitPoints + traitPointsForTrait;
    end
    return TOTAL_TRAIT_POINTS - totalTraitPoints;
end

--v function(currentTraits: vector<string>, addTraitCallback: function(string)) --> FRAME
function createTraitSelectionFrame(currentTraits, addTraitCallback)
    local traitSelectionFrame = Frame.new("traitSelectionFrame");
    traitSelectionFrame:SetTitle("Select the Trait to Add");
    --traitSelectionFrame:Scale(0.75);
    local traitSelectionFrameContainer = Container.new(FlowLayout.VERTICAL);
    local traitList = ListView.new("traitList", traitSelectionFrame);
    traitList:Resize(600, traitSelectionFrame:Height() - 200);
    local divider = createTraitDivider("SelectFrameTopDivider", traitList, traitSelectionFrame:Width());
    traitList:AddComponent(divider);
    local remainingTraitPoints = calculateRemainingTraitPoints(currentTraits);
    for i, trait in ipairs(TRAITS) do
        local addTraitButtonFunction = function(
            trait, --: string
            parent --: COMPONENT_TYPE | CA_UIC
        )
            local addTraitButton = Button.new("addTraitButton" .. trait, parent, "SQUARE", "ui/skins/default/parchment_header_min.png");
            addTraitButton:RegisterForClick(
                "addTraitButton" .. trait .. "Listener",
                function(context)
                    traitSelectionFrameContainer:Clear();
                    traitSelectionFrame:Delete();
                    addTraitCallback(trait);
                end
            )
            if remainingTraitPoints < TRAIT_COSTS[trait] then
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

--v function(recruitCallback: function(name: string, lordType: string, skillSet: string, traits: vector<string>)) --> FRAME
function createCustomLordFrameUi(recruitCallback)
    local customLordFrame = Frame.new("customLordFrame");
    customLordFrame:SetTitle("Create your custom Lord");
    customLordFrame:Resize(customLordFrame:Width(), customLordFrame:Height() * 1.5);
    customLordFrame:MoveTo(50, 100);

    local frameContainer = Container.new(FlowLayout.VERTICAL);        
    local lordName = Text.new("lordName", customLordFrame, "NORMAL", "Name your Lord");
    frameContainer:AddComponent(lordName);
    local lordNameTextBox = TextBox.new("lordNameTextBox", customLordFrame);
    frameContainer:AddComponent(lordNameTextBox);

    local lordTypeText = Text.new("lordTypeText", customLordFrame, "NORMAL", "Select your Lord type");
    frameContainer:AddComponent(lordTypeText);

    local lordTypeButtons = createLordTypeButtons(cm:get_local_faction(), customLordFrame);
    local buttonContainer = Container.new(FlowLayout.HORIZONTAL);
    for i, button in pairs(lordTypeButtons) do
        buttonContainer:AddComponent(button);
    end
    frameContainer:AddComponent(buttonContainer);

    local skillSetText = Text.new("skillSetText", customLordFrame, "NORMAL", "Select your Lord skill-set");
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
        lordTypeButton:RegisterForClick(lordTypeButton.name .. "SkillSetListener",
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
                Util.centreComponentOnComponent(frameContainer, customLordFrame);
            end
        );
    end
    frameContainer:AddComponent(skillSetButtonsContainer);

    local traitsText = Text.new("traitsText", customLordFrame, "NORMAL", "Select your Lord traits");
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
            "removeTraitButton" .. trait .. "Listener",
            function(context)
                removeFromList(selectedTraits, trait);
                resetSelectedTraits(selectedTraits, traitRowsContainer, customLordFrame, removeTraitButtonFunction);
                frameContainer:PositionRelativeTo(customLordFrame, 50, 50);
            end
        )
        removeTraitButton:Resize(25, 25);
        return removeTraitButton;
    end

    resetSelectedTraits(selectedTraits, traitRowsContainer, customLordFrame, removeTraitButtonFunction);
    frameContainer:AddComponent(traitRowsContainer);

    local addTraitButton = TextButton.new("addTraitButton", customLordFrame, "TEXT", "Add Trait");
    addTraitButton:RegisterForClick(
        "addTraitButtonClickListener", 
        function(context)
            local traitSelectionFrame = createTraitSelectionFrame(selectedTraits, 
                function(addedTrait)
                    table.insert(selectedTraits, addedTrait);
                    resetSelectedTraits(selectedTraits, traitRowsContainer, customLordFrame, removeTraitButtonFunction);
                    frameContainer:PositionRelativeTo(customLordFrame, 50, 50);
                end
            );
            customLordFrame.uic:Adopt(traitSelectionFrame.uic:Address());
            traitSelectionFrame:PositionRelativeTo(customLordFrame, customLordFrame:Width()-300, 0);
        end
    );

    frameContainer:AddComponent(addTraitButton);
    frameContainer:PositionRelativeTo(customLordFrame, 50, 50);

    local region = string.sub(tostring(cm:get_campaign_ui_manager().settlement_selected), 12);
    local settlement = get_region(region):settlement();
    customLordFrame:AddCloseButton(
        function()
            recruitCallback(
                lordNameTextBox.uic:GetStateText(),
                findSelectedButton(lordTypeButtons),
                findSelectedButton(skillSetToButtonMap),
                selectedTraits
            );
        end
    );

    customLordFrame.uic:PropagatePriority(100);
    return customLordFrame;
end