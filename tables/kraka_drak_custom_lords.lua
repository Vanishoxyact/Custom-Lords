faction_lord_types = {
    SCHEMA = {"key", "faction_type", "lord_type", "lord_type_name"},
    KEY = {"key", "LIST"},
    DATA = {
        {"wh_main_dwf_kraka_drak", "FACTION", "kraka_wardlord", "Wardlord"}
    }
}

lord_type_art = {
    SCHEMA = {"lord_type", "art_set_id", "culture", "portrait_name"},
    KEY = {"lord_type", "LIST"},
    DATA = {
        {"kraka_wardlord", "kraka_wardlord_01", "no_culture", "kraka_wardlord_01"},
        {"kraka_wardlord", "kraka_wardlord_02", "no_culture", "kraka_wardlord_02"},
        {"kraka_wardlord", "kraka_wardlord_03", "no_culture", "kraka_wardlord_03"}
    }
}