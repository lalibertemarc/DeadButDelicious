-- Dead But Delicious data: edit what your character says about each corpse here.
local _, ns = ...

-- Classic Era client (Forever is 1.60+).
ns.ERA = select(4, GetBuildInfo()) < 16000

-- The Undead racial. Found by ID first, then by name (only works once you know it).
ns.CANNIBALIZE_ID = 20577
ns.CANNIBALIZE_NAME = "Cannibalize"

-- Corpse types Cannibalize accepts, by their English name (the keys of ns.TYPES).
ns.EDIBLE = { Humanoid = true, Undead = true }

-- UnitCreatureType's name is in the client's language ("Humanoïde"); its 2nd return, the
-- CreatureType ID, isn't. ID -> English name.
ns.TYPE_IDS = { [6] = "Undead", [7] = "Humanoid" }

-- Seconds a corpse you targeted is remembered after you lose the target (for casts from your bar).
ns.MEMORY = 60

-- Seconds after a comment before the next click can say another (spam clicks): one global cooldown.
ns.QUIET = 1.5

-- How often a line from ns.ANY replaces the corpse's own lines.
ns.ANY_CHANCE = 0.2

-- Undead accents your comments can be spoken in (/dbd accent, per character), respelled live by Accent.lua:
-- key -> name shown. In /e mode only the "quoted" comment is accented, not the bite; the corpse's name never is.
ns.ACCENTS = { none = "no accent", locked = "locked jaw", jawless = "jawless" }
ns.ACCENT_ORDER = { "none", "locked", "jawless" }
ns.ACCENT_SAMPLE = "{name}. Tender, with a hint of surprise. Probably theirs."

-- In /e mode the line is quoted after one of these: 'Grimbald chews thoughtfully. "Murloc. Salty."'
ns.BITES = {
    "chews thoughtfully.",
    "smacks rotting lips.",
    "picks something out of a gap in the teeth.",
    "takes another bite and considers it.",
    "licks bony fingers clean.",
    "savors the bite like a fine wine.",
    "wipes a bit of gristle from the jaw.",
    "swallows with a wet crunch.",
    "sniffs the morsel like a sommelier.",
    "tucks an imaginary napkin into a torn collar.",
    "chews slowly, eyes half closed.",
    "pauses mid-bite to jot a note.",
    "rolls the bite around a rotted tongue.",
    "gnaws on a knuckle, deep in thought.",
}

-- Lines are picked at random, never the same twice in a row. {name} = the corpse's name.

local MURLOC = {
    "Murloc. Salty, with a fishy finish. Mrglrgl to you too.",
    "Ah, murloc. Like sushi that screams.",
    "Murloc again. Low in fat, high in sodium. And fins. So many fins.",
    "Hint of seaweed, notes of low tide. Murloc is an acquired taste.",
    "Murloc. Chewy. I swear it gurgled on the way down.",
    "This {name} is a fish stick with opinions.",
    "Murloc ceviche. Marinated in its own fear.",
    "Murloc. The catch of the day, and it caught me first.",
    "Slimy outside, slimier inside. Consistent, I'll give it that.",
    "Murloc. Where there's one, there's dessert. And seconds. And thirds.",
    "Pairs well with a crisp white. Or a crisp anything, really.",
    "The eyes are the best part. They stare back.",
}

local KOBOLD = {
    "Kobold. Tastes like candle wax and bad decisions.",
    "You no take candle. I take everything else.",
    "Kobold. Mostly dirt by weight. Crunchy dirt.",
    "Hints of tunnel, a whiff of wax, and a long finish of regret.",
    "Kobold jerky, smoked by its own candle. Efficient.",
    "Small portion. Kobolds are the appetizers of the underworld.",
    "Kobold. Rat-adjacent. I've had worse in the Undercity.",
    "Coal dust seasoning. The miners' special.",
    "Kobold. Chewy little thing. I'll keep the candle for later.",
    "{name}. Smells like a mine shaft. Tastes like one too.",
    "Candle-roasted kobold. Self-basting.",
}

local GNOLL = {
    "Gnoll. Gamey. Needs a marinade.",
    "Gnoll. Mostly fur and fleas. The fleas are the protein.",
    "Tastes like wet dog. An angry wet dog.",
    "Gnoll haunch. Tough, stringy, and it still owes Redridge money.",
    "This one lived on Elwynn pork. You can taste it. Not bad.",
    "{name}. All bark, decent bite.",
    "Gnoll. Hyena with ambition. The ambition is chewy.",
    "Notes of mange and campfire. Rustic cuisine.",
    "Gnoll. The paws are like pig's feet, with more claws.",
    "It laughed when it died. Now I'm the one laughing. With my mouth full.",
    "Gnoll. Mostly sinew. My jaw is getting a workout.",
}

local TROLL = {
    "Troll. It keeps regenerating while I chew. A meal that refills itself.",
    "Spicy. Trolls are marinated in voodoo from birth.",
    "Troll. Long, lean, and somehow still smug about it.",
    "The tusks are not edible. Learned that the hard way. The rest is lovely.",
    "Troll. Hints of jungle and mojo. Pairs well with a hex.",
    "Troll. I'll eat slowly. It might grow back a second helping.",
    "So much leg. Trolls are mostly leg.",
    "Troll. A bit blue, a bit green. Aged in the jungle humidity.",
    "Notes of banana and blood magic. Exotic.",
    "{name}. Stay away from the voodoo bits. Ate one once. Saw colors.",
    "Troll ribs. Long enough to use as chopsticks.",
}

