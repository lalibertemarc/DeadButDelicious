-- Dead But Delicious, French lines (frFR client). Every client loads this file, but any other one
-- stops at the first line below: its strings are never kept, only parsed, and freed with the chunk.
-- Same groups as Data.lua, keyed the same way; a group missing here keeps its English lines.
-- No gender on the speaker ("je suis ravi") or on {name} ("ce {name}"): either may be female.
local _, ns = ...
if GetLocale() ~= "frFR" then return end

local MURLOC = {
    "Murloc. Salé, avec une finale iodée. Mrglrgl à toi aussi !",
    "Ah, du murloc. Comme des sushis qui hurlent.",
    "Encore du murloc. Peu de gras, beaucoup de sel. Et des nageoires. Tant de nageoires.",
    "Une pointe d'algue, des notes de marée basse. Le murloc, ça s'apprivoise.",
    "Murloc. Caoutchouteux. Je jure qu'il a gargouillé en descendant.",
    "{name}. Un bâtonnet de poisson avec des opinions.",
    "Ceviche de murloc. Mariné dans sa propre peur.",
    "Murloc. La pêche du jour. Et c'est elle qui a mordu la première.",
    "Gluant dehors, encore plus gluant dedans. Au moins, c'est constant.",
    "Murloc. Quand il y en a un, il y a le dessert. Et le deuxième service. Et le troisième.",
    "Se marie bien avec un blanc sec. Ou n'importe quoi de sec, en fait.",
    "Les yeux sont le meilleur morceau. Ils vous regardent en retour.",
}

local KOBOLD = {
    "Kobold. Goût de cire de bougie et de mauvaises décisions.",
    "Toi pas prendre bougie. Moi prendre tout le reste.",
    "Kobold. Surtout de la terre, au poids. De la terre croustillante.",
    "Notes de tunnel, un soupçon de cire et une longue finale de regrets.",
    "Kobold séché, fumé à sa propre bougie. Efficace.",
    "Petite portion. Les kobolds, c'est l'amuse-bouche des profondeurs.",
    "Kobold. Cousin du rat. J'ai mangé pire à Fossoyeuse.",
    "Assaisonné à la poussière de charbon. Le plat du mineur.",
    "Kobold. Petit truc coriace. Je garde la bougie pour plus tard.",
    "{name}. Ça sent le puits de mine. Et ça en a le goût.",
    "Kobold rôti à la bougie. Il s'arrose tout seul.",
}

local GNOLL = {
    "Gnoll. Goût de gibier. Il lui faudrait une marinade.",
    "Gnoll. Surtout des poils et des puces. Les puces, c'est pour les protéines.",
    "Goût de chien mouillé. De chien mouillé en colère.",
    "Cuissot de gnoll. Dur, filandreux, et il doit encore de l'argent aux Carmines.",
    "Celui-ci vivait de porc d'Elwynn. Ça se sent. Pas mal.",
    "{name}. Beaucoup d'aboiements, mais une bonne mâche.",
    "Gnoll. Une hyène avec de l'ambition. L'ambition est caoutchouteuse.",
    "Notes de gale et de feu de camp. Cuisine rustique.",
    "Gnoll. Les pattes, c'est comme des pieds de cochon, avec plus de griffes.",
    "Il a ri en mourant. Maintenant, c'est moi qui ris. La bouche pleine.",
    "Gnoll. Que du tendon. Ma mâchoire fait de l'exercice.",
}

local TROLL = {
    "Troll. Il se régénère pendant que je mâche. Un plat qui se ressert tout seul.",
    "Épicé. Les trolls marinent dans le vaudou depuis la naissance.",
    "Troll. Long, maigre, et encore content de lui.",
    "Les défenses ne se mangent pas. Appris à mes dépens. Le reste est délicieux.",
    "Troll. Notes de jungle et de mojo. Se marie bien avec un maléfice.",
    "Troll. Je mange lentement. Il pourrait repousser une deuxième portion.",
    "Que de jambes. Un troll, c'est surtout des jambes.",
    "Troll. Un peu bleu, un peu vert. Affiné à l'humidité de la jungle.",
    "Notes de banane et de magie du sang. Exotique.",
    "{name}. Évitez les morceaux vaudous. J'en ai mangé un, une fois. J'ai vu des couleurs.",
    "Côtes de troll. Assez longues pour servir de baguettes.",
}

local OGRE = {
    "Ogre. Taille de la portion : oui.",
    "Un ogre nourrit tout un cimetière. Des restes pour des semaines.",
    "Deux têtes ? Deux services.",
    "Peau épaisse, crâne encore plus épais. Étonnamment tendre au milieu.",
    "Ogre. Comme manger un canapé qui a déjà mangé des gens.",
    "Ogre. Moi manger. Moi content.",
    "C'est un rôti entier. Il me faudra un sac à emporter. Et un chien.",
    "Ogre. Gras, autrement dit savoureux.",
    "Ça sent les trois dernières choses qu'il a mangées. Des plats en prime.",
    "{name}. Du gros, du bête et du délicieux. Mon genre de repas.",
    "Ogre. J'en ai pour un moment. Partez sans moi.",
}

