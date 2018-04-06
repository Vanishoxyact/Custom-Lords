faction_lord_types = {
    SCHEMA = {"key", "faction_type", "lord_type", "lord_type_name"},
    KEY = {"key", "LIST"},
    DATA = {
        {"wh_main_sc_brt_bretonnia", "SUBCULTURE", "dlc07_brt_prophetess_beasts", "Prophetess (Beasts)"},
        {"wh_main_sc_brt_bretonnia", "SUBCULTURE", "dlc07_brt_prophetess_heavens", "Prophetess (Heavens)"},
        {"wh_main_sc_brt_bretonnia", "SUBCULTURE", "dlc07_brt_prophetess_life", "Prophetess (Life)"},
        {"wh_main_sc_brt_bretonnia", "SUBCULTURE", "brt_lord", "Lord"},

        {"wh_main_sc_chs_chaos", "SUBCULTURE", "chs_lord", "Chaos Lord"},
        {"wh_main_sc_chs_chaos", "SUBCULTURE", "chs_sorcerer_lord_death", "Chaos Sorcerer Lord (Death)"},
        {"wh_main_sc_chs_chaos", "SUBCULTURE", "chs_sorcerer_lord_fire", "Chaos Sorcerer Lord (Fire)"},
        {"wh_main_sc_chs_chaos", "SUBCULTURE", "chs_sorcerer_lord_metal", "Chaos Sorcerer Lord (Metal)"},
        {"wh_main_sc_chs_chaos", "SUBCULTURE", "dlc07_chs_sorcerer_lord_shadow", "Chaos Sorcerer Lord (Shadows)"},

        {"wh_dlc03_sc_bst_beastmen", "SUBCULTURE", "dlc03_bst_beastlord", "Beastlord"},

        {"wh_dlc05_sc_wef_wood_elves", "SUBCULTURE", "dlc05_wef_ancient_treeman", "Ancient Treeman"},
        {"wh_dlc05_sc_wef_wood_elves", "SUBCULTURE", "dlc05_wef_glade_lord", "Glade Lord"},
        {"wh_dlc05_sc_wef_wood_elves", "SUBCULTURE", "dlc05_wef_glade_lord_fem", "Glade Lord"},

        {"wh_main_sc_dwf_dwarfs", "SUBCULTURE", "dwf_lord", "Lord"},
        {"wh_main_sc_dwf_dwarfs", "SUBCULTURE", "dlc06_dwf_runelord", "Runelord"},

        {"wh_main_sc_grn_greenskins", "SUBCULTURE", "dlc06_grn_night_goblin_warboss", "Night Goblin Warboss"},
        {"wh_main_sc_grn_greenskins", "SUBCULTURE", "grn_goblin_great_shaman", "Goblin Great Shaman"},
        {"wh_main_sc_grn_greenskins", "SUBCULTURE", "grn_orc_warboss", "Orc Warboss"},

        {"wh_main_sc_grn_savage_orcs", "SUBCULTURE", "dlc06_grn_night_goblin_warboss", "Night Goblin Warboss"},
        {"wh_main_sc_grn_savage_orcs", "SUBCULTURE", "grn_goblin_great_shaman", "Goblin Great Shaman"},
        {"wh_main_sc_grn_savage_orcs", "SUBCULTURE", "grn_orc_warboss", "Orc Warboss"},

        {"wh_main_sc_emp_empire", "SUBCULTURE", "emp_lord", "General of the Empire"},
        {"wh_main_sc_emp_empire", "SUBCULTURE", "dlc04_emp_arch_lector", "Arch Lector"},

        {"wh_main_sc_ksl_kislev", "SUBCULTURE", "ksl_lord", "Lord"},

        {"wh_main_sc_nor_norsca", "SUBCULTURE", "nor_marauder_chieftain", "Marauder Chieftain"},
        {"wh_main_sc_nor_norsca", "SUBCULTURE", "nor_sorcerer_lord_metal", "Chaos Sorcerer Lord (Metal)"},

        {"wh_main_sc_teb_teb", "SUBCULTURE", "teb_lord", "Lord"},

        {"wh_main_sc_vmp_vampire_counts", "SUBCULTURE", "vmp_lord", "Vampire Lord"},
        {"wh_main_sc_vmp_vampire_counts", "SUBCULTURE", "vmp_master_necromancer", "Master Necromancer"},

        {"wh2_dlc09_sc_tmb_tomb_kings", "SUBCULTURE", "wh2_dlc09_tmb_tomb_king", "Tomb King"},

        {"wh2_main_sc_def_dark_elves", "SUBCULTURE", "wh2_main_def_dreadlord", "Dreadlord (Sword & Crossbow)"},
        {"wh2_main_sc_def_dark_elves", "SUBCULTURE", "wh2_main_def_dreadlord_fem", "Dreadlord (Sword & Shield)"},

        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_main_hef_prince", "Prince"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_main_hef_princess", "Princess"},

        {"wh2_main_sc_lzd_lizardmen", "SUBCULTURE", "wh2_main_lzd_saurus_old_blood", "Saurus Oldblood"},
        {"wh2_main_sc_lzd_lizardmen", "SUBCULTURE", "wh2_main_lzd_slann_mage_priest", "Slann Mage-Priest"},

        {"wh2_main_sc_skv_skaven", "SUBCULTURE", "wh2_main_skv_grey_seer_plague", "Grey Seer (Plague)"},
        {"wh2_main_sc_skv_skaven", "SUBCULTURE", "wh2_main_skv_grey_seer_ruin", "Grey Seer (Ruin)"},
        {"wh2_main_sc_skv_skaven", "SUBCULTURE", "wh2_main_skv_warlord", "Warlord"}
    }
}

