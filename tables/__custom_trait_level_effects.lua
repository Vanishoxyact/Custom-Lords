trait_level_effects_tables = {
	SCHEMA = {"trait_level", "effect", "effect_scope", "value"},
	KEY = {"trait_level", "LIST"},
	DATA = {
		{"wh2_main_trait_hef_prince_magic", "wh2_main_effect_magic_high_enable_apotheosis", "character_to_character_own", "1"},
		{"wh2_main_trait_hef_princess_magic", "wh2_main_effect_magic_high_enable_apotheosis", "character_to_character_own", "1"},
		{"wh2_main_skill_innate_all_aggressive", "wh_main_effect_character_stat_mod_charge_add", "character_to_character_own", "8"},
		{"wh2_main_skill_innate_all_aggressive", "wh_main_effect_character_stat_mod_melee_damage", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_all_confident", "wh_main_effect_force_unit_stat_morale", "character_to_force_own", "2"},
		{"wh2_main_skill_innate_all_cunning", "wh_main_effect_character_stat_enable_poison_attacks", "character_to_character_own", "1"},
		{"wh2_main_skill_innate_all_cunning", "wh_main_effect_force_army_campaign_ambush_attack_success_chance", "character_to_force_regionwide_own", "10"},
		{"wh2_main_skill_innate_all_determined", "wh_main_effect_character_stat_mod_morale", "character_to_character_own", "3"},
		{"wh2_main_skill_innate_all_determined", "wh_main_effect_unit_enable_attribute_immune_to_psychology", "character_to_character_own", "1"},
		{"wh2_main_skill_innate_all_disciplined", "wh_main_effect_force_unit_stat_melee_attack", "character_to_force_own", "2"},
		{"wh2_main_skill_innate_all_disciplined", "wh_main_effect_force_unit_stat_morale", "character_to_force_own", "2"},
		{"wh2_main_skill_innate_all_fleet_footed", "wh_main_effect_character_stat_mod_battle_movement_speed", "character_to_character_own", "15"},
		{"wh2_main_skill_innate_all_fleet_footed", "wh_main_effect_unit_enable_attribute_strider", "character_to_character_own", "1"},
		{"wh2_main_skill_innate_all_intelligent", "wh_main_effect_agent_defence_wound_chance_mod", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_all_intelligent", "wh_main_effect_force_army_campaign_ambush_defence_success_chance", "character_to_force_own_unseen", "10"},
		{"wh2_main_skill_innate_all_knowledgeable", "wh_main_effect_military_force_winds_of_magic_depletion_mod_character", "character_to_force_own_factionwide", "5"},
		{"wh2_main_skill_innate_all_knowledgeable", "wh_main_effect_military_force_winds_of_magic_depletion_mod_character_enemy", "general_to_force_enemy_regionwide", "-5"},
		{"wh2_main_skill_innate_all_perceptive", "wh_main_effect_agent_field_line_of_sight_mod", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_all_perceptive", "wh_main_effect_character_mod_ancillary_drop", "character_to_character_own", "15"},
		{"wh2_main_skill_innate_all_strategist", "wh_main_effect_agent_movement_range_mod", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_all_strong", "wh_main_effect_character_stat_mod_armour", "character_to_character_own", "3"},
		{"wh2_main_skill_innate_all_strong", "wh_main_effect_character_stat_mod_melee_attack", "character_to_character_own", "2"},
		{"wh2_main_skill_innate_all_strong", "wh_main_effect_character_stat_mod_melee_damage", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_all_tactician", "wh_main_effect_character_stat_mod_personal_aura_morale_effect", "character_to_character_own", "2"},
		{"wh2_main_skill_innate_all_tactician", "wh_main_effect_character_stat_mod_personal_aura_size", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_all_tough", "wh_main_effect_character_stat_mod_armour", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_all_tough", "wh_main_effect_character_stat_mod_melee_defence", "character_to_character_own", "3"},
		{"wh2_main_skill_innate_all_weapon_master", "wh_main_effect_character_stat_mod_ap_damage", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_all_weapon_master", "wh_main_effect_character_stat_mod_melee_attack", "character_to_character_own", "3"},
		{"wh2_main_skill_innate_hef_prince_army_0_fay", "wh2_main_effect_unit_stat_mod_ward_save_magic_all_units", "general_to_force_own", "-10"},
		{"wh2_main_skill_innate_hef_prince_army_0_ill_prepared", "wh_main_effect_agent_field_line_of_sight_mod", "character_to_character_own", "-20"},
		{"wh2_main_skill_innate_hef_prince_army_0_scornful", "wh2_main_effect_tech_battle_morale_increase_hef_white_lions_swordmasters_phoenix_guard", "general_to_force_own", "-10"},
		{"wh2_main_skill_innate_hef_prince_battle_0_pale_and_wan", "wh_main_effect_character_stat_mod_melee_attack", "character_to_character_own", "-5"},
		{"wh2_main_skill_innate_hef_prince_battle_0_pigeon_chested", "wh_main_effect_character_stat_mod_ward_save_physical", "character_to_character_own", "-10"},
		{"wh2_main_skill_innate_hef_prince_battle_0_squishy", "wh_main_effect_character_stat_mod_melee_defence", "character_to_character_own", "-5"},
		{"wh2_main_skill_innate_hef_prince_campaign_0_birdbrained", "wh_main_effect_force_all_campaign_recruitment_cost_all", "general_to_force_own", "15"},
		{"wh2_main_skill_innate_hef_prince_campaign_0_disorganised", "wh2_main_effect_buildling_upkeep_reduction_hef_resource_wood", "general_to_force_own", "10"},
		{"wh2_main_skill_innate_hef_prince_campaign_0_wasteful", "wh2_main_effect_force_all_campaign_sacking_income", "character_to_character_own", "-30"},
		{"wh2_main_skill_innate_hef_prince_campaign_0_wasteful", "wh_main_effect_force_all_campaign_post_battle_loot_mod", "character_to_character_own", "-50"},
		{"wh2_main_skill_innate_hef_princess_army_0_indolent", "wh_main_effect_force_army_battle_movement_speed", "general_to_force_own", "-5"},
		{"wh2_main_skill_innate_hef_princess_army_0_poltroon", "wh_main_effect_character_stat_mod_personal_aura_size", "general_to_force_own", "-50"},
		{"wh2_main_skill_innate_hef_princess_army_0_soft_hearted", "wh2_main_effect_tech_missile_damage_increase_hef_bow_units", "general_to_force_own", "-5"},
		{"wh2_main_skill_innate_hef_princess_battle_0_feeble", "wh_main_effect_character_stat_mod_melee_damage", "character_to_character_own", "-30"},
		{"wh2_main_skill_innate_hef_princess_battle_0_inaccurate", "wh_main_effect_character_stat_mod_missile_damage", "character_to_character_own", "-10"},
		{"wh2_main_skill_innate_hef_princess_battle_0_inaccurate", "wh_main_effect_character_stat_mod_range", "character_to_character_own", "-20"},
		{"wh2_main_skill_innate_hef_princess_battle_0_unfortunate", "wh_main_effect_character_stat_mod_ward_save_missile", "character_to_character_own", "-10"},
		{"wh2_main_skill_innate_hef_princess_campaign_0_dullard", "wh_main_effect_force_army_campaign_ambush_attack_success_chance", "general_to_force_own_unseen", "-50"},
		{"wh2_main_skill_innate_hef_princess_campaign_0_slovenly", "wh2_main_effect_tech_upkeep_reduction_hef_archers_seaguard_reavers", "general_to_force_own", "10"},
		{"wh2_main_skill_innate_hef_princess_campaign_0_tardy", "wh2_main_effect_tech_upkeep_reduction_hef_chariots_boltthrowers", "general_to_force_own", "30"},
		{"wh2_main_skill_innate_hef_prince_army_3_competent", "wh_main_effect_force_unit_stat_melee_defence", "general_to_force_own", "3"},
		{"wh2_main_skill_innate_hef_prince_army_3_respectful", "wh2_main_effect_tech_battle_morale_increase_hef_white_lions_swordmasters_phoenix_guard", "general_to_force_own", "10"},
		{"wh2_main_skill_innate_hef_prince_army_3_strong_willed", "wh2_main_effect_unit_stat_mod_ward_save_magic_all_units", "general_to_force_own", "5"},
		{"wh2_main_skill_innate_hef_prince_battle_3_elusive", "wh_main_effect_character_stat_mod_battle_movement_speed", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_hef_prince_battle_3_elusive", "wh_main_effect_character_stat_mod_melee_defence", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_hef_prince_battle_3_hale_and_hearty", "wh_main_effect_character_stat_mod_ward_save_physical", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_hef_prince_battle_3_trained", "wh_main_effect_character_stat_mod_charge_add", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_hef_prince_battle_3_trained", "wh_main_effect_character_stat_mod_melee_attack", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_hef_prince_campaign_3_observant", "wh_main_effect_agent_action_outcome_parent_army_xp_gain", "general_to_force_own", "100"},
		{"wh2_main_skill_innate_hef_prince_campaign_3_organised", "wh2_main_effect_buildling_upkeep_reduction_hef_resource_wood", "general_to_force_own", "-10"},
		{"wh2_main_skill_innate_hef_prince_campaign_3_unsentimental", "wh2_main_effect_force_all_campaign_sacking_income", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_hef_prince_campaign_3_unsentimental", "wh_main_effect_force_all_campaign_post_battle_loot_mod", "character_to_character_own", "25"},
		{"wh2_main_skill_innate_hef_princess_army_3_brisk", "wh_main_effect_character_stat_mod_missile_attack_rate", "general_to_force_own", "5"},
		{"wh2_main_skill_innate_hef_princess_army_3_brisk", "wh_main_effect_force_army_battle_movement_speed", "general_to_force_own", "5"},
		{"wh2_main_skill_innate_hef_princess_army_3_resolute", "wh_main_effect_force_army_battle_charge_bonus", "general_to_force_own", "5"},
		{"wh2_main_skill_innate_hef_princess_army_3_resolute", "wh_main_effect_force_unit_stat_morale", "general_to_force_own", "5"},
		{"wh2_main_skill_innate_hef_princess_army_3_retaliatory", "wh2_main_effect_tech_missile_damage_increase_hef_bow_units", "general_to_force_own", "10"},
		{"wh2_main_skill_innate_hef_princess_army_3_retaliatory", "wh_main_effect_agent_defence_wound_chance_mod", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_hef_princess_battle_3_accurate", "wh_main_effect_character_stat_mod_missile_damage", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_hef_princess_battle_3_accurate", "wh_main_effect_character_stat_mod_range", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_hef_princess_battle_3_fortuitous", "wh_main_effect_character_stat_mod_ward_save_missile", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_hef_princess_battle_3_well_founded", "wh_main_effect_character_stat_mod_armour", "character_to_character_own", "20"},
		{"wh2_main_skill_innate_hef_princess_battle_3_well_founded", "wh_main_effect_character_stat_mod_melee_damage", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_hef_princess_campaign_3_careful", "wh_main_effect_character_campaign_spotting_chance", "character_to_character_own", "20"},
		{"wh2_main_skill_innate_hef_princess_campaign_3_careful", "wh_main_effect_force_army_campaign_ambush_attack_success_chance", "general_to_force_own_unseen", "15"},
		{"wh2_main_skill_innate_hef_princess_campaign_3_example", "wh2_main_effect_tech_missile_rate_of_fire_increase_hef_boltthrower", "general_to_force_own", "5"},
		{"wh2_main_skill_innate_hef_princess_campaign_3_example", "wh2_main_effect_tech_movement_speed_increase_hef_chariots", "general_to_force_own", "5"},
		{"wh2_main_skill_innate_hef_princess_campaign_3_example", "wh2_main_effect_tech_upkeep_reduction_hef_chariots_boltthrowers", "general_to_force_own", "-10"},
		{"wh2_main_skill_innate_hef_princess_campaign_3_keen", "wh2_main_effect_tech_upkeep_reduction_hef_archers_seaguard_reavers", "general_to_force_own", "-10"},
		{"wh2_main_skill_innate_hef_prince_army_7_doctrinal", "wh2_main_effect_tech_battle_morale_increase_hef_white_lions_swordmasters_phoenix_guard", "general_to_force_own", "10"},
		{"wh2_main_skill_innate_hef_prince_army_7_doctrinal", "wh2_main_effect_tech_melee_attack_increase_hef_white_lions_swordmasters_phoenix_guard", "general_to_force_own", "5"},
		{"wh2_main_skill_innate_hef_prince_army_7_doctrinal", "wh2_main_effect_tech_melee_damage_increase_hef_white_lions_swordmasters_phoenix_guard", "general_to_force_own", "10"},
		{"wh2_main_skill_innate_hef_prince_army_7_dragon_willed", "wh2_main_effect_tech_upkeep_reduction_hef_dragons", "general_to_force_own", "-20"},
		{"wh2_main_skill_innate_hef_prince_army_7_dragon_willed", "wh2_main_effect_trait_unit_recruitment_duration_hef_dragons", "character_to_province_own", "-1"},
		{"wh2_main_skill_innate_hef_prince_army_7_dragon_willed", "wh2_main_effect_unit_stat_mod_ward_save_magic_all_units", "general_to_force_own", "10"},
		{"wh2_main_skill_innate_hef_prince_army_7_resistant", "wh2_main_effect_tech_ward_save_missile_infantry", "general_to_force_own", "5"},
		{"wh2_main_skill_innate_hef_prince_army_7_resistant", "wh2_main_effect_unit_stat_mod_ward_save_magic_all_units", "general_to_force_own", "5"},
		{"wh2_main_skill_innate_hef_prince_army_7_resistant", "wh_main_effect_force_unit_stat_melee_defence", "general_to_force_own", "5"},
		{"wh2_main_skill_innate_hef_prince_battle_7_dangerous", "wh_main_effect_character_stat_mod_charge_add", "character_to_character_own", "20"},
		{"wh2_main_skill_innate_hef_prince_battle_7_dangerous", "wh_main_effect_character_stat_mod_melee_attack", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_hef_prince_battle_7_dangerous", "wh_main_effect_unit_enable_attribute_fear", "character_to_character_own", "1"},
		{"wh2_main_skill_innate_hef_prince_battle_7_resilient", "wh_main_effect_character_stat_mod_armour", "character_to_character_own", "20"},
		{"wh2_main_skill_innate_hef_prince_battle_7_resilient", "wh_main_effect_character_stat_mod_melee_defence", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_hef_prince_battle_7_vigorous", "wh_main_effect_character_stat_mod_melee_defence", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_hef_prince_battle_7_vigorous", "wh_main_effect_character_stat_mod_ward_save_physical", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_hef_prince_campaign_7_adept", "wh_main_effect_agent_action_outcome_parent_army_xp_gain", "general_to_force_own", "250"},
		{"wh2_main_skill_innate_hef_prince_campaign_7_avaricious", "wh2_main_effect_force_all_campaign_sacking_income", "character_to_character_own", "25"},
		{"wh2_main_skill_innate_hef_prince_campaign_7_avaricious", "wh_main_effect_character_mod_ancillary_drop", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_hef_prince_campaign_7_avaricious", "wh_main_effect_force_all_campaign_post_battle_loot_mod", "character_to_character_own", "50"},
		{"wh2_main_skill_innate_hef_prince_campaign_7_efficient", "wh2_main_effect_buildling_upkeep_reduction_hef_resource_pastures", "general_to_force_own", "-15"},
		{"wh2_main_skill_innate_hef_prince_campaign_7_efficient", "wh2_main_effect_buildling_upkeep_reduction_hef_resource_wood", "general_to_force_own", "-25"},
		{"wh2_main_skill_innate_hef_princess_army_7_dashing", "wh2_main_effect_buildling_upkeep_reduction_hef_resource_pastures", "general_to_force_own", "-30"},
		{"wh2_main_skill_innate_hef_princess_army_7_dashing", "wh2_main_effect_tech_melee_damage_increase_hef_reavers_silverhelms", "general_to_force_own", "20"},
		{"wh2_main_skill_innate_hef_princess_army_7_dashing", "wh2_main_effect_tech_missile_damage_increase_hef_reavers", "general_to_force_own", "20"},
		{"wh2_main_skill_innate_hef_princess_army_7_dashing", "wh_main_effect_force_army_battle_charge_bonus", "general_to_force_own", "20"},
		{"wh2_main_skill_innate_hef_princess_army_7_energetic", "wh_main_effect_agent_movement_range_mod", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_hef_princess_army_7_energetic", "wh_main_effect_character_stat_mod_missile_attack_rate", "general_to_force_own", "10"},
		{"wh2_main_skill_innate_hef_princess_army_7_energetic", "wh_main_effect_force_army_battle_movement_speed", "general_to_force_own", "10"},
		{"wh2_main_skill_innate_hef_princess_army_7_punitive", "wh2_main_effect_force_stat_mod_ward_save_missile_enemy_army", "region_to_force_enemy", "-10"},
		{"wh2_main_skill_innate_hef_princess_army_7_punitive", "wh2_main_effect_tech_missile_damage_increase_hef_bow_units", "general_to_force_own", "20"},
		{"wh2_main_skill_innate_hef_princess_army_7_punitive", "wh_main_effect_agent_defence_wound_chance_mod", "character_to_character_own", "15"},
		{"wh2_main_skill_innate_hef_princess_battle_7_charmed", "wh_dlc03_effect_ability_enable_bound_amber_spear", "character_to_character_own", "1"},
		{"wh2_main_skill_innate_hef_princess_battle_7_charmed", "wh_main_effect_character_stat_mod_ward_save_magic", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_hef_princess_battle_7_charmed", "wh_main_effect_character_stat_mod_ward_save_missile", "character_to_character_own", "20"},
		{"wh2_main_skill_innate_hef_princess_battle_7_charmed", "wh_main_effect_military_force_winds_of_magic_depletion_mod_character", "character_to_force_own_unseen", "-5"},
		{"wh2_main_skill_innate_hef_princess_battle_7_hawk_eyed", "wh_main_effect_character_stat_mod_missile_damage", "character_to_character_own", "30"},
		{"wh2_main_skill_innate_hef_princess_battle_7_hawk_eyed", "wh_main_effect_character_stat_mod_range", "character_to_character_own", "30"},
		{"wh2_main_skill_innate_hef_princess_battle_7_strong", "wh_main_effect_character_stat_mod_armour", "character_to_character_own", "40"},
		{"wh2_main_skill_innate_hef_princess_battle_7_strong", "wh_main_effect_character_stat_mod_melee_damage", "character_to_character_own", "20"},
		{"wh2_main_skill_innate_hef_princess_campaign_7_ardent", "wh2_main_effect_skill_missile_range_increase_hef_archers_reavers_seaguard", "general_to_force_own", "10"},
		{"wh2_main_skill_innate_hef_princess_campaign_7_ardent", "wh2_main_effect_tech_upkeep_reduction_hef_archers_seaguard_reavers", "general_to_force_own", "-30"},
		{"wh2_main_skill_innate_hef_princess_campaign_7_exemplar", "wh2_main_effect_tech_missile_rate_of_fire_increase_hef_boltthrower", "general_to_force_own", "10"},
		{"wh2_main_skill_innate_hef_princess_campaign_7_exemplar", "wh2_main_effect_tech_movement_speed_increase_hef_chariots", "general_to_force_own", "10"},
		{"wh2_main_skill_innate_hef_princess_campaign_7_exemplar", "wh2_main_effect_tech_upkeep_reduction_hef_chariots_boltthrowers", "general_to_force_own", "-30"},
		{"wh2_main_skill_innate_hef_princess_campaign_7_exemplar", "wh2_main_effect_trait_unit_recruitment_duration_hef_chariot", "character_to_province_own", "-1"},
		{"wh2_main_skill_innate_hef_princess_campaign_7_vigilant", "wh2_main_effect_agent_action_success_chance_enemies", "character_to_enemy_character_in_region", "-10"},
		{"wh2_main_skill_innate_hef_princess_campaign_7_vigilant", "wh_main_effect_agent_defence_wound_chance_mod", "character_to_character_own", "20"},
		{"wh2_main_skill_innate_hef_princess_campaign_7_vigilant", "wh_main_effect_character_campaign_spotting_chance", "character_to_character_own", "40"},
		{"wh2_main_skill_innate_hef_princess_campaign_7_vigilant", "wh_main_effect_force_army_campaign_ambush_attack_success_chance", "general_to_force_own_unseen", "30"},
		{"wh2_main_skill_innate_bst_booze_cravings", "wh_dlc03_effect_building_upkeep_reduction_centigors", "character_to_force_own", "-10"},
		{"wh2_main_skill_innate_bst_booze_cravings", "wh_dlc03_effect_tech_unit_xp_levels_centigors", "character_to_force_own", "3"},
		{"wh2_main_skill_innate_bst_khornes_fury", "wh_dlc03_effect_ability_enable_banner_of_outrage", "character_to_character_own", "1"},
		{"wh2_main_skill_innate_bst_nurgles_foul_stink", "wh_main_effect_force_army_battle_enemy_unit_morale", "general_to_force_enemy_regionwide", "-5"},
		{"wh2_main_skill_innate_bst_torment_utterances", "wh_dlc04_effect_force_all_campaign_razing_income_not_shown", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_bst_torment_utterances", "wh_main_effect_force_all_campaign_raid_income", "general_to_force_own", "5"},
		{"wh2_main_skill_innate_bst_unsated_bloodthirst", "wh_dlc03_effect_tech_unit_stat_melee_damage_minotaurs", "agent_to_parent_army_own", "10"},
		{"wh_main_skill_innate_brt_virtue_audacity", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "10"},
		{"wh_main_skill_innate_brt_virtue_audacity", "wh_main_effect_character_stat_mod_melee_damage", "character_to_character_own", "5"},
		{"wh_main_skill_innate_brt_virtue_confidence", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "10"},
		{"wh_main_skill_innate_brt_virtue_confidence", "wh_main_effect_character_stat_mod_melee_defence", "character_to_character_own", "5"},
		{"wh_main_skill_innate_brt_virtue_discipline", "wh_dlc07_effect_battle_defence_knights_of_the_realm", "general_to_force_own", "5"},
		{"wh_main_skill_innate_brt_virtue_discipline", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "10"},
		{"wh_main_skill_innate_brt_virtue_duty", "wh_dlc07_effect_battle_morale_knights", "general_to_force_own", "5"},
		{"wh_main_skill_innate_brt_virtue_duty", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "10"},
		{"wh_main_skill_innate_brt_virtue_heroism", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "10"},
		{"wh_main_skill_innate_brt_virtue_heroism", "wh_main_effect_character_stat_mod_bonus_v_large", "character_to_character_own", "8"},
		{"wh_main_skill_innate_brt_virtue_ideal", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "10"},
		{"wh_main_skill_innate_brt_virtue_ideal", "wh_main_effect_character_stat_mod_melee_attack", "character_to_character_own", "5"},
		{"wh_main_skill_innate_brt_virtue_ideal", "wh_main_effect_character_stat_mod_melee_defence", "character_to_character_own", "5"},
		{"wh_main_skill_innate_brt_virtue_impetuous_knight", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "10"},
		{"wh_main_skill_innate_brt_virtue_impetuous_knight", "wh_main_effect_character_stat_mod_battle_movement_speed", "character_to_character_own", "10"},
		{"wh_main_skill_innate_brt_virtue_joust", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "10"},
		{"wh_main_skill_innate_brt_virtue_joust", "wh_main_effect_force_army_battle_charge_bonus", "character_to_character_own", "15"},
		{"wh_main_skill_innate_brt_virtue_knightly_temper", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "10"},
		{"wh_main_skill_innate_brt_virtue_knightly_temper", "wh_main_effect_character_stat_mod_melee_attack", "character_to_character_own", "5"},
		{"wh_main_skill_innate_brt_virtue_noble_disdain", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "10"},
		{"wh_main_skill_innate_brt_virtue_noble_disdain", "wh_main_effect_character_stat_mod_ward_save_missile", "character_to_character_own", "10"},
		{"wh_main_skill_innate_brt_virtue_penitent", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "10"},
		{"wh_main_skill_innate_brt_virtue_penitent", "wh_main_effect_character_stat_mod_ward_save", "character_to_character_own", "3"},
		{"wh_main_skill_innate_brt_virtue_stoicism", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "10"},
		{"wh_main_skill_innate_brt_virtue_stoicism", "wh_main_effect_character_stat_mod_morale", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_chs_diabolic_spendour", "wh_main_effect_general_aura_mod_all_during_attack", "character_to_character_own", "15"},
		{"wh2_main_skill_innate_chs_dominance", "wh_main_effect_force_unit_stat_melee_attack", "character_to_force_own", "5"},
		{"wh2_main_skill_innate_def_cruel", "wh_main_effect_force_all_campaign_raid_income", "general_to_force_own", "10"},
		{"wh2_main_skill_innate_def_cruel", "wh_main_effect_force_all_campaign_sacking_income", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_def_malevolent", "wh_main_effect_general_aura_mod_all_during_attack", "character_to_character_own", "25"},
		{"wh2_main_skill_innate_def_malicious", "wh2_main_effect_agent_recruitment_xp_def_death_hag", "character_to_province_own", "2"},
		{"wh2_main_skill_innate_def_malicious", "wh_main_effect_building_construction_cost_mod_worship_def", "character_to_region_own", "-40"},
		{"wh2_main_skill_innate_def_spiteful", "wh_main_effect_force_unit_stat_melee_attack", "character_to_force_own", "3"},
		{"wh2_main_skill_innate_def_spiteful", "wh_main_effect_force_unit_stat_melee_damage", "character_to_force_own", "5"},
		{"wh2_main_skill_innate_def_vicious", "wh_main_effect_character_stat_mod_melee_attack", "character_to_character_own", "3"},
		{"wh2_main_skill_innate_def_vicious", "wh_main_effect_character_stat_mod_melee_defence", "character_to_character_own", "3"},
		{"wh2_main_skill_innate_dwf_ancestral_blood_grimnir", "wh_main_effect_character_stat_mod_melee_attack", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_dwf_ancestral_blood_grungni", "wh_main_effect_building_construction_cost_mod", "character_to_region_own", "-15"},
		{"wh2_main_skill_innate_dwf_ancestral_blood_valaya", "wh_main_effect_agent_action_success_chance_enemy", "character_to_character_own", "-20"},
		{"wh2_main_skill_innate_grn_big_bully", "wh_main_effect_tech_recruitment_cost_reduction_bigun_black_orcs", "general_to_force_own", "-10"},
		{"wh2_main_skill_innate_grn_big_bully", "wh_main_effect_tech_unit_xp_levels_bigun_black_orcs", "general_to_force_own", "1"},
		{"wh2_main_skill_innate_grn_bragga", "wh_main_effect_character_stat_mod_morale", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_grn_mushroom_addicted", "wh_dlc06_effect_upkeep_for_goblin_units", "character_to_force_own_unseen", "-15"},
		{"wh2_main_skill_innate_grn_serial_danca", "wh_dlc03_effect_ability_enable_banner_of_outrage", "character_to_character_own", "1"},
		{"wh2_main_skill_innate_grn_tortura", "wh_main_effect_public_order_characters", "character_to_enemy_province", "-3"},
		{"wh2_main_skill_innate_emp_imperious", "wh_main_effect_character_stat_mod_charge_bonus", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_emp_monster_hunter", "wh_main_effect_character_stat_mod_bonus_v_large", "character_to_character_own", "6"},
		{"wh2_main_skill_innate_emp_monster_tracker", "wh_main_effect_agent_field_line_of_sight_mod", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_emp_monster_tracker", "wh_main_effect_agent_movement_range_mod", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_emp_noble", "wh_main_effect_economy_gdp_mod_all", "character_to_region_own_provincewide", "10"},
		{"wh2_main_skill_innate_emp_regal", "wh_main_effect_public_order_characters", "character_to_province_own", "4"},
		{"wh2_main_skill_innate_lzd_arrogant", "wh_main_effect_character_stat_mod_charge_add", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_lzd_arrogant", "wh_main_effect_unit_enable_attribute_immune_to_psychology", "character_to_character_own", "1"},
		{"wh2_main_skill_innate_lzd_humble", "wh_main_effect_agent_recruitment_xp_all_agents", "character_to_province_own", "2"},
		{"wh2_main_skill_innate_lzd_pompous", "wh_main_effect_force_army_battle_enemy_unit_morale", "general_to_force_enemy_regionwide", "-4"},
		{"wh2_main_skill_innate_lzd_uncompromising", "wh_main_effect_agent_defence_wound_chance_mod", "character_to_character_own", "15"},
		{"wh_dlc07_brt_skill_innate_all_honourable", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "5"},
		{"wh_dlc07_brt_skill_innate_all_honourable", "wh_main_effect_character_stat_mod_morale", "character_to_character_own", "10"},
		{"wh_dlc07_brt_skill_innate_all_intelligent", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "5"},
		{"wh_dlc07_brt_skill_innate_all_intelligent", "wh_main_effect_agent_defence_wound_chance_mod", "character_to_character_own", "5"},
		{"wh_dlc07_brt_skill_innate_all_intelligent", "wh_main_effect_force_army_campaign_ambush_defence_success_chance", "general_to_force_own", "10"},
		{"wh_dlc07_brt_skill_innate_all_intelligent", "wh_main_effect_name_epithet_brt_the_astute", "character_to_character_own", "1"},
		{"wh_dlc07_brt_skill_innate_all_intelligent", "wh_main_effect_name_epithet_chs_the_astute", "character_to_character_own", "1"},
		{"wh_dlc07_brt_skill_innate_all_intelligent", "wh_main_effect_name_epithet_dwf_the_astute", "character_to_character_own", "1"},
		{"wh_dlc07_brt_skill_innate_all_intelligent", "wh_main_effect_name_epithet_emp_the_astute", "character_to_character_own", "1"},
		{"wh_dlc07_brt_skill_innate_all_intelligent", "wh_main_effect_name_epithet_grn_the_astute", "character_to_character_own", "1"},
		{"wh_dlc07_brt_skill_innate_all_intelligent", "wh_main_effect_name_epithet_vmp_the_astute", "character_to_character_own", "1"},
		{"wh_dlc07_brt_skill_innate_all_magnanimous", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "5"},
		{"wh_dlc07_brt_skill_innate_all_magnanimous", "wh_main_effect_economy_gdp_mod_all", "character_to_region_own", "5"},
		{"wh_dlc07_brt_skill_innate_all_melancholic", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "5"},
		{"wh_dlc07_brt_skill_innate_all_melancholic", "wh_main_effect_agent_defence_wound_chance_mod", "character_to_character_own", "-5"},
		{"wh_dlc07_brt_skill_innate_all_melancholic", "wh_main_effect_public_order_characters_negative", "character_to_enemy_province", "-1"},
		{"wh_dlc07_brt_skill_innate_all_phlegmatic", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "5"},
		{"wh_dlc07_brt_skill_innate_all_phlegmatic", "wh_main_effect_agent_field_line_of_sight_mod", "character_to_character_own", "5"},
		{"wh_dlc07_brt_skill_innate_all_phlegmatic", "wh_main_effect_public_order_characters", "character_to_province_own", "1"},
		{"wh_dlc07_brt_skill_innate_all_sanguine", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "5"},
		{"wh_dlc07_brt_skill_innate_all_sanguine", "wh_main_effect_agent_action_success_chance_enemy", "character_to_character_own", "-3"},
		{"wh_dlc07_brt_skill_innate_all_sanguine", "wh_main_effect_character_stat_mod_melee_attack", "character_to_character_own", "5"},
		{"wh_dlc07_brt_skill_innate_all_uncompromising", "wh_dlc07_effect_chivalry_dummy", "character_to_faction_unseen", "5"},
		{"wh_dlc07_brt_skill_innate_all_uncompromising", "wh_main_effect_agent_defence_wound_chance_mod", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_skv_sharp_claws", "wh_main_effect_character_stat_mod_charge_add", "character_to_character_own", "4"},
		{"wh2_main_skill_innate_skv_sharp_claws", "wh_main_effect_character_stat_mod_melee_damage", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_skv_sharp_teeth", "wh_main_effect_character_stat_mod_ap_damage", "character_to_character_own", "5"},
		{"wh2_main_skill_innate_skv_sharp_teeth", "wh_main_effect_character_stat_mod_melee_attack", "character_to_character_own", "3"},
		{"wh2_main_skill_innate_skv_sneaky", "wh_main_effect_force_army_campaign_ambush_attack_success_chance", "character_to_force_own_unseen", "25"},
		{"wh2_main_skill_innate_skv_warpstone_hoarder", "wh2_main_effect_skv_warp_unit_upkeep_down", "character_to_force_own", "-12"},
		{"wh2_dlc09_skill_innate_tmb_eternal", "wh_main_effect_character_stat_mod_ward_save_physical", "character_to_character_own", "5"},
		{"wh2_dlc09_skill_innate_tmb_master_of_ceremony", "wh_main_effect_religion_conversion_untainted", "character_to_character_own_provincetext", "2"},
		{"wh2_dlc09_skill_innate_tmb_prepared", "wh_main_effect_force_unit_stat_ammunition", "army_to_army_own", "20"},
		{"wh2_dlc09_skill_innate_tmb_prepared", "wh_main_effect_force_unit_stat_missile_damage", "general_to_force_own", "5"},
		{"wh2_dlc09_skill_innate_tmb_scavenger", "wh_main_effect_character_mod_ancillary_drop", "character_to_character_own", "3"},
		{"wh2_dlc09_skill_innate_tmb_scavenger", "wh_main_effect_character_mod_ancillary_steal", "character_to_character_own", "20"},
		{"wh2_dlc09_skill_innate_tmb_scavenger", "wh_main_effect_force_all_campaign_post_battle_loot_mod", "character_to_character_own", "10"},
		{"wh2_dlc09_skill_innate_tmb_treacherous", "wh2_dlc09_effect_tech_melee_attack_increase_tmb_scorpions", "general_to_force_own", "5"},
		{"wh2_dlc09_skill_innate_tmb_treacherous", "wh2_dlc09_effect_tech_melee_defence_increase_tmb_scorpions", "general_to_force_own", "5"},
		{"wh2_dlc09_skill_innate_tmb_treacherous", "wh_main_effect_agent_action_success_chance", "character_to_character_provincewide", "5"},
		{"wh2_dlc09_skill_innate_tmb_trustworthy", "wh2_dlc09_faction_political_diplomacy_mod", "faction_to_faction_own_unseen", "5"},
		{"wh2_dlc09_skill_innate_tmb_trustworthy", "wh_main_effect_public_order_characters", "character_to_province_own", "1"},
		{"wh2_dlc09_skill_innate_tmb_wrathful", "wh_main_effect_character_stat_mod_bonus_v_small", "character_to_character_own", "10"},
		{"wh2_main_skill_innate_vmp_dark_majesty", "wh_main_effect_character_stat_mod_personal_aura_morale_effect", "character_to_character_own", "3"},
		{"wh2_main_skill_innate_vmp_dark_majesty", "wh_main_effect_character_stat_mod_personal_aura_size", "character_to_character_own", "20"},
		{"wh2_main_skill_innate_vmp_devious", "wh_main_effect_agent_action_cost_mod", "character_to_character_provincewide", "-10"},
		{"wh2_main_skill_innate_vmp_devious", "wh_main_effect_agent_action_success_chance", "character_to_character_provincewide", "5"},
		{"wh2_main_skill_innate_vmp_dread_incarnate", "wh_main_effect_unit_enable_attribute_terror", "character_to_character_own", "1"},
		{"wh2_main_skill_innate_vmp_lore_keeper", "wh_main_effect_building_construction_cost_mod", "character_to_region_own", "-10"},
		{"wh2_main_skill_innate_vmp_master_of_the_black_arts", "wh2_main_effect_force_stat_mod_miscast_chance", "character_to_character_regionwide_local_region", "-10"},
		{"wh2_main_skill_innate_wef_ariels_chosen", "wh_dlc05_effect_force_army_battle_melee_attack_during_forest", "general_to_force_own", "4"},
		{"wh2_main_skill_innate_wef_ariels_chosen", "wh_main_effect_military_force_winds_of_magic_depletion_mod_character", "character_to_force_own_unseen", "10"},
		{"wh2_main_skill_innate_wef_talon_of_kurnous", "wh_main_effect_force_unit_stat_missile_range", "character_to_force_own", "10"},
		{"wh2_main_trait_increased_cost_1", "increased_cost", "character_to_character_own", "1000"},
		{"wh2_main_trait_increased_cost_2", "increased_cost", "character_to_character_own", "3000"},
		{"wh2_main_trait_increased_cost_3", "increased_cost", "character_to_character_own", "6000"},
		{"wh2_main_trait_increased_cost_4", "increased_cost", "character_to_character_own", "10000"}
	}
}