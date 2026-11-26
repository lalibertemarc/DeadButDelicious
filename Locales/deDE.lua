-- Dead But Delicious, German lines (deDE client). Every client loads this file, but any other one
-- stops at the first line below: its strings are never kept, only parsed, and freed with the chunk.
-- Same groups as Data.lua, keyed the same way; a group missing here keeps its English lines.
-- No gender on the speaker ("ich war mal einer"): your character may be either.
local _, ns = ...
if GetLocale() ~= "deDE" then return end

local MURLOC = {
    "Murloc. Salzig, mit fischigem Abgang. Mrglrgl dir auch!",
    "Ah, Murloc. Wie Sushi, das schreit.",
    "Schon wieder Murloc. Wenig Fett, viel Salz. Und Flossen. So viele Flossen.",
    "Ein Hauch von Seetang, Noten von Ebbe. Murloc muss man mögen lernen.",
    "Murloc. Zäh. Ich schwöre, er hat beim Runterschlucken geblubbert.",
    "{name}. Ein Fischstäbchen mit eigener Meinung.",
    "Murloc-Ceviche. Mariniert in der eigenen Angst.",
    "Murloc. Der Fang des Tages. Und er hat zuerst angebissen.",
    "Außen schleimig, innen schleimiger. Immerhin konsequent.",
    "Murloc. Wo einer ist, gibt es Nachtisch. Und Nachschlag. Und noch einen.",
    "Passt gut zu einem trockenen Weißen. Oder zu irgendwas Trockenem.",
    "Die Augen sind das Beste. Sie starren zurück.",
}

local KOBOLD = {
    "Kobold. Schmeckt nach Kerzenwachs und schlechten Entscheidungen.",
    "Du nix nehmen Kerze. Ich nehme alles andere.",
    "Kobold. Nach Gewicht hauptsächlich Dreck. Knuspriger Dreck.",
    "Noten von Stollen, ein Hauch Wachs und ein langer Abgang voller Reue.",
    "Kobold-Trockenfleisch, geräuchert über der eigenen Kerze. Effizient.",
    "Kleine Portion. Kobolde sind die Vorspeise der Unterwelt.",
    "Kobold. Mit der Ratte verwandt. In Unterstadt hatte ich Schlimmeres.",
    "Mit Kohlenstaub gewürzt. Das Bergmannsgericht.",
    "Kobold. Zähes kleines Ding. Die Kerze hebe ich mir für später auf.",
    "{name}. Riecht nach Schacht. Schmeckt auch so.",
    "Kobold, an der Kerze geröstet. Begießt sich selbst.",
}

local GNOLL = {
    "Gnoll. Wildgeschmack. Braucht eine Marinade.",
    "Gnoll. Hauptsächlich Fell und Flöhe. Die Flöhe sind das Protein.",
    "Schmeckt nach nassem Hund. Nach wütendem nassem Hund.",
    "Gnollkeule. Zäh, sehnig, und schuldet dem Rotkammgebirge noch Geld.",
    "Der hier hat von Schweinen aus Elwynn gelebt. Das schmeckt man. Nicht übel.",
    "{name}. Viel Gebell, aber guter Biss.",
    "Gnoll. Eine Hyäne mit Ehrgeiz. Der Ehrgeiz ist zäh.",
    "Noten von Räude und Lagerfeuer. Rustikale Küche.",
    "Gnoll. Die Pfoten sind wie Schweinsfüße, nur mit mehr Krallen.",
    "Er hat beim Sterben gelacht. Jetzt lache ich. Mit vollem Mund.",
    "Gnoll. Nur Sehnen. Mein Kiefer bekommt ein Training.",
}

local TROLL = {
    "Troll. Er regeneriert sich, während ich kaue. Ein Gericht, das sich selbst nachfüllt.",
    "Scharf. Trolle werden von Geburt an in Voodoo mariniert.",
    "Troll. Lang, mager und irgendwie immer noch selbstgefällig.",
    "Die Hauer sind nicht essbar. Auf die harte Tour gelernt. Der Rest ist köstlich.",
    "Troll. Noten von Dschungel und Mojo. Passt gut zu einem Fluch.",
    "Troll. Ich esse langsam. Vielleicht wächst eine zweite Portion nach.",
    "So viel Bein. Trolle bestehen hauptsächlich aus Bein.",
    "Troll. Ein bisschen blau, ein bisschen grün. In Dschungelfeuchte gereift.",
    "Noten von Banane und Blutmagie. Exotisch.",
    "{name}. Finger weg von den Voodoo-Stücken. Hab mal eins gegessen. Farben gesehen.",
    "Trollrippen. Lang genug für Essstäbchen.",
}

local OGRE = {
    "Oger. Portionsgröße: ja.",
    "Ein Oger ernährt einen ganzen Friedhof. Reste für Wochen.",
    "Zwei Köpfe? Zwei Gänge.",
    "Dicke Haut, dickerer Schädel. Überraschend zart in der Mitte.",
    "Oger. Wie ein Sofa essen, das selbst schon Leute gegessen hat.",
    "Oger. Ich essen. Ich glücklich.",
    "Ein ganzer Braten. Ich brauche eine Tüte für die Reste. Und einen Hund.",
    "Oger. Fettig, also geschmackvoll.",
    "Riecht nach den letzten drei Dingen, die er gegessen hat. Bonusgänge.",
    "{name}. Groß, dumm und köstlich. Ganz mein Geschmack.",
    "Oger. Das dauert. Geht ohne mich weiter.",
}