local HARPY = {
    "Harpie. Goût de poulet. De poulet furieux qui hurle.",
    "Ailes de harpie. Épicées. Il me faut une serviette pour les plumes.",
    "Blanc ou cuisse ? La harpie, c'est les deux, et les deux crient.",
    "Harpie. Que du pilon, aucune manière.",
    "Harpie. La plumer, c'est la moitié du repas.",
    "Des plumes entre les dents. Celles qu'il me reste.",
    "Harpie. Elle crie encore dans mon estomac. Légère indigestion.",
    "Les serres font un cure-dent correct.",
    "Harpie. Élevée en plein air, ça, je le reconnais.",
    "{name}. Une vieille carne.",
}

local CENTAUR = {
    "Centaure. Terre et mer, sauf que c'est homme et cheval.",
    "Le haut, c'est du bœuf, le bas aussi. Le centaure, c'est un buffet.",
    "Centaure. Je ne sais pas par quel bout commencer. Les deux, alors.",
    "Goût de gibier, et ça sent les Tarides. Authentique.",
    "Centaure. Le cheval est un mets fin, à certains endroits. Pas ici.",
    "La croupe est le meilleur morceau. Et il y a beaucoup de croupe.",
    "Centaure. Nourri à l'herbe des Tarides et à la rancune.",
    "Tant de viande, et si peu de mains pour la manger.",
    "{name}. Fini, le galop. Maintenant, ça trotte dans mes entrailles.",
    "Steak de centaure. Attention aux fers.",
}

local QUILBOAR = {
    "Huran. Du porc, en gros. Du porc très piquant.",
    "Du bacon, mais il faut d'abord retirer les épines.",
    "Goût de jambon et de ronces. La cuisine maison de Tranchebauge.",
    "Côtelettes de huran. Je tuerais pour une pomme à lui mettre dans la gueule.",
    "Huran. Du groin à la queue, rien ne se perd.",
    "Huran effiloché. Mijoté dans sa propre boue.",
    "Huran. Élevé en plein air, nourri aux épines. Très tendance.",
    "Aïe. Un piquant dans la gencive. Ça valait le coup.",
    "{name}. Fumé et terreux, comme un cochon qui a trop lu sur le chamanisme.",
    "Côtes de huran. Je vais me lécher les os après ça. Et les siens.",
}

local NAGA = {
    "Naga. Mer et mer.",
    "Queue de naga. Comme l'anguille, si l'anguille gardait rancune dix mille ans.",
    "Écailleux dehors, saumuré dedans. Le meilleur d'Azshara.",
    "Naga. Riche, salé, et bien trop fier de lui.",
    "Naga. Beaucoup de queue à finir. Je commence par le bout.",
    "Goût d'eaux profondes et de vieux snobisme bien-né.",
    "Naga. Six bras d'amuse-gueule.",
    "Serpent et poisson. Deux de mes choses préférées à mâchouiller.",
    "{name}. Dix mille ans sous la mer, et toujours pas tendre.",
    "Naga. Se marie bien avec des algues et du ressentiment.",
}

local FURBOLG = {
    "Furbolg. Poilu. Tellement, tellement poilu.",
    "Comme de l'ours, avec plus de culpabilité spirituelle.",
    "Furbolg. Sucré. Ils doivent manger beaucoup de miel.",
    "Les poils se coincent dans mes dents. Celles qu'il me reste.",
    "Furbolg. Corrompu par les démons. Ça relève le goût.",
    "Steak d'ours, avec une garniture de mauvaise humeur.",
    "Furbolg. Les pattes sont le morceau de choix. Les quatre.",
    "Goût de forêt. De forêt très en colère.",
    "{name}. Copieux. Le genre de repas qui tient aux côtes qu'il me reste.",
    "Furbolg. Je vais cracher des boules de poils pendant une semaine.",
}

local TROGG = {
    "Trogg. Goût de gravier. Il y a du vrai gravier dedans.",
    "Trogg. Croquant dehors, croquant dedans.",
    "Un trogg, c'est surtout de la roche. Bon pour les os. Les miens se voient.",
    "Riche en minéraux. Ma mâchoire va le sentir demain.",
    "Trogg. Du saturnisme, mais savoureux.",
    "Trogg. L'âge de pierre de la gastronomie.",
    "Terreux. Au sens où c'est surtout de la terre.",
    "{name}. Je crois que je me suis cassé une dent. J'en trouverai une autre.",
    "Trogg. En gros, un caillou qui a appris à marcher. Et à saigner.",
    "Trogg affiné en caverne. Très dur. Très, très dur.",
}

