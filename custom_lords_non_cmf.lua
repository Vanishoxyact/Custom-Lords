CUSTOM_LORDS_CAN_RECRUIT_SLANN = false --: boolean
my_load_mod_script("table_loading");
my_load_mod_script("custom_lords_ui");

--v function(traits: vector<string>) --> vector<string>
function calculateTraitIncidents(traits)
   local incidents = {} --: vector<string>
   for i, trait in ipairs(traits) do
      local traitIncidents = TABLES["trait_incidents"][trait];
      if traitIncidents then
         for i, traitIncidentRow in ipairs(traitIncidents) do
            table.insert(incidents, traitIncidentRow["incident_key"]);
         end
      end
   end
   return incidents;
end

--v function() --> boolean
function isPlayerFactionHorde()
   local player_faction = cm:get_faction(cm:get_local_faction());
   return wh_faction_is_horde(player_faction);
end

function isLord(agentType)
   return agentType == "general" or agentType == "colonel";
end

--v function(selectedSkillSet: string, selectedTraits: vector<string>, attributes: map<string, int>, lordName: string, lordCqi: CA_CQI)
function lordCreated(selectedSkillSet, selectedTraits, attributes, lordName, lordCqi)
   local selectedCharCqi = cm:get_campaign_ui_manager():get_char_selected_cqi();
   --# assume selectedCharCqi: CA_CQI
   -- Add traits
   cm:force_add_trait(cm:char_lookup_str(selectedCharCqi), selectedSkillSet);
   for i, trait in ipairs(selectedTraits) do
      cm:force_add_trait(cm:char_lookup_str(selectedCharCqi), trait);
   end
   
   -- Add attribute effect bundles
   for attribute, value in pairs(attributes) do
      if value ~= 0 then
         local effectBundle = calculateEffectBundleForAttributeAndValue(attribute, value);
         local customEffectBundle = cm:create_new_custom_effect_bundle(effectBundle)
         local oldEffect = customEffectBundle:effects():item_at(0)
         customEffectBundle:remove_effect(oldEffect);
         customEffectBundle:add_effect(oldEffect:key(), "character_to_character_own", oldEffect:value());
         cm:apply_custom_effect_bundle_to_character(customEffectBundle, cm:get_character_by_cqi(selectedCharCqi))
      end
   end

   -- Rename lord
   local generalButton = find_uicomponent(core:get_ui_root(), "layout", "info_panel_holder", "primary_info_panel_holder", "info_button_list", "button_general");
   generalButton:SimulateLClick();
   local renameButton = find_uicomponent(core:get_ui_root(), "character_details_panel", "background", "bottom_buttons", "button_rename");
   renameButton:SimulateLClick();
   local textInput = find_uicomponent(core:get_ui_root(), "popup_text_input", "text_input_list_parent", "text_input");
   if lordName == "" then
      lordName = "Custom Lord";
   end
   for i = 1, string.len(lordName) do
      textInput:SimulateKey(string.sub(lordName, i, i));
   end
   local popupOkButton = find_uicomponent(core:get_ui_root(), "popup_text_input", "ok_cancel_buttongroup", "button_ok");
   popupOkButton:SimulateLClick();
   find_uicomponent(core:get_ui_root(), "character_details_panel", "button_ok"):SimulateLClick();

   -- Trigger incidents
   cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_event_dilemma_incident", "");
   local traitIncidents = calculateTraitIncidents(selectedTraits);
   for i, incident in ipairs(traitIncidents) do
      cm:trigger_incident(cm:get_local_faction(), incident, true);
   end
   cm:callback(
         function()
            cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_event_dilemma_incident", "");
            cm:remove_all_background_skills(cm:char_lookup_str(selectedCharCqi));
         end, 0.5, "RE_ENABLE INCIDENTS"
   );
end

