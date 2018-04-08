CUSTOM_LORDS_CAN_RECRUIT_SLANN = true --: boolean
LORD_SPAWN_X = 0 --: number
LORD_SPAWN_Y = 0 --: number
LORD_SPAWN_REGION = nil --: string

require("custom_lords_ui");

--v function() --> string
function calculateUpkeepEffectBundle()
    local difficultyLevel = cm:model():difficulty_level();
    if difficultyLevel == 1 then					-- easy
        return "wh_main_bundle_force_additional_army_upkeep_easy"
    elseif difficultyLevel == 0 then				-- normal
        return "wh_main_bundle_force_additional_army_upkeep_normal"
    elseif difficultyLevel == -1 then				-- hard
        return "wh_main_bundle_force_additional_army_upkeep_hard"
    elseif difficultyLevel == -2 then				-- very hard
        return "wh_main_bundle_force_additional_army_upkeep_very_hard"
    elseif difficultyLevel == -3 then				-- legendary
        return "wh_main_bundle_force_additional_army_upkeep_legendary"
    end;
    output("Failed to calculate upkeep effect bundle for difficulty: " .. difficultyLevel);
    return "";
end

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

--v function(selectedSkillSet: string, selectedTraits: vector<string>, attributes: map<string, int>, lordName: string, lordCqi: CA_CQI)
function lordCreated(selectedSkillSet, selectedTraits, attributes, lordName, lordCqi)
    -- Add traits
    cm:force_add_trait_on_selected_character(selectedSkillSet);
    for i, trait in ipairs(selectedTraits) do
        cm:force_add_trait_on_selected_character(trait);
    end

    -- Add attribute effect bundles
    for attribute, value in pairs(attributes) do
        local effectBundle = calculateEffectBundleForAttributeAndValue(attribute, value);
        cm:apply_effect_bundle_to_characters_force(effectBundle, lordCqi, -1, false);
    end

    -- Add additional army upkeep effect bundle
    cm:apply_effect_bundle_to_characters_force(calculateUpkeepEffectBundle(), lordCqi, -1, false);

    -- Remove un-needed unit
    find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "units", "LandUnit 1"):SimulateLClick();
    find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "button_group_unit", "button_disband"):SimulateLClick();
    find_uicomponent(core:get_ui_root(), "dialogue_box", "both_group", "button_tick"):SimulateLClick();

    -- Rename lord
    local generalButton = find_uicomponent(core:get_ui_root(), "layout", "info_panel_holder", "primary_info_panel_holder", "info_button_list", "button_general");
    generalButton:SimulateLClick();
    local renameButton = find_uicomponent(core:get_ui_root(), "character_details_panel", "background", "bottom_buttons", "button_rename");
    renameButton:SimulateLClick();
    local textInput =  find_uicomponent(core:get_ui_root(), "popup_text_input", "text_input_list_parent", "text_input");
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
    table.insert(traitIncidents, "wh2_main_incident_treasury_down_one_k");
    for i, incident in ipairs(traitIncidents) do
        cm:trigger_incident(cm:get_local_faction(), incident, true);
    end
    cm:callback(
        function()
            cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_event_dilemma_incident", "");
        end, 0.5, "RE_ENABLE INCIDENTS"
    );

    -- Disable movement
    cm:zero_action_points(char_lookup_str(lordCqi));
end

--v function(xPos: number, yPos: number) --> boolean
function isValidSpawnPoint(xPos, yPos)
    local faction_list = cm:model():world():faction_list();
    for i = 0, faction_list:num_items() - 1 do
        local current_faction = faction_list:item_at(i);
        local char_list = current_faction:character_list();
        for i = 0, char_list:num_items() - 1 do
            local current_char = char_list:item_at(i);
            if current_char:logical_position_x() == xPos and current_char:logical_position_y() == yPos then
                return false;
            end;
        end;
    end;
    return true;
end

--v function(xPos: number, yPos: number) --> (number, number)
function calculateSpawnPoint(xPos, yPos)
    for i = 2, 5 do
        for j = 2, 5 do
            local newX = xPos + i;
            local newY = yPos + j;
            if isValidSpawnPoint(newX, newY) then
                return newX, newY;
            end
        end
    end
    return xPos, yPos;
end

