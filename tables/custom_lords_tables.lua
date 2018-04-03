faction_lord_types = {
	SCHEMA = {"key", "faction_type", "lord_type", "lord_type_name"},
	KEY = {"key", "LIST"},
	DATA = {
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_main_hef_prince", "Prince"},
        {"wh2_main_sc_hef_high_elves", "SUBCULTURE", "wh2_main_hef_princess", "Princess"}
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
        {"wh2_main_trait_hef_prince_magic", "wh_main_skill_all_magic_all_11_arcane_conduit"}
    }
}

traits = {
	SCHEMA = {"key", "trait_cost"},
	KEY = {"key", "UNIQUE"},
	DATA = {
        {"wh2_main_trait_defeated_teclis", "-2"},
        {"wh2_main_trait_defeated_tyrion", "-2"},
        {"wh2_main_skill_innate_all_aggressive", "-1"},
        {"wh2_main_skill_innate_all_confident", "-1"},
        {"wh2_main_skill_innate_all_cunning", "-1"},
        {"wh2_main_skill_innate_all_determined", "-1"},
        {"wh2_main_skill_innate_all_disciplined", "-1"},
        {"wh2_main_skill_innate_all_fleet_footed", "-1"},
        {"wh2_main_skill_innate_all_intelligent", "-1"},
        {"wh2_main_skill_innate_all_knowledgeable", "-1"},
        {"wh2_main_skill_innate_all_perceptive", "-1"},
        {"wh2_main_skill_innate_all_strategist", "-1"},
        {"wh2_main_skill_innate_all_strong", "-1"},
        {"wh2_main_skill_innate_all_tactician", "-1"},
        {"wh2_main_skill_innate_all_tough", "-1"},
        {"wh2_main_skill_innate_all_weapon_master", "-1"},
        {"wh2_main_trait_increased_cost", "1"}
    }
}

trait_incidents = {
	SCHEMA = {"key", "incident_key"},
	KEY = {"key", "LIST"},
	DATA = {
        {"wh2_main_trait_increased_cost", "wh2_main_incident_treasury_down_one_k"}
    }
}