local OGRE = {
    "Ogre. Portion size: yes.",
    "One ogre feeds a whole graveyard. Leftovers for weeks.",
    "Two heads? Two courses.",
    "Thick skin, thicker skull. Surprisingly tender in the middle.",
    "Ogre. Like eating a sofa that once ate people.",
    "Ogre. Me eat. Me happy.",
    "It's a whole roast. I'll need a doggy bag. And a dog.",
    "Ogre. Fatty, which is to say flavorful.",
    "This one smells like the last three things it ate. Bonus courses.",
    "{name}. Big, dumb, and delicious. My kind of meal.",
    "Ogre. I'll be here a while. Go on without me.",
}

local HARPY = {
    "Harpy. Tastes like chicken. Angry, screaming chicken.",
    "Harpy wings. Spicy. I need a napkin for the feathers.",
    "Dark meat or white meat? Harpy is both, and both are loud.",
    "Harpy. All drumstick, no manners.",
    "Harpy. Plucking it is half the meal.",
    "Feathers in my teeth. Of the teeth I have left.",
    "Harpy. Still screeching in my stomach. Mild indigestion.",
    "The talons make a decent toothpick.",
    "Harpy. Free-range, I'll give it that.",
    "{name}. Tough old bird.",
}

local CENTAUR = {
    "Centaur. Surf and turf, except it's man and horse.",
    "Top half beef, bottom half also beef. Centaur is a buffet.",
    "Centaur. Not sure which end to start with. Both, then.",
    "Gamey, and it smells of the Barrens. Authentic.",
    "Centaur. Horse meat is a delicacy in some places. This is not one of them.",
    "The rump is the best cut. There is a lot of rump.",
    "Centaur. Raised on Barrens grass and grudges.",
    "So much meat, so few hands to eat it with.",
    "{name}. Galloped its last. Now it trots through my gut.",
    "Centaur steak. Mind the horseshoes.",
}

local QUILBOAR = {
    "Quilboar. Basically pork. Very prickly pork.",
    "Bacon, but you have to pick the thorns out first.",
    "Tastes like ham and brambles. Razorfen home cooking.",
    "Quilboar chops. I'd kill for an apple to stuff in its mouth.",
    "Quilboar. Snout to tail, nothing wasted.",
    "Pulled quilboar. Slow-cooked in its own mud.",
    "Quilboar. Free-range, thorn-fed. Very trendy.",
    "Ow. Quill in the gums. Worth it.",
    "{name}. Smoky and earthy, like a pig that read too much shamanism.",
    "Quilboar ribs. I'll be licking my bones after this. And its bones.",
}

local NAGA = {
    "Naga. Surf and surf.",
    "Naga tail. Like eel, if eels held grudges for ten thousand years.",
    "Scaly outside, briny inside. Azshara's finest.",
    "Naga. Rich, salty, and far too proud of itself.",
    "Naga. A lot of tail to get through. I'll start at the end.",
    "Tastes of deep water and old Highborne snobbery.",
    "Naga. Six arms of finger food.",
    "Snake and fish. Two of my favorite things to chew on.",
    "{name}. Ten thousand years under the sea, and it's still not tender.",
    "Naga. Pairs well with seaweed and resentment.",
}

local FURBOLG = {
    "Furbolg. Hairy. So, so hairy.",
    "Like bear, with more spiritual guilt.",
    "Furbolg. Sweet. They must eat a lot of honey.",
    "The fur gets stuck in my teeth. Of which I have few.",
    "Furbolg. Corrupted by demons. Adds a nice spice.",
    "Bear steak with a side of bad mood.",
    "Furbolg. The paws are the delicacy. All four of them.",
    "Tastes like a forest. A very angry forest.",
    "{name}. Hearty. The kind of meal that sticks to the ribs I have left.",
    "Furbolg. I'll be coughing up hairballs for a week.",
}

local TROGG = {
    "Trogg. Tastes like gravel. There is actual gravel in it.",
    "Trogg. Crunchy on the outside, crunchy on the inside.",
    "Troggs are mostly rock. Good for the bones. Mine are showing.",
    "Mineral-rich. My jaw will feel this tomorrow.",
    "Trogg. Lead poisoning, but tasty.",
    "Trogg. The stone age of cuisine.",
    "Earthy. In the sense that it's mostly earth.",
    "{name}. I think I chipped a tooth. I'll find another.",
    "Trogg. Basically a rock that learned to walk. And bleed.",
    "Cave-aged trogg. Very hard. Very, very hard.",
}

local GOBLIN = {
    "Goblin. Bitter, greasy, and it tried to charge me for the bite.",
    "Goblin. Notes of motor oil and fine print.",
    "Tastes like gold coins and gunpowder. An expensive meal.",
    "Goblin. Small and salty, and somehow I'm still paying for it.",
    "Goblin. Time is money, and this is going to take a while.",
    "Ears are crispy. The rest is pure grease.",
    "Goblin. Comes with a receipt.",
    "Hints of azerite and rocket fuel. Do not chew near a campfire.",
    "{name}. Cheap meat. Still overpriced.",
    "Goblin. I'm sure someone will send me a bill for this.",
}

local GNOME = {
    "Gnome. Bite-size. Hint of motor oil.",
    "Gnome. Fun-size. Comes with a free cog.",
    "Lightly irradiated. It glows a little. Very gnomish.",
    "Gnome. Delicate, like veal, if veal could build a death ray.",
    "Gnome. One mouthful. Two if I'm polite.",
    "Gnome. I found a spring in it. Not a metaphor.",
    "Tastes like Gnomeregan. Leaded and slightly toxic.",
    "Gnome. Crunchy hair. Is that a mohawk?",
    "{name}. Small, but I appreciate the craftsmanship.",
    "Gnome. Hors d'oeuvre portion. Bring me three more.",
}

