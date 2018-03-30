require("custom_lords_ui");

--v function(selectedSkillSet: string, selectedTraits: vector<string>, lordName: string)
function lordCreated(selectedSkillSet, selectedTraits, lordName)
    cm:force_add_trait_on_selected_character(selectedSkillSet);
    for i, trait in ipairs(selectedTraits) do
        cm:force_add_trait_on_selected_character(trait);
    end
    find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "units", "LandUnit 1"):SimulateLClick();
    find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "button_group_unit", "button_disband"):SimulateLClick();
    find_uicomponent(core:get_ui_root(), "dialogue_box", "both_group", "button_tick"):SimulateLClick();
    local generalButton = find_uicomponent(core:get_ui_root(), "layout", "info_panel_holder", "primary_info_panel_holder", "info_button_list", "button_general");
    generalButton:SimulateLClick();
    local renameButton = find_uicomponent(core:get_ui_root(), "character_details_panel", "background", "bottom_buttons", "button_rename");
    renameButton:SimulateLClick();
    find_uicomponent(core:get_ui_root(), "popup_text_input", "panel_title", "heading_txt"):SetStateText("Name your Lord");
    find_uicomponent(core:get_ui_root(), "popup_text_input", "text_input_list_parent", "text_input1"):SetStateText("Name your Lord");
    local textInput =  find_uicomponent(core:get_ui_root(), "popup_text_input", "text_input_list_parent", "text_input");
    for i = 1, string.len(lordName) do
        textInput:SimulateKey(string.sub(lordName, i, i));
    end
    local popupOkButton = find_uicomponent(core:get_ui_root(), "popup_text_input", "ok_cancel_buttongroup", "button_ok");
    popupOkButton:SimulateLClick();
    find_uicomponent(core:get_ui_root(), "character_details_panel", "button_ok"):SimulateLClick();
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
    for i = 1, 5 do
        for j = 1, 5 do
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
    local region = string.sub(tostring(cm:get_campaign_ui_manager().settlement_selected), 12);
    local settlement = get_region(region):settlement();
    local xPos, yPos = calculateSpawnPoint(settlement:logical_position_x(), settlement:logical_position_y());
    cm:create_force_with_general(
        cm:get_local_faction(),
        "wh2_main_skv_inf_clanrats_0",
        region,
        xPos,
        yPos,
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

function createCustomLordFrame()
    local blocker = nil --: COMPONENT_TYPE
    cm:callback(
        function()
            output("BLOCKER CALLBACK");
            blocker = Util.getComponentWithName("Blocker");
            --# assume blocker : IMAGE
            if not blocker then
                output("NEW BLOCKER");
                blocker = Image.new("Blocker", core:get_ui_root(), "ui/skins/default/icon_end_turn.png");
                blocker:Resize(5000, 5000);
                blocker:MoveTo(-500, -500);
                blocker:SetOpacity(0);
                blocker.uic:PropagatePriority(5);
            else
                output("BLOCKER FOUND");
                blocker:SetVisible(true);
            end
        end, 0.01, "asdasdasd"
    );

    local existingFrame = Util.getComponentWithName("customLordFrame");
    if not existingFrame then
        local recruitCallback = function(
            name, --: string
            lordType, --: string
            skillSet, --: string
            traits --: vector<string>
        )
            createLord(lordType, 
                function(context)
                    lordCreated(skillSet, traits, name);
                end
            );
            --# assume blocker: IMAGE
            blocker.uic:SetVisible(false);
        end

        createCustomLordFrameUi(recruitCallback);
    else
        --# assume existingFrame: FRAME
        existingFrame:SetVisible(true); 
    end
end

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

            local rfWidth, rfHeight = raiseForcesButton:Bounds();
            local rfXPos, rfYPos = raiseForcesButton:Position();
            local gap = 20;
            raiseForcesButton:MoveTo(rfXPos - (rfWidth / 2 + gap / 2), rfYPos);
            createCustomLordButton:PositionRelativeTo(raiseForcesButton, gap + rfWidth, 0);
            
            createCustomLordButton:RegisterForClick(
                "createCustomLordButtonListener", 
                function(context)
                    createCustomLordFrame();
                end
            );

            createCustomLordButton:SetVisible(raiseForcesButton:Visible());

            local createArmyButton = find_uicomponent(core:get_ui_root(), "layout", "hud_center_docker", "hud_center", "small_bar", "button_group_settlement", "button_create_army");
            local agentsButton = find_uicomponent(core:get_ui_root(), "layout", "hud_center_docker", "hud_center", "small_bar", "button_group_settlement", "button_agents");
            core:remove_listener("createArmyButtonListener");
            Util.registerForClick(
                createArmyButton, "createArmyButtonListener", 
                function(context)
                    createCustomLordButton:SetVisible(true);
                end
            );
            core:remove_listener("agentsButtonListener");
            Util.registerForClick(
                agentsButton, "agentsButtonListener", 
                function(context)
                    createCustomLordButton:SetVisible(false);
                end
            );
        end,
        true
    );
end

--v function() --> map<string, vector<string>>
function createSkillToSkillSetMap()
    local skillToSkillSetMap = {} --: map<string, vector<string>>
    for skillSet, skillSetSkills in pairs(SKILL_SET_SKILLS) do
        for i, currentSkillSetSkill in ipairs(skillSetSkills) do
            local skillSkillSets = skillToSkillSetMap[currentSkillSetSkill];
            if not skillSkillSets then
                skillSkillSets = {};
                skillToSkillSetMap[currentSkillSetSkill] = skillSkillSets;
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

function custom_lords()
    attachButtonToLordRecuitment();
    core:add_listener(
        "CustomLordsSkillHider",
        "PanelOpenedCampaign",
        function(context) 
            return context.string == "character_details_panel"; 
        end,
        function(context)
            local skillToSkillSetMap = createSkillToSkillSetMap();
            local selectedChar = getSelectedChar();
            local chain = find_uicomponent(core:get_ui_root(), "character_details_panel", "background", "skills_subpanel", "listview", "list_clip", "list_box", "chain2", "chain");
            if chain then
                local childCount = chain:ChildCount();
                for i=0, childCount-1  do
                    local child = UIComponent(chain:Find(i));
                    local skillSetFound = false;
                    local skillSkillSet = skillToSkillSetMap[child:Id()];
                    if skillSkillSet then
                        for i, skillSet in ipairs(skillToSkillSetMap[child:Id()]) do
                            if selectedChar:has_trait(skillSet) then
                                skillSetFound = true;
                            end
                        end
                        if not skillSetFound then
                            child:SetVisible(false);
                        end
                    end
                end
            end
        end, 
        true
    );
end

--tooltip generation
--trait --> character_trait_levels --> trait_level_effects --> effects
--                                 --> campaign_effect_scopes

-- build_frame_cross.png
-- icon_cross_square_red.png
-- parchment_header_min.png
-- parchment_header_max.png