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

local function OnCooldown()
    local cd = spell.id and C_Spell and C_Spell.GetSpellCooldown and C_Spell.GetSpellCooldown(spell.id)
    -- Longer than a global cooldown and not over yet. Unknown (secret) counts as ready.
    return cd and Safe(function() return cd.duration > 1.5 and cd.startTime + cd.duration > GetTime() end) or false
end

---------------------------------------------------------------------------
-- Corpses
---------------------------------------------------------------------------
-- ns.FLESH entry -> whole-word patterns of its words; a trailing "s" matches too.
local patterns = {}
for _, f in ipairs(ns.FLESH) do
    patterns[f] = {}
    for _, word in ipairs(f.words) do
        local escaped = word:lower():gsub("%p", "%%%0")
        patterns[f][#patterns[f] + 1] = "%f[%w]" .. escaped .. "s?%f[%W]"
    end
end

-- The lines of the first ns.FLESH entry whose words are in the name.
local function Match(name)
    local lower = name:lower()
    for _, f in ipairs(ns.FLESH) do
        for _, p in ipairs(patterns[f]) do
            if lower:find(p) then return f.lines end
        end
    end
end

-- Forever's dungeons and raids hide names and creature types from addons, so a beast can't be
-- told from a meal there: the addon stays out of them. Classic Era hides nothing.
local function InDungeon()
    if ns.ERA then return false end
    local inInstance, kind = IsInInstance()
    return inInstance and (kind == "party" or kind == "raid")
end

-- The dead unit as a meal: { name, lines }, or nil when it isn't a corpse Cannibalize takes (or
-- the game won't say what it is).
local function Corpse(unit)
    if InDungeon() or not UnitExists(unit) then return nil end
    local dead = UnitIsDead(unit)
    if issecret(dead) or not dead then return nil end
    local ctype, name = UnitCreatureType(unit), UnitName(unit)
    if issecret(ctype) or issecret(name) or not (ctype and name and ns.EDIBLE[ctype]) then return nil end
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
    if c then last, lastAt = c, GetTime() end
    return c
end

local function RecentCorpse()
    if last and GetTime() - lastAt <= ns.MEMORY then return last end
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

-- The comment on corpse c (nil: unknown), and the chat type it goes in.
local function Comment(c)
    local lines = (c and c.lines) or ns.MYSTERY
    if math.random() < ns.ANY_CHANCE then lines = ns.ANY end
    -- Function replacement, so a "%" in a name can't break gsub.
    local text = Pick(lines):gsub("{name}", function() return c and c.name or "This" end)
    if DeadButDeliciousDB.chat == "EMOTE" then return format('%s "%s"', Pick(ns.BITES), text), "EMOTE" end
    return text, "SAY"
end

-- Prints the comment as if said, for your eyes only.
local function Echo(text, chatType)
    local me = UnitName("player")
    local line = chatType == "EMOTE" and (me .. " " .. text) or (format(CHAT_SAY_GET or "%s says: ", "[" .. me .. "]") .. text)
    local color = ChatTypeInfo and ChatTypeInfo[chatType]
    DEFAULT_CHAT_FRAME:AddMessage(line, color and color.r or 1, color and color.g or 1, color and color.b or 1)
end

local spokeAt = -math.huge -- GetTime() of the last comment said aloud

-- The cast will clearly fail (moving, on cooldown, corpse out of reach): nothing to comment on.
local function WillFail()
    local speed = GetUnitSpeed("player")
    if speed and not issecret(speed) and speed > 0 then return true end
    if OnCooldown() then return true end
    -- Duel range (~10 yd) is the closest check there is; Cannibalize needs 5.
    return Safe(function() return CheckInteractDistance("target", 3) == false end) or false
end

-- PreClick of the button: says the comment in the press itself, the only time the game lets
-- addons send chat. Keys click on press and release; the spell goes out on the release.
local function OnPreClick(_, button, down)
    if down or button ~= "LeftButton" or not spell.name then return end
    if DeadButDeliciousDB.private or ChatLocked() then return end -- the cast itself then comments to you
    local c = Corpse("target")
    if not c or WillFail() then return end
    Send(Comment(c))
    spokeAt = GetTime()
end

local hinted -- the "only you heard that" hint was shown this session

-- Cannibalize started without a comment said aloud (cast from your bar, private mode, chat
-- locked): comment to yourself.
local function OnChannelStart(spellID)
    if not IsCannibalize(spellID) or GetTime() - spokeAt < 3 or InDungeon() then return end
    local c = Corpse("target") or RecentCorpse()
    Echo(Comment(c))
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
    GameTooltip:AddLine("Cannibalize " .. c.name, 1, 0.82, 0)
    GameTooltip:AddLine("Click to eat, and comment " .. Where(), 1, 1, 1)
    GameTooltip:AddLine("Key binding: Options > Keybindings > Dead But Delicious", 0.6, 0.6, 0.6)
    GameTooltip:AddLine("Shift-drag to move", 0.6, 0.6, 0.6)
    GameTooltip:Show()
end)
btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

local function Update()
    local c = TargetCorpse()
    local show = c ~= nil and spell.name ~= nil
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
    "/dbd test - taste your target (or the last corpse), only you see it",
    "/dbd reset - reset the icon position",
}

local COMMANDS = {
    say = function() DeadButDeliciousDB.chat = "SAY"; Print("Comments go in /say.") end,
    emote = function() DeadButDeliciousDB.chat = "EMOTE"; Print("Comments go in /e.") end,
    private = function()
        DeadButDeliciousDB.private = not DeadButDeliciousDB.private
        Print(DeadButDeliciousDB.private and "Comments are for your ears only." or ("Comments go " .. Where() .. " again."))
    end,
    test = function()
        Echo(Comment(Corpse("target") or RecentCorpse()))
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
    local fn = COMMANDS[strtrim(msg):lower()]
    if fn then return fn() end
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
        -- Undead only: everyone else gets no icon, binding or comments.
        local _, race = UnitRace("player")
        if race ~= "Scourge" and race ~= "Undead" then
            SlashCmdList.DEADBUTDELICIOUS = function() Print("Only the Undead have the stomach for this.") end
            self:UnregisterAllEvents()
            return
        end
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