local HARPY = {
    "Harpyie. Schmeckt nach Huhn. Nach wütendem, kreischendem Huhn.",
    "Harpyienflügel. Scharf. Ich brauche eine Serviette für die Federn.",
    "Helles oder dunkles Fleisch? Eine Harpyie ist beides, und beides ist laut.",
    "Harpyie. Nur Keule, keine Manieren.",
    "Harpyie. Das Rupfen ist die halbe Mahlzeit.",
    "Federn zwischen den Zähnen. Den Zähnen, die ich noch habe.",
    "Harpyie. Kreischt immer noch in meinem Magen. Leichte Verdauungsstörung.",
    "Die Krallen sind ein brauchbarer Zahnstocher.",
    "Harpyie. Freilandhaltung, das muss man ihr lassen.",
    "{name}. Zähes altes Federvieh.",
}

local CENTAUR = {
    "Zentaur. Surf and Turf, nur eben Mann und Pferd.",
    "Oben Rind, unten auch Rind. Ein Zentaur ist ein Buffet.",
    "Zentaur. Ich weiß nicht, an welchem Ende ich anfangen soll. Dann eben an beiden.",
    "Wildgeschmack, und es riecht nach Brachland. Authentisch.",
    "Zentaur. Pferdefleisch gilt mancherorts als Delikatesse. Hier nicht.",
    "Die Hüfte ist das beste Stück. Und es gibt viel Hüfte.",
    "Zentaur. Aufgezogen mit Brachlandgras und Groll.",
    "So viel Fleisch, so wenige Hände zum Essen.",
    "{name}. Ausgaloppiert. Jetzt trabt es durch meinen Magen.",
    "Zentaurensteak. Vorsicht, Hufeisen.",
}

local QUILBOAR = {
    "Stacheleber. Im Grunde Schwein. Sehr stacheliges Schwein.",
    "Speck, aber erst muss man die Dornen rauspulen.",
    "Schmeckt nach Schinken und Dornengestrüpp. Hausmannskost der Klingenhauer.",
    "Stacheleberkoteletts. Für einen Apfel in seinem Maul würde ich töten.",
    "Stacheleber. Von der Schnauze bis zum Schwanz, nichts wird verschwendet.",
    "Pulled Stacheleber. Langsam im eigenen Schlamm gegart.",
    "Stacheleber. Freilandhaltung, mit Dornen gefüttert. Sehr im Trend.",
    "Au. Stachel im Zahnfleisch. Hat sich gelohnt.",
    "{name}. Rauchig und erdig, wie ein Schwein, das zu viel über Schamanismus gelesen hat.",
    "Stacheleberrippchen. Danach lecke ich mir die Knochen ab. Und seine.",
}

local NAGA = {
    "Naga. Surf and Surf.",
    "Nagaschwanz. Wie Aal, wenn Aale zehntausend Jahre lang nachtragend wären.",
    "Außen schuppig, innen salzig. Azsharas Feinstes.",
    "Naga. Gehaltvoll, salzig und viel zu stolz auf sich.",
    "Naga. Viel Schwanz zum Durchkauen. Ich fange am Ende an.",
    "Schmeckt nach Tiefsee und altem Hochgeborenendünkel.",
    "Naga. Sechs Arme voller Fingerfood.",
    "Schlange und Fisch. Zwei meiner liebsten Dinge zum Kauen.",
    "{name}. Zehntausend Jahre unter dem Meer, und immer noch nicht zart.",
    "Naga. Passt gut zu Seetang und Groll.",
}

local FURBOLG = {
    "Furbolg. Haarig. So, so haarig.",
    "Wie Bär, nur mit mehr spirituellen Schuldgefühlen.",
    "Furbolg. Süßlich. Die essen wohl viel Honig.",
    "Das Fell bleibt mir in den Zähnen hängen. Von denen habe ich nicht viele.",
    "Furbolg. Von Dämonen verderbt. Gibt eine schöne Schärfe.",
    "Bärensteak mit einer Beilage schlechter Laune.",
    "Furbolg. Die Tatzen sind die Delikatesse. Alle vier.",
    "Schmeckt nach Wald. Nach sehr wütendem Wald.",
    "{name}. Deftig. Die Art Mahlzeit, die an den Rippen hängen bleibt, die ich noch habe.",
    "Furbolg. Ich werde eine Woche lang Haarballen husten.",
}

local TROGG = {
    "Trogg. Schmeckt nach Kies. Da ist echter Kies drin.",
    "Trogg. Außen knusprig, innen knusprig.",
    "Troggs sind hauptsächlich Stein. Gut für die Knochen. Meine liegen frei.",
    "Mineralreich. Das spürt mein Kiefer morgen noch.",
    "Trogg. Bleivergiftung, aber lecker.",
    "Trogg. Die Steinzeit der Küche.",
    "Erdig. In dem Sinne, dass es hauptsächlich Erde ist.",
    "{name}. Ich glaube, ich hab mir einen Zahn abgebrochen. Ich finde schon einen anderen.",
    "Trogg. Im Grunde ein Stein, der laufen gelernt hat. Und bluten.",
    "Höhlengereifter Trogg. Sehr hart. Sehr, sehr hart.",
}