lord_types = {
    SCHEMA = {"key", "skill_set", "skill_set_name", "default_skill_set"},
    KEY = {"key", "LIST"},
    DATA = {
        {"wh2_main_hef_prince", "wh2_main_trait_hef_prince_melee", "Melee", "TRUE"},
        {"wh2_main_hef_prince", "wh2_main_trait_hef_prince_magic", "Magic", "FALSE"},
        {"wh2_main_hef_princess", "wh2_main_trait_hef_princess_ranged", "Ranged", "TRUE"},
        {"wh2_main_hef_princess", "wh2_main_trait_hef_princess_magic", "Magic", "FALSE"}
    }
}

skill_set_skills = {
    SCHEMA = {"key", "skill_set_skill"},
    KEY = {"key", "LIST"},
    DATA = {
        {"wh2_main_trait_hef_prince_melee", "wh2_main_skill_hef_combat_graceful_strikes"},
        {"wh2_main_trait_hef_prince_melee", "module_wh2_main_skill_hef_combat_graceful_strikes"},
        {"wh2_main_trait_hef_prince_melee", "wh_main_skill_all_all_self_foe-seeker"},
        {"wh2_main_trait_hef_prince_melee", "module_wh_main_skill_all_all_self_foe-seeker"},
        {"wh2_main_trait_hef_prince_melee", "wh_main_skill_all_all_self_deadly_onslaught"},
        {"wh2_main_trait_hef_prince_magic", "wh2_main_skill_all_magic_high_02_apotheosis"},
        {"wh2_main_trait_hef_prince_magic", "module_wh2_main_skill_all_magic_high_02_apotheosis"},
        {"wh2_main_trait_hef_prince_magic", "wh_main_skill_all_magic_all_06_evasion"},
        {"wh2_main_trait_hef_prince_magic", "module_wh_main_skill_all_magic_all_06_evasion"},
        {"wh2_main_trait_hef_prince_magic", "wh_main_skill_all_magic_all_11_arcane_conduit"},
        {"wh2_main_trait_hef_princess_ranged", "wh2_main_skill_hef_seeking_arrows"},
        {"wh2_main_trait_hef_princess_ranged", "module_wh2_main_skill_hef_seeking_arrows"},
        {"wh2_main_trait_hef_princess_ranged", "wh_main_skill_all_all_self_foe-seeker"},
        {"wh2_main_trait_hef_princess_ranged", "module_wh_main_skill_all_all_self_foe-seeker"},
        {"wh2_main_trait_hef_princess_ranged", "wh2_main_skill_hef_def_volley_of_arrows"},
        {"wh2_main_trait_hef_princess_magic", "wh2_main_skill_all_magic_high_02_apotheosis"},
        {"wh2_main_trait_hef_princess_magic", "module_wh2_main_skill_all_magic_high_02_apotheosis"},
        {"wh2_main_trait_hef_princess_magic", "wh_main_skill_all_magic_all_06_evasion"},
        {"wh2_main_trait_hef_princess_magic", "module_wh_main_skill_all_magic_all_06_evasion"},
        {"wh2_main_trait_hef_princess_magic", "wh_main_skill_all_magic_all_11_arcane_conduit"}
    }
}