local GOBLIN = {
    "Gobelin. Amer, graisseux, et il a voulu me faire payer la bouchée.",
    "Gobelin. Notes d'huile de moteur et de petits caractères.",
    "Goût de pièces d'or et de poudre à canon. Un repas qui coûte cher.",
    "Gobelin. Petit et salé, et j'ai l'impression de le payer encore.",
    "Gobelin. Le temps, c'est de l'argent, et ça va prendre un moment.",
    "Les oreilles sont croustillantes. Le reste, c'est de la graisse pure.",
    "Gobelin. Livré avec un reçu.",
    "Notes d'azérite et de carburant de fusée. Ne pas mâcher près d'un feu de camp.",
    "{name}. Viande bon marché. Encore trop chère.",
    "Gobelin. Quelqu'un va sûrement m'envoyer la facture.",
}

local GNOME = {
    "Gnome. Format bouchée. Pointe d'huile de moteur.",
    "Gnome. Format mini. Un engrenage offert.",
    "Légèrement irradié. Ça brille un peu. Très gnome.",
    "Gnome. Délicat comme du veau, si le veau savait construire un rayon de la mort.",
    "Gnome. Une bouchée. Deux, par politesse.",
    "Gnome. J'ai trouvé un ressort dedans. Ce n'est pas une métaphore.",
    "Goût de Gnomeregan. Au plomb, et un peu toxique.",
    "Gnome. Cheveux croquants. C'est une crête, ça ?",
    "{name}. Petite portion, mais j'apprécie le savoir-faire.",
    "Gnome. Portion amuse-bouche. Apportez-m'en trois autres.",
}

local DWARF = {
    "Nain. Mariné à la bière depuis la naissance. Délicieux.",
    "Nain. Surtout de la barbe. Je passerai le fil dentaire plus tard.",
    "Dense et copieux. Les nains, c'est du ragoût en bottes.",
    "Goût de stout et d'entêtement.",
    "{name}. Un peu métallique. Beaucoup de fer, comme promis.",
    "Nain. Court, trapu et très nourrissant.",
    "Notes de malt, de fumée et de forge. Un grand cru de Forgefer.",
    "Nain. Dur à mâcher. Comme ronger une enclume avec une barbe.",
    "Que de barbe. J'ai mangé des moutons avec moins de laine.",
    "Nain. On dirait qu'il voudrait se battre avec moi au sujet de la recette.",
    "Nain. Mariné de l'intérieur. Pas besoin de saumure.",
}

local ORC = {
    "Orc. Dur comme du cuir de botte, et à peu près aussi assaisonné.",
    "Orc. Goût prononcé. Comme un worg qui se serait mis à la hache.",
    "Que du muscle. Bonnes protéines. Ma jambe en aurait bien besoin.",
    "Notes de gangrène. Un vieux millésime, d'avant le sevrage.",
    "Orc. Lok'tar ogar. Lok'tar miam.",
    "De la viande verte. D'habitude, mauvais signe. Ici, un délice.",
    "Orc. Les défenses font de bons cure-dents.",
    "Goût de Durotar. Poussiéreux, brûlant et en colère.",
    "{name}. Que de l'honneur, pas de gras. Viande très maigre.",
    "Orc. Coriace, avec une longue finale guerrière.",
}

local TAUREN = {
    "Tauren. Enfin, du vrai bœuf.",
    "Steak de tauren, saignant. La Terre-Mère n'approuverait pas.",
    "Tout un troupeau dans un seul cadavre.",
    "Goût d'herbe des plaines et de sagesse tranquille. Surtout d'herbe.",
    "Tauren. Côte de bœuf. Toutes les côtes sont de premier choix.",
    "Nourri à l'herbe, élevé en plein air, abattu dans les règles. Cinq étoiles.",
    "Tauren. Je meuglerais de joie si j'avais encore des poumons.",
    "{name}. Il manque un peu de moutarde de Mulgore.",
    "Poitrine de tauren. Cuite lentement au soleil des Tarides.",
    "Tant de viande. J'en ai jusqu'au Cataclysme.",
}

local NIGHTELF = {
    "Elfe de la nuit. Dix mille ans et toujours tendre.",
    "Elfe de la nuit. Goût de clair de lune et de suffisance.",
    "Maigre. Ils ne mangent que des feuilles.",
    "Viande violette. Légèrement mentholée. Tout cet air de Teldrassil.",
    "Elfe de la nuit. Nourri aux légumes. Sain, mais ennuyeux.",
    "Oreilles d'elfe. Croquantes. Comme une chips qui vous juge.",
    "Elfe de la nuit. Notes de puits de lune et de fleurs sauvages. Très parfumé.",
    "{name}. Tout en longueur, et des millénaires de bouteille. Comme un grand vin.",
    "Elfe de la nuit. Qu'Élune bénisse ce repas.",
    "Goût de Darnassus. Joli, et un peu trop content de lui.",
}