local GOBLIN = {
    "Goblin. Bitter, fettig, und er wollte mir den Bissen in Rechnung stellen.",
    "Goblin. Noten von Motoröl und Kleingedrucktem.",
    "Schmeckt nach Goldmünzen und Schießpulver. Ein teures Essen.",
    "Goblin. Klein und salzig, und irgendwie zahle ich immer noch dafür.",
    "Goblin. Zeit ist Geld, und das hier dauert.",
    "Die Ohren sind knusprig. Der Rest ist reines Fett.",
    "Goblin. Mit Quittung.",
    "Noten von Azerit und Raketentreibstoff. Nicht in der Nähe eines Lagerfeuers kauen.",
    "{name}. Billiges Fleisch. Trotzdem überteuert.",
    "Goblin. Bestimmt schickt mir jemand die Rechnung.",
}

local GNOME = {
    "Gnom. Mundgerecht. Ein Hauch Motoröl.",
    "Gnom. Minigröße. Mit Gratis-Zahnrad.",
    "Leicht verstrahlt. Er leuchtet ein bisschen. Sehr gnomisch.",
    "Gnom. Zart wie Kalb, wenn Kälber Todesstrahlen bauen könnten.",
    "Gnom. Ein Bissen. Zwei, aus Höflichkeit.",
    "Gnom. Ich habe eine Sprungfeder darin gefunden. Keine Metapher.",
    "Schmeckt nach Gnomeregan. Verbleit und leicht giftig.",
    "Gnom. Knusprige Haare. Ist das ein Irokese?",
    "{name}. Klein, aber ich schätze die Handwerkskunst.",
    "Gnom. Häppchenportion. Bringt mir noch drei.",
}

local DWARF = {
    "Zwerg. Seit der Geburt in Bier mariniert. Herrlich.",
    "Zwerg. Hauptsächlich Bart. Zahnseide später.",
    "Dicht und deftig. Zwerge sind Eintopf in Stiefeln.",
    "Schmeckt nach Starkbier und Sturheit.",
    "{name}. Etwas metallisch. Viel Eisen, wie versprochen.",
    "Zwerg. Klein, stämmig und sehr sättigend.",
    "Noten von Malz, Rauch und Schmiede. Ein feiner Jahrgang aus Eisenschmiede.",
    "Zwerg. Schwer zu kauen. Wie an einem Amboss mit Bart zu nagen.",
    "So viel Bart. Ich habe Schafe mit weniger Wolle gegessen.",
    "Zwerg. Schmeckt, als wollte er mit mir über das Rezept streiten.",
    "Zwerg. Von innen eingelegt. Keine Lake nötig.",
}

local ORC = {
    "Ork. Zäh wie Stiefelleder und ungefähr so gut gewürzt.",
    "Ork. Kräftiger Geschmack. Wie ein Worg, der zur Axt gegriffen hat.",
    "Nur Muskeln. Gutes Protein. Mein Bein könnte welches gebrauchen.",
    "Noten von Teufelsenergie. Ein alter Jahrgang, von vor dem Entzug.",
    "Ork. Lok'tar ogar. Lok'tar mampf.",
    "Grünes Fleisch. Meistens ein schlechtes Zeichen. Hier eine Delikatesse.",
    "Ork. Die Hauer sind gute Zahnstocher.",
    "Schmeckt nach Durotar. Staubig, heiß und wütend.",
    "{name}. Nur Ehre, kein Fett. Sehr mager.",
    "Ork. Zäh, mit einem langen, kriegerischen Abgang.",
}

local TAUREN = {
    "Tauren. Endlich richtiges Rind.",
    "Taurensteak, medium rare. Die Erdenmutter wäre nicht begeistert.",
    "Eine ganze Herde in einer Leiche.",
    "Schmeckt nach Präriegras und stiller Weisheit. Vor allem nach Gras.",
    "Tauren. Hochrippe. Jede Rippe ist erste Wahl.",
    "Grasgefüttert, Freilandhaltung, ethisch erschlagen. Fünf Sterne.",
    "Tauren. Ich würde vor Freude muhen, wenn ich noch Lungen hätte.",
    "{name}. Fehlt nur etwas Senf aus Mulgore.",
    "Taurenbrust. Langsam gegart in der Sonne des Brachlands.",
    "So viel Fleisch. Daran kaue ich bis zum Kataklysmus.",
}

