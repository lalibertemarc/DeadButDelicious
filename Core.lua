-- Dead But Delicious: your Undead comments on the corpse they Cannibalize, like a food critic.
local _, ns = ...

-- The key binding (Bindings.xml) clicks the button, so it works with the UI hidden (e.g. EzCinematic).
BINDING_HEADER_DEADBUTDELICIOUS = "Dead But Delicious"
_G["BINDING_NAME_CLICK DeadButDeliciousButton:LeftButton"] = "Cannibalize, with a comment"

---------------------------------------------------------------------------
-- API compat (old classic globals vs. modern C_ namespaces)
---------------------------------------------------------------------------
-- spell: ID or name. Returns name, icon, spellID.
local function SpellInfo(spell)
    if C_Spell and C_Spell.GetSpellInfo then
        local info = C_Spell.GetSpellInfo(spell)
        if info then return info.name, info.iconID, info.spellID end
    elseif GetSpellInfo then
        local name, _, icon, _, _, _, id = GetSpellInfo(spell)
        return name, icon, id
    end
end

-- chatType: "SAY", or "EMOTE" for /e.
local function Send(msg, chatType)
    if C_ChatInfo and C_ChatInfo.SendChatMessage then
        C_ChatInfo.SendChatMessage(msg, chatType)
    else
        SendChatMessage(msg, chatType)
    end
end

-- Encounters and similar lock addon chat; sending then would be blocked.
local function ChatLocked()
    return C_ChatInfo and C_ChatInfo.InChatMessagingLockdown and C_ChatInfo.InChatMessagingLockdown()
end

-- Forever hides some unit and cooldown data from addons as "secret" values; comparing one throws.
local issecret = issecretvalue or function() return false end

-- fn's first result, or nil if it threw (e.g. on a secret value).
local function Safe(fn, ...)
    local ok, result = pcall(fn, ...)
    if ok then return result end
end

local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff8fbc5aDead But Delicious|r: " .. msg)
end

---------------------------------------------------------------------------
-- Cannibalize
---------------------------------------------------------------------------
local spell = {} -- name, icon, id once the game knows Cannibalize

local function RefreshSpell()
    local name, icon, id = SpellInfo(ns.CANNIBALIZE_ID)
    if not name then name, icon, id = SpellInfo(ns.CANNIBALIZE_NAME) end
    spell.name, spell.icon, spell.id = name, icon, id
end

local function IsCannibalize(spellID)
    if not spellID or issecret(spellID) then return false end
    return spellID == spell.id or (spell.name ~= nil and SpellInfo(spellID) == spell.name)
end

local function Cooldown()
    if not spell.id then return end
    if C_Spell and C_Spell.GetSpellCooldown then return C_Spell.GetSpellCooldown(spell.id) end
    if GetSpellCooldown then
        local startTime, duration = GetSpellCooldown(spell.id)
        return startTime and { startTime = startTime, duration = duration }
    end
end

-- Seconds before the global cooldown or a cast ends in which a press is queued and goes off when
-- it ends (SpellQueueWindow, default 400 ms).
local function QueueWindow()
    local ms = C_CVar and C_CVar.GetCVar and C_CVar.GetCVar("SpellQueueWindow")
    if not ms and GetCVar then ms = GetCVar("SpellQueueWindow") end
    return (tonumber(ms) or 400) / 1000
end

-- A cooldown longer than minDuration with more than slack seconds left; minDuration 0 counts
-- the global cooldown too. Unknown (secret) counts as ready.
local function CoolingDown(minDuration, slack)
    local cd = Cooldown()
    return cd and Safe(function() return cd.duration > minDuration and cd.startTime + cd.duration - GetTime() > (slack or 0) end) or false
end

local function OnCooldown() return CoolingDown(1.5) end

-- A click now casts nothing: casting something not about to end, or already eating. Other
-- channels (bandages, Drain Life) don't count: Cannibalize breaks them off.
local function Busy()
    return Safe(function()
        local _, _, _, _, endMS = UnitCastingInfo("player")
        if endMS and endMS / 1000 - GetTime() > QueueWindow() then return true end
        local channel, _, _, _, _, _, _, channelID = UnitChannelInfo("player")
        return channel ~= nil and IsCannibalize(channelID)
    end) or false