local DWARF = {
    "Dwarf. Marinated in ale since birth. Lovely.",
    "Dwarf. Mostly beard. I'll floss later.",
    "Dense and hearty. Dwarves are stew in boots.",
    "Tastes like stout and stubbornness.",
    "{name}. A bit metallic. Lots of iron, as advertised.",
    "Dwarf. Short, stocky, and very filling.",
    "Notes of malt, smoke, and the forge. A fine Ironforge vintage.",
    "Dwarf. Hard to chew. Like gnawing on an anvil with a beard.",
    "So much beard. I've eaten a sheep with less wool.",
    "Dwarf. Tastes like it would pick a fight with me about the recipe.",
    "Dwarf. Pickled from the inside. No brine needed.",
}

local ORC = {
    "Orc. Tough as boot leather, and about as seasoned.",
    "Orc. Strong flavor. Like a warg that took up axes.",
    "All muscle. Good protein. My leg could use some.",
    "Hints of fel. An old vintage, from before they got clean.",
    "Orc. Lok'tar ogar. Lok'tar nom.",
    "Green meat. Usually a bad sign. Here, a delicacy.",
    "Orc. The tusks make good toothpicks.",
    "Tastes like Durotar. Dusty, hot, and angry.",
    "{name}. All honor, no fat. Very lean.",
    "Orc. Chewy, with a long, warlike finish.",
}

local TAUREN = {
    "Tauren. Finally, real beef.",
    "Tauren steak, medium rare. The Earth Mother would not approve.",
    "A whole herd in one corpse.",
    "Tastes like plains grass and quiet wisdom. Mostly grass.",
    "Tauren. Prime rib. Every rib is prime.",
    "Grass-fed, free-range, ethically slain. Five stars.",
    "Tauren. I'd moo with joy if I still had lungs.",
    "{name}. Needs some Mulgore mustard.",
    "Tauren brisket. Slow-cooked by the sun of the Barrens.",
    "So much meat. I'll be chewing until the Cataclysm.",
}

local NIGHTELF = {
    "Night elf. Ten thousand years old and still tender.",
    "Night elf. Tastes like moonlight and smugness.",
    "Lean. They never eat anything but leaves.",
    "Purple meat. Faintly minty. All that Teldrassil air.",
    "Night elf. Vegetarian-fed. Healthy, if boring.",
    "Elf ears. Crunchy. Like a chip that judges you.",
    "Night elf. Notes of moonwell and wildflowers. Very perfumed.",
    "{name}. Tall, lean, and very, very old. Like a vintage wine.",
    "Night elf. Elune bless this meal.",
    "Tastes like Darnassus. Pretty, and a bit too pleased with itself.",
}

local HUMAN = {
    "Human. A classic. Like mother used to... be.",
    "Human. A bit bland. The bread of the races.",
    "Human. I was one once. I don't remember being this salty.",
    "Ah, Stormwind's finest. Needs salt. And a better king.",
    "Human. The comfort food of the Forsaken.",
    "Notes of bread, ale, and tax collection. Very Stormwind.",
    "Human. Tastes like nostalgia, and a little like cousin Edmund.",
    "Humans. Everywhere, so cheap, so good.",
    "{name}. Light and versatile. Goes with anything.",
    "Human. Corn-fed, Westfall-raised. You can taste the farm.",
    "Human. I'd forgotten how warm they are inside.",
}

local FORSAKEN = {
    "Forsaken. Cannibalism? We call it family dinner.",
    "One of my own. A bit dry. Like eating a mirror.",
    "Pre-aged, perfectly rotted. My compliments to the Lich King.",
    "Tastes like Tirisfal. Damp, gloomy, and a little like home.",
    "Forsaken. Dry-aged for years. A gourmet's dream.",
    "Nothing to chew but bone and grudges.",
    "Sorry, cousin. The Banshee Queen would understand.",
    "{name}. A familiar taste. Too familiar.",
    "Forsaken. Embalmed meat. A little perfumey.",
    "Forsaken. We all end up as dinner eventually.",
}

local DEFIAS = {
    "Defias. Notes of bandana and Deadmines dust.",
    "Tastes like red cloth and resentment. Pay your stonemasons, Stormwind.",
    "Bandit, with a crunchy coating of stolen gold dust.",
    "{name}. Smells of the Westfall fields. Organic, at least.",
    "Defias. A brotherhood of flavors. All of them sour.",
    "Defias. Mask off, bib on.",
    "Notes of gunpowder and seafaring. Deadmines vintage.",
    "Defias. Stole my heart. Now I steal its liver.",
    "Westfall bandit. Lean. They don't eat well on the run.",
}

local SCARLET = {
    "Scarlet Crusade. Over-seasoned with zeal. Very bitter aftertaste.",
    "They died trying to purge me. Now I purge them. Into my belly.",
    "Holy fervor makes the meat tough. I'll still finish my plate.",
    "Crusader. Incense and fanaticism. Hold the fanaticism.",
    "Scarlet. Red on the outside, red on the inside.",
    "Tastes holy. Burns a little going down.",
    "Crusader. The Light didn't save this one. Thank the Light.",
    "{name}. Very righteous. Righteously delicious.",
    "Scarlet Crusade. Purged, plated, and served.",
    "Notes of holy water and paranoia. A Monastery vintage.",
}