local NIGHTELF = {
    "Nachtelf. Zehntausend Jahre alt und immer noch zart.",
    "Nachtelf. Schmeckt nach Mondlicht und Selbstgefälligkeit.",
    "Mager. Die essen ja nur Blätter.",
    "Lila Fleisch. Leicht minzig. Die ganze Luft von Teldrassil.",
    "Nachtelf. Vegetarisch gefüttert. Gesund, aber langweilig.",
    "Elfenohren. Knusprig. Wie ein Chip, der einen verurteilt.",
    "Nachtelf. Noten von Mondbrunnen und Wildblumen. Sehr parfümiert.",
    "{name}. Hoch gewachsen, schlank und sehr, sehr alt. Wie ein guter Wein.",
    "Nachtelf. Elune segne dieses Mahl.",
    "Schmeckt nach Darnassus. Hübsch, und etwas zu zufrieden mit sich.",
}

local HUMAN = {
    "Mensch. Ein Klassiker. Wie bei Mutter. Wörtlich.",
    "Mensch. Etwas fad. Das Brot unter den Völkern.",
    "Mensch. Das war ich auch mal. So salzig war ich nicht, glaube ich.",
    "Ah, Sturmwinds Feinstes. Braucht Salz. Und einen besseren König.",
    "Mensch. Das Wohlfühlessen der Verlassenen.",
    "Noten von Brot, Bier und Steuereintreibung. Sehr Sturmwind.",
    "Mensch. Schmeckt nach Nostalgie und ein bisschen nach Vetter Edmund.",
    "Menschen. Überall, so billig, so gut.",
    "{name}. Leicht und vielseitig. Passt zu allem.",
    "Mensch. Maisgefüttert, in Westfall aufgezogen. Man schmeckt den Hof.",
    "Mensch. Ich hatte vergessen, wie warm sie innen sind.",
}

local FORSAKEN = {
    "Verlassener. Kannibalismus? Wir nennen das Familienessen.",
    "Einer von uns. Etwas trocken. Wie einen Spiegel essen.",
    "Vorgereift, perfekt verrottet. Mein Kompliment an den Lichkönig.",
    "Schmeckt nach Tirisfal. Feucht, düster und ein bisschen nach Zuhause.",
    "Verlassener. Jahrelang trocken gereift. Ein Traum für Feinschmecker.",
    "Nichts zu kauen außer Knochen und Groll.",
    "Tut mir leid, Vetter. Die Bansheekönigin hätte Verständnis.",
    "{name}. Ein vertrauter Geschmack. Zu vertraut.",
    "Verlassener. Einbalsamiertes Fleisch. Etwas parfümiert.",
    "Verlassener. Am Ende werden wir alle Abendessen.",
}

local DEFIAS = {
    "Defias. Noten von Halstuch und Staub aus den Todesminen.",
    "Schmeckt nach rotem Stoff und Groll. Bezahlt eure Steinmetze, Sturmwind.",
    "Bandit, mit einer knusprigen Kruste aus gestohlenem Goldstaub.",
    "{name}. Riecht nach den Feldern von Westfall. Wenigstens bio.",
    "Defias. Eine Bruderschaft der Aromen. Alle sauer.",
    "Defias. Maske ab, Lätzchen um.",
    "Noten von Schießpulver und Seefahrt. Jahrgang Todesminen.",
    "Defias. Er hat mein Herz gestohlen. Jetzt stehle ich seine Leber.",
    "Bandit aus Westfall. Mager. Auf der Flucht isst man schlecht.",
}

local SCARLET = {
    "Scharlachroter Kreuzzug. Mit Eifer überwürzt. Sehr bitterer Nachgeschmack.",
    "Sie starben beim Versuch, mich zu läutern. Jetzt läutere ich sie. In meinen Bauch.",
    "Heiliger Eifer macht das Fleisch zäh. Ich esse trotzdem auf.",
    "Kreuzfahrer. Weihrauch und Fanatismus. Ohne Fanatismus, bitte.",
    "Scharlachrot. Außen rot, innen rot.",
    "Schmeckt heilig. Brennt ein wenig beim Schlucken.",
    "Kreuzfahrer. Das Licht hat ihn nicht gerettet. Dem Licht sei Dank.",
    "{name}. Sehr rechtschaffen. Rechtschaffen lecker.",
    "Scharlachroter Kreuzzug. Geläutert, angerichtet, serviert.",
    "Noten von Weihwasser und Verfolgungswahn. Jahrgang Kloster.",
}

local PIRATE = {
    "Pirat. Salzig und in Rum eingelegt. Jo-ho, knirsch.",
    "Pirat. Der Skorbut gibt ihm eine schöne Bitterkeit.",
    "In Rum getränkt. Besser als jeder Grog in der Beutebucht.",
    "Pirat. Das Holzbein ist nicht essbar. Gerade gelernt.",
    "Pirat. Durch Jahre auf See salzgepökelt.",
    "Arr. Schmeckt nach Seemann. Weil er einer war.",
    "{name}. Riecht nach Salzwasser und gebrochenen Versprechen.",
    "Pirat. Das Vitamin C ist lange weg. Der Geschmack nicht.",
    "Pirat. Tote erzählen keine Geschichten. Aber sie schmecken ganz gut.",
}