--v function(lordType: string, selectedArtId: string)
function spawnGeneralToPoolAndRecruit(lordType, selectedArtId, agentType)
   local male = true;
   local femaleLordTypesTable = TABLES["female_lord_types"];
   if femaleLordTypesTable[lordType] then
      male = false;
   end

   cm:spawn_character_to_pool(cm:get_local_faction(), "", "", "", "", 50, male, agentType, lordType, false, selectedArtId);
   if isLord(agentType) then
      spawnLord();
   else
      spawnHero(lordType, agentType);
   end
end

function spawnLord()
   find_uicomponent(core:get_ui_root(), "layout", "hud_center_docker", "hud_center", "small_bar", "button_group_settlement", "button_agents"):SimulateLClick();
   find_uicomponent(core:get_ui_root(), "layout", "hud_center_docker", "hud_center", "small_bar", "button_group_settlement", "button_create_army"):SimulateLClick();

   local generalCandidateButton = nil --: CA_UIC

   local generalsList = find_uicomponent(core:get_ui_root(), "character_panel", "general_selection_panel", "character_list_parent", "character_list", "listview", "list_clip", "list_box");
   for i = 0, generalsList:ChildCount() - 1 do
      local generalPanel = UIComponent(generalsList:Find(i));
      local name = find_uicomponent(generalPanel, "dy_name"):GetStateText();
      if name == "" then
         generalCandidateButton = generalPanel;
      end
   end

   if not generalCandidateButton then
      out("Failed to find candidate");
   end

   generalCandidateButton:SimulateLClick();
   find_uicomponent(core:get_ui_root(), "character_panel", "raise_forces_options", "button_raise"):SimulateLClick();
end

function spawnHero(lordType, agentType)
   find_uicomponent(core:get_ui_root(), "layout", "hud_center_docker", "hud_center", "small_bar", "button_group_settlement", "button_create_army"):SimulateLClick();
   find_uicomponent(core:get_ui_root(), "layout", "hud_center_docker", "hud_center", "small_bar", "button_group_settlement", "button_agents"):SimulateLClick();
   
   local agentsButtonGroup = find_uicomponent(core:get_ui_root(), "character_panel", "agent_parent", "button_group_agents");
   local agentButton;
   for i=0, agentsButtonGroup:ChildCount()-1  do
      local child = UIComponent(agentsButtonGroup:Find(i));
      if child:Id() == agentType then
         agentButton = child;
      end
   end
   if not agentButton then
      out("Failed to find agent button for type " .. agentType);
      return;
   end
   agentButton:SimulateLClick();

   local typeList = find_uicomponent(core:get_ui_root(), "character_panel", "agent_parent", "type_list");
   if typeList and typeList:ChildCount() > 0 then
      local typeButton;
      for i = 0, typeList:ChildCount() - 1 do
         local typeListItem = UIComponent(typeList:Find(i));
         if typeListItem:Id() == lordType then
            typeButton = typeListItem;
         end
      end
      if not typeButton then
         out("Failed to find type button for type " .. lordType);
         return;
      end
      typeButton:SimulateLClick();
   end

   local generalCandidateButton = nil --: CA_UIC

   local generalsList = find_uicomponent(core:get_ui_root(), "character_panel", "general_selection_panel", "character_list_parent", "character_list", "listview", "list_clip", "list_box");
   for i = 0, generalsList:ChildCount() - 1 do
      local generalPanel = UIComponent(generalsList:Find(i));
      local name = find_uicomponent(generalPanel, "dy_name"):GetStateText();
      if name == "" then
         generalCandidateButton = generalPanel;
      end
   end

   if not generalCandidateButton then
      out("Failed to find candidate");
      return;
   end

   generalCandidateButton:SimulateLClick();
   find_uicomponent(core:get_ui_root(), "character_panel", "general_selection_panel", "button_confirm"):SimulateLClick();
end