local PIRATE = {
    "Pirate. Salty and pickled in rum. Yo ho, crunch.",
    "Pirate. The scurvy gives it a nice bitterness.",
    "Rum-soaked. Better than any grog in Booty Bay.",
    "Pirate. Peg leg's not edible. Learned that just now.",
    "Pirate. Salt-cured by years at sea.",
    "Arr. Tastes like a sailor. Because it was one.",
    "{name}. Smells of brine and broken promises.",
    "Pirate. All the vitamin C was gone long ago. All the flavor wasn't.",
    "Pirate. Dead men tell no tales. They do taste pretty good.",
}

local SYNDICATE = {
    "Syndicate. Lean and shifty. Even dead, it's trying to pick my pocket.",
    "Tastes like Alterac. Cold, bitter, and full of lost causes.",
    "Syndicate. Notes of stolen goods and old nobility.",
    "A noble flavor that went bad. Like the Perenolde family.",
    "Syndicate. Black cloth, dark heart, tender thigh.",
    "{name}. Shady. I'll check my purse after this.",
    "Syndicate. Hillsbrad farm-to-table, if the farm was robbed.",
    "Treachery tastes a lot like chicken.",
}

local CULTIST = {
    "Cultist. They wanted to join the Scourge. Now they're part of me. Close enough.",
    "Cultist. Tastes like candles and poor life choices.",
    "{name}. Devoted to death. Death is very grateful.",
    "Cultist. Dark rituals make for a smoky flavor.",
    "Cult of the Damned. More like Cult of the Dinner.",
    "Cultist. Pre-salted with grave dirt. How considerate.",
    "They prayed for undeath. I'm the closest they'll get.",
    "Cultist. A bit mad, a bit bitter. Like most of us.",
    "Notes of incense and shadow magic. Very gothic cuisine.",
}

local GHOST = {
    "Ghost meat. Zero calories. Diet food.",
    "Ghost. All texture, no substance. Like Dalaran cuisine.",
    "Ectoplasm again. I'm still hungry, and now my mouth is cold.",
    "Banshee? Spectre? Either way, it went straight through me.",
    "Spectral flesh. Light, airy, and screaming.",
    "Ghost. Like eating fog. Spooky fog.",
    "I'll need something more substantial after this. Something with a body.",
    "Ghost. Ethereal, and gone before I finished chewing.",
    "{name}. Very light. A soufflé of the damned.",
    "Spirit. Cold, wispy, and tastes faintly of sorrow.",
    "Ghost. The meal that haunts you after.",
}

local SKELETON = {
    "All bone, no meat. Who serves this?",
    "Skeleton. I'm chewing on the marrow of disappointment.",
    "Bones. Calcium is good for me. I have plenty showing.",
    "This one is soup stock waiting to happen.",
    "Skeleton. Rattling in my stomach now.",
    "Bones. I came for a feast, I got a xylophone.",
    "Skeleton. Crunchy. Very crunchy. Only crunchy.",
    "{name}. No skin, no meat, no soul. No tip.",
    "Bones again. Is there a butcher in this town?",
    "Skeleton. The chef forgot everything except the plate.",
}

local GHOUL = {
    "Ghoul. Well aged. Very well aged.",
    "Zombie. Pre-chewed. How thoughtful.",
    "Rotten, yes. But rotten like a fine cheese.",
    "Abomination. Several meals stitched into one. A buffet.",
    "Mummy. Pre-wrapped, but so dry.",
    "Ghoul. Pungent. The kind of smell that wins awards.",
    "Zombie. The flies got here first, but I don't mind sharing.",
    "Ghoul. Soft as butter. Rotten butter.",
    "Abomination. The stitches are a bit chewy.",
    "{name}. Aged to perfection, then aged some more.",
    "Ghoul. Fermented flesh. The kimchi of the Scourge.",
}

