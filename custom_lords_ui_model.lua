core:load_mod_script("custom_lords_util");
local CustomLordsModel = {} --# assume CustomLordsModel: CUSTOM_LORDS_MODEL
CustomLordsModel.__index = CustomLordsModel;

--v function() --> CUSTOM_LORDS_MODEL
function CustomLordsModel.new()
    local clm = {};
    setmetatable(clm, CustomLordsModel);
    --# assume clm: CUSTOM_LORDS_MODEL
    clm.lordTypes = {} --: vector<string>
    clm.selectedLordType = nil --: string
    clm.skillSets = {} --: vector<string>
    clm.selectedSkillSet = nil --: string
    clm.selectedArtId = "" --: string
    clm.availableTraits = {} --: vector<string>
    clm.selectedTraits = {} --: vector<string>
    clm.attributeValues = {} --: map<string, int>
    clm.baseCost = 0 --: number
    clm.maxTraits = 6 --: int
    clm.startingTraitPoints = 2 --: int
    clm.callbacks = {} --: map<CUSTOM_LORDS_EVENT, vector<function()>>
    return clm
end

--v function(self: CUSTOM_LORDS_MODEL, eventType: CUSTOM_LORDS_EVENT)
function CustomLordsModel.RegisterForEventType(self, eventType)
    if not self.callbacks[eventType] then
        self.callbacks[eventType] = {};
    end
end

--v function(self: CUSTOM_LORDS_MODEL, eventType: CUSTOM_LORDS_EVENT) --> vector<function()>
function CustomLordsModel.GetCallbacksForEventType(self, eventType)
    if not self.callbacks[eventType] then
        return {};
    else
        return self.callbacks[eventType];
    end
end

--v function(self: CUSTOM_LORDS_MODEL, eventType: CUSTOM_LORDS_EVENT, callback: function())
function CustomLordsModel.RegisterForEvent(self, eventType, callback)
    self:RegisterForEventType(eventType);
    local eventCallbacks = self:GetCallbacksForEventType(eventType);
    table.insert(eventCallbacks, callback);
end

--v function(self: CUSTOM_LORDS_MODEL, eventType: CUSTOM_LORDS_EVENT)
function CustomLordsModel.NotifyEvent(self, eventType)
    local eventCallbacks = self:GetCallbacksForEventType(eventType);
    for i, callback in ipairs(eventCallbacks) do
        callback();
    end
end

--v function(self: CUSTOM_LORDS_MODEL, lordTypes: vector<string>)
function CustomLordsModel.SetLordTypes(self, lordTypes)
    self.lordTypes = lordTypes;
    self:NotifyEvent("LORD_TYPES_CHANGE");
end

--v function(self: CUSTOM_LORDS_MODEL, selectedLordType: string)
function CustomLordsModel.SetSelectedLordType(self, selectedLordType)
    self.selectedLordType = selectedLordType;
    self:NotifyEvent("SELECTED_LORD_TYPE_CHANGE");
end

--v function(self: CUSTOM_LORDS_MODEL, skillSets: vector<string>)
function CustomLordsModel.SetSkillSets(self, skillSets)
    self.skillSets = skillSets;
    self:NotifyEvent("SKILL_SETS_CHANGE");
end

--v function(self: CUSTOM_LORDS_MODEL, selectedSkillSet: string)
function CustomLordsModel.SetSelectedSkillSet(self, selectedSkillSet)
    self.selectedSkillSet = selectedSkillSet;
    self:NotifyEvent("SELECTED_SKILL_SET_CHANGE");
end

--v function(self: CUSTOM_LORDS_MODEL, availableTraits: vector<string>)
function CustomLordsModel.SetAvailableTraits(self, availableTraits)
    self.availableTraits = availableTraits;
    self:NotifyEvent("AVAILABLE_TRAITS_CHANGE");
end

--v function(self: CUSTOM_LORDS_MODEL, addedTrait: string)
function CustomLordsModel.AddSelectedTrait(self, addedTrait)
    table.insert(self.selectedTraits, addedTrait);
    self:NotifyEvent("SELECTED_TRAITS_CHANGE");
end

--v function(self: CUSTOM_LORDS_MODEL, removedTrait: string)
function CustomLordsModel.RemoveSelectedTrait(self, removedTrait)
    removeFromList(self.selectedTraits, removedTrait);
    self:NotifyEvent("SELECTED_TRAITS_CHANGE");
end

--v function(self: CUSTOM_LORDS_MODEL, attribute: string, value: int)
function CustomLordsModel.SetAttributeValue(self, attribute, value)
    self.attributeValues[attribute] = value;
    self:NotifyEvent("ATTRIBUTE_VALUE_CHANGE");
end

--v function(self: CUSTOM_LORDS_MODEL, baseCost: number)
function CustomLordsModel.SetBaseCost(self, baseCost)
    self.baseCost = baseCost;
end

--v function(self: CUSTOM_LORDS_MODEL, artId: string)
function CustomLordsModel.SetSelectedArtId(self, artId)
    self.selectedArtId = artId;
    self:NotifyEvent("SELECTED_ART_ID_VALUE_CHANGE");
end

--v function(self: CUSTOM_LORDS_MODEL, maxTraits: int)
function CustomLordsModel.SetMaxTraits(self, maxTraits)
    self.maxTraits = maxTraits;
end

--v function(self: CUSTOM_LORDS_MODEL, startingTraitPoints: int)
function CustomLordsModel.SetStartingTraitPoints(self, startingTraitPoints)
    self.startingTraitPoints = startingTraitPoints;
end

return {
    new = CustomLordsModel.new
}