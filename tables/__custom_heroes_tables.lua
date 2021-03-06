faction_lord_types = {
    SCHEMA = {"key", "faction_type", "lord_type", "lord_type_name"},
    KEY = {"key", "LIST"},
    DATA = {
        {"wh_main_sc_brt_bretonnia", "SUBCULTURE", "brt_paladin", "Paladin"},
        {"wh_main_sc_brt_bretonnia", "SUBCULTURE", "brt_damsel", "Damsel (Heavens)"},
        {"wh_main_sc_brt_bretonnia", "SUBCULTURE", "brt_damsel_beasts", "Damsel (Beasts)"},
        {"wh_main_sc_brt_bretonnia", "SUBCULTURE", "brt_damsel_life", "Damsel (Life)"},

        {"wh_main_sc_chs_chaos", "SUBCULTURE", "chs_exalted_hero", "Exalted Hero"},
        {"wh_main_sc_chs_chaos", "SUBCULTURE", "chs_chaos_sorcerer_death", "Chaos Sorcerer (Death)"},
        {"wh_main_sc_chs_chaos", "SUBCULTURE", "chs_chaos_sorcerer_fire", "Chaos Sorcerer (Fire)"},
        {"wh_main_sc_chs_chaos", "SUBCULTURE", "chs_chaos_sorcerer_metal", "Chaos Sorcerer (Metal)"},
        {"wh_main_sc_chs_chaos", "SUBCULTURE", "dlc07_chs_chaos_sorcerer_shadow", "Chaos Sorcerer (Shadows)"},

        {"wh_dlc03_sc_bst_beastmen", "SUBCULTURE", "dlc03_bst_gorebull", "Gorebull"},
        {"wh_dlc03_sc_bst_beastmen", "SUBCULTURE", "dlc03_bst_bray_shaman_beasts", "Bray-Shaman (Beasts)"},
        {"wh_dlc03_sc_bst_beastmen", "SUBCULTURE", "dlc03_bst_bray_shaman_death", "Bray-Shaman (Death)"},
        {"wh_dlc03_sc_bst_beastmen", "SUBCULTURE", "dlc03_bst_bray_shaman_shadows", "Bray-Shaman (Shadows)"},
        {"wh_dlc03_sc_bst_beastmen", "SUBCULTURE", "dlc03_bst_bray_shaman_wild", "Bray-Shaman (Wild)"},

        {"wh_dlc05_sc_wef_wood_elves", "SUBCULTURE", "wh_dlc05_wef_branchwraith", "Branchwraith"},
        {"wh_dlc05_sc_wef_wood_elves", "SUBCULTURE", "dlc05_wef_waystalker", "Waystalker"},
        {"wh_dlc05_sc_wef_wood_elves", "SUBCULTURE", "dlc05_wef_spellsinger_beasts", "Spellsinger (Beasts)"},
        {"wh_dlc05_sc_wef_wood_elves", "SUBCULTURE", "dlc05_wef_spellsinger_life", "Spellsinger (Life)"},
        {"wh_dlc05_sc_wef_wood_elves", "SUBCULTURE", "dlc05_wef_spellsinger_shadow", "Spellsinger (Shadows)"},

        {"wh_main_sc_dwf_dwarfs", "SUBCULTURE", "dwf_thane", "Thane"},
        {"wh_main_sc_dwf_dwarfs", "SUBCULTURE", "dwf_master_engineer", "Master Engineer"},
        {"wh_main_sc_dwf_dwarfs", "SUBCULTURE", "dwf_runesmith", "Runesmith"},

        {"wh_main_sc_grn_greenskins", "SUBCULTURE", "grn_goblin_big_boss", "Goblin Big Boss"},
        {"wh_main_sc_grn_greenskins", "SUBCULTURE", "grn_night_goblin_shaman", "Night Goblin Shaman"},
        {"wh_main_sc_grn_greenskins", "SUBCULTURE", "grn_orc_shaman", "Orc Shaman"},
        {"wh_main_sc_grn_greenskins", "SUBCULTURE", "wh2_dlc15_grn_river_troll_hag", "Giant River Troll Hag"},

        {"wh_main_sc_grn_savage_orcs", "SUBCULTURE", "grn_goblin_big_boss", "Goblin Big Boss"},
        {"wh_main_sc_grn_savage_orcs", "SUBCULTURE", "grn_night_goblin_shaman", "Night Goblin Shaman"},
        {"wh_main_sc_grn_savage_orcs", "SUBCULTURE", "grn_orc_shaman", "Orc Shaman"},

        {"wh_main_sc_emp_empire", "SUBCULTURE", "emp_captain", "Empire Captain"},
        {"wh_main_sc_emp_empire", "SUBCULTURE", "emp_warrior_priest", "Warrior Priest"},
        {"wh_main_sc_emp_empire", "SUBCULTURE", "emp_witch_hunter", "Witch Hunter"},
        {"wh_main_sc_emp_empire", "SUBCULTURE", "dlc03_emp_amber_wizard", "Amber Wizard"},
        {"wh_main_sc_emp_empire", "SUBCULTURE", "dlc05_emp_grey_wizard", "Grey Wizard"},
        {"wh_main_sc_emp_empire", "SUBCULTURE", "dlc05_emp_jade_wizard", "Jade Wizard"},
        {"wh_main_sc_emp_empire", "SUBCULTURE", "emp_bright_wizard", "Bright Wizard"},
        {"wh_main_sc_emp_empire", "SUBCULTURE", "emp_celestial_wizard", "Celestial Wizard"},
        {"wh_main_sc_emp_empire", "SUBCULTURE", "emp_light_wizard", "Light Wizard"},
        {"wh_main_sc_emp_empire", "SUBCULTURE", "wh2_pro07_emp_amethyst_wizard", "Amethyst Wizard"},

        {"wh_main_sc_ksl_kislev", "SUBCULTURE", "ksl_captain", "Captain"},
        {"wh_main_sc_ksl_kislev", "SUBCULTURE", "emp_warrior_priest", "Warrior Priest"},
        {"wh_main_sc_ksl_kislev", "SUBCULTURE", "emp_witch_hunter", "Witch Hunter"},
        {"wh_main_sc_ksl_kislev", "SUBCULTURE", "ksl_celestial_wizard", "Celestial Wizard"},

        {"wh_main_sc_nor_norsca", "SUBCULTURE", "wh_dlc08_nor_skin_wolf_werekin", "Skin Wolf Werekin"},
        {"wh_main_sc_nor_norsca", "SUBCULTURE", "wh_dlc08_nor_fimir_balefiend_fire", "Fimir Balefiend (Fire)"},
        {"wh_main_sc_nor_norsca", "SUBCULTURE", "wh_dlc08_nor_fimir_balefiend_shadow", "Fimir Balefiend (Shadows)"},
        {"wh_main_sc_nor_norsca", "SUBCULTURE", "wh_dlc08_nor_shaman_sorcerer_death", "Shaman-Sorcerer (Death)"},
        {"wh_main_sc_nor_norsca", "SUBCULTURE", "wh_dlc08_nor_shaman_sorcerer_fire", "Shaman-Sorcerer (Fire)"},
        {"wh_main_sc_nor_norsca", "SUBCULTURE", "wh_dlc08_nor_shaman_sorcerer_metal", "Shaman-Sorcerer (Metal)"},
        
        {"wh_main_sc_teb_teb", "SUBCULTURE", "teb_captain", "Captain"},
        {"wh_main_sc_teb_teb", "SUBCULTURE", "emp_warrior_priest", "Warrior Priest"},
        {"wh_main_sc_teb_teb", "SUBCULTURE", "emp_witch_hunter", "Witch Hunter"},
        {"wh_main_sc_teb_teb", "SUBCULTURE", "teb_bright_wizard", "Bright Wizard"},

        {"wh_main_sc_vmp_vampire_counts", "SUBCULTURE", "vmp_wight_king", "Wight King"},
        {"wh_main_sc_vmp_vampire_counts", "SUBCULTURE", "vmp_vampire", "Vampire (Death)"},
        {"wh_main_sc_vmp_vampire_counts", "SUBCULTURE", "wh_dlc05_vmp_vampire_shadow", "Vampire (Shadows)"},
        {"wh_main_sc_vmp_vampire_counts", "SUBCULTURE", "vmp_banshee", "Banshee"},
        {"wh_main_sc_vmp_vampire_counts", "SUBCULTURE", "vmp_necromancer", "Necromancer"},

        {"wh2_dlc09_sc_tmb_tomb_kings", "SUBCULTURE", "wh2_dlc09_tmb_tomb_prince", "Tomb Prince"},
        {"wh2_dlc09_sc_tmb_tomb_kings", "SUBCULTURE", "wh2_dlc09_tmb_necrotect", "Necrotect"},
        {"wh2_dlc09_sc_tmb_tomb_kings", "SUBCULTURE", "wh2_dlc09_tmb_liche_priest_death", "Liche Priest (Death)"},
        {"wh2_dlc09_sc_tmb_tomb_kings", "SUBCULTURE", "wh2_dlc09_tmb_liche_priest_light", "Liche Priest (Light)"},
        {"wh2_dlc09_sc_tmb_tomb_kings", "SUBCULTURE", "wh2_dlc09_tmb_liche_priest_nehekhara", "Liche Priest (Nehekhara)"},
        {"wh2_dlc09_sc_tmb_tomb_kings", "SUBCULTURE", "wh2_dlc09_tmb_liche_priest_shadow", "Liche Priest (Shadows)"},

        {"wh2_main_sc_def_dark_elves", "SUBCULTURE", "wh2_dlc14_def_master", "Master"},
        {"wh2_main_sc_def_dark_elves", "SUBCULTURE", "wh2_main_def_death_hag", "Death Hag"},
        {"wh2_main_sc_def_dark_elves", "SUBCULTURE", "wh2_main_def_khainite_assassin", "Khainite Assassin"},
        {"wh2_main_sc_def_dark_elves", "SUBCULTURE", "wh2_dlc10_def_sorceress_beasts", "Sorceress (Beasts)"},
        {"wh2_main_sc_def_dark_elves", "SUBCULTURE", "wh2_dlc10_def_sorceress_death", "Sorceress (Death)"},
        {"wh2_main_sc_def_dark_elves", "SUBCULTURE", "wh2_main_def_sorceress_dark", "Sorceress (Dark)"},
        {"wh2_main_sc_def_dark_elves", "SUBCULTURE", "wh2_main_def_sorceress_fire", "Sorceress (Fire)"},
        {"wh2_main_sc_def_dark_elves", "SUBCULTURE", "wh2_main_def_sorceress_shadow", "Sorceress (Shadows)"},

        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_main_hef_noble", "Noble"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_dlc10_hef_handmaiden", "Handmaiden"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_main_hef_loremaster_of_hoeth", "Loremaster of Hoeth"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_dlc10_hef_mage_heavens", "Mage (Heavens)"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_dlc10_hef_mage_shadows", "Mage (Shadows)"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_main_hef_mage_high", "Mage (High)"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_main_hef_mage_life", "Mage (Life)"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_main_hef_mage_light", "Mage (Light)"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_dlc15_hef_mage_beasts", "Mage (Beasts)"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_dlc15_hef_mage_death", "Mage (Death)"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_dlc15_hef_mage_fire", "Mage (Fire)"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_dlc15_hef_mage_metal", "Mage (Metal)"},

        {"wh2_main_sc_lzd_lizardmen", "SUBCULTURE", "wh2_main_lzd_saurus_scar_veteran", "Saurus Scar-Veteran"},
        {"wh2_main_sc_lzd_lizardmen", "SUBCULTURE", "wh2_main_lzd_skink_chief", "Skink Chief"},
        {"wh2_main_sc_lzd_lizardmen", "SUBCULTURE", "wh2_main_lzd_skink_priest_beasts", "Skink Priest (Beasts)"},
        {"wh2_main_sc_lzd_lizardmen", "SUBCULTURE", "wh2_main_lzd_skink_priest_heavens", "Skink Priest (Heavens)"},

        {"wh2_main_sc_skv_skaven", "SUBCULTURE", "wh2_main_skv_warlock_engineer", "Warlock Engineer"},
        {"wh2_main_sc_skv_skaven", "SUBCULTURE", "wh2_main_skv_assassin", "Assassin"},
        {"wh2_main_sc_skv_skaven", "SUBCULTURE", "wh2_dlc14_skv_eshin_sorcerer", "Eshin Sorcerer"},
        {"wh2_main_sc_skv_skaven", "SUBCULTURE", "wh2_main_skv_plague_priest", "Plague Priest"},

        --wh2_dlc11_cst_ghost_paladin
        {"wh2_dlc11_sc_cst_vampire_coast", "SUBCULTURE", "wh2_dlc11_cst_mourngul", "Mourngul Haunter"},
        {"wh2_dlc11_sc_cst_vampire_coast", "SUBCULTURE", "wh2_dlc11_cst_fleet_captain", "Vampire Fleet Captain (Vampires)"},
        {"wh2_dlc11_sc_cst_vampire_coast", "SUBCULTURE", "wh2_dlc11_cst_fleet_captain_death", "Vampire Fleet Captain (Death)"},
        {"wh2_dlc11_sc_cst_vampire_coast", "SUBCULTURE", "wh2_dlc11_cst_fleet_captain_deep", "Vampire Fleet Captain (Deeps)"},
        {"wh2_dlc11_sc_cst_vampire_coast", "SUBCULTURE", "wh2_dlc11_cst_gunnery_wight", "Gunnery Wight"},
    }
}