-- Corpse names are matched against these whole words (a trailing "s" also matches), first
-- entry first, so put factions and specific names before races.
ns.FLESH = {
    { words = { "hogger" }, lines = {
        "Hogger. Elwynn's most wanted, now Elwynn's most eaten.",
        "Hogger. Overrated, like every famous chef.",
        "Hogger. Big name, gamey flavor.",
        "Hogger. Stormwind put a bounty on him. I put salt on him.",
        "Hogger. Every Elwynn adventurer's first boss, and my first course.",
    } },
    { words = { "vancleef" }, lines = {
        "VanCleef. Tastes of revenge and unpaid wages.",
        "VanCleef. A master craftsman. Tender, well built.",
        "VanCleef. The Brotherhood's finest cut.",
        "Edwin VanCleef. Rich, like he always wanted.",
    } },
    { words = { "herod" }, lines = {
        "Herod. All that shouting, and he tastes of nothing but whirlwind.",
        "Herod. Blades of Light? Blades of bite.",
        "Herod. The Scarlet Champion. Champion of my dinner table.",
        "Herod. He said 'Ah, I've been waiting for a real challenge.' So was I.",
    } },
    { words = { "defias" }, lines = DEFIAS },
    { words = { "scarlet" }, lines = SCARLET },
    { words = { "bloodsail", "southsea", "pirate", "buccaneer", "swashbuckler", "corsair" }, lines = PIRATE },
    { words = { "syndicate" }, lines = SYNDICATE },
    { words = { "quilboar", "razormane", "bristleback", "death's head" }, lines = QUILBOAR }, -- before cultists: Death's Head Acolyte
    { words = { "cultist", "cult", "necromancer", "acolyte", "twilight" }, lines = CULTIST },
    { words = { "forsaken", "deathguard" }, lines = FORSAKEN },
    { words = { "ghost", "ghostly", "spirit", "spectre", "specter", "spectral", "phantom", "banshee", "wraith",
        "apparition", "haunt", "shade", "poltergeist" }, lines = GHOST },
    { words = { "skeleton", "skeletal", "bone", "skull" }, lines = SKELETON },
    { words = { "ghoul", "zombie", "rotting", "rotted", "decaying", "putrid", "risen", "abomination", "mummy",
        "mummified" }, lines = GHOUL },
    { words = { "murloc", "murk-eye", "mur'gul" }, lines = MURLOC },
    { words = { "kobold", "tunnel rat" }, lines = KOBOLD },
    { words = { "gnoll", "riverpaw", "mosshide", "shadowhide", "rot hide" }, lines = GNOLL },
    { words = { "troll", "witherbark", "vilebranch", "skullsplitter", "bloodscalp", "mossflayer", "smolderthorn",
        "gurubashi", "hakkari", "frostmane", "darkspear" }, lines = TROLL },
    { words = { "ogre", "gordok", "gordunni", "boulderfist", "dunemaul", "mo'grosh" }, lines = OGRE },
    { words = { "harpy", "harpie" }, lines = HARPY },
    { words = { "centaur", "kolkar", "galak", "maraudine", "gelkis", "magram" }, lines = CENTAUR },
    { words = { "naga", "slitherblade", "spitelash", "daggerspine" }, lines = NAGA },
    { words = { "furbolg", "timbermaw", "deadwood", "foulweald", "thistlefur", "winterfall", "gnarlpine" }, lines = FURBOLG },
    { words = { "trogg", "rockjaw", "stonesplinter" }, lines = TROGG },
    { words = { "goblin", "venture co" }, lines = GOBLIN },
    { words = { "gnome", "leper gnome" }, lines = GNOME },
    { words = { "dwarf", "dwarven", "dark iron", "mountaineer", "wildhammer" }, lines = DWARF },
    { words = { "orc", "blackrock", "dragonmaw", "bleeding hollow" }, lines = ORC },
    { words = { "tauren", "grimtotem" }, lines = TAUREN },
    { words = { "night elf", "sentinel" }, lines = NIGHTELF },
}