local HUMAN = {
    "Humain. Un classique. Ça me rappelle maman. Littéralement.",
    "Humain. Un peu fade. Le pain des races.",
    "Humain. J'en étais, autrefois. Je n'avais pas ce goût salé, dans mon souvenir.",
    "Ah, le meilleur de Hurlevent. Manque de sel. Et d'un meilleur roi.",
    "Humain. La cuisine réconfortante des Réprouvés.",
    "Notes de pain, de bière et de percepteur. Très Hurlevent.",
    "Humain. Goût de nostalgie, et un peu du cousin Edmond.",
    "Les humains. Partout, pas chers, si bons.",
    "{name}. Une viande légère et polyvalente. Va avec tout.",
    "Humain. Nourri au maïs, élevé dans la marche de l'Ouest. On sent la ferme.",
    "Humain. J'avais oublié comme c'est chaud, à l'intérieur.",
}

local FORSAKEN = {
    "Réprouvé. Du cannibalisme ? Nous, on appelle ça un dîner de famille.",
    "Un des miens. Un peu sec. Comme manger un miroir.",
    "Pré-affiné, parfaitement pourri. Mes compliments au roi-liche.",
    "Goût de Tirisfal. Humide, lugubre, et un peu comme à la maison.",
    "Réprouvé. Affiné à sec pendant des années. Le rêve du gourmet.",
    "Rien à mâcher que des os et de la rancune.",
    "Pardon, cousin. La reine banshee comprendrait.",
    "{name}. Un goût familier. Trop familier.",
    "Réprouvé. Viande embaumée. Un peu parfumée.",
    "Réprouvé. On finit tous en dîner, un jour ou l'autre.",
}

local DEFIAS = {
    "Défias. Notes de bandana et de poussière des Mortemines.",
    "Goût de tissu rouge et de rancœur. Payez vos tailleurs de pierre, Hurlevent.",
    "Bandit, avec un enrobage croustillant de poudre d'or volée.",
    "{name}. Ça sent les champs de la marche de l'Ouest. Bio, au moins.",
    "Défias. Une confrérie de saveurs. Toutes aigres.",
    "Défias. On enlève le masque, on met le bavoir.",
    "Notes de poudre et d'embruns. Millésime des Mortemines.",
    "Défias. Il m'a volé le cœur. Moi, je lui vole le foie.",
    "Bandit de la marche de l'Ouest. Maigre. On mange mal quand on est en fuite.",
}

local SCARLET = {
    "Croisade écarlate. Trop assaisonné au zèle. Arrière-goût très amer.",
    "Ils sont morts en essayant de me purger. Maintenant, c'est moi qui les purge. Dans mon ventre.",
    "La ferveur sacrée durcit la viande. Je finirai quand même mon assiette.",
    "Croisé. Encens et fanatisme. Sans le fanatisme, merci.",
    "Écarlate. Rouge dehors, rouge dedans.",
    "Goût sacré. Ça brûle un peu en descendant.",
    "Croisé. La Lumière ne l'a pas sauvé. Merci la Lumière.",
    "{name}. Plein de vertu. Vertueusement délicieux.",
    "Croisade écarlate. Purgée, dressée et servie.",
    "Notes d'eau bénite et de paranoïa. Millésime du Monastère.",
}

local PIRATE = {
    "Pirate. Salé et mariné au rhum. Yo ho, crac.",
    "Pirate. Le scorbut lui donne une belle amertume.",
    "Imbibé de rhum. Meilleur que tous les grogs de Baie-du-Butin.",
    "Pirate. La jambe de bois ne se mange pas. Je viens de l'apprendre.",
    "Pirate. Salé par des années en mer.",
    "Arr. Goût de marin. Normal, c'en était un.",
    "{name}. Ça sent la saumure et les promesses brisées.",
    "Pirate. La vitamine C a disparu depuis longtemps. Le goût, non.",
    "Pirate. Les morts ne racontent pas d'histoires. Mais ils ont plutôt bon goût.",
}

local SYNDICATE = {
    "Syndicat. Maigre et fuyant. Même mort, il essaie de me faire les poches.",
    "Goût d'Alterac. Froid, amer, et plein de causes perdues.",
    "Syndicat. Notes de marchandise volée et de vieille noblesse.",
    "Une saveur noble qui a mal tourné. Comme la famille Perenolde.",
    "Syndicat. Tissu noir, cœur sombre, cuisse tendre.",
    "{name}. Louche. Je vérifierai ma bourse après ça.",
    "Syndicat. De la ferme à la table, à Hautebrande. Si la ferme a été cambriolée.",
    "La traîtrise a un goût de poulet.",
}

