lord_types = {
    SCHEMA = {"key", "skill_set", "skill_set_name", "default_skill_set"},
    KEY = {"key", "LIST"},
    DATA = {
        {"wh2_main_lzd_slann_mage_priest", "wh2_main_trait_lzd_slann_mage_priest_magic", "Purification Magic", "TRUE"},
        {"wh2_main_lzd_slann_mage_priest", "wh2_main_trait_lzd_slann_mage_preist_destruction", "Destruction Magic", "FALSE"},
        {"wh2_main_lzd_slann_mage_priest", "wh2_main_trait_lzd_slann_mage_priest_debuffs", "Corruption Magic", "FALSE"},
    }
}

skill_set_skills = {
    SCHEMA = {"key", "skill_set_skill"},
    KEY = {"key", "LIST"},
    DATA = {
        {"wh2_main_trait_lzd_slann_mage_priest_magic", "wh2_main_skill_all_magic_light_02_phas_protection_lord"},
        {"wh2_main_trait_lzd_slann_mage_priest_magic", "module_wh2_main_skill_all_magic_light_02_phas_protection_lord"},
        {"wh2_main_trait_lzd_slann_mage_priest_magic", "wh_main_skill_all_magic_all_06_evasion"},
        {"wh2_main_trait_lzd_slann_mage_priest_magic", "module_wh_main_skill_all_magic_all_06_evasion"},
        {"wh2_main_trait_lzd_slann_mage_priest_magic", "wh_main_skill_all_magic_all_11_arcane_conduit"},

        {"wh2_main_trait_lzd_slann_mage_preist_destruction", "wh_main_skill_all_magic_death_01_spirit_leech"},
        {"wh2_main_trait_lzd_slann_mage_preist_destruction", "module_wh_main_skill_all_magic_death_01_spirit_leech"},
        {"wh2_main_trait_lzd_slann_mage_preist_destruction", "wh_main_skill_all_magic_all_06_evasion_slann_destruction"},
        {"wh2_main_trait_lzd_slann_mage_preist_destruction", "module_wh_main_skill_all_magic_all_06_evasion_slann_destruction"},
        {"wh2_main_trait_lzd_slann_mage_preist_destruction", "wh_main_skill_all_magic_all_11_arcane_conduit_slann_destruction"},

        {"wh2_main_trait_lzd_slann_mage_priest_debuffs", "wh2_main_skill_magic_shadow_mystifying_miasma_loremaster"},
        {"wh2_main_trait_lzd_slann_mage_priest_debuffs", "module_wh2_main_skill_magic_shadow_mystifying_miasma_loremaster"},
        {"wh2_main_trait_lzd_slann_mage_priest_debuffs", "wh_main_skill_all_magic_all_06_evasion_slann_debuff"},
        {"wh2_main_trait_lzd_slann_mage_priest_debuffs", "module_wh_main_skill_all_magic_all_06_evasion_slann_debuff"},
        {"wh2_main_trait_lzd_slann_mage_priest_debuffs", "wh_main_skill_all_magic_all_11_arcane_conduit_slann_debuff"},
    }
}