std = "lua51"
max_line_length = false
self = false

globals = {
    "DeadButDeliciousDB",
    "SLASH_DEADBUTDELICIOUS1",
    "SLASH_DEADBUTDELICIOUS2",
    "SLASH_DEADBUTDELICIOUS3",
    "SLASH_DEADBUTDELICIOUS4",
    "SlashCmdList",
    "BINDING_HEADER_DEADBUTDELICIOUS",
    "_G",
}

read_globals = {
    -- Lua / WoW utility
    "format", "strtrim",
    -- Frames & UI
    "CreateFrame", "UIParent", "TargetFrame", "GameTooltip", "DEFAULT_CHAT_FRAME", "ChatTypeInfo", "CHAT_SAY_GET",
    -- Namespaced APIs
    "C_Spell", "C_Timer", "C_ChatInfo", "issecretvalue",
    -- Global APIs
    "GetBuildInfo", "GetSpellInfo", "GetTime", "IsInInstance", "GetUnitSpeed", "CheckInteractDistance", "InCombatLockdown", "IsShiftKeyDown",
    "UnitExists", "UnitIsDead", "UnitIsPlayer", "UnitCreatureType", "UnitName", "UnitRace", "SendChatMessage",
}
