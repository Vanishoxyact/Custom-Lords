core:load_mod_script("custom_lords_util");
local CustomLordsOptionsFrame = {} --# assume CustomLordsOptionsFrame: CUSTOM_LORDS_OPTIONS_FRAME
CustomLordsOptionsFrame.__index = CustomLordsOptionsFrame;
CustomLordsOptionsFrame.model = nil --: CUSTOM_LORDS_MODEL
CustomLordsOptionsFrame.parentFrame = nil --: FRAME
CustomLordsOptionsFrame.optionsFrame = nil --: FRAME
CustomLordsOptionsFrame.closeCallback = nil --: function()

--v function(self: CUSTOM_LORDS_OPTIONS_FRAME, name: string, getterFunction: function() --> int, setterFunction: function(int)) --> CONTAINER
function CustomLordsOptionsFrame.CreateConfigurationRow(self, name, getterFunction, setterFunction)
    local configurationRow = Container.new(FlowLayout.HORIZONTAL);
    local nameLabel = Text.new(name .. "ConfigurationLabel", self.optionsFrame, "NORMAL", name);
    configurationRow:AddComponent(nameLabel);

    local valueLabel = Text.new(name .. "ConfigurationValueLabel", self.optionsFrame, "NORMAL", tostring(getterFunction()));
    configurationRow:AddComponent(valueLabel);

    local increaseButton = Button.new(name .. "ConfigurationIncreaseButton", self.optionsFrame, "SQUARE", "ui/skins/default/parchment_header_min.png");
    increaseButton:RegisterForClick(
            function(context)
                setterFunction(getterFunction() + 1);
                valueLabel:SetText(tostring(getterFunction()));
            end
    );
    configurationRow:AddComponent(increaseButton);

    local decreaseButton = Button.new(name .. "ConfigurationDecreaseButton", self.optionsFrame, "SQUARE", "ui/skins/default/parchment_header_max.png");
    decreaseButton:RegisterForClick(
            function(context)
                if getterFunction() > 0 then
                    setterFunction(getterFunction() - 1);
                    valueLabel:SetText(tostring(getterFunction()));
                end
            end
    );
    configurationRow:AddComponent(decreaseButton);
    return configurationRow;
end

--v function(self: CUSTOM_LORDS_OPTIONS_FRAME) --> CONTAINER
function CustomLordsOptionsFrame.CreateConfigurationPanel(self)
    local configurationContainer = Container.new(FlowLayout.VERTICAL);
    local maxTraitsConfiguration = self:CreateConfigurationRow(
            "Max Traits",
            function() return self.model.maxTraits end,
            function(value) self.model:SetMaxTraits(value) end
    );
    configurationContainer:AddComponent(maxTraitsConfiguration);
    local startingTraitPointsConfiguration = self:CreateConfigurationRow(
            "Starting Trait Points",
            function() return self.model.startingTraitPoints end,
            function(value) self.model:SetStartingTraitPoints(value) end
    );
    configurationContainer:AddComponent(startingTraitPointsConfiguration);
    return configurationContainer;
end

--v function(self: CUSTOM_LORDS_OPTIONS_FRAME) --> FRAME
function CustomLordsOptionsFrame.CreateOptionsFrame(self)
    local optionsFrame = Frame.new("CustomLordOptionsFrame");
    self.optionsFrame = optionsFrame;
    optionsFrame:SetTitle("Custom Lord Creation Options");
    local optionsFrameContainer = Container.new(FlowLayout.VERTICAL);
    optionsFrame:AddComponent(optionsFrameContainer);
    optionsFrame:AddCloseButton(self.closeCallback, false, true);
    local configurationPanel = self:CreateConfigurationPanel();
    optionsFrameContainer:AddComponent(configurationPanel);
    Util.centreComponentOnComponent(optionsFrameContainer, optionsFrame);
    return optionsFrame;
end

--v function(model: CUSTOM_LORDS_MODEL, parentFrame: FRAME, closeCallback: function()) --> CUSTOM_LORDS_OPTIONS_FRAME
function CustomLordsOptionsFrame.new(model, parentFrame, closeCallback)
    local clop = {};
    setmetatable(clop, CustomLordsOptionsFrame);
    --# assume clop: CUSTOM_LORDS_OPTIONS_FRAME
    clop.model = model;
    clop.parentFrame = parentFrame;
    clop.closeCallback = closeCallback;
    clop.optionsFrame = clop:CreateOptionsFrame();
    return clop;
end

return {
    new = CustomLordsOptionsFrame.new
}