-- Translated lines (Locales\*.lua): only the client's language stays in memory, every English group has
-- its translation, every line fits a chat message with {name} as its only placeholder, and Core says them
-- (plain, no accent) unless /dbd language english.
-- lua tests/lines.lua (Lua 5.1, from the addon folder)
local dir = arg[1] or "."
local LOCALES = { frFR = "Locales/frFR.lua" }
local NAME_ROOM = 40 -- bytes a long corpse name may take
local fails = 0
local function check(ok, what)
  if not ok then fails = fails + 1; print("FAIL " .. what) end
end

local function stub() local s; s = setmetatable({}, { __index = function() return function() return stub() end end, __call = function() return stub() end }); return s end

-- Runs the files in a fresh env; returns ns and the env.
local function load(locale, files, setup)
  local env = setmetatable({}, { __index = function(_, k) local v = rawget(_G, k); if v ~= nil then return v end return stub() end })
  env.GetLocale = function() return locale end
  env.GetBuildInfo = function() return "", "", "", 16001 end
  if setup then setup(env) end
  local ns = {}
  for _, f in ipairs(files) do
    local chunk = assert(loadfile(dir .. "/" .. f)); setfenv(chunk, env); chunk("DeadButDelicious", ns)
  end
  return ns, env
end

local function used()
  collectgarbage("collect"); collectgarbage("collect")
  return collectgarbage("count")
end