--v function(selectedLordType: string, lordCreatedCallback: function(CA_CQI))
function createLord(selectedLordType, lordCreatedCallback)
    cm:create_force_with_general(
        cm:get_local_faction(),
        "wh2_main_skv_inf_clanrats_0",
        LORD_SPAWN_REGION,
        LORD_SPAWN_X,
        LORD_SPAWN_Y,
        "general",
        selectedLordType,
        "",
        "",
        "",
        "",
        "my_custom_lord",
        false,
        lordCreatedCallback
    );
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

    local existingFrame = Util.getComponentWithName("customLordFrame");
    local recruitCallback = function(
        name, --: string
        lordType, --: string
        skillSet, --: string
        attributes, --: map<string, int>
        traits --: vector<string>
    )
        createLord(lordType, 
            function(context)
                lordCreated(skillSet, traits, attributes, name, context);
            end
        );
        --# assume blocker: IMAGE
        blocker.uic:SetVisible(false);
    end

    createCustomLordFrameUi(recruitCallback);
end

--v function() --> boolean
function canRecuitArmy()
    local currentFaction = get_faction(cm:get_local_faction());
    if currentFaction:culture() == "wh2_dlc09_tmb_tomb_kings" then
        local armyCap = find_uicomponent(core:get_ui_root(), "character_panel", "raise_forces_options", "dy_army_cap");
        local curr, max = string.match(armyCap:GetStateText(), "(%d+) / (%d+)");
        return curr < max;
    else
        return true;
    end
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
            local createCustomLordButton = TextButton.new("createCustomLordButton", raiseForces, "TEXT", "Custom");
            createCustomLordButton:Resize(raiseForcesButton:Bounds());
            if not canRecuitArmy() then
                createCustomLordButton:SetDisabled(true);
            end

            local rfWidth, rfHeight = raiseForcesButton:Bounds();
            local rfXPos, rfYPos = raiseForcesButton:Position();
            local gap = 20;
            raiseForcesButton:MoveTo(rfXPos - (rfWidth / 2 + gap / 2), rfYPos);
            createCustomLordButton:PositionRelativeTo(raiseForcesButton, gap + rfWidth, 0);
            createCustomLordButton:RegisterForClick(
                function(context)
                    createCustomLordFrame();
                end
            );
            createCustomLordButton:SetVisible(raiseForcesButton:Visible());

            local createArmyButton = find_uicomponent(core:get_ui_root(), "layout", "hud_center_docker", "hud_center", "small_bar", "button_group_settlement", "button_create_army");
            local agentsButton = find_uicomponent(core:get_ui_root(), "layout", "hud_center_docker", "hud_center", "small_bar", "button_group_settlement", "button_agents");
            Util.registerForClick(
                createArmyButton, "createArmyButtonListener", 
                function(context)
                    createCustomLordButton:SetVisible(true);
                end
            );

            Util.registerForClick(
                agentsButton, "agentsButtonListener", 
                function(context)
                    createCustomLordButton:SetVisible(false);
                end
            );
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
            --# assume createCustomLordButton: TEXT_BUTTON
            if createCustomLordButton then
                createCustomLordButton:Delete();
                core:remove_listener("createArmyButtonListener");
                core:remove_listener("agentsButtonListener");
            end
        end,
        true
    );
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
    local char = cm:get_campaign_ui_manager():get_char_selected();
    local cqi = string.sub(char, 15);
    --# assume cqi: CA_CQI
    return get_character_by_cqi(cqi);
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
    return TABLES["lord_types"][lordType];
end