local CULTIST = {
    "Cultiste. Il voulait rejoindre le Fléau. Maintenant, il fait partie de moi. C'est presque pareil.",
    "Cultiste. Goût de bougie et de mauvais choix de vie.",
    "{name}. Dévoué à la mort. La mort lui en est très reconnaissante.",
    "Cultiste. Les rituels obscurs donnent un goût fumé.",
    "Culte des damnés ? Plutôt Culte des dînés.",
    "Cultiste. Pré-salé à la terre de tombe. Quelle délicatesse.",
    "Ils priaient pour la non-mort. Je suis ce qu'ils auront de plus proche.",
    "Cultiste. Un peu fou, un peu amer. Comme la plupart d'entre nous.",
    "Notes d'encens et de magie de l'ombre. Cuisine très gothique.",
}

local GHOST = {
    "Viande de fantôme. Zéro calorie. Repas minceur.",
    "Fantôme. Toute la texture, aucune substance. Comme la cuisine de Dalaran.",
    "Encore de l'ectoplasme. J'ai toujours faim, et maintenant j'ai la bouche froide.",
    "Banshee ? Spectre ? Dans tous les cas, c'est passé à travers moi.",
    "Chair spectrale. Légère, aérienne, et hurlante.",
    "Fantôme. Comme manger du brouillard. Du brouillard qui fait peur.",
    "Il me faudra quelque chose de plus consistant après ça. Quelque chose avec un corps.",
    "Fantôme. Éthéré, et parti avant que j'aie fini de mâcher.",
    "{name}. Très léger. Un soufflé de damnés.",
    "Esprit. Froid, vaporeux, avec un léger goût de chagrin.",
    "Fantôme. Le repas qui vous hante après.",
}

local SKELETON = {
    "Que des os, pas de viande. Qui sert ça ?",
    "Squelette. Je mâche la moelle de la déception.",
    "Des os. Le calcium, c'est bon pour moi. Les miens se voient assez.",
    "Celui-ci, c'est un fond de bouillon qui s'ignore.",
    "Squelette. Ça cliquette dans mon estomac, maintenant.",
    "Des os. Je venais pour un festin, j'ai eu un xylophone.",
    "Squelette. Croquant. Très croquant. Rien que croquant.",
    "{name}. Pas de peau, pas de viande, pas d'âme. Pas de pourboire.",
    "Encore des os. Il n'y a pas de boucher dans cette ville ?",
    "Squelette. Le chef a tout oublié, sauf l'assiette.",
}

local GHOUL = {
    "Goule. Bien affinée. Très bien affinée.",
    "Zombie. Pré-mâché. Quelle attention.",
    "Pourri, oui. Mais pourri comme un grand fromage.",
    "Abomination. Plusieurs repas cousus en un. Un buffet.",
    "Momie. Déjà emballée, mais tellement sèche.",
    "Goule. Odorante. Le genre d'odeur qui gagne des concours.",
    "Zombie. Les mouches sont arrivées les premières, mais je partage volontiers.",
    "Goule. Fondante comme du beurre. Du beurre rance.",
    "Abomination. Les coutures sont un peu caoutchouteuses.",
    "{name}. Affinage parfait, puis un peu plus encore.",
    "Goule. Chair fermentée. Le kimchi du Fléau.",
}

local RAZORFEN = {
    "Tranchebauge. Endroit épineux. La viande arrive attendrie par les ronces.",
    "Tranchebauge. Tout a des épines, ici. Sauf le dîner, heureusement.",
}
local SPIRE = {
    "Pic de Rochenoire. Un menu à étages, et je mange chaque étage.",
    "Pic de Rochenoire. Cuisine orc, propriétaire dragon. Endroit animé.",
}
local AQ = {
    "Ahn'Qiraj. Tout ici est un insecte. Je m'en tiens au personnel.",
    "Ahn'Qiraj. Du sable dans chaque bouchée. Cuisine du désert.",
}