--v function(selectedLordType: string, selectedArtId: string, lordCreatedCallback: function(CA_CQI))
function createLord(selectedLordType, selectedArtId, agentType, lordCreatedCallback)
   core:add_listener(
         "LordCreatedListener",
         "PanelOpenedCampaign",
         function(context)
            return context.string == "units_panel";
         end,
         function(context)
            local cqi = cm:get_campaign_ui_manager():get_char_selected_cqi();
            --# assume cqi: CA_CQI
            lordCreatedCallback(cqi);
         end,
         false
   );
   spawnGeneralToPoolAndRecruit(selectedLordType, selectedArtId, agentType);
end

--v function() --> number
function calculateGeneralCost()
   local generalsList = find_uicomponent(core:get_ui_root(), "character_panel", "general_selection_panel", "character_list_parent", "character_list", "listview", "list_clip", "list_box");
   for i = 0, generalsList:ChildCount() - 1 do
      local generalPanel = UIComponent(generalsList:Find(i));
      local costText = find_uicomponent(generalPanel, "RecruitmentCost", "Cost"):GetStateText();
      local cost = tonumber(costText, 10);
      if cost > 0 then
         return cost;
      end
   end
   out("Failed to calculate general cost.");
   return 0;
end

function calculateSelectedAgentType()
   local agentParent = find_uicomponent(core:get_ui_root(), "character_panel", "agent_parent");
   if agentParent == nil or not agentParent:Visible() then
      return "general";
   end
   local agentsButtonGroup = find_uicomponent(agentParent, "button_group_agents");
   for i=0, agentsButtonGroup:ChildCount()-1  do
      local child = UIComponent(agentsButtonGroup:Find(i));
      if child:CurrentState() == "selected" then
         return child:Id();
      end
   end
   return "general";
end

--v function()
function createCustomLordFrame()
   local blocker = nil --: COMPONENT_TYPE
   cm:callback(
         function()
            blocker = Util.getComponentWithName("Blocker");
            --# assume blocker : DUMMY
            if not blocker then
               blocker = Dummy.new(core:get_ui_root());
               blocker:Resize(5000, 5000);
               blocker:MoveTo(-500, -500);
               blocker.uic:SetInteractive(true);
               blocker.uic:PropagatePriority(50);
               local customLordFrame = Util.getComponentWithName("customLordFrame");
               --# assume customLordFrame: FRAME
               if customLordFrame then
                  customLordFrame:AddComponent(blocker);
               end
            else
               blocker:SetVisible(true);
            end
         end, 0.01, "BLOCKER_CALLBACK"
   );

   local agentType = calculateSelectedAgentType();
   local recruitCallback = function(
         name, --: string
         lordType, --: string
         skillSet, --: string
         attributes, --: map<string, int>
         traits, --: vector<string>
         selectedArtId --: string
   )
      createLord(lordType, selectedArtId, agentType,
            function(context)
               lordCreated(skillSet, traits, attributes, name, context);
            end
      );
      --# assume blocker: IMAGE
      blocker.uic:SetVisible(false);
   end

   createCustomLordFrameUi(recruitCallback, calculateGeneralCost(), agentType);
end

--v function() --> boolean
function hasArmyAlreadyBeenRecruited()
   local generalsList = find_uicomponent(core:get_ui_root(), "character_panel", "general_selection_panel", "character_list_parent", "character_list", "listview", "list_clip", "list_box");
   if generalsList then
      for i = 0, generalsList:ChildCount() - 1 do
         local generalPanel = UIComponent(generalsList:Find(i));
         local tooltip = generalPanel:GetTooltipText();
         if string.match(tooltip, "You have already recruited") then
            return true;
         end
      end
   end
   return false;
end

--v function() --> boolean
function notEnoughPopulation()
   local generalsList = find_uicomponent(core:get_ui_root(), "character_panel", "general_selection_panel", "character_list_parent", "character_list", "listview", "list_clip", "list_box");
   if generalsList then
      for i = 0, generalsList:ChildCount() - 1 do
         local generalPanel = UIComponent(generalsList:Find(i));
         local tooltip = generalPanel:GetTooltipText();
         if string.match(tooltip, "You do not have enough population") then
            return true;
         end
      end
   end
   return false;
end