--v function(lordType: string) --> string
function findDefaultSkillSet(lordType)
    local defaultSkillSet = nil --: string
    for i, lordTypeTable in ipairs(TABLES["lord_types"][lordType]) do
        if lordTypeTable["default_skill_set"] == "TRUE" then
            return lordTypeTable["skill_set"];
        end
    end 
    output("Failed to find default skillset for lord type: " .. lordType);
    return "";
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
            local selectedChar = getSelectedChar();
            if not charHasCustomSkills(selectedChar) then
                output("Char does not have custom skill sets: " .. selectedChar:character_subtype_key());
                return;
            end

            local skillToSkillSetMap = createSkillToSkillSetMap();
            local charHasSkillSetTrait = charHasSkillSetTrait(selectedChar);
            local defaultSkillSet = findDefaultSkillSet(selectedChar:character_subtype_key());
            
            local skillsChainList = find_uicomponent(core:get_ui_root(), "character_details_panel", "background", "skills_subpanel", "listview", "list_clip", "list_box");
            local skillChainCount = skillsChainList:ChildCount();
            for i=0, skillChainCount-1  do
                local skillChain = UIComponent(skillsChainList:Find(i));
                local skillChainChain = find_uicomponent(skillChain, "chain");
                if skillChainChain then
                    local childCount = skillChainChain:ChildCount();
                    for i=0, childCount-1  do
                        local child = UIComponent(skillChainChain:Find(i));
                        local skillSetFound = false;
                        local skillSkillSet = skillToSkillSetMap[child:Id()];
                        if skillSkillSet then
                            for i, skillSet in ipairs(skillSkillSet) do
                                if selectedChar:has_trait(skillSet) or (not charHasSkillSetTrait and defaultSkillSet == skillSet) then
                                    skillSetFound = true;
                                end
                            end
                            if not skillSetFound then
                                child:SetVisible(false);
                            end
                        end
                    end
                end
            end
        end, 
        true
    );
end

--v function()
function destroyCustomLordFrame()
    local customLordFrame = Util.getComponentWithName("customLordFrame");
    --# assume customLordFrame: FRAME
    if customLordFrame then
        customLordFrame:Delete();
    end
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
function addSlannCountListener()
    core:add_listener(
        "CanRecruitSlannListener",
        "PanelClosedCampaign",
        function(context) 
            return context.string == "settlement_panel"; 
        end,
        function(context)
            local currentFaction = get_faction(cm:get_local_faction());
            if currentFaction:culture() == "wh2_main_lzd_lizardmen" then
                local buildingBrowser = find_uicomponent(core:get_ui_root(), "building_browser");
                if not buildingBrowser then
                    local clanButton = find_uicomponent(core:get_ui_root(), "layout", "bar_small_top", "faction_icons", "button_factions");
                    clanButton:SimulateLClick();
                    local imperiumPanel = find_uicomponent(core:get_ui_root(), "clan", "main", "tab_children_parent", "Summary", "portrait_frame", "parchment_R", "imperium");
                    local slannCount = find_uicomponent(imperiumPanel, "agent_parent", "agent_cap_list", "wh2_main_lzd_slann_mage_priest", "dy_count");
                    local curr, max = string.match(slannCount:GetStateText(), "(%d+)/(%d+)");
                    CUSTOM_LORDS_CAN_RECRUIT_SLANN = curr < max;
                    local okButton = find_uicomponent(core:get_ui_root(), "clan", "main", "button_ok");
                    okButton:SimulateLClick();
                end
            end
        end,
        true
    );
end

--v function()
function addSettlementSelectedListener()
    core:add_listener(
        "LordsPlacementListenerSettlement",
        "SettlementSelected",
        function()
            return true;
        end,
        function(context)
            --# assume context: CA_SETTLEMENT_CONTEXT
            local settlementName = context:garrison_residence():region():name();
            local settlement = get_region(settlementName):settlement();
            local xPos, yPos = calculateSpawnPoint(settlement:logical_position_x(), settlement:logical_position_y());
            LORD_SPAWN_X = xPos;
            LORD_SPAWN_Y = yPos;
            LORD_SPAWN_REGION = settlementName;
        end,
        true
    );
end

--v function()
function addCharacterSelectedListener()
    core:add_listener(
        "LordsPlacementListenerCharacter",
        "CharacterSelected",
        function()
            return true;
        end,
        function(context)
            --# assume context: CA_CHAR_CONTEXT
            local char = context:character();
            local xPos, yPos = calculateSpawnPoint(char:logical_position_x(), char:logical_position_y());
            LORD_SPAWN_X = xPos;
            LORD_SPAWN_Y = yPos;
            LORD_SPAWN_REGION = char:region():name();
        end,
        true
    );
end

--v function()
function custom_lords()
    attachButtonToLordRecuitment();
    attachSkillListener();
    addEscapeButtonListener();
    addSlannCountListener();
    addSettlementSelectedListener();
    addCharacterSelectedListener();
end