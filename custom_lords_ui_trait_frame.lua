local TOTAL_TRAIT_POINTS = 2;
MAX_TRAITS = 4;
local CustomLordsTraitFrame = {} --# assume CustomLordsTraitFrame: CUSTOM_LORDS_TRAIT_FRAME
CustomLordsTraitFrame.__index = CustomLordsTraitFrame;
CustomLordsTraitFrame.model = nil --: CUSTOM_LORDS_MODEL
CustomLordsTraitFrame.parentFrame = nil --: FRAME

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

--v function(model: CUSTOM_LORDS_MODEL) --> number
function calculateRemainingTraitPoints(model)
    local totalTraitPoints = tonumber(0);
    for i, trait in ipairs(model.selectedTraits) do
        local traitPointsForTrait = tonumber(TABLES["traits"][trait]["trait_cost"]);
        totalTraitPoints = totalTraitPoints + traitPointsForTrait;
    end
    return TOTAL_TRAIT_POINTS + totalTraitPoints;
end

--v function(self: CUSTOM_LORDS_TRAIT_FRAME, addTraitCallback: function(string)) --> FRAME
function CustomLordsTraitFrame.createTraitSelectionFrame(self, addTraitCallback)
    local traitSelectionFrame = Frame.new("traitSelectionFrame");
    traitSelectionFrame:SetTitle("Select the trait to add");
    local traitSelectionFrameContainer = Container.new(FlowLayout.VERTICAL);
    traitSelectionFrame:AddComponent(traitSelectionFrameContainer);
    traitSelectionFrame:AddCloseButton();
    local traitList = ListView.new("traitList", traitSelectionFrame, "VERTICAL");
    traitList:Resize(600, traitSelectionFrame:Height() - 200);
    local divider = createTraitDivider("SelectFrameTopDivider", traitList, traitSelectionFrame:Width());
    traitList:AddComponent(divider);
    local remainingTraitPoints = calculateRemainingTraitPoints(self.model);
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
        if not listContains(self.model.selectedTraits, trait) then
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

--v function(model: CUSTOM_LORDS_MODEL, parentFrame: FRAME, addTraitCallback: function(string)) --> CUSTOM_LORDS_TRAIT_FRAME
function CustomLordsTraitFrame.new(model, parentFrame, addTraitCallback)
    local cltf = {};
    setmetatable(cltf, CustomLordsTraitFrame);
    --# assume cltf: CUSTOM_LORDS_TRAIT_FRAME
    cltf.model = model;
    cltf.parentFrame = parentFrame;
    cltf.traitSelectionFrame = cltf:createTraitSelectionFrame(addTraitCallback);
    return cltf;
end

return {
    new = CustomLordsTraitFrame.new
}