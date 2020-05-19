---@class RandomNameGenerator
RandomNameGenerator = LuaObject()

---generateRandomName
---@param agentType string
---@param factionName string
---@return string, string
---@public
function RandomNameGenerator:generateRandomName(agentType, factionName)
   out("Generate random name");
   local factionNames = self:calculateNamesForFaction(factionName);
   local genderFactionNames = self:filterNamesByGender(agentType, factionNames);
   local forenames, surnames = self:generateForenameSurnameRollingMap(genderFactionNames);
   local randomForenameId = forenames[math.random(1, #forenames)];
   local randomForename = self:convertNameIdIntoString(randomForenameId);
   local randomSurname = "";
   if #surnames > 0 then
      local randomSurnameId = surnames[math.random(1, #surnames)];
      randomSurname = self:convertNameIdIntoString(randomSurnameId);
   end
   out("Generated random name: " .. randomForename .. " " .. randomSurname);
   return randomForename, randomSurname;
end

---calculateNamesForFaction
---@param factionName string
---@return table<string, string>[]
---@private
function RandomNameGenerator:calculateNamesForFaction(factionName)
   return TABLES["names_tables"][self:calculateNameGroupId(factionName)];
end

---@param factionName string
---@return string
---@private
function RandomNameGenerator:calculateNameGroupId(factionName)
   return TABLES["factions_tables"][factionName]["name_group"]
end

---filterNamesByGender
---@param agentType string
---@param factionNames table<string, string>[]
---@return table<string, string>[]
---@private
function RandomNameGenerator:filterNamesByGender(agentType, factionNames)
   ---@type table<string, string>[]
   local outputNames = {};
   local isAgentMale = self:doesAgentHaveMaleName(agentType);
   for _, nameData in ipairs(factionNames) do
      -- "0" = male
      -- "1" = female
      -- "2" = both
      if nameData["gender"] == "2" then
         table.insert(outputNames, nameData);
      elseif nameData["gender"] == "1" and not isAgentMale then
         table.insert(outputNames, nameData);
      elseif nameData["gender"] == "0" and isAgentMale then
         table.insert(outputNames, nameData);
      end
   end
   return outputNames;
end

---@param agentType string
---@return boolean
---@private
function RandomNameGenerator:doesAgentHaveMaleName(agentType)
   return TABLES["agent_subtypes_tables"][agentType]["has_female_name"] == "false"
end

---generateForenameSurnameRollingMap
---@param validNames table<string, string>[]
---@return string[], string[]
---@private
function RandomNameGenerator:generateForenameSurnameRollingMap(validNames)
   ---@type string[]
   local forenames = {};
   ---@type string[]
   local familyNames = {};
   -- "0" = forename
   -- "1" = family_name
   -- "2" = clanname
   -- "3" = other
   for _, nameData in ipairs(validNames) do
      local frequency = tonumber(nameData["frequency"], 10);
      local nameId = nameData["id"];
      if nameData["type"] == "1" then
         for i=1,frequency do
            table.insert(familyNames, nameId);
         end
      elseif nameData["type"] == "0" then
         for i=1,frequency do
            table.insert(forenames, nameId);
         end
      end
   end
   return forenames, familyNames;
end

---convertNameIdIntoString
---@param nameId string
---@return string
---@private
function RandomNameGenerator:convertNameIdIntoString(nameId)
   return effect.get_localised_string("names_name_" .. nameId);
end