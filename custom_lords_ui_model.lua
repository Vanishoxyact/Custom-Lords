require("custom_lords_util");
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
    clm.availableTraits = {} --: vector<string>
    clm.selectedTraits = {} --: vector<string>
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
function CustomLordsModel.GetCallbacksFOrEventType(self, eventType)
    if not self.callbacks[eventType] then
        return {};
    else
        return self.callbacks[eventType];
    end
end

--v function(self: CUSTOM_LORDS_MODEL, eventType: CUSTOM_LORDS_EVENT, callback: function())
function CustomLordsModel.RegisterForEvent(self, eventType, callback)
    self:RegisterForEventType(eventType);
    local eventCallbacks = self:GetCallbacksFOrEventType(eventType);
    table.insert(eventCallbacks, callback);
end

--v function(self: CUSTOM_LORDS_MODEL, eventType: CUSTOM_LORDS_EVENT)
function CustomLordsModel.NotifyEvent(self, eventType)
    local eventCallbacks = self:GetCallbacksFOrEventType(eventType);
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

return {
    new = CustomLordsModel.new
}