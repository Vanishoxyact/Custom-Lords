faction_lord_types = {
    SCHEMA = {"key", "faction_type", "lord_type", "lord_type_name"},
    KEY = {"key", "LIST"},
    DATA = {
        {"wh_main_teb_border_princes", "FACTION", "bor_ranger_lord", "Pathfinder"},
        {"wh_main_teb_lichtenburg_confederacy", "FACTION", "bor_ranger_lord", "Pathfinder"},
        {"wh_main_teb_estalia", "FACTION", "est_inquisitor", "Inquisitor Lord"},
        {"wh_main_teb_magritta", "FACTION", "est_inquisitor", "Inquisitor Lord"},
        {"wh_main_teb_tilea", "FACTION", "til_merchant", "Merchant Prince"},
        {"wh2_main_emp_new_world_colonies", "FACTION", "til_merchant", "Merchant Prince"},
        {"wh_main_teb_luccini", "FACTION", "til_merchant", "Merchant Prince"},
        {"wh_main_teb_bilbali", "FACTION", "til_merchant", "Merchant Prince"},
        {"wh_main_teb_tobaro", "FACTION", "til_merchant", "Merchant Prince"},
    }
}

lord_type_art = {
    SCHEMA = {"lord_type", "art_set_id", "culture", "portrait_name"},
    KEY = {"lord_type", "LIST"},
    DATA = {
        {"teb_lord", "teb_general_01", "no_culture", "teb_general_01"},
        {"teb_lord", "teb_general_02", "no_culture", "teb_general_02"},
        {"teb_lord", "teb_general_03", "no_culture", "teb_general_03"},
        {"teb_lord", "teb_general_04", "no_culture", "teb_general_04"},
        {"teb_lord", "teb_general_05", "no_culture", "teb_general_05"},
        {"bor_ranger_lord", "bor_ranger_lord_01", "no_culture", "bor_ranger_lord_01"},
        {"bor_ranger_lord", "bor_ranger_lord_02", "no_culture", "bor_ranger_lord_02"},
        {"bor_ranger_lord", "bor_ranger_lord_03", "no_culture", "bor_ranger_lord_03"},
        {"est_inquisitor", "est_inquisitor_01", "no_culture", "est_inquisitor_01"},
        {"est_inquisitor", "est_inquisitor_02", "no_culture", "est_inquisitor_02"},
        {"est_inquisitor", "est_inquisitor_03", "no_culture", "est_inquisitor_03"},
        {"til_merchant", "til_merchant_01", "no_culture", "til_merchant_01"},
        {"til_merchant", "til_merchant_02", "no_culture", "til_merchant_02"},
        {"til_merchant", "til_merchant_03", "no_culture", "til_merchant_03"}
    }
}