ns.TRANSLATION = {
    code = "fr", name = "French", native = "français",
    -- /dbd language shows it, with sampleName as {name}.
    sample = "{name}. Tendre, avec une pointe de surprise. Sûrement la sienne.",
    sampleName = "Fourrageur murloc",

    -- After your name in /e mode: 'Grimbald mâche d'un air pensif. "Murloc. Salé."'
    bites = {
        "mâche d'un air pensif.",
        "fait claquer ses lèvres pourries.",
        "retire quelque chose d'entre ses dents.",
        "prend une autre bouchée et réfléchit.",
        "lèche ses doigts osseux.",
        "savoure la bouchée comme un grand cru.",
        "essuie un bout de cartilage sur sa mâchoire.",
        "avale dans un craquement humide.",
        "hume le morceau comme un sommelier.",
        "glisse une serviette imaginaire dans un col déchiré.",
        "mâche lentement, les yeux mi-clos.",
        "s'arrête en pleine bouchée pour prendre une note.",
        "fait rouler la bouchée sur une langue pourrie.",
        "ronge une phalange, l'air songeur.",
    },

    -- By the first word of the ns.FLESH entry.
    flesh = {
        hogger = {
            "Lardeur. L'ennemi public d'Elwynn, désormais le plat du jour d'Elwynn.",
            "Lardeur. Surcoté, comme tous les chefs célèbres.",
            "Lardeur. Un grand nom, un goût de gibier.",
            "Lardeur. Hurlevent a mis sa tête à prix. Moi, j'y ai mis du sel.",
            "Lardeur. Le premier boss de chaque aventurier d'Elwynn, et ma première assiette.",
        },
        vancleef = {
            "VanCleef. Goût de vengeance et de salaires impayés.",
            "VanCleef. Un maître artisan. Tendre, bien construit.",
            "VanCleef. Le meilleur morceau de la Confrérie.",
            "Edwin VanCleef. Riche, comme il l'a toujours voulu.",
        },
        herod = {
            "Hérode. Tous ces cris, et il n'a que le goût du tourbillon.",
            "Hérode. Lames de la Lumière ? Lames de la mâchoire.",
            "Hérode. Le champion écarlate. Champion de ma table.",
            "Hérode. Il attendait un vrai défi. Moi, j'attendais le dîner.",
        },
        defias = DEFIAS,
        scarlet = SCARLET,
        bloodsail = PIRATE,
        syndicate = SYNDICATE,
        quilboar = QUILBOAR,
        cultist = CULTIST,
        forsaken = FORSAKEN,
        ghost = GHOST,
        skeleton = SKELETON,
        ghoul = GHOUL,
        murloc = MURLOC,
        kobold = KOBOLD,
        gnoll = GNOLL,
        troll = TROLL,
        ogre = OGRE,
        harpy = HARPY,
        centaur = CENTAUR,
        naga = NAGA,
        furbolg = FURBOLG,
        trogg = TROGG,
        goblin = GOBLIN,
        gnome = GNOME,
        dwarf = DWARF,
        orc = ORC,
        tauren = TAUREN,
        ["night elf"] = NIGHTELF,
    },

    races = {
        Human = HUMAN, Dwarf = DWARF, NightElf = NIGHTELF, Gnome = GNOME,
        Orc = ORC, Troll = TROLL, Tauren = TAUREN, Scourge = FORSAKEN, Goblin = GOBLIN,
    },

    types = {
        Humanoid = {
            "{name}. Pas mal. Il manque un peu de sel.",
            "Hmm. {name}. Coriace. Trois étoiles.",
            "Un peu filandreux, mais de la cuisine honnête.",
            "{name}, à température ambiante. Comme je l'aime.",
            "Humanoïde mystère. Un peu le goût de tout le monde.",
            "{name}. Tendre, avec une pointe de surprise. Sûrement la sienne.",
            "Humanoïde standard. La spécialité de la maison.",
            "{name}. Rien de compliqué. De la bonne viande honnête.",
            "Deux bras, deux jambes. La découpe classique.",
            "{name}. Un peu fade. Comme le reste de sa vie.",
            "Humanoïde. Cuisine réconfortante.",
        },
        Undead = {
            "Mort-vivant. Déjà attendri par la mort.",
            "{name}. Conserve à la magie noire. Se garde des décennies.",
            "Froid et filandreux. Toujours meilleur que la cuisine de Tirisfal.",
            "Mort d'occasion. Ça ne me dérange pas.",
            "Deux fois mort. Deux fois meilleur.",
            "{name}. Un peu faisandé. Le Fléau les nourrit mal.",
            "Mort-vivant. Les restes du roi-liche.",
            "{name}. Déjà en train de pourrir. Ça m'épargne la peine.",
            "Chair nécrotique. Un peu acidulée.",
            "Mort-vivant. Réchauffé, comme la plupart des restes.",
        },
    },

    mystery = {
        "Viande mystère. Je ne poserai pas de questions.",
        "Aucune idée de ce que c'était. Délicieux, pourtant.",
        "Quoi que ce fût, c'est moi, maintenant.",
        "Ça a le goût de... disons du poulet.",
        "Ah, le cadavre du jour.",
        "La surprise du chef. La surprise, c'est que je ne sais pas non plus.",
        "Dégustation à l'aveugle. Hmm. Mort, sans aucun doute.",
        "Je n'ai pas regardé. C'est la moitié du plaisir.",
        "Une sorte de viande. Probablement. En gros.",
        "Ne me dites pas ce que c'était. Je préfère ne pas savoir.",
    },

    any = {
        "Il manque du sel. Il manque toujours du sel.",
        "Cinq sur dix. Je repillerais la tombe.",
        "Charcuterie froide. Ma préférée.",
        "Mmm. Fraîchement mort. Le meilleur.",
        "Mes compliments à qui l'a tué.",
        "Les calories ? Chez les morts, on ne les compte plus.",
        "Ne faites pas attention à moi. Juste un petit en-cas.",
        "Une étoile en moins pour les cris de tout à l'heure.",
        "Un peu salissant. Je mange salement.",
        "Celui-là, je vais l'écrire dans mon journal.",
        "Se marie bien avec un verre de peste.",
        "Pas mon meilleur repas, pas mon pire.",
        "Dîner-spectacle. Le spectacle, c'était la mise à mort.",
    },

    dungeon = {
        "Dîner en donjon. L'ambiance, c'est surtout des hurlements.",
        "Grande cuisine, sous terre. Apportez votre torche.",
        "Le service ici est meurtrier. Quatre étoiles.",
        "Une table pour cinq, et ce sont les locaux qui viennent à nous.",
        "Tout frais sorti du pull. Impossible d'être plus près du producteur.",
        "Le tank découpe. Moi, je goûte.",
        "Joli coin. Un peu humide. Le personnel n'arrête pas d'attaquer.",
        "Pas de carte, pas de prix, à volonté. Mon genre d'endroit.",
        "On mange entre deux pulls. C'est la règle du chef.",
        "Le soigneur dit que je ne peux pas manger ça. Le soigneur a tort.",
        "Cuisine de couloir. Étroite, sombre et pleine de saveurs.",
        "Chaque salle est un nouveau plat. Ménagez-vous.",
        "Qui a besoin d'une taverne ? Ici, on livre. Par vagues.",
        "Attendez avant le prochain pull. J'en suis au deuxième plat.",
        "Ne m'attendez pas. Je vous rattrape quand j'aurai fini mon assiette.",
        "Menu dégustation, une salle à la fois.",
    },

    raid = {
        "Banquet pour quarante. Je prends les restes.",
        "Soirée raid. Le buffet ne finit jamais.",
        "Quarante convives, et personne d'autre ne mange. Plus pour moi.",
        "Le butin se partage, qu'ils ont dit. Personne n'a parlé du dîner.",
        "Traiteur pour une armée. Littéralement.",
        "Grande salle, grande foule, grand appétit.",
        "Wipe ou victoire, quelqu'un se fait manger ce soir.",
        "Raid gastronomique. Portions énormes, longue attente entre les plats.",
        "Tant de choix. Un de chaque, s'il vous plaît.",
        "Gardez-moi une place au prochain boss. J'en suis encore aux trash.",
    },

    -- By instance ID, as ns.VENUES. Forever's new places have no French name we could check, so their
    -- lines don't name them (Krol'dok, Alcaz and Dalaran are names in any language).
    venues = {
        [36] = {
            "Les Mortemines. De la mine à la table.",
            "Les Mortemines. Tout a un goût de poussière de charbon et de rancune.",
            "Mortemines. Chaque repas ici est servi avec un casque de chantier.",
            "Les Mortemines. On vient pour le navire, on reste pour le buffet.",
        },
        [43] = {
            "Cavernes des Lamentations. Les lamentations, c'est surtout moi qui mâche.",
            "Cavernes des Lamentations. Humide, vert et plein de rêves. Sans les rêves, merci.",
            "Cavernes des Lamentations. Tout dormait, ici. Maintenant, c'est le déjeuner.",
        },
        [33] = {
            "Donjon d'Ombrecroc. La meilleure cuisine de château des Pins-Argentés.",
            "Donjon d'Ombrecroc. Vieux manoir, vieille viande, très vieille cave à vin.",
            "Donjon d'Ombrecroc. Attention aux poils de worgen dans la soupe.",
        },
        [34] = {
            "La Prison. Nourriture de cantine pénitentiaire, mais je ne me plains pas.",
            "La Prison. Repas livré en cellule. Le service en chambre.",
        },
        [389] = {
            "Gouffre de Ragefeu. Tout arrive déjà grillé.",
            "Gouffre de Ragefeu. Belle chaleur. La viande est presque fumée.",
        },
        [48] = {
            "Profondeurs de Brassenoire. Le bar à fruits de mer est ouvert.",
            "Profondeurs de Brassenoire. Détrempé, mais la vue est belle.",
        },
        [90] = {
            "Gnomeregan. Légères notes d'huile et de radiations.",
            "Gnomeregan. Tout brille un peu, ici. Assaisonnement offert.",
        },
        [47] = RAZORFEN,
        [129] = RAZORFEN,
        [189] = {
            "Monastère écarlate. Ils tenaient une cuisine pieuse. La mienne est affamée.",
            "Le Monastère. Ils ont juré de purger mon espèce. Ça tourne dans l'autre sens.",
            "Monastère écarlate. Marinade à l'eau bénite. Ça pique un peu.",
        },
        [70] = {
            "Uldaman. Plus vieux que la carte. Plus vieux que le restaurant.",
            "Uldaman. Poussiéreux, mais la cuisine est là depuis des lustres.",
        },
        [209] = {
            "Zul'Farrak. Séché au soleil. Un mets du désert.",
            "Zul'Farrak. Apportez de l'eau. Tout est tellement salé, ici.",
        },
        [349] = {
            "Maraudon. Violet, humide et étrangement fleuri.",
            "Maraudon. La salade du jardin mord en retour.",
        },
        [109] = {
            "Le temple englouti. Du marais à la table.",
            "Temple englouti. Tout est détrempé. Très authentique.",
        },
        [230] = {
            "Profondeurs de Rochenoire. Cuisine brûlante, cuisiniers Sombrefer, et un bar. Je ne repars plus.",
            "Profondeurs de Rochenoire. Se marie bien avec une bière Sombrefer.",
        },
        [429] = {
            "Hache-Tripes. Traiteur ogre, architecture elfique. Drôle de mariage.",
            "Hache-Tripes. Palais en ruine, repas en ruine. Je mange quand même.",
        },
        [289] = {
            "Scholomance. Retour à l'école. La cantine n'a pas changé.",
            "Scholomance. J'ai suivi un cours ici, autrefois. Le professeur était délicieux.",
        },
        [329] = {
            "Stratholme. Cuisine maison. Littéralement, pour certains d'entre nous.",
            "Stratholme. Le grain était mauvais, la viande est pire. J'adore.",
        },
        [229] = SPIRE,
        [409] = {
            "Cœur du Magma. Tout est bien cuit. Beaucoup trop bien cuit.",
            "Cœur du Magma. La cuisine est en feu, et c'est la déco.",
        },
        [249] = {
            "Repaire d'Onyxia. Tous ces dragonnets, et aucun à mon goût.",
            "Repaire d'Onyxia. Du dragon au menu, mais je dois me contenter du personnel.",
        },
        [469] = {
            "Repaire de l'Aile noire. Les dragons à l'étage, les repas du personnel en bas.",
            "Repaire de l'Aile noire. Fumé, écailleux, et une longue attente pour une table.",
        },
        [309] = {
            "Zul'Gurub. Cuisine de la jungle. Les restes du dieu du sang.",
            "Zul'Gurub. Épicé. Tout, ici, a trempé dans le mojo.",
        },
        [509] = AQ,
        [531] = AQ,
        [533] = {
            "Naxxramas. Dîner dans la vieille maison de famille.",
            "Naxxramas. Kel'Thuzad ne nous a jamais aussi bien nourris.",
            "Naxxramas. La cuisine du Fléau en personne. Je connais les recettes.",
        },

        -- New in Forever
        [3065] = {
            "Un repas chez les rois nains. Ils ne s'en plaignent plus.",
            "Les pilleurs ont pris l'or et laissé le meilleur.",
            "Tombeau royal, portions royales.",
        },
        [2999] = {
            "Ruines de Lordaeron. Cuisine maison. J'habitais à l'étage.",
            "Lordaeron. La vieille capitale sert toujours un excellent Fléau.",
            "Ruines de Lordaeron. Un repas par terre, dans la salle du trône. Arthas serait outré. Tant mieux.",
        },
        [2998] = {
            "Une partie de cette viande est plus vieille que les fouilles.",
            "Le chantier de fouilles. Ils venaient pour les reliques. Moi, pour le déjeuner.",
            "Intact depuis des siècles, et maintenant, entamé par moi.",
        },
        [2959] = {
            "Dalaran. Tout a un léger goût arcanique. Comme lécher une baguette.",
            "Dalaran. Les sorts s'emballent, et mon appétit aussi.",
            "Dalaran. J'espère que celui-ci n'était pas un mouton il y a cinq minutes.",
        },
        [2970] = {
            "Une cité engloutie. Terre et mer, surtout mer.",
            "Vieilles ruines trolls, salées à point par la mer.",
            "Garniture d'algues sur tout. Le chef insiste.",
        },
        [3039] = {
            "Krol'dok. Des portions d'ogre. J'approuve.",
            "Krol'dok. Les ogres gardaient des captifs pour la marmite. Je suis juste la recette de la maison.",
            "Krol'dok. Grande cuisine, cuisiniers encore plus grands.",
        },
        [2994] = {
            "Alcaz. Défias et nagas au même menu. Cuisine fusion.",
            "Alcaz. Encore de la nourriture de prison. Je finis toujours dans ce genre d'endroit.",
            "Alcaz. Cellules humides, invités salés.",
        },
        [2974] = {
            "Quelque chose cloche, ici. Même moi, je le sens au goût.",
            "Corrompu, qu'ils disent. Moi, je dis affiné.",
            "Poilu, faisandé et un peu malade. Comme à la maison.",
        },
        [3001] = {
            "Pierre des titans, vue sur Un'Goro. Cinq étoiles pour le cadre.",
            "Les cristaux bourdonnent pendant que je mange. Musique de table.",
            "Tout ici a été façonné, un jour. Maintenant, c'est moi qui le refaçonne.",
        },
        [3109] = {
            "Le manoir hanté du Bois de la Pénombre. La plus belle salle à manger du coin.",
            "Belle vieille maison. L'hôte est un peu possessif.",
            "Aux chandelles, sous les toiles d'araignée, et personne ne reviendra pour la vaisselle.",
        },
    },
}
