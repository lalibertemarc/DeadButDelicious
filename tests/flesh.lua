-- Corpse names in every client language: loads Data.lua + Core.lua on a stubbed API per locale, runs
-- /dbd test on a dead Humanoid of that name and checks which ns.FLESH entry the line came from.
-- lua tests/flesh.lua (Lua 5.1, from the addon folder)
local dir = arg[1] or "."
local function stub() local s; s = setmetatable({}, { __index = function() return function() return stub() end end, __call = function() return stub() end }); return s end
local cases = {
  { "frFR", "Néophyte du Crépuscule", "CULTIST" },
  { "frFR", "Flibustier des Mers du sud", "PIRATE" },
  { "frFR", "Bandit défias", "DEFIAS" },
  { "frFR", "Squelette guerrier", "SKELETON" },
  { "frFR", "Goule affamée", "GHOUL" },
  { "frFR", "Nain Sombrefer", "DWARF" },
  { "frFR", "Croisé écarlate", "SCARLET" },
  { "frFR", "Paysan de Comté-de-l'Or", nil },
  { "deDE", "Skelettkrieger", "SKELETON" },
  { "deDE", "Scharlachroter Mönch", "SCARLET" },
  { "deDE", "Defiasbandit", "DEFIAS" },
  { "deDE", "Murlocgezeitenjäger", "MURLOC" },
  { "esES", "Bandido Defias", "DEFIAS" },
  { "esES", "Esqueleto guerrero", "SKELETON" },
  { "esMX", "Pirata Velasangre", "PIRATE" },
  { "ruRU", "Скелет-воин", "SKELETON" },
  { "ruRU", "Огромный бандит", nil },
  { "ruRU", "Огр-маг", "OGRE" },
  { "enUS", "Twilight Geomancer", "CULTIST" },
  { "enUS", "Death's Head Acolyte", "QUILBOAR" },
  { "enUS", "Murk-Eye Scout", "MURLOC" },
  { "enUS", "Hogger's Minion", "HOGGER" },
  { "enUS", "Defias Pillager", "DEFIAS" },
  { "enUS", "Riverpaw Gnolls", "GNOLL" },
  { "enUS", "Farmer", nil },
}
local fails = 0
for _, c in ipairs(cases) do
  local locale, name, want = c[1], c[2], c[3]
  local printed = {}
  local env = setmetatable({}, { __index = function(_, k) local v = rawget(_G, k); if v ~= nil then return v end return stub() end })
  env.GetLocale = function() return locale end
  env.GetBuildInfo = function() return "", "", "", 16001 end
  env.issecretvalue = function() return false end
  env.UnitExists = function() return true end
  env.UnitIsDead = function() return true end
  env.UnitCreatureType = function() return "Humanoïde", 7 end
  env.UnitName = function() return name end
  env.UnitIsPlayer = function() return false end
  env.IsInInstance = function() return false end
  env.InCombatLockdown = function() return false end
  env.GetTime = function() return 100 end
  env.strtrim = function(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
  env.format = string.format
  env.CHAT_SAY_GET = "%s says: "
  env.SlashCmdList = {}
  env.ChatTypeInfo = {}
  env.DEFAULT_CHAT_FRAME = { AddMessage = function(_, t) printed[#printed + 1] = t end }
  env.DeadButDeliciousDB = { chat = "SAY" }
  env.DeadButDeliciousCharDB = { accent = "none" }
  env.math = setmetatable({ random = function(n) if n then return 1 end return 0.99 end }, { __index = math })
  local ns = {}
  for _, f in ipairs({ "Data.lua", "Core.lua" }) do
    local chunk = assert(loadfile(dir .. "/" .. f)); setfenv(chunk, env); chunk("DeadButDelicious", ns)
  end
  -- which FLESH entry / type the test line came from
  env.SlashCmdList.DEADBUTDELICIOUS("test")
  local said = printed[1] or ""
  local got
  for _, f in ipairs(ns.FLESH) do for _, l in ipairs(f.lines) do
    local filled = l:gsub("{name}", function() return name end)
    if said:find(filled, 1, true) then got = got or f.words[1] end end end
  local wantWord = want and ({ CULTIST="cultist", PIRATE="bloodsail", DEFIAS="defias", SKELETON="skeleton", GHOUL="ghoul", DWARF="dwarf", SCARLET="scarlet", MURLOC="murloc", OGRE="ogre", QUILBOAR="quilboar", HOGGER="hogger", GNOLL="gnoll" })[want]
  local ok = got == wantWord
  if not ok then fails = fails + 1 end
  print((ok and "ok   " or "FAIL ") .. locale .. "  " .. name .. "  -> " .. tostring(got) .. (ok and "" or ("  (want " .. tostring(wantWord) .. ")")))
end
print(fails == 0 and "all passed" or (fails .. " failed"))
if fails > 0 then os.exit(1) end
