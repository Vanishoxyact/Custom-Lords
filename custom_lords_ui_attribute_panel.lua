require("custom_lords_util");
local maxDiff = 4;
local CustomLordsAttributePanel = {} --# assume CustomLordsAttributePanel: CUSTOM_LORDS_ATTRIBUTE_PANEL
CustomLordsAttributePanel.__index = CustomLordsAttributePanel;
CustomLordsAttributePanel.model = nil --: CUSTOM_LORDS_MODEL
CustomLordsAttributePanel.attributesContainer = nil --: CONTAINER
CustomLordsAttributePanel.attributeRowContainer = nil --: CONTAINER
CustomLordsAttributePanel.parentFrame = nil --: FRAME
CustomLordsAttributePanel.attributeText = {} --: map<string, TEXT>
CustomLordsAttributePanel.attributePointIndicators = {} --: map<string, map<int, IMAGE>>
CustomLordsAttributePanel.attributeIncreaseButton = {} --: map<string, BUTTON>
CustomLordsAttributePanel.attributeDecreaseButton = {} --: map<string, BUTTON>
CustomLordsAttributePanel.remainingAttributePointsText = nil --: TEXT

--v function(model: CUSTOM_LORDS_MODEL) --> int
function calculateRemainingAttributePoints(model)
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

--v function(attribute: string, value: int) --> string
function calculateAttributeText(attribute, value)
    local attributeEffectBundle = calculateEffectBundleForAttributeAndValue(attribute, value);
    local changeValue = calculateEffectValueForEffectBundle(attributeEffectBundle);
    local changeText = tostring(changeValue);
    if changeValue >= 0 then
        changeText = "+" .. changeText;
    end
    return changeText;
end

--v function(value: int) --> boolean
function shouldDecreaseButtonBeDisabled(value)
    if value == maxDiff * -1 then
        return true;
    else
        return false;
    end
end

--v function(value: int, model: CUSTOM_LORDS_MODEL) --> boolean
function shouldIncreaseButtonBeDisabled(value, model)
    local remainingPoints = calculateRemainingAttributePoints(model);
    if value == maxDiff or remainingPoints <= 0 then
        return true;
    else
        return false;
    end
end

--v function(indicatorValue: number, value: number) --> number
function calculateAttributePointOpacity(indicatorValue, value)
    if indicatorValue > value then
        return 50;
    else
        return 255;
    end
end

--v function(self: CUSTOM_LORDS_ATTRIBUTE_PANEL, attribute: string, value: int, frame: FRAME, model: CUSTOM_LORDS_MODEL) --> CONTAINER
function CustomLordsAttributePanel.createAttributeRow(self, attribute, value, frame, model)
    local remainingPoints = calculateRemainingAttributePoints(model);
    local rowContainer = Container.new(FlowLayout.HORIZONTAL);
    local attributeEffectBundle = calculateEffectBundleForAttributeAndValue(attribute, value);
    local attributeEffect = calculateEffectForEffectBundle(attributeEffectBundle);
    
    local attributeChangeText = Text.new("AttributeChangeText" .. attribute, frame, "NORMAL", "");
    attributeChangeText:Resize(35, 20);
    rowContainer:AddComponent(attributeChangeText);
    self.attributeText[attribute] = attributeChangeText;

    local effectImage = TABLES["effects_tables"][attributeEffect]["icon"];
    local attributeImage = Image.new("AttributeRowImage" .. attribute, frame, "ui/campaign ui/effect_bundles/" .. effectImage);
    rowContainer:AddComponent(attributeImage);
    rowContainer:AddGap(15);
    local decreaseButton = Button.new("AttributeDecreaseButton" .. attribute, frame, "SQUARE", "ui/skins/default/parchment_header_max.png");
    decreaseButton:Resize(25, 25);
    decreaseButton:RegisterForClick(
        function(context)
            model:SetAttributeValue(attribute, model.attributeValues[attribute] - 1);
        end
    );
    rowContainer:AddComponent(decreaseButton);
    self.attributeDecreaseButton[attribute] = decreaseButton;
    self.attributePointIndicators[attribute] = {};
    for i=-maxDiff,maxDiff do
        local attributePointIndicator = Image.new("AttributePointIndicator" .. attribute .. i, frame, "ui/skins/warhammer2/button_basic_hover.png");
        attributePointIndicator:Resize(25, 25);
        rowContainer:AddComponent(attributePointIndicator);
        self.attributePointIndicators[attribute][i] = attributePointIndicator;
    end
    local increaseButton = Button.new("AttributeIncreaseButton" .. attribute, frame, "SQUARE", "ui/skins/default/parchment_header_min.png");
    increaseButton:Resize(25, 25);
    increaseButton:RegisterForClick(
        function(context)
            model:SetAttributeValue(attribute, model.attributeValues[attribute] + 1);
        end
    );
    rowContainer:AddComponent(increaseButton);
    self.attributeIncreaseButton[attribute] = increaseButton;

    rowContainer:AddGap(10);
    return rowContainer;