for locale, file in pairs(LOCALES) do
  -- 1. Memory: another client keeps nothing of the file.
  local ns = load("enUS", { "Data.lua" })
  local before = used()
  local chunk = assert(loadfile(dir .. "/" .. file))
  setfenv(chunk, setmetatable({ GetLocale = function() return "enUS" end }, { __index = _G }))
  chunk("DeadButDelicious", ns)
  chunk = nil -- luacheck: ignore
  local other = used() - before
  check(ns.TRANSLATION == nil, locale .. ": enUS client got a translation")
  check(other < 1, ("%s: enUS client keeps %.1f KB"):format(locale, other))

  before = used()
  local kept = load(locale, { file }) -- for its size only
  print(("%s: %.1f KB kept on its own client, %.2f KB on others"):format(locale, used() - before, other))
  check(kept.TRANSLATION ~= nil, locale .. ": nothing kept on its own client")

  -- 2. Coverage and 3. lines.
  local en = load(locale, { "Data.lua", file })
  local T = en.TRANSLATION
  check(T ~= nil, locale .. ": no ns.TRANSLATION on its own client")
  if T then
    check(type(T.code) == "string" and type(T.name) == "string" and type(T.native) == "string", locale .. ": code/name/native")
    local maxBite = 0
    for _, b in ipairs(T.bites or {}) do maxBite = math.max(maxBite, #b) end
    local groups = {
      { "bites", en.BITES, T.bites }, { "mystery", en.MYSTERY, T.mystery }, { "any", en.ANY, T.any },
      { "dungeon", en.DUNGEON, T.dungeon }, { "raid", en.RAID, T.raid },
    }
    for _, f in ipairs(en.FLESH) do groups[#groups + 1] = { "flesh." .. f.words[1], f.lines, T.flesh and T.flesh[f.words[1]] } end
    for k, l in pairs(en.RACES) do groups[#groups + 1] = { "races." .. k, l, T.races and T.races[k] } end
    for k, l in pairs(en.TYPES) do groups[#groups + 1] = { "types." .. k, l, T.types and T.types[k] } end
    for id, l in pairs(en.VENUES) do groups[#groups + 1] = { "venues." .. id, l, T.venues and T.venues[id] } end
    groups[#groups + 1] = { "sample", { "" }, { T.sample } }
    local count = 0
    for _, g in ipairs(groups) do
      local key, english, lines = g[1], g[2], g[3]
      check(type(lines) == "table" and #lines > 0, locale .. ": missing " .. key)
      if type(lines) == "table" then
        check(#lines * 2 >= #english, ("%s: %s has %d lines for %d English"):format(locale, key, #lines, #english))
        local seen = {}
        for i, line in ipairs(lines) do
          count = count + 1
          local where = ("%s: %s #%d"):format(locale, key, i)
          check(type(line) == "string" and line:match("%S"), where .. " empty")
          check(not seen[line], where .. " repeated")
          seen[line] = true
          local rest, names = line:gsub("{name}", "")
          check(not rest:find("[{}]"), where .. " has a placeholder other than {name}: " .. line)
          check(not rest:find("%%"), where .. " has a %: " .. line)
          if key == "bites" then
            check(names == 0, where .. " names the corpse")
          else
            local bytes = #rest + names * NAME_ROOM + maxBite + 3
            check(bytes <= 255, ("%s takes %d bytes in /e with a long name"):format(where, bytes))
          end
        end
      end
    end
    print(("%s: %d lines in %d groups"):format(locale, count, #groups))
  end
  -- 4. Core on that client.
  local function said(lang, accent, chat)
    local printed = {}
    local _, env = load(locale, { "Data.lua", file, "AccentRules.lua", "Accent.lua", "Core.lua" }, function(e)
      e.issecretvalue = function() return false end
      e.UnitExists = function() return true end
      e.UnitIsDead = function() return true end
      e.UnitCreatureType = function() return "Humanoïde", 7 end
      e.UnitName = function(unit) if unit == "player" then return "Grimbald" end return "Bandit défias" end
      e.UnitIsPlayer = function() return false end
      e.IsInInstance = function() return false end
      e.InCombatLockdown = function() return false end
      e.GetTime = function() return 100 end
      e.strtrim = function(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
      e.format = string.format
      e.CHAT_SAY_GET = "%s dit : "
      e.SlashCmdList = {}
      e.ChatTypeInfo = {}
      e.DEFAULT_CHAT_FRAME = { AddMessage = function(_, t) printed[#printed + 1] = t end }
      e.DeadButDeliciousDB = { chat = chat or "SAY", lang = lang }
      e.DeadButDeliciousCharDB = { accent = accent or "none" }
      e.math = setmetatable({ random = function(n) if n then return 1 end return 0.99 end }, { __index = math })
    end)
    env.SlashCmdList.DEADBUTDELICIOUS("test")
    return printed[1] or "", printed, env
  end
  local frDefias = T.flesh.defias[1]:gsub("{name}", "Bandit défias")
  local enDefias = en.FLESH[4].lines[1]:gsub("{name}", "Bandit défias")
  local line = said(nil, "none")
  check(line:find(frDefias, 1, true) ~= nil, locale .. ": /dbd test said " .. line)
  line = said(nil, "jawless")
  check(line:find(frDefias, 1, true) ~= nil, locale .. ": the accent touched a translated line: " .. line)
  line = said("en", "none")
  check(line:find(enDefias, 1, true) ~= nil, locale .. ": /dbd language english said " .. line)
  line = said(nil, "none", "EMOTE")
  check(line:find("Grimbald " .. T.bites[1] .. ' "' .. frDefias .. '"', 1, true) ~= nil, locale .. ": /e said " .. line)
  local _, printed, env = said(nil, "none")
  env.SlashCmdList.DEADBUTDELICIOUS("language english")
  check(env.DeadButDeliciousDB.lang == "en", locale .. ": /dbd language english")
  env.SlashCmdList.DEADBUTDELICIOUS("language " .. T.native)
  check(env.DeadButDeliciousDB.lang == nil, locale .. ": /dbd language " .. T.native)
  check(printed[#printed]:find("Sample", 1, true) ~= nil, locale .. ": no sample after /dbd language")
end

print(fails == 0 and "all passed" or (fails .. " failed"))
if fails > 0 then os.exit(1) end