--v function() --> boolean
function canRecuitArmy()
   local currentFaction = cm:get_faction(cm:get_local_faction());
   if isPlayerFactionHorde() and notEnoughPopulation() then
      return false;
   elseif hasArmyAlreadyBeenRecruited() then
      return false;
   elseif currentFaction:culture() == "wh2_dlc09_tmb_tomb_kings" then
      local armyCap = find_uicomponent(core:get_ui_root(), "character_panel", "raise_forces_options", "dy_army_cap");
      if armyCap == nil then
         return false;
      end
      local curr, max = string.match(armyCap:GetStateText(), "(%d+)%s*/%s*(%d+)");
      if curr == nil or max == nil then
         return false;
      end
      return max > curr;
   end
   return true;
end


function createCustomLordsButton(parentComponent, raiseForcesButton, gap)
   local rfWidth, rfHeight = raiseForcesButton:Bounds();
   local createCustomLordButton = TextButton.new("createCustomLordButton", parentComponent, "TEXT", "Custom");
   createCustomLordButton:Resize(raiseForcesButton:Bounds());
   createCustomLordButton:RegisterForClick(
         function(context)
            createCustomLordFrame();
         end
   );
   return createCustomLordButton;
end

function createCustomHeroesButton(parentComponent, raiseForcesButton, gap)
   local rfWidth, rfHeight = raiseForcesButton:Bounds();
   local createCustomHeroButton = TextButton.new("createCustomHeroButton", parentComponent, "TEXT", "Custom");
   createCustomHeroButton:Resize(raiseForcesButton:Bounds());
   createCustomHeroButton:RegisterForClick(
         function(context)
            createCustomLordFrame();
         end
   );
   return createCustomHeroButton;
end

--v function()
function attachButtonToLordRecuitment()
   core:add_listener(
         "CustomLordButtonAdder",
         "PanelOpenedCampaign",
         function(context)
            return context.string == "character_panel";
         end,
         function(context)
            local characterPanel = find_uicomponent(core:get_ui_root(), "character_panel");
            local raiseForces = find_uicomponent(characterPanel, "raise_forces_options");
            local raiseForcesButton = find_uicomponent(raiseForces, "button_raise");
            local gap = 20;
            local createCustomLordButton = createCustomLordsButton(raiseForces, raiseForcesButton, gap);
            local generalSelectionPanel = find_uicomponent(characterPanel, "general_selection_panel");
            local createCustomHeroButton = createCustomHeroesButton(generalSelectionPanel, raiseForcesButton, gap);

            local rfWidth, rfHeight = raiseForcesButton:Bounds();
            local rfXPos, rfYPos = raiseForcesButton:Position();
            raiseForcesButton:MoveTo(rfXPos - (rfWidth / 2 + gap / 2), rfYPos);
            createCustomLordButton:PositionRelativeTo(raiseForcesButton, gap + rfWidth, 0);

            local agentHireButton = find_uicomponent(characterPanel, "button_confirm");
            local rfWidth, rfHeight = agentHireButton:Bounds();
            local rfXPos, rfYPos = agentHireButton:Position();
            agentHireButton:MoveTo(rfXPos - (rfWidth / 2 + gap / 2), rfYPos);
            createCustomHeroButton:PositionRelativeTo(raiseForcesButton, gap + rfWidth, 0);

            createCustomHeroButton:Resize(createCustomLordButton:Bounds());
            createCustomHeroButton:MoveTo(createCustomLordButton:Position());
            agentHireButton:Resize(createCustomLordButton:Bounds());
            agentHireButton:MoveTo(raiseForcesButton:Position());

            local createArmyButton = find_uicomponent(core:get_ui_root(), "layout", "hud_center_docker", "hud_center", "small_bar", "button_group_settlement", "button_create_army");
            local agentsButton = find_uicomponent(core:get_ui_root(), "layout", "hud_center_docker", "hud_center", "small_bar", "button_group_settlement", "button_agents");
            Util.registerForClick(
                  createArmyButton, "createArmyButtonListener",
                  function(context)
                     updateButtonsStateWithCallback();
                  end
            );

            Util.registerForClick(
                  agentsButton, "agentsButtonListener",
                  function(context)
                     updateButtonsStateWithCallback();
                  end
            );
            
            local agentsButtonGroup = find_uicomponent(core:get_ui_root(), "character_panel", "agent_parent", "button_group_agents");
            for i=0, agentsButtonGroup:ChildCount()-1  do
               local child = UIComponent(agentsButtonGroup:Find(i));
               Util.registerForClick(
                     child, "agentsButtonListener",
                     function(context)
                        updateButtonsStateWithCallback();
                     end
               );
            end
            updateButtonsStateWithCallback();
         end,
         true
   );

   core:add_listener(
         "CustomLordButtonRemover",
         "PanelClosedCampaign",
         function(context)
            return context.string == "character_panel";
         end,
         function(context)
            local createCustomLordButton = Util.getComponentWithName("createCustomLordButton");
            local createCustomHeroButton = Util.getComponentWithName("createCustomHeroButton");

            --# assume createCustomLordButton: TEXT_BUTTON
            if createCustomLordButton then
               createCustomLordButton:Delete();
               createCustomHeroButton:Delete();
               core:remove_listener("createArmyButtonListener");
               core:remove_listener("agentsButtonListener");
            end
         end,
         true
   );

   core:add_listener(
         "CustomLordButtonEnableSettlmentChangeListener",
         "SettlementSelected",
         function()
            return not isPlayerFactionHorde();
         end,
         updateButtonsStateWithCallback,
         true
   );

   core:add_listener(
         "CustomLordButtonEnableCharacterChangeListener",
         "CharacterSelected",
         function()
            return isPlayerFactionHorde();
         end,
         updateButtonsStateWithCallback,
         true
   );