traits = {
    SCHEMA = {"key", "trait_cost"},
    KEY = {"key", "UNIQUE"},
    DATA = {
        {"wh2_main_skill_innate_all_aggressive", "-2"},
        {"wh2_main_skill_innate_all_confident", "-2"},
        {"wh2_main_skill_innate_all_cunning", "-2"},
        {"wh2_main_skill_innate_all_determined", "-2"},
        {"wh2_main_skill_innate_all_disciplined", "-2"},
        {"wh2_main_skill_innate_all_fleet_footed", "-2"},
        {"wh2_main_skill_innate_all_intelligent", "-2"},
        {"wh2_main_skill_innate_all_knowledgeable", "-2"},
        {"wh2_main_skill_innate_all_perceptive", "-2"},
        {"wh2_main_skill_innate_all_strategist", "-2"},
        {"wh2_main_skill_innate_all_strong", "-2"},
        {"wh2_main_skill_innate_all_tactician", "-2"},
        {"wh2_main_skill_innate_all_tough", "-2"},
        {"wh2_main_skill_innate_all_weapon_master", "-2"},
        {"wh2_main_trait_increased_cost", "1"},
        {"wh2_main_skill_innate_hef_prince_army_0_fay", "1"},
        {"wh2_main_skill_innate_hef_prince_army_0_ill_prepared", "1"},
        --{"wh2_main_skill_innate_hef_prince_army_0_scornful", "1"},
        {"wh2_main_skill_innate_hef_prince_battle_0_pale_and_wan", "1"},
        {"wh2_main_skill_innate_hef_prince_battle_0_pigeon_chested", "1"},
        {"wh2_main_skill_innate_hef_prince_battle_0_squishy", "1"},
        {"wh2_main_skill_innate_hef_prince_campaign_0_birdbrained", "1"},
        --{"wh2_main_skill_innate_hef_prince_campaign_0_disorganised", "1"},
        {"wh2_main_skill_innate_hef_prince_campaign_0_wasteful", "1"},
        {"wh2_main_skill_innate_hef_princess_army_0_indolent", "1"},
        {"wh2_main_skill_innate_hef_princess_army_0_poltroon", "1"},
        --{"wh2_main_skill_innate_hef_princess_army_0_soft_hearted", "1"},
        {"wh2_main_skill_innate_hef_princess_battle_0_feeble", "1"},
        {"wh2_main_skill_innate_hef_princess_battle_0_inaccurate", "1"},
        {"wh2_main_skill_innate_hef_princess_battle_0_unfortunate", "1"},
        {"wh2_main_skill_innate_hef_princess_campaign_0_dullard", "1"},
        --{"wh2_main_skill_innate_hef_princess_campaign_0_slovenly", "1"},
        --{"wh2_main_skill_innate_hef_princess_campaign_0_tardy", "1"},
        {"wh2_main_skill_innate_hef_prince_army_3_competent", "-2"},
        --{"wh2_main_skill_innate_hef_prince_army_3_respectful", "-2"},
        {"wh2_main_skill_innate_hef_prince_army_3_strong_willed", "-2"},
        {"wh2_main_skill_innate_hef_prince_battle_3_elusive", "-2"},
        {"wh2_main_skill_innate_hef_prince_battle_3_hale_and_hearty", "-2"},
        {"wh2_main_skill_innate_hef_prince_battle_3_trained", "-2"},
        {"wh2_main_skill_innate_hef_prince_campaign_3_observant", "-2"},
        --{"wh2_main_skill_innate_hef_prince_campaign_3_organised", "-2"},
        {"wh2_main_skill_innate_hef_prince_campaign_3_unsentimental", "-2"},
        {"wh2_main_skill_innate_hef_princess_army_3_brisk", "-2"},
        {"wh2_main_skill_innate_hef_princess_army_3_resolute", "-2"},
        --{"wh2_main_skill_innate_hef_princess_army_3_retaliatory", "-2"},
        {"wh2_main_skill_innate_hef_princess_battle_3_accurate", "-2"},
        {"wh2_main_skill_innate_hef_princess_battle_3_fortuitous", "-2"},
        {"wh2_main_skill_innate_hef_princess_battle_3_well_founded", "-2"},
        {"wh2_main_skill_innate_hef_princess_campaign_3_careful", "-2"},
        --{"wh2_main_skill_innate_hef_princess_campaign_3_example", "-2"},
        --{"wh2_main_skill_innate_hef_princess_campaign_3_keen", "-2"},
        --{"wh2_main_skill_innate_hef_prince_army_7_doctrinal", "-4"},
        --{"wh2_main_skill_innate_hef_prince_army_7_dragon_willed", "-4"},
        {"wh2_main_skill_innate_hef_prince_army_7_resistant", "-4"},
        {"wh2_main_skill_innate_hef_prince_battle_7_dangerous", "-4"},
        {"wh2_main_skill_innate_hef_prince_battle_7_resilient", "-4"},
        {"wh2_main_skill_innate_hef_prince_battle_7_vigorous", "-4"},
        {"wh2_main_skill_innate_hef_prince_campaign_7_adept", "-4"},
        {"wh2_main_skill_innate_hef_prince_campaign_7_avaricious", "-4"},
        --{"wh2_main_skill_innate_hef_prince_campaign_7_efficient", "-4"},
        --{"wh2_main_skill_innate_hef_princess_army_7_dashing", "-4"},
        {"wh2_main_skill_innate_hef_princess_army_7_energetic", "-4"},
        --{"wh2_main_skill_innate_hef_princess_army_7_punitive", "-4"},
        {"wh2_main_skill_innate_hef_princess_battle_7_charmed", "-4"},
        {"wh2_main_skill_innate_hef_princess_battle_7_hawk_eyed", "-4"},
        {"wh2_main_skill_innate_hef_princess_battle_7_strong", "-4"},
        --{"wh2_main_skill_innate_hef_princess_campaign_7_ardent", "-4"},
        --{"wh2_main_skill_innate_hef_princess_campaign_7_exemplar", "-4"},
        {"wh2_main_skill_innate_hef_princess_campaign_7_vigilant", "-4"}
    }
}

trait_incidents = {
    SCHEMA = {"key", "incident_key"},
    KEY = {"key", "LIST"},
    DATA = {
        {"wh2_main_trait_increased_cost", "wh2_main_incident_treasury_down_one_k"}
    }
}

attributes = {
    SCHEMA = {"key", "attribute_value", "effect_bundle"},
    KEY = {"key", "LIST"},
    DATA = {
        {"char_melee_attack", "1", "wh2_vanish_clc_attribute_melee_attack_1"}
    }
}