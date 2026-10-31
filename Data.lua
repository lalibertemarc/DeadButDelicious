-- Dead But Delicious data: edit what your character says about each corpse here.
local _, ns = ...

-- Classic Era client (Forever is 1.60+).
ns.ERA = select(4, GetBuildInfo()) < 16000

-- The Undead racial. Found by ID first, then by name (only works once you know it).
ns.CANNIBALIZE_ID = 20577
ns.CANNIBALIZE_NAME = "Cannibalize"

-- Corpse types Cannibalize accepts (UnitCreatureType, English client).
ns.EDIBLE = { Humanoid = true, Undead = true }

-- Seconds a corpse you targeted is remembered after you lose the target (for casts from your bar).
ns.MEMORY = 60

-- How often a line from ns.ANY replaces the corpse's own lines.
ns.ANY_CHANCE = 0.2

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
    { words = { "cultist", "cult", "necromancer", "acolyte" }, lines = CULTIST },
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
