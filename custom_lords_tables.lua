FACTION_LORD_TYPES = {} --: map<string, vector<string>>
FACTION_LORD_TYPES["wh2_main_hef_eataine"] = {};
table.insert(FACTION_LORD_TYPES["wh2_main_hef_eataine"], "wh2_main_hef_prince");
table.insert(FACTION_LORD_TYPES["wh2_main_hef_eataine"], "wh2_main_hef_princess");

LORD_TYPE_NAMES = {} --: map<string, string>
LORD_TYPE_NAMES["wh2_main_hef_prince"] = "Prince";
LORD_TYPE_NAMES["wh2_main_hef_princess"] = "Princess";

LORD_SKILL_SETS = {} --: map<string, vector<string>>
LORD_SKILL_SETS["wh2_main_hef_prince"] = {};
table.insert(LORD_SKILL_SETS["wh2_main_hef_prince"], "wh2_main_trait_hef_prince_melee");
table.insert(LORD_SKILL_SETS["wh2_main_hef_prince"], "wh2_main_trait_hef_prince_magic");
LORD_SKILL_SETS["wh2_main_hef_princess"] = {};
table.insert(LORD_SKILL_SETS["wh2_main_hef_princess"], "wh2_main_trait_hef_princess_ranged");
table.insert(LORD_SKILL_SETS["wh2_main_hef_princess"], "wh2_main_trait_hef_princess_magic");

SKILL_SETS_NAMES = {} --: map<string, string>
SKILL_SETS_NAMES["wh2_main_trait_hef_prince_melee"] = "Melee";
SKILL_SETS_NAMES["wh2_main_trait_hef_prince_magic"] = "Magic";
SKILL_SETS_NAMES["wh2_main_trait_hef_princess_ranged"] = "Ranged";
SKILL_SETS_NAMES["wh2_main_trait_hef_princess_magic"] = "Magic";

SKILL_SET_SKILLS = {} --: map<string, vector<string>>
SKILL_SET_SKILLS["wh2_main_trait_hef_prince_melee"] = {};
table.insert(SKILL_SET_SKILLS["wh2_main_trait_hef_prince_melee"], "wh2_main_skill_hef_combat_graceful_strikes");
table.insert(SKILL_SET_SKILLS["wh2_main_trait_hef_prince_melee"], "module_wh2_main_skill_hef_combat_graceful_strikes");
table.insert(SKILL_SET_SKILLS["wh2_main_trait_hef_prince_melee"], "wh_main_skill_all_all_self_foe-seeker");
table.insert(SKILL_SET_SKILLS["wh2_main_trait_hef_prince_melee"], "module_wh_main_skill_all_all_self_foe-seeker");
table.insert(SKILL_SET_SKILLS["wh2_main_trait_hef_prince_melee"], "wh_main_skill_all_all_self_deadly_onslaught");
SKILL_SET_SKILLS["wh2_main_trait_hef_prince_magic"] = {};
table.insert(SKILL_SET_SKILLS["wh2_main_trait_hef_prince_magic"], "wh2_main_skill_all_magic_high_02_apotheosis");
table.insert(SKILL_SET_SKILLS["wh2_main_trait_hef_prince_magic"], "module_wh2_main_skill_all_magic_high_02_apotheosis");
table.insert(SKILL_SET_SKILLS["wh2_main_trait_hef_prince_magic"], "wh_main_skill_all_magic_all_06_evasion");
table.insert(SKILL_SET_SKILLS["wh2_main_trait_hef_prince_magic"], "module_wh_main_skill_all_magic_all_06_evasion");
table.insert(SKILL_SET_SKILLS["wh2_main_trait_hef_prince_magic"], "wh_main_skill_all_magic_all_11_arcane_conduit");

TRAITS = {} --: vector<string>
table.insert(TRAITS, "wh2_main_trait_defeated_teclis");
table.insert(TRAITS, "wh2_main_trait_defeated_tyrion");

table.insert(TRAITS, "wh2_main_skill_innate_all_aggressive");
table.insert(TRAITS, "wh2_main_skill_innate_all_confident");
table.insert(TRAITS, "wh2_main_skill_innate_all_cunning");
table.insert(TRAITS, "wh2_main_skill_innate_all_determined");
table.insert(TRAITS, "wh2_main_skill_innate_all_disciplined");
table.insert(TRAITS, "wh2_main_skill_innate_all_fleet_footed");
table.insert(TRAITS, "wh2_main_skill_innate_all_intelligent");
table.insert(TRAITS, "wh2_main_skill_innate_all_knowledgeable");
-- table.insert(TRAITS, "wh2_main_skill_innate_all_perceptive");
-- table.insert(TRAITS, "wh2_main_skill_innate_all_strategist");
-- table.insert(TRAITS, "wh2_main_skill_innate_all_strong");
-- table.insert(TRAITS, "wh2_main_skill_innate_all_tactician");
-- table.insert(TRAITS, "wh2_main_skill_innate_all_tough");
-- table.insert(TRAITS, "wh2_main_skill_innate_all_weapon_master");