-- Corpse names on other clients (GetLocale()), added to the ns.FLESH entry whose first word is the key; the
-- English words still count (many names keep them: "Murloc", "Gnoll"). Case and accents don't matter (Fold
-- in Core: "Défias" is "defias"). These match at the start of a word, so a stem finds every ending and German
-- compounds ("skelett" -> "Skelettkrieger"); end one with "$" to match the whole word only. Best guesses at
-- each language's names: a miss only means the corpse gets its type's lines.
ns.FLESH_LOCALE = {
    frFR = {
        hogger = { "lardeur" }, herod = { "hérode" },
        scarlet = { "écarlate" },
        bloodsail = { "voile sanglante", "mers du sud", "boucanier", "flibustier", "corsaire", "bretteur" },
        syndicate = { "syndicat" },
        quilboar = { "huran", "tranchecrin", "tête de mort" },
        cultist = { "cultiste", "culte", "nécromancien", "acolyte", "crépuscul" },
        forsaken = { "réprouvé", "garde de la mort" },
        ghost = { "fantôm", "esprit", "spectr", "âme en peine", "apparition", "poltergeist" },
        skeleton = { "squelett", "crâne" },
        ghoul = { "goule", "zombi", "pourri", "putride", "abomination", "momie", "momifi", "ressuscité" },
        kobold = { "rat des tunnels" },
        gnoll = { "rivepatte" },
        troll = { "vilebranche", "sombrelance", "givrecrin" },
        centaur = { "centaure" },
        furbolg = { "grumegueule" },
        goblin = { "gobelin", "kapitalrisque" },
        gnome = { "gnome lépreux" },
        dwarf = { "nain", "sombrefer", "marteau-hardi", "montagnard" },
        orc = { "rochenoire", "gueule-de-dragon" },
        tauren = { "totem-sinistre" },
        ["night elf"] = { "elfe de la nuit", "sentinelle" },
    },
    deDE = {
        defias = { "defias" },
        scarlet = { "scharlachrot" },
        bloodsail = { "pirat", "blutsegel", "südmeer", "freibeuter", "korsar", "bukanier" },
        syndicate = { "syndikat" },
        quilboar = { "stacheleber", "klingenmähne", "borstennacken", "todeskopf" },
        cultist = { "kult", "nekromant", "akolyth", "schattenhammer" },
        forsaken = { "verlassen", "todeswache" },
        ghost = { "geist", "gespenst", "phantom", "banshee", "erscheinung", "spuk" },
        skeleton = { "skelett", "knochen", "schädel" },
        ghoul = { "ghul", "zombie", "verrott", "faulend", "monstrosität", "mumie", "auferstanden" },
        murloc = { "murloc" },
        kobold = { "kobold", "tunnelratte" },
        gnoll = { "gnoll", "flusspfote" },
        troll = { "troll", "gurubashi", "hakkari", "dunkelspeer", "frostmähne" },
        ogre = { "oger", "gordok" },
        harpy = { "harpyie" },
        centaur = { "zentaur", "kolkar", "galak", "maraudine", "gelkis", "magram" },
        naga = { "naga" },
        furbolg = { "furbolg", "holzschlund" },
        trogg = { "trogg" },
        goblin = { "goblin", "venture" },
        gnome = { "gnom", "lepragnom" },
        dwarf = { "zwerg", "dunkeleisen", "wildhammer" },
        orc = { "ork", "schwarzfels", "drachenmal" },
        tauren = { "taure", "grimmtotem" },
        ["night elf"] = { "nachtelf", "schildwache" },
    },
    esES = {
        scarlet = { "escarlata" },
        bloodsail = { "pirata", "velasangre", "mares del sur", "bucanero", "espadach", "corsario", "filibustero" },
        syndicate = { "sindicato" },
        quilboar = { "jabaespín" },
        cultist = { "cultista", "culto", "nigromante", "acólito", "crepuscular" },
        forsaken = { "renegad", "guardia de la muerte" },
        ghost = { "fantasma", "espíritu", "espectr", "alma en pena", "aparición" },
        skeleton = { "esquelet", "hueso", "calavera", "cráneo" },
        ghoul = { "necrófago", "zombi", "putrefact", "podrid", "abominación", "momia", "momificad", "resucitad" },
        kobold = { "rata de túnel" },
        troll = { "trol", "lanza negra" },
        ogre = { "ogro" },
        harpy = { "arpía" },
        centaur = { "centauro" },
        goblin = { "ventura" },
        gnome = { "gnomo" },
        dwarf = { "enano", "enana", "hierro negro", "martillo salvaje", "montañero" },
        orc = { "orco", "roca negra", "faucedraco" },
        tauren = { "tótem siniestro" },
        ["night elf"] = { "elfo de la noche", "elfa de la noche", "centinela" },
    },
    itIT = {
        scarlet = { "scarlatt" },
        bloodsail = { "pirata", "mari del sud", "bucaniere", "corsaro" },
        syndicate = { "sindacato" },
        cultist = { "cultista", "culto", "negromante", "accolito", "crepuscol" },
        forsaken = { "reiett" },
        ghost = { "fantasma", "spirito", "spettr" },
        skeleton = { "scheletr", "teschio" },
        ghoul = { "zombi", "abominio", "mummia", "putrescent" },
        harpy = { "arpia" },
        centaur = { "centauro" },
        gnome = { "gnomo" },
        dwarf = { "nano$", "nana$", "nani$" },
        ["night elf"] = { "elfo della notte", "sentinella" },
    },
    ptBR = {
        scarlet = { "escarlate" },
        bloodsail = { "pirata", "mares do sul", "bucaneiro", "corsário" },
        syndicate = { "sindicato" },
        quilboar = { "javaliço" },
        cultist = { "cultista", "culto", "necromante", "acólito", "crepuscular" },
        forsaken = { "renegad" },
        ghost = { "fantasma", "espírito", "espectr", "aparição" },
        skeleton = { "esquelet", "caveira", "crânio" },
        ghoul = { "carniçal", "zumbi", "abominação", "múmia", "putrefat" },
        troll = { "trol" },
        ogre = { "ogro" },
        harpy = { "harpia" },
        centaur = { "centauro" },
        gnome = { "gnomo" },
        dwarf = { "anão", "anã$" },
        ["night elf"] = { "elfo noturno", "elfa noturna", "sentinela" },
    },
    ruRU = {
        hogger = { "хоггер" }, vancleef = { "ванклиф" },
        defias = { "справедливост" },
        scarlet = { "алого$", "алый$", "алая$", "алое$" },
        bloodsail = { "пират", "кровавого паруса", "южных морей", "буканьер", "корсар" },
        syndicate = { "синдикат" },
        quilboar = { "свинобраз", "иглогрив", "щетиноспин" },
        cultist = { "культ", "некромант", "послушни", "сумеречн" },
        forsaken = { "отрекш", "смертестраж" },
        ghost = { "призрак", "дух$", "духа$", "привидени", "банши", "фантом" },
        skeleton = { "скелет", "череп" },
        ghoul = { "вурдалак", "упыр", "зомби", "гниющ", "поганищ", "мумия", "мумифиц", "восставш" },
        murloc = { "мурлок" },
        kobold = { "кобольд" },
        gnoll = { "гнолл" },
        troll = { "тролл" },
        ogre = { "огр$", "огры$", "огра$" },
        harpy = { "гарпи" },
        centaur = { "кентавр" },
        naga = { "нага$", "наги$" },
        furbolg = { "фурболг" },
        trogg = { "трогг" },
        goblin = { "гоблин" },
        gnome = { "гном" },
        dwarf = { "дворф", "черного железа", "чёрного железа" },
        orc = { "орк$", "орки$", "орков$", "орка$" },
        tauren = { "таурен" },
        ["night elf"] = { "ночной эльф", "ночная эльфийка", "часов" },
    },
}
ns.FLESH_LOCALE.esMX = ns.FLESH_LOCALE.esES

