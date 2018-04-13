require("custom_lords_util");
local CustomLordsArtPanel = {} --# assume CustomLordsArtPanel: CUSTOM_LORDS_ART_PANEL
CustomLordsArtPanel.__index = CustomLordsArtPanel;
CustomLordsArtPanel.model = nil --: CUSTOM_LORDS_MODEL
CustomLordsArtPanel.parentFrame = nil --: FRAME
CustomLordsArtPanel.artContainer = nil --: CONTAINER
CustomLordsArtPanel.artButtonsContainer = nil --: CONTAINER

--v function(self: CUSTOM_LORDS_ART_PANEL) --> vector<string>
function CustomLordsArtPanel.calculateArtIds(self)
    local artIds = {} --: vector<string>
    local lordTypeArtTable = TABLES["lord_type_art"] --: map<string, vector<map<string, string>>>
    local currentLordType = self.model.selectedLordType;
    local lordTypeArt = lordTypeArtTable[currentLordType];
    if not lordTypeArt then
        return artIds;
    end
    for i, artTable in ipairs(lordTypeArt) do
        table.insert(artIds, artTable["art_set_id"]);
    end
    return artIds;
end

--v function(self: CUSTOM_LORDS_ART_PANEL, artId: string) --> string
function CustomLordsArtPanel.calculateArtPortaitPath(self, artId)
    local lordTypeArtTable = TABLES["lord_type_art"] --: map<string, vector<map<string, string>>>
    for lordType, lordTypeVectorTable in pairs(lordTypeArtTable) do
        for i, lordTypeTable in ipairs(lordTypeVectorTable) do
            if lordTypeTable["art_set_id"] == artId then
                local culture = lordTypeTable["culture"];
                local portraitName = lordTypeTable["portrait_name"];
                return "ui/portraits/portholes/" .. culture .. "/" .. portraitName .. ".png";
            end
        end
    end
    output("Failed to calculate art portrait path for art id: " .. artId);
    return nil;
end

--v function(self: CUSTOM_LORDS_ART_PANEL) --> vector<BUTTON>
function CustomLordsArtPanel.createArtButtons(self)
    local artButtons = {} --: vector<BUTTON>
    local artIds = self:calculateArtIds();

    local randomArtButton = Button.new("RandomArtButton", self.parentFrame, "CIRCULAR_TOGGLE", "ui/portraits/portholes/no_culture/random.png");
    randomArtButton:RegisterForClick(
        function(context)
            self.model:SetSelectedArtId("");
        end
    );
    randomArtButton:SetState("selected");
    table.insert(artButtons, randomArtButton);
    for i, artId in ipairs(artIds) do
        local artIdImagePath = self:calculateArtPortaitPath(artId);
        local artButton = Button.new(artId .. "ArtButton", self.parentFrame, "CIRCULAR_TOGGLE", artIdImagePath);
        artButton:RegisterForClick(
            function(context)
                self.model:SetSelectedArtId(artId);
            end
        );
        table.insert(artButtons, artButton);
    end
    setUpSingleButtonSelectedGroupButton(artButtons);
    return artButtons;
end

--v function(self: CUSTOM_LORDS_ART_PANEL) --> LIST_VIEW
function CustomLordsArtPanel.createArtSelectionList(self)
    local artSelectionButtons = self:createArtButtons();
    local artSelectionList = ListView.new("artSelectionList", self.parentFrame, "HORIZONTAL");
    artSelectionList:Resize(self.parentFrame:Width() - 55, 52);
    for i, button in pairs(artSelectionButtons) do
        artSelectionList:AddComponent(button);
    end
    return artSelectionList;
end

--v function(self: CUSTOM_LORDS_ART_PANEL)
function CustomLordsArtPanel.populateArtButtonsContainer(self)
    self.artButtonsContainer:Clear();
    self.artButtonsContainer:AddComponent(self:createArtSelectionList())
    self.artButtonsContainer:Reposition();
end

--v function(self: CUSTOM_LORDS_ART_PANEL) --> CONTAINER
function CustomLordsArtPanel.constructArtContainer(self)
    local artContainer = Container.new(FlowLayout.VERTICAL);
    local artTypeText = Text.new("artTypeText", self.parentFrame, "HEADER", "Select your lord's appearance");
    artTypeText:Resize(artTypeText:Width(), artTypeText:Height()/2);
    artContainer:AddComponent(artTypeText);
    local artButtonsContainer = Container.new(FlowLayout.VERTICAL);
    self.artButtonsContainer = artButtonsContainer;
    artContainer:AddComponent(artButtonsContainer);
    return artContainer;
end

--v function(model: CUSTOM_LORDS_MODEL, parentFrame: FRAME) --> CUSTOM_LORDS_ART_PANEL
function CustomLordsArtPanel.new(model, parentFrame)
    local clap = {};
    setmetatable(clap, CustomLordsArtPanel);
    --# assume clap: CUSTOM_LORDS_ART_PANEL
    clap.model = model;
    clap.parentFrame = parentFrame;
    clap.artContainer = clap:constructArtContainer();
    clap:populateArtButtonsContainer();
    model:RegisterForEvent(
        "SELECTED_LORD_TYPE_CHANGE", 
        function()
            clap:populateArtButtonsContainer();
        end
    );
    return clap;
end

return {
    new = CustomLordsArtPanel.new
}