local SYNDICATE = {
    "Syndikat. Mager und zwielichtig. Sogar tot versucht er noch, mir die Taschen zu leeren.",
    "Schmeckt nach Alterac. Kalt, bitter und voller verlorener Hoffnungen.",
    "Syndikat. Noten von Diebesgut und altem Adel.",
    "Ein edler Geschmack, der verdorben ist. Wie die Familie Perenolde.",
    "Syndikat. Schwarzer Stoff, finsteres Herz, zarter Schenkel.",
    "{name}. Zwielichtig. Danach prüfe ich meinen Geldbeutel.",
    "Syndikat. Vom Hof auf den Tisch, im Hügelland. Wenn der Hof ausgeraubt wurde.",
    "Verrat schmeckt ziemlich nach Huhn.",
}

local CULTIST = {
    "Kultist. Wollte zur Geißel gehören. Jetzt gehört er zu mir. Fast dasselbe.",
    "Kultist. Schmeckt nach Kerzen und schlechten Lebensentscheidungen.",
    "{name}. Dem Tod ergeben. Der Tod ist sehr dankbar.",
    "Kultist. Dunkle Rituale geben ein rauchiges Aroma.",
    "Kult der Verdammten. Eher Kult der Verspeisten.",
    "Kultist. Mit Grabeserde vorgesalzen. Wie aufmerksam.",
    "Sie beteten um Untod. Näher als ich kommen sie da nicht ran.",
    "Kultist. Etwas verrückt, etwas bitter. Wie die meisten von uns.",
    "Noten von Weihrauch und Schattenmagie. Sehr gotische Küche.",
}

local GHOST = {
    "Geisterfleisch. Null Kalorien. Diätkost.",
    "Geist. Nur Textur, keine Substanz. Wie die Küche in Dalaran.",
    "Schon wieder Ektoplasma. Ich habe immer noch Hunger, und jetzt ist mein Mund kalt.",
    "Banshee? Gespenst? Egal, es ging glatt durch mich durch.",
    "Spektrales Fleisch. Leicht, luftig und kreischend.",
    "Geist. Wie Nebel essen. Gruseligen Nebel.",
    "Danach brauche ich etwas Gehaltvolleres. Etwas mit Körper.",
    "Geist. Ätherisch, und weg, bevor ich fertig gekaut hatte.",
    "{name}. Sehr leicht. Ein Soufflé der Verdammten.",
    "Geist. Kalt, flüchtig, mit einem Hauch von Kummer.",
    "Geist. Das Essen, das einen danach heimsucht.",
}

local SKELETON = {
    "Nur Knochen, kein Fleisch. Wer serviert denn so was?",
    "Skelett. Ich kaue auf dem Mark der Enttäuschung.",
    "Knochen. Kalzium tut mir gut. Bei mir liegt genug frei.",
    "Das hier ist eine Knochenbrühe, die es nur noch nicht weiß.",
    "Skelett. Klappert jetzt in meinem Magen.",
    "Knochen. Ich kam für ein Festmahl und bekam ein Xylophon.",
    "Skelett. Knusprig. Sehr knusprig. Nur knusprig.",
    "{name}. Keine Haut, kein Fleisch, keine Seele. Kein Trinkgeld.",
    "Schon wieder Knochen. Gibt es in dieser Stadt keinen Metzger?",
    "Skelett. Der Koch hat alles vergessen außer dem Teller.",
}

local GHOUL = {
    "Ghul. Gut abgehangen. Sehr gut abgehangen.",
    "Zombie. Vorgekaut. Wie aufmerksam.",
    "Verfault, ja. Aber verfault wie ein feiner Käse.",
    "Monstrosität. Mehrere Mahlzeiten in einer vernäht. Ein Buffet.",
    "Mumie. Schon eingepackt, aber so trocken.",
    "Ghul. Würzig. Die Art Geruch, die Preise gewinnt.",
    "Zombie. Die Fliegen waren zuerst da, aber ich teile gern.",
    "Ghul. Weich wie Butter. Ranzige Butter.",
    "Monstrosität. Die Nähte sind etwas zäh.",
    "{name}. Perfekt gereift, und dann noch etwas länger.",
    "Ghul. Fermentiertes Fleisch. Das Kimchi der Geißel.",
}

local RAZORFEN = {
    "Bei den Klingenhauern. Dorniger Ort. Das Fleisch kommt von Dornen zartgeklopft.",
    "Bei den Klingenhauern hat alles Stacheln. Außer dem Essen, zum Glück.",
}
local SPIRE = {
    "Schwarzfelsspitze. Ein Menü über viele Etagen, und ich esse jede.",
    "Schwarzfelsspitze. Orkküche, Drache als Vermieter. Viel los hier.",
}
local AQ = {
    "Ahn'Qiraj. Alles hier ist ein Käfer. Ich halte mich ans Personal.",
    "Ahn'Qiraj. Sand in jedem Bissen. Wüstenküche.",
}