end

function canRecruitHero()
   local heroCount = find_uicomponent(core:get_ui_root(), "character_panel", "agent_parent", "dy_agent_cap");
   if not heroCount then
      return false;
   end
   local curr, max = string.match(heroCount:GetStateText(), "(%d+)%s*/%s*(%d+)");
   if curr == nil or max == nil then
      return false;
   end
   return max > curr;
end

function updateButtonsStateWithCallback()
   cm:callback(
         function()
            updateButtonsState();
         end, 0.01, "UpdateButtonStateCallback"
   );
end

function updateButtonsState()
   local createCustomLordButton = Util.getComponentWithName("createCustomLordButton");
   if createCustomLordButton then
      --# assume createCustomLordButton: TEXT_BUTTON
      createCustomLordButton:SetDisabled(not canRecuitArmy());
      local raiseForcesButton = find_uicomponent(core:get_ui_root(), "character_panel", "raise_forces_options", "button_raise");
      if raiseForcesButton == nil then
         createCustomLordButton:SetVisible(false);
      else
         createCustomLordButton:SetVisible(raiseForcesButton:Visible());
      end
   end

   local createCustomHeroButton = Util.getComponentWithName("createCustomHeroButton");
   if createCustomHeroButton then
      --# assume createCustomHeroButton: TEXT_BUTTON
      createCustomHeroButton:SetDisabled(not canRecruitHero());
      local agentParent = find_uicomponent(core:get_ui_root(), "character_panel", "agent_parent");
      if agentParent == nil then
         createCustomHeroButton:SetVisible(false);
      else
         createCustomHeroButton:SetVisible(agentParent:Visible());
      end
   end
end

--v function() --> map<string, vector<string>>
function createSkillToSkillSetMap()
   local skillToSkillSetMap = {} --: map<string, vector<string>>
   for skillSet, skillSetSkills in pairs(TABLES["skill_set_skills"]) do
      for i, currentSkillSetSkillData in ipairs(skillSetSkills) do
         local skill = currentSkillSetSkillData["skill_set_skill"];
         local skillSkillSets = skillToSkillSetMap[skill];
         if not skillSkillSets then
            skillSkillSets = {};
            skillToSkillSetMap[skill] = skillSkillSets;
         end
         table.insert(skillSkillSets, skillSet);
      end
   end
   return skillToSkillSetMap;