-- Player corpses, by race (UnitRace's second return).
ns.RACES = {
    Human = HUMAN, Dwarf = DWARF, NightElf = NIGHTELF, Gnome = GNOME,
    Orc = ORC, Troll = TROLL, Tauren = TAUREN, Scourge = FORSAKEN, Goblin = GOBLIN,
}

-- Anything else, by corpse type.
ns.TYPES = {
    Humanoid = {
        "{name}. Not bad. Could use some salt.",
        "Hmm. {name}. Chewy. Three stars.",
        "A little stringy, but honest food.",
        "{name}, served at room temperature. My favorite.",
        "Mystery humanoid. Tastes a bit like everyone.",
        "{name}. Tender, with a hint of surprise. Probably theirs.",
        "Standard humanoid. The house special.",
        "{name}. Nothing fancy. Good, honest meat.",
        "Two arms, two legs. The classic cut.",
        "{name}. A little underseasoned. Like most of their life.",
        "Humanoid. Comfort food.",
    },
    Undead = {
        "Undead. Already tenderized by death.",
        "{name}. Preserved by dark magic. Stays fresh for decades.",
        "Cold and stringy. Still better than Tirisfal cooking.",
        "Second-hand dead. I don't mind.",
        "Twice dead. Twice as tasty.",
        "{name}. A little gamey. The Scourge doesn't feed them well.",
        "Undead. The leftovers of the Lich King.",
        "{name}. Already rotting. Saves me the trouble.",
        "Necrotic flesh. A bit tangy.",
        "Undead. Reheated, like most leftovers.",
    },
}

-- A corpse the addon can't name (you cast from your bar without a corpse targeted).
ns.MYSTERY = {
    "Mystery meat. I won't ask.",
    "No idea what that was. Delicious, though.",
    "Whatever it was, it's me now.",
    "Tastes like... I'll say chicken.",
    "Ah, the corpse of the day.",
    "Chef's surprise. The surprise is that I don't know either.",
    "Blind tasting. Hmm. Definitely dead.",
    "I didn't look. That's half the fun.",
    "Some kind of meat. Probably. Mostly.",
    "Don't tell me what it was. I'd rather not know.",
}

-- Fit any corpse; used ns.ANY_CHANCE of the time.
ns.ANY = {
    "Needs salt. Everything needs salt.",
    "Five out of ten. Would graverob again.",
    "Cold cuts. My favorite.",
    "Mmm. Freshly dead. The best kind.",
    "My compliments to whoever killed it.",
    "Calories? I'm dead. I don't count them.",
    "Don't mind me. Just a light snack.",
    "One star off for the screaming earlier.",
    "Bit of a mess. I'm a messy eater.",
    "I'll be writing about this one in my journal.",
    "Pairs well with a glass of plague.",
    "Not my best meal, not my worst.",
    "Dinner and a show. The show was the killing.",
}

---------------------------------------------------------------------------
-- Dungeons and raids (Forever): the game hides what a corpse is there, so these review the
-- place, not the meal. No {name}: they must fit whatever you eat. Classic Era hides nothing and
-- keeps the lines above.
---------------------------------------------------------------------------
-- How often a line from the instance's own pool (ns.VENUES) is used instead of the general one.
ns.VENUE_CHANCE = 0.4

ns.DUNGEON = {
    "Dungeon dining. The ambience is mostly screaming.",
    "Fine dining, underground. Bring your own torch.",
    "The service here is murderous. Four stars.",
    "Table for five, and the locals came to us.",
    "Fresh from the pull. You can't get closer to the source.",
    "The tank does the carving. I just do the tasting.",
    "Lovely spot. A bit damp. The staff keep attacking.",
    "No menu, no prices, all you can eat. My kind of place.",
    "Eat between pulls. That's the chef's rule.",
    "The healer says I can't eat that. The healer is wrong.",
    "Corridor cuisine. Narrow, dark, and full of flavor.",
    "Every room's a new course. Pace yourselves.",
    "Who needs a tavern? This place delivers, in waves.",
    "Hold the next pull. I'm on the second course.",
    "Don't wait for me. I'll catch up once I've cleared my plate.",
    "Tasting menu, one room at a time.",
}

ns.RAID = {
    "Banquet for forty. I'm taking the leftovers.",
    "Raid night. The buffet never ends.",
    "Forty of us, and I'm the only one eating. More for me.",
    "Loot is shared, they said. Nobody said anything about dinner.",
    "Catering for an army. Literally.",
    "Big room, big crowd, big appetite.",
    "Wipe or win, someone gets eaten tonight.",
    "Raid dining. Huge portions, long wait between courses.",
    "So much to choose from. One of everything, please.",
    "Save me a seat at the next boss. I'm still on trash.",
}

-- An instance's own lines, by instance ID (GetInstanceInfo's 8th return = Map.db2 ID; checked in
-- Forever's Map.db2 on wago.tools, 2026-11-13). An unknown ID only means the general lines.
local RAZORFEN = {
    "Razorfen. Thorny place. The meat comes tenderized by brambles.",
    "Razorfen. Everything here has spines. Except dinner, luckily.",
}
local SPIRE = {
    "Blackrock Spire. A tall order, and I'm eating every floor.",
    "Blackrock Spire. Orc kitchen, dragon landlord. Busy place.",
}
local AQ = {
    "Ahn'Qiraj. Everything here is a bug. I'll stick to the staff.",
    "Ahn'Qiraj. Sand in every bite. Desert dining.",
}
ns.VENUES = {
    [36] = {
        "Deadmines. Mine-to-table dining.",
        "The Deadmines. Everything tastes of coal dust and grudges.",
        "Deadmines. Every meal here comes with a hard hat.",
        "The Deadmines. Came for the ship, stayed for the buffet.",
    },
    [43] = {
        "Wailing Caverns. The wailing is mostly me, chewing.",
        "Wailing Caverns. Damp, green and full of dreams. Hold the dreams.",
        "Wailing Caverns. Everything here was asleep. Now it's lunch.",
    },
    [33] = {
        "Shadowfang Keep. Silverpine's finest castle kitchen.",
        "Shadowfang Keep. Old manor, old meat, very old wine cellar.",
        "Shadowfang Keep. Mind the worgen hair in the soup.",
    },
    [34] = {
        "The Stockade. Prison food, but I'm not complaining.",
        "The Stockade. Locked up and served. Room service.",
    },
    [389] = {
        "Ragefire Chasm. Everything comes pre-grilled.",
        "Ragefire Chasm. Lovely heat. The meat's practically smoked.",
    },
    [48] = {
        "Blackfathom Deeps. The seafood bar is open.",
        "Blackfathom Deeps. Waterlogged, but the view is lovely.",
    },
    [90] = {
        "Gnomeregan. Faint notes of oil and radiation.",
        "Gnomeregan. Everything here glows a little. Extra seasoning.",
    },
    [47] = RAZORFEN,
    [129] = RAZORFEN,
    [189] = {
        "Scarlet Monastery. They kept a pious kitchen. I keep a hungry one.",
        "The Monastery. They swore to purge my kind. It's going the other way.",
        "Scarlet Monastery. Holy water marinade. Stings a little.",
    },
    [70] = {
        "Uldaman. Older than the menu. Older than the restaurant.",
        "Uldaman. Dusty, but the kitchen's been here for ages.",
    },
    [209] = {
        "Zul'Farrak. Sun-dried. A desert delicacy.",
        "Zul'Farrak. Bring water. Everything here is so salty.",
    },
    [349] = {
        "Maraudon. Purple, damp and oddly floral.",
        "Maraudon. The garden salad bites back.",
    },
    [109] = {
        "The Sunken Temple. A swamp-to-table experience.",
        "Sunken Temple. Everything's soggy. Very authentic.",
    },
    [230] = {
        "Blackrock Depths. Hot kitchen, Dark Iron cooks, and a bar. I'm never leaving.",
        "Blackrock Depths. Pairs nicely with a Dark Iron ale.",
    },
    [429] = {
        "Dire Maul. Ogre catering, elven architecture. Odd combination.",
        "Dire Maul. Ruined palace, ruined meal. Still eating it.",
    },
    [289] = {
        "Scholomance. Back to school. The cafeteria hasn't changed.",
        "Scholomance. I took a class here once. The teacher was delicious.",
    },
    [329] = {
        "Stratholme. Home cooking. Literally, for some of us.",
        "Stratholme. The grain was bad, the meat is worse. I love it.",
    },
    [229] = SPIRE,
    [409] = {
        "Molten Core. Everything is well done. Far too well done.",
        "Molten Core. The kitchen's on fire, and that's the decor.",
    },
    [249] = {
        "Onyxia's Lair. All these whelps, and none of them my type.",
        "Onyxia's Lair. Dragon on the menu, but I'm stuck with the help.",
    },
    [469] = {
        "Blackwing Lair. Dragons upstairs, staff meals down here.",
        "Blackwing Lair. Smoky, scaly, and a long wait for a table.",
    },
    [309] = {
        "Zul'Gurub. Jungle cuisine. The blood god's leftovers.",
        "Zul'Gurub. Spicy. Everything here was soaked in mojo.",
    },
    [509] = AQ,
    [531] = AQ,
    [533] = {
        "Naxxramas. Dinner at the old family home.",
        "Naxxramas. Kel'Thuzad never fed us this well.",
        "Naxxramas. The Scourge's own kitchen. I know the recipes.",
    },

    -- New in Forever
    [3065] = {
        "The Hall of Thanes. Dining among dwarven kings. They're past minding.",
        "Hall of Thanes. The robbers took the gold and left the good stuff.",
        "Hall of Thanes. Royal tomb, royal portions.",
    },
    [2999] = {
        "Ruins of Lordaeron. Home cooking. I used to live upstairs.",
        "Lordaeron. The old capital still serves a fine Scourge.",
        "Ruins of Lordaeron. Eating on the throne room floor. Arthas would be appalled. Good.",
    },
    [2998] = {
        "Excavation Site. Some of this meat is older than the dig.",
        "The dig site. They came for relics. I came for lunch.",
        "Excavation Site. Untouched by time, and now touched by me.",
    },
    [2959] = {
        "Dalaran. Everything tastes faintly arcane. Like licking a wand.",
        "Dalaran. The spells run wild, and so does my appetite.",
        "City of Dalaran. I hope this one wasn't a sheep five minutes ago.",
    },
    [2970] = {
        "The Drowned City. Surf and turf, mostly surf.",
        "Drowned City. Old troll ruins, salted fresh by the sea.",
        "The Drowned City. Seaweed garnish on everything.",
    },
    [3039] = {
        "Krol'dok Stronghold. Ogre portions. I approve.",
        "Krol'dok. The ogres kept captives for the pot. I'm only following the house recipe.",
        "Krol'dok Stronghold. Big kitchen, bigger cooks.",
    },
    [2994] = {
        "Alcaz Prison. Defias and naga on the same menu. Fusion cuisine.",
        "Alcaz Prison. Prison food again. I keep ending up in these places.",
        "Alcaz. Damp cells, salty guests.",
    },
    [2974] = {
        "Blackmaw Hold. Something's off here. Even I can taste it.",
        "Blackmaw Hold. Corrupted, they say. I say aged.",
        "Blackmaw Hold. Furry, gamey and a bit sick. Like home.",
    },
    [3001] = {
        "The Shaper's Terrace. Titan stonework, a view over Un'Goro. Five stars for the setting.",
        "Shaper's Terrace. The crystals hum while I eat. Dinner music.",
        "Shaper's Terrace. Everything here was shaped once. Now I'm reshaping it.",
    },
    [3109] = {
        "Manor Mistmantle. Duskwood's finest haunted dining room.",
        "Mistmantle. Lovely old house. The host is a bit possessive.",
        "Manor Mistmantle. Candlelit, cobwebbed, and nobody's coming back for the dishes.",
    },
}