ns.TRANSLATION = {
    code = "de", name = "German", native = "deutsch",
    -- /dbd language shows it, with sampleName as {name}.
    sample = "{name}. Zart, mit einem Hauch Überraschung. Vermutlich der eigenen.",
    sampleName = "Murlocsammler",

    -- After your name in /e mode: 'Grimbald kaut nachdenklich. "Murloc. Salzig."'
    bites = {
        "kaut nachdenklich.",
        "schmatzt mit verfaulten Lippen.",
        "pult etwas aus einer Zahnlücke.",
        "nimmt noch einen Bissen und denkt darüber nach.",
        "leckt sich die knochigen Finger ab.",
        "genießt den Bissen wie einen edlen Wein.",
        "wischt sich ein Stück Knorpel vom Kiefer.",
        "schluckt mit einem nassen Knirschen.",
        "beschnuppert den Happen wie ein Sommelier.",
        "steckt sich eine unsichtbare Serviette in den zerrissenen Kragen.",
        "kaut langsam, die Augen halb geschlossen.",
        "hält mitten im Bissen inne, um sich eine Notiz zu machen.",
        "rollt den Bissen über eine verfaulte Zunge.",
        "nagt nachdenklich an einem Fingerknöchel.",
    },

    -- By the first word of the ns.FLESH entry.
    flesh = {
        hogger = {
            "Hogger. Elwynns meistgesuchter, jetzt Elwynns meistgegessener.",
            "Hogger. Überbewertet, wie jeder berühmte Koch.",
            "Hogger. Großer Name, Wildgeschmack.",
            "Hogger. Sturmwind hat ein Kopfgeld auf ihn ausgesetzt. Ich setze Salz drauf.",
            "Hogger. Der erste Boss jedes Abenteurers in Elwynn, und mein erster Gang.",
        },
        vancleef = {
            "VanCleef. Schmeckt nach Rache und unbezahltem Lohn.",
            "VanCleef. Ein Meisterhandwerker. Zart, gut gebaut.",
            "VanCleef. Das beste Stück der Bruderschaft.",
            "Edwin VanCleef. Reichhaltig. Reich wollte er ja immer sein.",
        },
        herod = {
            "Herod. All das Geschrei, und er schmeckt nur nach Wirbelwind.",
            "Herod. Der scharlachrote Champion. Champion meiner Tafel.",
            "Herod. Er wartete auf eine echte Herausforderung. Ich wartete aufs Abendessen.",
            "Herod. Viel Wirbelwind, wenig Fett.",
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
            "{name}. Nicht schlecht. Könnte etwas Salz vertragen.",
            "Hm. {name}. Zäh. Drei Sterne.",
            "Etwas sehnig, aber ehrliches Essen.",
            "{name}, bei Zimmertemperatur serviert. Mein Liebstes.",
            "Unbekannter Humanoider. Schmeckt ein bisschen nach allen.",
            "{name}. Zart, mit einem Hauch Überraschung. Vermutlich der eigenen.",
            "Standard-Humanoider. Die Spezialität des Hauses.",
            "{name}. Nichts Besonderes. Gutes, ehrliches Fleisch.",
            "Zwei Arme, zwei Beine. Der klassische Zuschnitt.",
            "{name}. Etwas fad gewürzt. Wie der Rest des Lebens.",
            "Humanoider. Hausmannskost.",
        },
        Undead = {
            "Untot. Vom Tod bereits zart gemacht.",
            "{name}. Von dunkler Magie konserviert. Hält sich jahrzehntelang.",
            "Kalt und sehnig. Immer noch besser als die Küche in Tirisfal.",
            "Gebrauchte Tote. Stört mich nicht.",
            "Zweimal tot. Doppelt lecker.",
            "{name}. Etwas streng. Die Geißel füttert sie schlecht.",
            "Untot. Die Reste des Lichkönigs.",
            "{name}. Verrottet schon. Spart mir die Mühe.",
            "Nekrotisches Fleisch. Etwas säuerlich.",
            "Untot. Aufgewärmt, wie die meisten Reste.",
        },
    },

    mystery = {
        "Fleisch unbekannter Herkunft. Ich frage nicht nach.",
        "Keine Ahnung, was das war. Trotzdem köstlich.",
        "Was immer es war, jetzt ist es ein Teil von mir.",
        "Schmeckt nach... sagen wir Huhn.",
        "Ah, die Leiche des Tages.",
        "Überraschung des Küchenchefs. Die Überraschung: Ich weiß es auch nicht.",
        "Blindverkostung. Hm. Definitiv tot.",
        "Ich habe nicht hingesehen. Das ist der halbe Spaß.",
        "Irgendeine Art Fleisch. Wahrscheinlich. Größtenteils.",
        "Sagt mir nicht, was es war. Ich will es nicht wissen.",
    },

    any = {
        "Braucht Salz. Alles braucht Salz.",
        "Fünf von zehn. Würde wieder ein Grab plündern.",
        "Kalter Aufschnitt. Mein Lieblingsessen.",
        "Mmm. Frisch tot. Die beste Sorte.",
        "Mein Kompliment an wen auch immer, der es erlegt hat.",
        "Kalorien? Ich bin tot. Ich zähle keine.",
        "Achtet nicht auf mich. Nur ein kleiner Snack.",
        "Ein Stern Abzug für das Geschrei vorhin.",
        "Eine ziemliche Sauerei. Ich esse unordentlich.",
        "Darüber schreibe ich in mein Tagebuch.",
        "Passt gut zu einem Glas Seuche.",
        "Nicht mein bestes Essen, nicht mein schlechtestes.",
        "Dinner mit Show. Die Show war das Töten.",
    },

    dungeon = {
        "Essen im Dungeon. Die Atmosphäre besteht hauptsächlich aus Geschrei.",
        "Gehobene Küche, unter Tage. Fackel bitte selbst mitbringen.",
        "Der Service hier ist mörderisch. Vier Sterne.",
        "Tisch für fünf, und die Einheimischen kommen zu uns.",
        "Frisch vom Pull. Näher an der Quelle geht nicht.",
        "Der Tank tranchiert. Ich koste nur.",
        "Schöner Ort. Etwas feucht. Das Personal greift ständig an.",
        "Keine Karte, keine Preise, alles, was man essen kann. Ganz mein Laden.",
        "Gegessen wird zwischen den Pulls. Regel des Küchenchefs.",
        "Der Heiler sagt, ich darf das nicht essen. Der Heiler irrt sich.",
        "Korridorküche. Eng, dunkel und voller Geschmack.",
        "Jeder Raum ist ein neuer Gang. Teilt es euch ein.",
        "Wer braucht eine Taverne? Hier wird geliefert. In Wellen.",
        "Wartet mit dem nächsten Pull. Ich bin beim zweiten Gang.",
        "Wartet nicht auf mich. Ich komme nach, wenn mein Teller leer ist.",
        "Degustationsmenü, ein Raum nach dem anderen.",
    },

    raid = {
        "Bankett für vierzig. Ich nehme die Reste.",
        "Raidabend. Das Buffet hört nie auf.",
        "Vierzig Leute, und nur ich esse. Mehr für mich.",
        "Beute wird geteilt, hieß es. Vom Abendessen hat keiner was gesagt.",
        "Catering für eine Armee. Wortwörtlich.",
        "Großer Saal, große Menge, großer Appetit.",
        "Wipe oder Sieg, heute Abend wird jemand gegessen.",
        "Raidküche. Riesige Portionen, lange Wartezeit zwischen den Gängen.",
        "So viel Auswahl. Einmal von allem, bitte.",
        "Haltet mir beim nächsten Boss einen Platz frei. Ich bin noch beim Trash.",
    },

    -- By instance ID, as ns.VENUES. Forever's new places have no German name we could check, so their
    -- lines don't name them (Krol'dok, Alcaz, Dalaran and Lordaeron are names in any language).
    venues = {
        [36] = {
            "Die Todesminen. Von der Mine auf den Tisch.",
            "Die Todesminen. Alles schmeckt nach Kohlenstaub und Groll.",
            "Todesminen. Jedes Essen hier gibt es mit Schutzhelm.",
            "Die Todesminen. Wegen des Schiffs gekommen, wegen des Buffets geblieben.",
        },
        [43] = {
            "Höhlen des Wehklagens. Das Wehklagen bin hauptsächlich ich, beim Kauen.",
            "Höhlen des Wehklagens. Feucht, grün und voller Träume. Die Träume bitte weglassen.",
            "Höhlen des Wehklagens. Hier hat alles geschlafen. Jetzt ist es Mittagessen.",
        },
        [33] = {
            "Burg Schattenfang. Die feinste Burgküche im Silberwald.",
            "Burg Schattenfang. Altes Herrenhaus, altes Fleisch, sehr alter Weinkeller.",
            "Burg Schattenfang. Vorsicht, Worgenhaare in der Suppe.",
        },
        [34] = {
            "Das Verlies. Gefängniskost, aber ich beschwere mich nicht.",
            "Das Verlies. Essen direkt in die Zelle. Zimmerservice.",
        },
        [389] = {
            "Der Flammenschlund. Alles kommt vorgegrillt.",
            "Flammenschlund. Schöne Hitze. Das Fleisch ist praktisch geräuchert.",
        },
        [48] = {
            "Tiefschwarze Grotte. Die Fischbar hat geöffnet.",
            "Tiefschwarze Grotte. Durchnässt, aber die Aussicht ist schön.",
        },
        [90] = {
            "Gnomeregan. Leichte Noten von Öl und Strahlung.",
            "Gnomeregan. Alles hier leuchtet ein bisschen. Extra Würze.",
        },
        [47] = RAZORFEN,
        [129] = RAZORFEN,
        [189] = {
            "Scharlachrotes Kloster. Sie führten eine fromme Küche. Meine ist hungrig.",
            "Das Kloster. Sie schworen, meinesgleichen zu läutern. Es läuft andersherum.",
            "Scharlachrotes Kloster. Weihwasser-Marinade. Brennt ein bisschen.",
        },
        [70] = {
            "Uldaman. Älter als die Speisekarte. Älter als das Restaurant.",
            "Uldaman. Staubig, aber die Küche gibt es hier seit Ewigkeiten.",
        },
        [209] = {
            "Zul'Farrak. Sonnengetrocknet. Eine Wüstendelikatesse.",
            "Zul'Farrak. Bringt Wasser mit. Hier ist alles so salzig.",
        },
        [349] = {
            "Maraudon. Lila, feucht und seltsam blumig.",
            "Maraudon. Der Gartensalat beißt zurück.",
        },
        [109] = {
            "Der Versunkene Tempel. Vom Sumpf auf den Tisch.",
            "Versunkener Tempel. Alles durchweicht. Sehr authentisch.",
        },
        [230] = {
            "Schwarzfelstiefen. Heiße Küche, Dunkeleisenköche und eine Bar. Ich gehe nie wieder.",
            "Schwarzfelstiefen. Passt gut zu einem Dunkeleisenbier.",
        },
        [429] = {
            "Düsterbruch. Ogercatering, Elfenarchitektur. Seltsame Kombination.",
            "Düsterbruch. Zerstörter Palast, zerstörtes Essen. Ich esse es trotzdem.",
        },
        [289] = {
            "Scholomance. Zurück in die Schule. Die Mensa hat sich nicht verändert.",
            "Scholomance. Ich habe hier mal einen Kurs belegt. Der Lehrer war köstlich.",
        },
        [329] = {
            "Stratholme. Hausmannskost. Für manche von uns wörtlich.",
            "Stratholme. Das Korn war schlecht, das Fleisch ist schlimmer. Ich liebe es.",
        },
        [229] = SPIRE,
        [409] = {
            "Geschmolzener Kern. Alles ist durchgegart. Viel zu durch.",
            "Geschmolzener Kern. Die Küche brennt, und das ist die Deko.",
        },
        [249] = {
            "Onyxias Hort. All die Welpen, und keiner nach meinem Geschmack.",
            "Onyxias Hort. Drache auf der Karte, aber ich muss mit dem Personal vorliebnehmen.",
        },
        [469] = {
            "Pechschwingenhort. Oben die Drachen, unten das Personalessen.",
            "Pechschwingenhort. Rauchig, schuppig und lange Wartezeit auf einen Tisch.",
        },
        [309] = {
            "Zul'Gurub. Dschungelküche. Die Reste des Blutgottes.",
            "Zul'Gurub. Scharf. Hier ist alles in Mojo getränkt.",
        },
        [509] = AQ,
        [531] = AQ,
        [533] = {
            "Naxxramas. Abendessen im alten Elternhaus.",
            "Naxxramas. So gut hat uns Kel'Thuzad nie gefüttert.",
            "Naxxramas. Die Küche der Geißel höchstpersönlich. Ich kenne die Rezepte.",
        },

        -- New in Forever
        [3065] = {
            "Speisen unter Zwergenkönigen. Die beschweren sich nicht mehr.",
            "Die Räuber nahmen das Gold und ließen das Gute liegen.",
            "Königsgrab, königliche Portionen.",
        },
        [2999] = {
            "Ruinen von Lordaeron. Hausmannskost. Ich habe oben gewohnt.",
            "Lordaeron. Die alte Hauptstadt serviert immer noch eine feine Geißel.",
            "Ruinen von Lordaeron. Essen auf dem Boden des Thronsaals. Arthas wäre entsetzt. Gut so.",
        },
        [2998] = {
            "Manches Fleisch hier ist älter als die Ausgrabung.",
            "Die Grabungsstätte. Sie kamen wegen der Relikte. Ich wegen des Mittagessens.",
            "Von der Zeit unberührt, und jetzt von mir angebissen.",
        },
        [2959] = {
            "Dalaran. Alles schmeckt leicht arkan. Wie an einem Zauberstab lecken.",
            "Dalaran. Die Zauber laufen Amok, und mein Appetit auch.",
            "Dalaran. Hoffentlich war der hier vor fünf Minuten kein Schaf.",
        },
        [2970] = {
            "Eine versunkene Stadt. Surf and Turf, vor allem Surf.",
            "Alte Trollruinen, frisch vom Meer gesalzen.",
            "Seetang als Garnitur auf allem. Der Koch besteht darauf.",
        },
        [3039] = {
            "Krol'dok. Ogerportionen. Gefällt mir.",
            "Krol'dok. Die Oger hielten Gefangene für den Kochtopf. Ich halte mich nur ans Hausrezept.",
            "Krol'dok. Große Küche, noch größere Köche.",
        },
        [2994] = {
            "Alcaz. Defias und Naga auf derselben Karte. Fusionsküche.",
            "Alcaz. Schon wieder Gefängnisessen. Ich lande immer an solchen Orten.",
            "Alcaz. Feuchte Zellen, salzige Gäste.",
        },
        [2974] = {
            "Hier stimmt etwas nicht. Sogar ich schmecke es.",
            "Verderbt, sagen sie. Gereift, sage ich.",
            "Pelzig, streng und etwas krank. Wie zu Hause.",
        },
        [3001] = {
            "Steinmetzkunst der Titanen, Blick über Un'Goro. Fünf Sterne für die Lage.",
            "Die Kristalle summen, während ich esse. Tafelmusik.",
            "Alles hier wurde einmal geformt. Jetzt forme ich es um.",
        },
        [3109] = {
            "Das Spukhaus im Dämmerwald. Das schönste Speisezimmer weit und breit.",
            "Schönes altes Haus. Der Gastgeber ist etwas besitzergreifend.",
            "Kerzenschein, Spinnweben, und keiner kommt zurück, um abzuwaschen.",
        },
    },
}