end

--v function(self: CUSTOM_LORDS_ATTRIBUTE_PANEL, model: CUSTOM_LORDS_MODEL, parentFrame: FRAME) --> (CONTAINER, CONTAINER)
function CustomLordsAttributePanel.createTraitsAttributesContainer(self, model, parentFrame)
    local attributesContainer = Container.new(FlowLayout.VERTICAL);
    local attributesText = Text.new("attributesText", parentFrame, "HEADER", "Define your Lord's attributes");
    attributesContainer:AddComponent(attributesText);
    local attributesTable = TABLES["attributes"] --: map<string, vector<map<string, string>>>
    for attribute, table in pairs(attributesTable) do
        model:SetAttributeValue(attribute, 0);
    end
    local attributeRowContainer = Container.new(FlowLayout.VERTICAL);
    attributesContainer:AddComponent(attributeRowContainer);
    return attributesContainer, attributeRowContainer;
end

--v function(model: CUSTOM_LORDS_MODEL) --> string
function calculateAttributePointRemainingText(model)
    return "Attribute Points: " .. calculateRemainingAttributePoints(model);
end

--v function() --> boolean
function isCurrentFactionDwarf()
    local currentFaction = get_faction(cm:get_local_faction());
    return currentFaction:culture() == "wh_main_dwf_dwarfs";
end

--v function(self: CUSTOM_LORDS_ATTRIBUTE_PANEL)
function CustomLordsAttributePanel.constructAttributeContainer(self)
    local remainingAttributePointsText = Text.new("remainingAttributePointsText", self.parentFrame, "NORMAL", "");
    self.remainingAttributePointsText = remainingAttributePointsText;
    self.attributesContainer:AddComponent(remainingAttributePointsText);
    for attribute, value in pairs(self.model.attributeValues) do
        if not (attribute == "char_winds" and isCurrentFactionDwarf()) then
            local attributeRow = self:createAttributeRow(attribute, value, self.parentFrame, self.model);
            self.attributesContainer:AddComponent(attributeRow);
        end
    end
    self.attributesContainer:Reposition();
end

--v function(self: CUSTOM_LORDS_ATTRIBUTE_PANEL, attribute: string, value: int)
function CustomLordsAttributePanel.updateAttributeRow(self, attribute, value)
    self.attributeText[attribute]:SetText(calculateAttributeText(attribute, value));
    self.attributeDecreaseButton[attribute]:SetDisabled(shouldDecreaseButtonBeDisabled(value));
    for i=-maxDiff,maxDiff do
        self.attributePointIndicators[attribute][i]:SetOpacity(calculateAttributePointOpacity(i, value));
    end
    self.attributeIncreaseButton[attribute]:SetDisabled(shouldIncreaseButtonBeDisabled(value, self.model));
end

--v function(self: CUSTOM_LORDS_ATTRIBUTE_PANEL)
function CustomLordsAttributePanel.resetAttributeContainer(self)
    self.remainingAttributePointsText:SetText(calculateAttributePointRemainingText(self.model));
    for attribute, value in pairs(self.model.attributeValues) do
        if not (attribute == "char_winds" and isCurrentFactionDwarf()) then
            self:updateAttributeRow(attribute, value);
        end
    end
end

--v function(model: CUSTOM_LORDS_MODEL, parentFrame: FRAME) --> CUSTOM_LORDS_ATTRIBUTE_PANEL
function CustomLordsAttributePanel.new(model, parentFrame)
    local clap = {};
    setmetatable(clap, CustomLordsAttributePanel);
    --# assume clap: CUSTOM_LORDS_ATTRIBUTE_PANEL
    clap.model = model;
    clap.parentFrame = parentFrame;
    local attributesContainer, attributeRowContainer = clap:createTraitsAttributesContainer(model, parentFrame);
    clap.attributesContainer = attributesContainer;
    clap.attributeRowContainer = attributeRowContainer;
    clap:constructAttributeContainer();
    clap:resetAttributeContainer();
    model:RegisterForEvent(
        "ATTRIBUTE_VALUE_CHANGE", 
        function()
            clap:resetAttributeContainer();
        end
    );
    return clap;
end

return {
    new = CustomLordsAttributePanel.new
}