end

--v function() --> CA_CHAR
function getSelectedChar()
   local cqi = cm:get_campaign_ui_manager():get_char_selected_cqi();
   --# assume cqi: CA_CQI
   return cm:get_character_by_cqi(cqi);
end

--v function(char: CA_CHAR) --> boolean
function charHasSkillSetTrait(char)
   for skillSetTrait, traitTable in pairs(TABLES["skill_set_skills"]) do
      if char:has_trait(skillSetTrait) then
         return true;
      end
   end
   return false;
end

--v function(char: CA_CHAR) --> boolean
function charHasCustomSkills(char)
   local lordType = char:character_subtype_key();
   local table = TABLES["lord_types"][lordType];
   if not table then
      return false;
   else
      local charType = find_uicomponent(core:get_ui_root(), "character_details_panel", "background", "character_details_subpanel", "frame", "details", "info_list", "dy_type");
      local charTypeText = charType:GetStateText();
      if string.match(charTypeText, "Lord") then
         return true;
      else
         return false;
      end
   end
end

--v function(lordType: string) --> string
function findDefaultSkillSet(lordType)
   local defaultSkillSet = nil --: string
   local table = TABLES["lord_types"][lordType];
   if not table then
      return nil;
   end
   for i, lordTypeTable in ipairs(table) do
      if lordTypeTable["default_skill_set"] == "TRUE" then
         return lordTypeTable["skill_set"];
      end
   end
   out("Failed to find default skillset for lord type: " .. lordType);
   return nil;
end

--# assume updateSkillSets : function(depth: int?)
--v function(depth: int?)
function updateSkillSets(depth)
   local charDetailsPanel = find_uicomponent(core:get_ui_root(), "character_details_panel");
   if not charDetailsPanel then
      return ;
   end
   local selectedChar = getSelectedChar();
   local hasCustomSkills = charHasCustomSkills(selectedChar);
   local skillToSkillSetMap = createSkillToSkillSetMap();
   local charHasSkillSetTrait = charHasSkillSetTrait(selectedChar);
   local defaultSkillSet = findDefaultSkillSet(selectedChar:character_subtype_key());
   if not hasCustomSkills and not defaultSkillSet then
      return ;
   end
   local skillsChainList = find_uicomponent(core:get_ui_root(), "character_details_panel", "background", "skills_subpanel", "listview", "list_clip", "list_box");
   local skillChainCount = skillsChainList:ChildCount();
   for i = 0, skillChainCount - 1 do
      local skillChain = UIComponent(skillsChainList:Find(i));
      local skillChainChain = find_uicomponent(skillChain, "chain");
      if skillChainChain then
         local childCount = skillChainChain:ChildCount();
         for i = 0, childCount - 1 do
            local child = UIComponent(skillChainChain:Find(i));
            local skillSetFound = false;
            local skillSkillSet = skillToSkillSetMap[child:Id()];
            if skillSkillSet then
               for i, skillSet in ipairs(skillSkillSet) do
                  if selectedChar:has_trait(skillSet) or ((not charHasSkillSetTrait) and defaultSkillSet == skillSet) or (not hasCustomSkills) then
                     skillSetFound = true;
                  end
               end
               child:SetVisible(skillSetFound);
            else
               child:SetVisible(true);
            end
         end
      end
   end
end

--v function()
function attachSkillListener()
   core:add_listener(
         "CustomLordsSkillHider",
         "PanelOpenedCampaign",
         function(context)
            return context.string == "character_details_panel";
         end,
         function(context)
            updateSkillSets();
         end,
         true
   );
   core:add_listener(
         "CustomLordsSkillHiderCharChange",
         "CharacterSelected",
         function()
            return true;
         end,
         function()
            cm:callback(
                  function()
                     updateSkillSets();
                  end, 0.01, "CustomLordsSkillHiderCharChange"
            );
         end,
         true
   );