end

---------------------------------------------------------------------------
-- Corpses
---------------------------------------------------------------------------
-- Two-byte UTF-8 letters -> what Fold makes of them: Latin accents dropped (é -> e, ß -> ss,
-- œ -> oe), Cyrillic capitals lowercased (ё -> е). string.lower only knows ASCII.
local FOLD = {}
do
    -- U+00C0..U+00DE and U+00E0..U+00FE share their order: À Á Â Ã Ä Å Æ Ç È … Ý Þ.
    local LATIN = { "a", "a", "a", "a", "a", "a", "ae", "c", "e", "e", "e", "e", "i", "i", "i", "i",
        "d", "n", "o", "o", "o", "o", "o", " ", "o", "u", "u", "u", "u", "y", "th" }
    for i, to in ipairs(LATIN) do
        FOLD["\195" .. string.char(127 + i)] = to
        FOLD["\195" .. string.char(159 + i)] = to
    end
    FOLD["\195\159"], FOLD["\195\191"] = "ss", "y"
    FOLD["\197\146"], FOLD["\197\147"] = "oe", "oe"
    for b = 0x90, 0x9F do FOLD["\208" .. string.char(b)] = "\208" .. string.char(b + 0x20) end -- А..П
    for b = 0xA0, 0xAF do FOLD["\208" .. string.char(b)] = "\209" .. string.char(b - 0x20) end -- Р..Я
    FOLD["\208\129"], FOLD["\209\145"] = "\208\181", "\208\181" -- Ё ё -> е
end

-- text lowercased, accents off, ASCII punctuation and spaces as one space, padded with a
-- space each side: "Bandit défias" -> " bandit defias ". Other non-ASCII letters stay, so a
-- Cyrillic word is a word too.
function ns.Fold(text)
    text = text:gsub("[\192-\223][\128-\191]", FOLD):lower():gsub("[%c%p%s]+", " ")
    return " " .. strtrim(text) .. " "
end