end

--v function()
function addEscapeButtonListener()
   core:add_listener(
         "CustomLordsEscapeButtonListener",
         "ShortcutTriggered",
         function(context)
            return context.string == "escape_menu";
         end,
         function()
            destroyCustomLordFrame();
         end,
         true
   );

   core:add_listener(
         "CustomLordsEscapeButtonListenerPanel",
         "PanelClosedCampaign",
         function(context)
            return context.string == "character_panel";
         end,
         function(context)
            destroyCustomLordFrame();
         end,
         true
   );
end

--v function()
function hideSlannsIfRequired()
   local currentFaction = cm:get_faction(cm:get_local_faction());
   if currentFaction:culture() == "wh2_main_lzd_lizardmen" and (not CUSTOM_LORDS_CAN_RECRUIT_SLANN) then
      local generalsList = find_uicomponent(core:get_ui_root(), "character_panel", "general_selection_panel", "character_list_parent", "character_list", "listview", "list_clip", "list_box");
      if generalsList then
         for i = 0, generalsList:ChildCount() - 1 do
            local generalPanel = UIComponent(generalsList:Find(i));
            local subtype = find_uicomponent(generalPanel, "dy_subtype"):GetStateText();
            if subtype == "Slann Mage-Priest" then
               generalPanel:SetVisible(false);
            end
         end
      end
   end
end

--v function()
function addSlannCountListener()
   core:add_listener(
         "CanRecruitSlannListener",
         "PanelClosedCampaign",
         function(context)
            return context.string == "settlement_panel";
         end,
         function(context)
            local currentFaction = cm:get_faction(cm:get_local_faction());
            if currentFaction:culture() == "wh2_main_lzd_lizardmen" then
               local buildingBrowser = find_uicomponent(core:get_ui_root(), "building_browser");
               if not buildingBrowser then
                  local clanButton = find_uicomponent(core:get_ui_root(), "layout", "bar_small_top", "faction_icons", "button_factions");
                  clanButton:SimulateLClick();
                  local imperiumPanel = find_uicomponent(core:get_ui_root(), "clan", "main", "tab_children_parent", "Summary", "portrait_frame", "parchment_R", "imperium");
                  local slannCount = find_uicomponent(imperiumPanel, "agent_parent", "agent_cap_list", "wh2_main_lzd_slann_mage_priest", "dy_count");
                  if not slannCount then
                     -- Trigged when opening diplomacy panel
                     return ;
                  end
                  local curr, max = string.match(slannCount:GetStateText(), "(%d+)/(%d+)");
                  CUSTOM_LORDS_CAN_RECRUIT_SLANN = tonumber(curr, 10) < tonumber(max, 10);
                  local okButton = find_uicomponent(core:get_ui_root(), "clan", "main", "button_ok");
                  okButton:SimulateLClick();
               end
            end
         end,
         true
   );
   core:add_listener(
         "SlannHider",
         "PanelOpenedCampaign",
         function(context)
            return context.string == "character_panel";
         end,
         function(context)
            hideSlannsIfRequired();
         end, true
   );

   core:add_listener(
         "SlannHiderSettlementChange",
         "SettlementSelected",
         function()
            return true;
         end,
         function()
            cm:callback(
                  function()
                     hideSlannsIfRequired();
                  end, 0.001, "SlannHiderSettlementChange"
            );
         end,
         true
   );
end

--v function()
function custom_lords_initialise()
   out("Custom lords loaded.");
   cm:set_saved_value("custom_lords", true);
   detectBeta();
   loadTables();
   attachButtonToLordRecuitment();
   attachSkillListener();
   addEscapeButtonListener();
   -- Remove slann count listener as no longer available in clan window
   --addSlannCountListener();
end

core:add_listener(
      "CustomLordsInit",
      "UICreated",
      function()
         return true;
      end,
      function()
         custom_lords_initialise();
      end,
      false
);

--v function()
function custom_lords()
   -- Do nothing
end