-- ns.FLESH entry -> its words, folded, as { text, prefix }: English words match whole (or
-- with an "s"), words of the client's language (ns.FLESH_LOCALE) at the start of a word,
-- so "skelett" finds "Skelettkrieger", unless they end in "$".
local words = {}
do
    local extra = ns.FLESH_LOCALE[GetLocale and GetLocale() or "enUS"] or {}
    for _, f in ipairs(ns.FLESH) do
        local list = {}
        for _, word in ipairs(f.words) do list[#list + 1] = { ns.Fold(word), false } end
        for _, word in ipairs(extra[f.words[1]] or {}) do
            local whole = word:sub(-1) == "$"
            list[#list + 1] = { ns.Fold(whole and word:sub(1, -2) or word), not whole }
        end
        words[f] = list
    end
end

-- The lines of the first ns.FLESH entry whose words are in the name.
local function Match(name)
    local folded = ns.Fold(name)
    for _, f in ipairs(ns.FLESH) do
        for _, w in ipairs(words[f]) do
            local text, prefix = w[1], w[2]
            local stem = text:sub(1, -2) -- " defias"
            if folded:find(prefix and stem or text, 1, true) or (not prefix and folded:find(stem .. "s ", 1, true)) then
                return f.lines
            end
        end
    end
end

-- Forever's dungeons and raids hide names and creature types from addons, so a beast can't be
-- told from a meal there: "party" or "raid" there, nil elsewhere. Classic Era hides nothing.
local function Instance()
    if ns.ERA then return nil end
    local inInstance, kind = IsInInstance()
    if inInstance and (kind == "party" or kind == "raid") then return kind end
end

-- Lines for a meal in instance kind: they review the place, not the corpse.
local function VenueLines(kind)
    local id = select(8, GetInstanceInfo())
    local own = id and not issecret(id) and ns.VENUES[id]
    if own and math.random() < ns.VENUE_CHANCE then return own end
    return kind == "raid" and ns.RAID or ns.DUNGEON
end

-- In a dungeon or raid, any dead target is taken for a meal: { venue = kind }. If the game hides
-- whether it's dead, still a meal out of combat (unsure: no icon), never in a fight.
local function VenueMeal(unit, kind)
    if not UnitExists(unit) then return nil end
    local dead = UnitIsDead(unit)
    if issecret(dead) then
        if InCombatLockdown() then return nil end
        return { venue = kind, unsure = true }
    end
    return dead and { venue = kind } or nil
end

-- The dead unit as a meal: { name, lines }, or nil when it isn't a corpse Cannibalize takes (or
-- the game won't say what it is). In Forever's dungeons and raids: VenueMeal's.
local function Corpse(unit)
    local kind = Instance()
    if kind then return VenueMeal(unit, kind) end
    if not UnitExists(unit) then return nil end
    local dead = UnitIsDead(unit)
    if issecret(dead) or not dead then return nil end
    local ctype, typeID = UnitCreatureType(unit)
    local name = UnitName(unit)
    if issecret(ctype) or issecret(typeID) or issecret(name) then return nil end
    -- By ID, so any client language works; the name only if the ID is missing.
    ctype = ns.TYPE_IDS[typeID] or ctype
    if not (ctype and name and ns.EDIBLE[ctype]) then return nil end
    local lines
    if UnitIsPlayer(unit) then
        local _, race = UnitRace(unit)
        lines = race and not issecret(race) and ns.RACES[race]
    else
        lines = Match(name)
    end
    return { name = name, lines = lines or ns.TYPES[ctype] }
end

-- The last corpse you targeted, kept a while after you lose the target: casts from your bar
-- don't need one targeted.
local last, lastAt

local function TargetCorpse()
    local c = Corpse("target")
    if c and not c.venue then last, lastAt = c, GetTime() end
    return c
end

local function RecentCorpse()
    if last and GetTime() - lastAt <= ns.MEMORY then return last end
end

-- What you're eating as far as the addon knows: in a dungeon or raid the place, else your target
-- or the last corpse you targeted (nil: unknown).
local function Meal()
    local kind = Instance()
    if kind then return { venue = kind } end
    return Corpse("target") or RecentCorpse()
end

---------------------------------------------------------------------------
-- Comments
---------------------------------------------------------------------------
local lastPick = {} -- lines table -> index said last time

-- A random line from the table, not the one said last time.
local function Pick(lines)
    local i = math.random(#lines)
    if #lines > 1 and i == lastPick[lines] then i = i % #lines + 1 end
    lastPick[lines] = i
    return lines[i]
end

-- The game refuses chat messages past 255 bytes.
local MAX_MESSAGE = 255

-- line in your accent (DeadButDeliciousCharDB.accent, Accent.lua), {name} still unfilled so the corpse's name is
-- never respelled; max: bytes it may take with the name filled in. Plain if the accent would run past that.
local function Accented(line, name, max)
    local accent = DeadButDeliciousCharDB and DeadButDeliciousCharDB.accent
    if not ns.ACCENTS[accent] or accent == "none" then return line end
    local _, names = line:gsub("{name}", "")
    max = max - names * (#name - #"{name}")
    local text = ns.Speak(accent, line, max)
    return #text <= max and text or line
end

-- Line with {name} filled in, in your accent; room: bytes left for it in the message.
local function Say(line, name, room)
    -- Function replacement, so a "%" in a name can't break gsub. The name goes in after the accent.
    return (Accented(line, name, room):gsub("{name}", function() return name end))
end

-- The comment on corpse c (nil: unknown), and the chat type it goes in. In /e the bite is narration and stays
-- plain; only the "quoted" comment has an accent.
local function Comment(c)
    local lines = c and (c.venue and VenueLines(c.venue) or c.lines) or ns.MYSTERY
    if math.random() < ns.ANY_CHANCE then lines = ns.ANY end
    local name = c and c.name or "This"
    if DeadButDeliciousDB.chat == "EMOTE" then
        local bite = Pick(ns.BITES)
        return format('%s "%s"', bite, Say(Pick(lines), name, MAX_MESSAGE - #bite - 3)), "EMOTE"
    end
    return Say(Pick(lines), name, MAX_MESSAGE), "SAY"
end

-- Prints the comment as if said, for your eyes only.
local function Echo(text, chatType)
    -- Forever's 2nd return is the surname (Era's is a realm): full name as your real /say shows it.
    local me, surname = UnitName("player")
    if not ns.ERA and surname and surname ~= "" and not issecret(surname) then me = me .. " " .. surname end
    local line = chatType == "EMOTE" and (me .. " " .. text) or (format(CHAT_SAY_GET or "%s says: ", "[" .. me .. "]") .. text)
    local color = ChatTypeInfo and ChatTypeInfo[chatType]
    DEFAULT_CHAT_FRAME:AddMessage(line, color and color.r or 1, color and color.g or 1, color and color.b or 1)
end

local spokeAt = -math.huge -- GetTime() of the last comment said aloud

-- The cast will clearly fail (moving, on cooldown or the global cooldown, already casting,
-- corpse out of reach): nothing to comment on. A press in the spell queue window still casts.
local function WillFail()
    local speed = GetUnitSpeed("player")
    if not issecret(speed) and type(speed) == "number" and speed > 0 then return true end
    if CoolingDown(0, QueueWindow()) or Busy() then return true end
    -- Duel range (~10 yd) is the closest check there is; Cannibalize needs 5.
    return Safe(function() return CheckInteractDistance("target", 3) == false end) or false
end

-- PreClick of the button: says the comment in the press itself, the only time the game lets
-- addons send chat. Keys click on press and release; the spell goes out on the release.
local function OnPreClick(_, button, down)
    if down or button ~= "LeftButton" or not spell.name then return end
    if DeadButDeliciousDB.private or ChatLocked() then return end -- the cast itself then comments to you
    if GetTime() - spokeAt < ns.QUIET then return end
    local c = Corpse("target")
    if not c or WillFail() then return end
    Send(Comment(c))
    spokeAt = GetTime()
end

local hinted -- the "only you heard that" hint was shown this session

-- Cannibalize started without a comment said aloud (cast from your bar, private mode, chat
-- locked): comment to yourself.
local function OnChannelStart(spellID)
    if not IsCannibalize(spellID) or GetTime() - spokeAt < 3 then return end
    Echo(Comment(Meal()))
    if not DeadButDeliciousDB.private and not hinted then
        hinted = true
        Print("Only you heard that. Cannibalize with the Dead But Delicious key binding, its icon or /click DeadButDeliciousButton to say it aloud.")
    end
end

---------------------------------------------------------------------------
-- Button: casts Cannibalize. Shows next to the target frame while the target is a corpse you
-- can eat; the key binding clicks it either way.
---------------------------------------------------------------------------
local btn = CreateFrame("Button", "DeadButDeliciousButton", UIParent, "SecureActionButtonTemplate")
btn:SetSize(36, 36)
btn:SetFrameStrata("MEDIUM")
btn:SetMovable(true)
btn:SetClampedToScreen(true)
btn:RegisterForClicks("AnyUp", "AnyDown")
btn:RegisterForDrag("LeftButton")
-- Cast on release for keys too, like a mouse click: PreClick ignores the press.
btn:SetAttribute("useOnKeyDown", false)
btn:SetAttribute("type", "spell")
btn:SetScript("PreClick", OnPreClick)
btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
btn:SetAlpha(0)
btn:EnableMouse(false)

btn.border = btn:CreateTexture(nil, "BACKGROUND")
btn.border:SetPoint("TOPLEFT", -2, 2)
btn.border:SetPoint("BOTTOMRIGHT", 2, -2)
btn.border:SetColorTexture(0, 0, 0)

btn.icon = btn:CreateTexture(nil, "ARTWORK")
btn.icon:SetAllPoints()
btn.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

-- Cooldown swipe and countdown, like an action button (numbers need Options > Action Bars >
-- Show Numbers for Cooldowns on).
btn.cooldown = CreateFrame("Cooldown", nil, btn, "CooldownFrameTemplate")
btn.cooldown:SetAllPoints()
btn.cooldown:SetHideCountdownNumbers(false)

-- The duration object carries secret cooldowns too; the plain numbers are the fallback.
local function UpdateCooldown()
    if not spell.id then return btn.cooldown:Clear() end
    if C_Spell.GetSpellCooldownDuration and btn.cooldown.SetCooldownFromDurationObject then
        local duration = C_Spell.GetSpellCooldownDuration(spell.id, true) -- true: no global cooldown
        if duration then return btn.cooldown:SetCooldownFromDurationObject(duration) end
        return btn.cooldown:Clear()
    end
    local cd = C_Spell.GetSpellCooldown and C_Spell.GetSpellCooldown(spell.id)
    if not (cd and Safe(function() return cd.duration > 1.5 end)) then return btn.cooldown:Clear() end
    btn.cooldown:SetCooldown(cd.startTime, cd.duration, cd.modRate or 1)
end

-- Secure button: attributes and position can't change in combat, so those wait for it to end.
local function ApplySpell()
    if InCombatLockdown() or not spell.name then return end
    btn:SetAttribute("spell", spell.name)
    btn.icon:SetTexture(spell.icon)
end

local function ApplyPosition()
    if InCombatLockdown() then return end
    local p = DeadButDeliciousDB.pos
    btn:ClearAllPoints()
    if p then
        btn:SetPoint(p[1], UIParent, p[2], p[3], p[4])
    else
        btn:SetPoint("LEFT", TargetFrame, "RIGHT", -10, 10)
    end
end

btn:SetScript("OnDragStart", function(self)
    if not IsShiftKeyDown() or InCombatLockdown() then return end
    self:StartMoving()
    self.moving = true
end)
btn:SetScript("OnDragStop", function(self)
    if not self.moving then return end
    self.moving = false
    self:StopMovingOrSizing()
    local point, _, relPoint, x, y = self:GetPoint()
    DeadButDeliciousDB.pos = { point, relPoint, x, y }
end)

local function Where()
    if DeadButDeliciousDB.private then return "for your ears only" end
    return DeadButDeliciousDB.chat == "EMOTE" and "in /e" or "in /say"
end

btn:SetScript("OnEnter", function(self)
    local c = Corpse("target")
    if not c then return end
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine(c.name and ("Cannibalize " .. c.name) or "Cannibalize", 1, 0.82, 0)
    if c.venue then GameTooltip:AddLine("The game hides what it is here: you'll review the place", 0.6, 0.6, 0.6) end
    GameTooltip:AddLine("Click to eat, and comment " .. Where(), 1, 1, 1)
    GameTooltip:AddLine("Key binding: Options > Keybindings > Dead But Delicious", 0.6, 0.6, 0.6)
    GameTooltip:AddLine("Shift-drag to move", 0.6, 0.6, 0.6)
    GameTooltip:Show()
end)
btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

local function Update()
    local c = TargetCorpse()
    local show = c ~= nil and not c.unsure and spell.name ~= nil
    btn:SetAlpha(show and 1 or 0)
    if not InCombatLockdown() then btn:EnableMouse(show) end
    if show then btn.icon:SetDesaturated(OnCooldown()) end
    UpdateCooldown()
end

---------------------------------------------------------------------------
-- Slash commands
---------------------------------------------------------------------------
local HELP = {
    "/dbd say - comment in /say (default)",
    "/dbd emote - comment as an /e emote",
    "/dbd private - toggle: comments only you see",
    "/dbd accent [none|locked|jawless] - show or set your undead accent (locked jaw, jawless) for this character",
    "/dbd test - taste your target (or the last corpse), only you see it",
    "/dbd reset - reset the icon position",
}

-- Shows your accent, or sets it (arg: a key of ns.ACCENTS or its name, "locked jaw"), with a sample said only to you.
local function SetAccent(arg)
    if arg ~= "" then
        local key = ns.ACCENTS[arg] and arg
        for k, label in pairs(ns.ACCENTS) do
            if label == arg then key = k end
        end
        if not key then return Print("Accents: " .. table.concat(ns.ACCENT_ORDER, ", ") .. ".") end
        DeadButDeliciousCharDB.accent = key
    end
    local accent = DeadButDeliciousCharDB.accent
    Print("Accent: " .. ns.ACCENTS[accent] .. (arg == "" and " (/dbd accent " .. table.concat(ns.ACCENT_ORDER, "|") .. ")" or "."))
    if accent ~= "none" then
        Print("Sample: " .. Say(ns.ACCENT_SAMPLE, "Murloc Forager", MAX_MESSAGE))
    end
end

-- EzAccent's accent changed (EzAccentAPI): undead is the locked jaw, or jawless when thick; any other accent is none.
local function FromEzAccent(accent, thick)
    local key = accent == "undead" and (thick and "jawless" or "locked") or "none"
    if DeadButDeliciousCharDB.accent == key then return end
    DeadButDeliciousCharDB.accent = key
    return "DeadButDelicious to " .. ns.ACCENTS[key]
end

local COMMANDS = {
    say =function() DeadButDeliciousDB.chat = "SAY"; Print("Comments go in /say.") end,
    emote = function() DeadButDeliciousDB.chat = "EMOTE"; Print("Comments go in /e.") end,
    private = function()
        DeadButDeliciousDB.private = not DeadButDeliciousDB.private
        Print(DeadButDeliciousDB.private and "Comments are for your ears only." or ("Comments go " .. Where() .. " again."))
    end,
    accent = SetAccent,
    test = function()
        Echo(Comment(Meal()))
    end,
    reset = function()
        if InCombatLockdown() then return Print("Can't move the icon in combat.") end
        DeadButDeliciousDB.pos = nil
        ApplyPosition()
        Print("Position reset.")
    end,
}

SLASH_DEADBUTDELICIOUS1 = "/dbd"
SLASH_DEADBUTDELICIOUS2 = "/deadbutdelicious"
SLASH_DEADBUTDELICIOUS3 = "/cannibal" -- the 1.0.0 commands still work
SLASH_DEADBUTDELICIOUS4 = "/foodcritic"
SlashCmdList.DEADBUTDELICIOUS = function(msg)
    local cmd, arg = strtrim(msg):lower():match("^(%S*)%s*(.-)$")
    local fn = COMMANDS[cmd]
    if fn then return fn(arg) end
    Print("Comments go " .. Where() .. ".")
    for _, line in ipairs(HELP) do Print(line) end
end

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:SetScript("OnEvent", function(self, event, _, _, spellID)
    if event == "PLAYER_LOGIN" then
        DeadButDeliciousDB = DeadButDeliciousDB or {}
        DeadButDeliciousDB.chat = DeadButDeliciousDB.chat or "SAY"
        DeadButDeliciousCharDB = DeadButDeliciousCharDB or {}
        if not ns.ACCENTS[DeadButDeliciousCharDB.accent] then DeadButDeliciousCharDB.accent = "none" end
        -- Undead only: everyone else gets no icon, binding or comments.
        local _, race = UnitRace("player")
        if race ~= "Scourge" and race ~= "Undead" then
            SlashCmdList.DEADBUTDELICIOUS = function() Print("Only the Undead have the stomach for this.") end
            self:UnregisterAllEvents()
            return
        end
        if EzAccentAPI then EzAccentAPI.OnAccentChanged(FromEzAccent) end
        ApplyPosition()
        for _, e in ipairs({ "PLAYER_TARGET_CHANGED", "SPELLS_CHANGED", "PLAYER_REGEN_ENABLED", "SPELL_UPDATE_COOLDOWN" }) do
            self:RegisterEvent(e)
        end
        self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
        -- The target dying, moving away or the cooldown ending fire nothing handy.
        C_Timer.NewTicker(0.5, Update)
    end
    if event == "UNIT_SPELLCAST_CHANNEL_START" then return OnChannelStart(spellID) end
    if event == "PLAYER_LOGIN" or event == "SPELLS_CHANGED" then RefreshSpell() end
    if event ~= "PLAYER_TARGET_CHANGED" and event ~= "SPELL_UPDATE_COOLDOWN" then
        ApplySpell()
        if event == "PLAYER_REGEN_ENABLED" then ApplyPosition() end
    end
    Update()
    if event == "PLAYER_LOGIN" and not spell.name then
        Print("Cannibalize not found. Its spell ID may have changed: see ns.CANNIBALIZE_ID in Data.lua.")
    end
end)
