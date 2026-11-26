-- Dead But Delicious, Spanish lines (esES and esMX clients; names are Spain's). Every client loads this
-- file, but any other one stops at the first lines below: its strings are never kept, only parsed, and
-- freed with the chunk. Same groups as Data.lua, keyed the same way; a group missing here keeps its
-- English lines. No gender on the speaker ("estoy lleno") or on {name} ("{name}. Tierno."): either may
-- be female. "ustedes", not "vosotros", so both clients read it right.
local _, ns = ...
local locale = GetLocale()
if locale ~= "esES" and locale ~= "esMX" then return end

local MURLOC = {
    "Múrloc. Salado, con un final a pescado. ¡Mrglrgl a ti también!",
    "Ah, múrloc. Como sushi que grita.",
    "Múrloc otra vez. Poca grasa, mucha sal. Y aletas. Tantas aletas.",
    "Un toque de alga, notas de marea baja. El múrloc es un gusto adquirido.",
    "Múrloc. Gomoso. Juraría que gorgoteó al bajar.",
    "{name}. Una barrita de pescado con opiniones.",
    "Ceviche de múrloc. Marinado en su propio miedo.",
    "Múrloc. La pesca del día. Y fue ella la que picó primero.",
    "Viscoso por fuera, más viscoso por dentro. Al menos es coherente.",
    "Múrloc. Donde hay uno, hay postre. Y segundo plato. Y tercero.",
    "Marida bien con un blanco seco. O con cualquier cosa seca, la verdad.",
    "Los ojos son lo mejor. Te devuelven la mirada.",
}

local KOBOLD = {
    "Kóbold. Sabe a cera de vela y a malas decisiones.",
    "Tú no llevar vela. Yo llevar todo lo demás.",
    "Kóbold. Casi todo tierra, por peso. Tierra crujiente.",
    "Notas de túnel, un toque de cera y un largo final de arrepentimiento.",
    "Cecina de kóbold, ahumada con su propia vela. Eficiente.",
    "Ración pequeña. Los kóbolds son el aperitivo del inframundo.",
    "Kóbold. Primo de la rata. He comido cosas peores en Entrañas.",
    "Sazonado con polvo de carbón. El especial del minero.",
    "Kóbold. Una cosita correosa. La vela me la guardo para luego.",
    "{name}. Huele a pozo de mina. Y sabe igual.",
    "Kóbold asado a la vela. Se baña solo en su jugo.",
}

local GNOLL = {
    "Gnoll. Sabor a caza. Le hace falta un adobo.",
    "Gnoll. Casi todo pelo y pulgas. Las pulgas son la proteína.",
    "Sabe a perro mojado. A perro mojado y enfadado.",
    "Pierna de gnoll. Dura, fibrosa, y aún le debe dinero a Crestagrana.",
    "Este vivía a base de cerdo de Elwynn. Se nota. No está mal.",
    "{name}. Mucho ladrido, pero buen bocado.",
    "Gnoll. Una hiena con ambición. La ambición es correosa.",
    "Notas de sarna y fogata. Cocina rústica.",
    "Gnoll. Las patas son como manitas de cerdo, con más garras.",
    "Se rio al morir. Ahora me río yo. Con la boca llena.",
    "Gnoll. Puro tendón. Mi mandíbula está haciendo ejercicio.",
}

local TROLL = {
    "Trol. Se regenera mientras mastico. Un plato que se rellena solo.",
    "Picante. A los trols los marinan en vudú desde que nacen.",
    "Trol. Largo, flaco y, de algún modo, todavía engreído.",
    "Los colmillos no se comen. Lo aprendí por las malas. Lo demás, delicioso.",
    "Trol. Notas de selva y mojo. Marida bien con un maleficio.",
    "Trol. Como despacio. Igual le crece una segunda ración.",
    "Cuánta pierna. Un trol es casi todo pierna.",
    "Trol. Un poco azul, un poco verde. Curado en la humedad de la selva.",
    "Notas de plátano y magia de sangre. Exótico.",
    "{name}. Ni toquen las partes de vudú. Una vez me comí una. Vi colores.",
    "Costillas de trol. Lo bastante largas para usarlas de palillos.",
}

local OGRE = {
    "Ogro. Tamaño de la ración: sí.",
    "Un ogro alimenta a todo un cementerio. Sobras para semanas.",
    "¿Dos cabezas? Dos platos.",
    "Piel gruesa, cráneo más grueso. Sorprendentemente tierno por dentro.",
    "Ogro. Como comerse un sofá que antes se comía a la gente.",
    "Ogro. Yo comer. Yo feliz.",
    "Es un asado entero. Necesitaré una bolsa para las sobras. Y un perro.",
    "Ogro. Grasiento, o sea, sabroso.",
    "Huele a las tres últimas cosas que se comió. Platos de regalo.",
    "{name}. Mucho tamaño, poco seso, y delicioso. Mi tipo de comida.",
    "Ogro. Tengo para rato. Sigan sin mí.",
}

local HARPY = {
    "Arpía. Sabe a pollo. A pollo enfadado que chilla.",
    "Alitas de arpía. Picantes. Necesito una servilleta para las plumas.",
    "¿Pechuga o muslo? La arpía es las dos cosas, y las dos gritan.",
    "Arpía. Todo muslo, cero modales.",
    "Arpía. Desplumarla es media comida.",
    "Plumas entre los dientes. Entre los que me quedan.",
    "Arpía. Sigue chillando en mi estómago. Leve indigestión.",
    "Las garras sirven de palillo.",
    "Arpía. De corral, eso hay que reconocerlo.",
    "{name}. Pájaro viejo y duro.",
}

local CENTAUR = {
    "Centauro. Mar y montaña, solo que es hombre y caballo.",
    "Mitad de arriba ternera, mitad de abajo también. El centauro es un bufé.",
    "Centauro. No sé por qué punta empezar. Por las dos, entonces.",
    "Sabor a caza, y huele a Los Baldíos. Auténtico.",
    "Centauro. El caballo es un manjar en algunos sitios. Este no es uno de ellos.",
    "La grupa es el mejor corte. Y hay mucha grupa.",
    "Centauro. Criado con hierba de Los Baldíos y rencor.",
    "Tanta carne, y tan pocas manos para comerla.",
    "{name}. Se acabó el galope. Ahora trota por mis tripas.",
    "Filete de centauro. Ojo con las herraduras.",
}

local QUILBOAR = {
    "Jabaespín. Básicamente cerdo. Cerdo muy espinoso.",
    "Beicon, pero primero hay que quitarle las espinas.",
    "Sabe a jamón y a zarzas. Cocina casera de Rajacieno.",
    "Chuletas de jabaespín. Mataría por una manzana para ponerle en la boca.",
    "Jabaespín. Del hocico a la cola, no se tira nada.",
    "Jabaespín desmenuzado. A fuego lento en su propio barro.",
    "Jabaespín. De campo, alimentado con espinas. Muy de moda.",
    "Ay. Una púa en la encía. Valió la pena.",
    "{name}. Ahumado y terroso, como un cerdo que leyó demasiado sobre chamanismo.",
    "Costillas de jabaespín. Después me chuparé los huesos. Y los suyos.",
}

local NAGA = {
    "Naga. Mar y mar.",
    "Cola de naga. Como la anguila, si las anguilas guardaran rencor diez mil años.",
    "Escamosa por fuera, salada por dentro. Lo mejor de Azshara.",
    "Naga. Sabrosa, salada y demasiado orgullosa de sí misma.",
    "Naga. Mucha cola que terminar. Empezaré por el final.",
    "Sabe a aguas profundas y a viejo esnobismo altonato.",
    "Naga. Seis brazos de comida para picar.",
    "Serpiente y pescado. Dos de mis cosas favoritas para masticar.",
    "{name}. Diez mil años bajo el mar, y la carne aún no está tierna.",
    "Naga. Marida bien con algas y resentimiento.",
}

local FURBOLG = {
    "Fúrbolg. Peludo. Muy, muy peludo.",
    "Como el oso, pero con más culpa espiritual.",
    "Fúrbolg. Dulce. Deben de comer mucha miel.",
    "El pelo se me queda entre los dientes. Y no me quedan muchos.",
    "Fúrbolg. Corrompido por demonios. Le da un toque picante.",
    "Filete de oso con guarnición de mal humor.",
    "Fúrbolg. Las zarpas son el manjar. Las cuatro.",
    "Sabe a bosque. A bosque muy enfadado.",
    "{name}. Contundente. De esas comidas que se pegan a las costillas que me quedan.",
    "Fúrbolg. Voy a toser bolas de pelo durante una semana.",
}

local TROGG = {
    "Trogg. Sabe a grava. Lleva grava de verdad.",
    "Trogg. Crujiente por fuera, crujiente por dentro.",
    "Los troggs son casi todo roca. Buenos para los huesos. Los míos se ven.",
    "Rico en minerales. Mi mandíbula lo notará mañana.",
    "Trogg. Envenenamiento por plomo, pero sabroso.",
    "Trogg. La edad de piedra de la gastronomía.",
    "Terroso. En el sentido de que es casi todo tierra.",
    "{name}. Creo que me he partido un diente. Ya encontraré otro.",
    "Trogg. Básicamente una piedra que aprendió a andar. Y a sangrar.",
    "Trogg curado en cueva. Muy duro. Muy, muy duro.",
}

local GOBLIN = {
    "Goblin. Amargo, grasiento, y quiso cobrarme el bocado.",
    "Goblin. Notas de aceite de motor y letra pequeña.",
    "Sabe a monedas de oro y pólvora. Una comida cara.",
    "Goblin. Pequeño y salado, y de algún modo sigo pagándolo.",
    "Goblin. El tiempo es oro, y esto va para largo.",
    "Las orejas están crujientes. Lo demás es pura grasa.",
    "Goblin. Viene con recibo.",
    "Notas de azerita y combustible de cohete. No masticar cerca de una fogata.",
    "{name}. Carne barata. Aun así, cara.",
    "Goblin. Seguro que alguien me manda la factura.",
}

local GNOME = {
    "Gnomo. Tamaño bocado. Un toque de aceite de motor.",
    "Gnomo. Tamaño mini. Con engranaje de regalo.",
    "Ligeramente irradiado. Brilla un poco. Muy gnómico.",
    "Gnomo. Delicado como la ternera, si la ternera supiera construir un rayo de la muerte.",
    "Gnomo. Un bocado. Dos, por educación.",
    "Gnomo. He encontrado un muelle dentro. No es una metáfora.",
    "Sabe a Gnomeregan. Con plomo y algo tóxico.",
    "Gnomo. Pelo crujiente. ¿Eso es una cresta?",
    "{name}. Ración pequeña, pero aprecio la artesanía.",
    "Gnomo. Ración de aperitivo. Tráiganme tres más.",
}

local DWARF = {
    "Enano. Marinado en cerveza desde que nació. Delicioso.",
    "Enano. Casi todo barba. Ya usaré el hilo dental luego.",
    "Denso y contundente. Los enanos son estofado con botas.",
    "Sabe a cerveza negra y a tozudez.",
    "{name}. Un poco metálico. Mucho hierro, como se anunciaba.",
    "Enano. Bajo, robusto y muy saciante.",
    "Notas de malta, humo y forja. Una buena cosecha de Forjaz.",
    "Enano. Duro de masticar. Como roer un yunque con barba.",
    "Cuánta barba. Me he comido ovejas con menos lana.",
    "Enano. Sabe como si quisiera discutirme la receta.",
    "Enano. Encurtido por dentro. No hace falta salmuera.",
}

local ORC = {
    "Orco. Duro como suela de bota, y más o menos igual de sazonado.",
    "Orco. Sabor fuerte. Como un huargo que se aficionó a las hachas.",
    "Todo músculo. Buena proteína. A mi pierna no le vendría mal.",
    "Notas de vil. Una cosecha vieja, de antes de que se desintoxicaran.",
    "Orco. Lok'tar ogar. Lok'tar ñam.",
    "Carne verde. Normalmente, mala señal. Aquí, un manjar.",
    "Orco. Los colmillos son buenos palillos.",
    "Sabe a Durotar. Polvoriento, caliente y enfadado.",
    "{name}. Todo honor, nada de grasa. Carne muy magra.",
    "Orco. Correoso, con un largo final guerrero.",
}

local TAUREN = {
    "Tauren. Por fin, ternera de verdad.",
    "Filete de tauren, poco hecho. La Madre Tierra no lo aprobaría.",
    "Un rebaño entero en un solo cadáver.",
    "Sabe a hierba de las llanuras y a sabiduría tranquila. Sobre todo a hierba.",
    "Tauren. Costillar de primera. Todas las costillas son de primera.",
    "Alimentado con hierba, criado en libertad, sacrificado con ética. Cinco estrellas.",
    "Tauren. Mugiría de alegría si aún tuviera pulmones.",
    "{name}. Le falta un poco de mostaza de Mulgore.",
    "Pecho de tauren. A fuego lento bajo el sol de Los Baldíos.",
    "Cuánta carne. Voy a estar masticando hasta el Cataclismo.",
}

local NIGHTELF = {
    "Elfo de la noche. Diez mil años y todavía tierno.",
    "Elfo de la noche. Sabe a luz de luna y a superioridad.",
    "Magro. No comen más que hojas.",
    "Carne morada. Un poco mentolada. Todo ese aire de Teldrassil.",
    "Elfo de la noche. Alimentado a base de verduras. Sano, pero aburrido.",
    "Orejas de elfo. Crujientes. Como una patata frita que te juzga.",
    "Elfo de la noche. Notas de pozo de la luna y flores silvestres. Muy perfumado.",
    "{name}. Mucha altura y milenios en barrica. Como un gran vino.",
    "Elfo de la noche. Que Elune bendiga esta comida.",
    "Sabe a Darnassus. Bonito, y demasiado satisfecho de sí mismo.",
}

local HUMAN = {
    "Humano. Un clásico. Me recuerda a mamá. Literalmente.",
    "Humano. Un poco soso. El pan de las razas.",
    "Humano. Yo también lo fui. No recuerdo este sabor tan salado.",
    "Ah, lo mejor de Ventormenta. Le falta sal. Y un rey mejor.",
    "Humano. La comida reconfortante de los Renegados.",
    "Notas de pan, cerveza y recaudación de impuestos. Muy de Ventormenta.",
    "Humano. Sabe a nostalgia, y un poco al primo Edmundo.",
    "Humanos. Por todas partes, tan baratos, tan ricos.",
    "{name}. Carne ligera y versátil. Combina con todo.",
    "Humano. Alimentado con maíz, criado en los Páramos de Poniente. Se nota la granja.",
    "Humano. Había olvidado lo calientes que son por dentro.",
}

local FORSAKEN = {
    "Renegado. ¿Canibalismo? Nosotros lo llamamos cena familiar.",
    "Uno de los míos. Algo seco. Como comerse un espejo.",
    "Curado de antemano, perfectamente podrido. Mis felicitaciones al Rey Exánime.",
    "Sabe a Tirisfal. Húmedo, lúgubre, y un poco a hogar.",
    "Renegado. Madurado en seco durante años. El sueño de un gourmet.",
    "Nada que masticar salvo hueso y rencor.",
    "Perdona, primo. La Reina alma en pena lo entendería.",
    "{name}. Un sabor familiar. Demasiado familiar.",
    "Renegado. Carne embalsamada. Un poco perfumada.",
    "Renegado. Todos acabamos siendo la cena, tarde o temprano.",
}

local DEFIAS = {
    "Defias. Notas de pañuelo y polvo de las Minas de la Muerte.",
    "Sabe a tela roja y a resentimiento. Paga a tus canteros, Ventormenta.",
    "Bandido, con un rebozado crujiente de polvo de oro robado.",
    "{name}. Huele a los campos de los Páramos de Poniente. Ecológico, al menos.",
    "Defias. Una hermandad de sabores. Todos agrios.",
    "Defias. Fuera la máscara, dentro el babero.",
    "Notas de pólvora y salitre. Cosecha de las Minas de la Muerte.",
    "Defias. Me robó el corazón. Ahora yo le robo el hígado.",
    "Bandido de los Páramos. Flaco. Cuando huyes, comes mal.",
}

local SCARLET = {
    "Cruzada Escarlata. Demasiado sazonada de fervor. Regusto muy amargo.",
    "Murieron intentando purgarme. Ahora los purgo yo. Hacia mi estómago.",
    "El fervor sagrado endurece la carne. Aun así, me terminaré el plato.",
    "Cruzado. Incienso y fanatismo. Sin el fanatismo, por favor.",
    "Escarlata. Rojo por fuera, rojo por dentro.",
    "Sabe a santo. Quema un poco al bajar.",
    "Cruzado. La Luz no lo salvó. Gracias a la Luz.",
    "{name}. Pura virtud. Virtuosamente delicioso.",
    "Cruzada Escarlata. Purgada, emplatada y servida.",
    "Notas de agua bendita y paranoia. Cosecha del Monasterio.",
}

local PIRATE = {
    "Pirata. Salado y encurtido en ron. Yo-ho, crac.",
    "Pirata. El escorbuto le da un buen amargor.",
    "Empapado en ron. Mejor que cualquier grog de Bahía del Botín.",
    "Pirata. La pata de palo no se come. Lo acabo de aprender.",
    "Pirata. Curado en sal tras años en el mar.",
    "Arr. Sabe a marinero. Porque lo era.",
    "{name}. Huele a salmuera y a promesas rotas.",
    "Pirata. La vitamina C se fue hace mucho. El sabor, no.",
    "Pirata. Los muertos no cuentan historias. Pero saben bastante bien.",
}

local SYNDICATE = {
    "Sindicato. Flaco y escurridizo. Aun muerto, intenta vaciarme los bolsillos.",
    "Sabe a Alterac. Frío, amargo y lleno de causas perdidas.",
    "Sindicato. Notas de mercancía robada y vieja nobleza.",
    "Un sabor noble que se echó a perder. Como la familia Perenolde.",
    "Sindicato. Tela negra, corazón oscuro, muslo tierno.",
    "{name}. Turbio. Después revisaré mi bolsa.",
    "Sindicato. Del campo a la mesa, en Trabalomas. Si al campo le robaron.",
    "La traición sabe bastante a pollo.",
}

local CULTIST = {
    "Cultista. Quería unirse a la Plaga. Ahora es parte de mí. Casi lo mismo.",
    "Cultista. Sabe a velas y a malas decisiones vitales.",
    "{name}. Devoción a la muerte. La muerte lo agradece.",
    "Cultista. Los rituales oscuros le dan un sabor ahumado.",
    "¿Culto de los Malditos? Más bien Culto de los Masticados.",
    "Cultista. Presalado con tierra de tumba. Qué detalle.",
    "Rezaban por la no muerte. Lo más cerca que van a estar soy yo.",
    "Cultista. Un poco loco, un poco amargo. Como casi todos nosotros.",
    "Notas de incienso y magia de las sombras. Cocina muy gótica.",
}

local GHOST = {
    "Carne de fantasma. Cero calorías. Comida de dieta.",
    "Fantasma. Toda textura, nada de sustancia. Como la cocina de Dalaran.",
    "Ectoplasma otra vez. Sigo con hambre, y ahora con la boca fría.",
    "¿Alma en pena? ¿Espectro? Sea lo que sea, me atravesó.",
    "Carne espectral. Ligera, aireada y chillona.",
    "Fantasma. Como comer niebla. Niebla que da miedo.",
    "Después de esto necesitaré algo más sustancioso. Algo con cuerpo.",
    "Fantasma. Etéreo, y desaparecido antes de que terminara de masticar.",
    "{name}. Muy ligero. Un suflé de condenados.",
    "Espíritu. Frío, vaporoso, con un leve sabor a pena.",
    "Fantasma. La comida que te persigue después.",
}

local SKELETON = {
    "Todo hueso, nada de carne. ¿Quién sirve esto?",
    "Esqueleto. Mastico la médula de la decepción.",
    "Huesos. El calcio me sienta bien. Tengo muchos a la vista.",
    "Esto es un caldo que todavía no lo sabe.",
    "Esqueleto. Ahora me traquetea en el estómago.",
    "Huesos. Vine por un festín y me dieron un xilófono.",
    "Esqueleto. Crujiente. Muy crujiente. Solo crujiente.",
    "{name}. Sin piel, sin carne, sin alma. Sin propina.",
    "Huesos otra vez. ¿No hay un carnicero en esta ciudad?",
    "Esqueleto. El chef se olvidó de todo menos del plato.",
}

local GHOUL = {
    "Necrófago. Bien madurado. Muy bien madurado.",
    "Zombi. Premasticado. Qué detalle.",
    "Podrido, sí. Pero podrido como un buen queso.",
    "Abominación. Varias comidas cosidas en una. Un bufé.",
    "Momia. Ya viene envuelta, pero qué seca.",
    "Necrófago. Penetrante. Ese olor que gana premios.",
    "Zombi. Las moscas llegaron primero, pero no me importa compartir.",
    "Necrófago. Suave como la mantequilla. Mantequilla rancia.",
    "Abominación. Las costuras están un poco correosas.",
    "{name}. Madurado a la perfección, y luego un poco más.",
    "Necrófago. Carne fermentada. El kimchi de la Plaga.",
}

local RAZORFEN = {
    "Rajacieno. Sitio espinoso. La carne viene ablandada por las zarzas.",
    "Rajacieno. Aquí todo tiene púas. Menos la cena, por suerte.",
}
local SPIRE = {
    "Cumbre de Roca Negra. Un menú de muchos pisos, y me como todos.",
    "Cumbre de Roca Negra. Cocina orca, casero dragón. Mucho ajetreo.",
}
local AQ = {
    "Ahn'Qiraj. Aquí todo es un bicho. Me quedo con el personal.",
    "Ahn'Qiraj. Arena en cada bocado. Cocina del desierto.",
}

ns.TRANSLATION = {
    code = "es", name = "Spanish", native = "español",
    -- /dbd language shows it, with sampleName as {name}.
    sample = "{name}. Carne tierna, con un toque de sorpresa. Probablemente la suya.",
    sampleName = "Forrajero múrloc",

    -- After your name in /e mode: 'Grimbald mastica pensativamente. "Múrloc. Salado."'
    bites = {
        "mastica pensativamente.",
        "se relame los labios podridos.",
        "se saca algo de un hueco entre los dientes.",
        "da otro bocado y lo medita.",
        "se chupa los dedos huesudos.",
        "saborea el bocado como un buen vino.",
        "se limpia un trozo de cartílago de la mandíbula.",
        "traga con un crujido húmedo.",
        "olfatea el bocado como un sumiller.",
        "se mete una servilleta imaginaria en el cuello roto.",
        "mastica despacio, con los ojos entrecerrados.",
        "se detiene a medio bocado para tomar una nota.",
        "hace rodar el bocado sobre una lengua podrida.",
        "roe un nudillo, con aire pensativo.",
    },

    -- By the first word of the ns.FLESH entry.
    flesh = {
        hogger = {
            "Hogger. El más buscado de Elwynn, ahora el más comido de Elwynn.",
            "Hogger. Sobrevalorado, como todo chef famoso.",
            "Hogger. Gran nombre, sabor a caza.",
            "Hogger. Ventormenta puso precio a su cabeza. Yo le puse sal.",
            "Hogger. El primer jefe de todo aventurero de Elwynn, y mi primer plato.",
        },
        vancleef = {
            "VanCleef. Sabe a venganza y a sueldos sin pagar.",
            "VanCleef. Un maestro artesano. Tierno, bien construido.",
            "VanCleef. El mejor corte de la Hermandad.",
            "Edwin VanCleef. Rico, como siempre quiso.",
        },
        herod = {
            "Herod. Tanto grito, y solo sabe a torbellino.",
            "Herod. El campeón escarlata. Campeón de mi mesa.",
            "Herod. Esperaba un desafío de verdad. Yo esperaba la cena.",
            "Herod. Mucho torbellino, poca grasa.",
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
            "{name}. No está mal. Le falta sal.",
            "Mmm. {name}. Correoso. Tres estrellas.",
            "Un poco fibroso, pero comida honrada.",
            "{name}, a temperatura ambiente. Como más me gusta.",
            "Humanoide misterioso. Sabe un poco a todo el mundo.",
            "{name}. Carne tierna, con un toque de sorpresa. Probablemente la suya.",
            "Humanoide estándar. La especialidad de la casa.",
            "{name}. Nada sofisticado. Carne buena y honrada.",
            "Dos brazos, dos piernas. El corte clásico.",
            "{name}. Le falta sazón. Como al resto de su vida.",
            "Humanoide. Comida casera.",
        },
        Undead = {
            "No-muerto. Ya ablandado por la muerte.",
            "{name}. Conserva de magia oscura. Aguanta décadas.",
            "Frío y fibroso. Aun así, mejor que la cocina de Tirisfal.",
            "Muerto de segunda mano. No me importa.",
            "Dos veces muerto. El doble de rico.",
            "{name}. Un poco fuerte de sabor. La Plaga no los alimenta bien.",
            "No-muerto. Las sobras del Rey Exánime.",
            "{name}. Ya se está pudriendo. Me ahorra el trabajo.",
            "Carne necrótica. Un poco ácida.",
            "No-muerto. Recalentado, como casi todas las sobras.",
        },
    },

    mystery = {
        "Carne misteriosa. No preguntaré.",
        "Ni idea de qué era. Delicioso, eso sí.",
        "Fuera lo que fuera, ahora es parte de mí.",
        "Sabe a... digamos que a pollo.",
        "Ah, el cadáver del día.",
        "Sorpresa del chef. La sorpresa es que yo tampoco lo sé.",
        "Cata a ciegas. Mmm. Definitivamente muerto.",
        "No he mirado. Eso es la mitad de la gracia.",
        "Algún tipo de carne. Probablemente. Casi seguro.",
        "No me digan qué era. Prefiero no saberlo.",
    },

    any = {
        "Le falta sal. A todo le falta sal.",
        "Cinco sobre diez. Volvería a saquear la tumba.",
        "Fiambre. Mi favorito.",
        "Mmm. Recién muerto. Lo mejor.",
        "Mis felicitaciones a quien lo mató.",
        "¿Calorías? Los muertos no las contamos.",
        "No me hagan caso. Solo un tentempié.",
        "Le quito una estrella por los gritos de antes.",
        "Qué desastre. Como de forma muy desordenada.",
        "Este va directo a mi diario.",
        "Marida bien con una copa de peste.",
        "Ni mi mejor comida ni la peor.",
        "Cena con espectáculo. El espectáculo fue la matanza.",
    },

    dungeon = {
        "Cenar en mazmorra. El ambiente es sobre todo gritos.",
        "Alta cocina, bajo tierra. Traigan su propia antorcha.",
        "El servicio aquí es asesino. Cuatro estrellas.",
        "Mesa para cinco, y los lugareños vienen a nosotros.",
        "Recién sacado del pull. Más cerca del productor, imposible.",
        "El tanque trincha. Yo solo pruebo.",
        "Bonito sitio. Algo húmedo. El personal no deja de atacar.",
        "Sin carta, sin precios, todo lo que puedas comer. Mi tipo de local.",
        "Se come entre pulls. Es la regla del chef.",
        "El sanador dice que no puedo comerme eso. El sanador se equivoca.",
        "Cocina de pasillo. Estrecha, oscura y llena de sabor.",
        "Cada sala es un plato nuevo. Dosifíquense.",
        "¿Quién necesita una taberna? Aquí te lo traen. En oleadas.",
        "Esperen al siguiente pull. Voy por el segundo plato.",
        "No me esperen. Los alcanzo cuando termine el plato.",
        "Menú degustación, sala por sala.",
    },

    raid = {
        "Banquete para cuarenta. Yo me llevo las sobras.",
        "Noche de banda. El bufé no se acaba nunca.",
        "Cuarenta personas, y solo como yo. Más para mí.",
        "El botín se reparte, dijeron. Nadie dijo nada de la cena.",
        "Catering para un ejército. Literalmente.",
        "Sala grande, mucha gente, mucho apetito.",
        "Wipe o victoria, esta noche alguien acaba en el plato.",
        "Cocina de banda. Raciones enormes, mucha espera entre platos.",
        "Cuánto donde elegir. Uno de cada, por favor.",
        "Guárdenme sitio en el próximo jefe. Sigo con la morralla.",
    },

    -- By instance ID, as ns.VENUES. Forever's new places have no Spanish name we could check, so their
    -- lines don't name them (Krol'dok, Alcaz, Dalaran and Lordaeron are names in any language).
    venues = {
        [36] = {
            "Minas de la Muerte. De la mina a la mesa.",
            "Las Minas de la Muerte. Todo sabe a polvo de carbón y rencor.",
            "Minas de la Muerte. Cada comida aquí viene con casco de obra.",
            "Las Minas de la Muerte. Vine por el barco, me quedé por el bufé.",
        },
        [43] = {
            "Cuevas de los Lamentos. Los lamentos son sobre todo míos, masticando.",
            "Cuevas de los Lamentos. Húmedas, verdes y llenas de sueños. Sin los sueños, gracias.",
            "Cuevas de los Lamentos. Aquí todo dormía. Ahora es el almuerzo.",
        },
        [33] = {
            "Castillo de Colmillo Oscuro. La mejor cocina de castillo del Bosque de Argénteos.",
            "Colmillo Oscuro. Mansión vieja, carne vieja, bodega muy vieja.",
            "Castillo de Colmillo Oscuro. Cuidado con los pelos de huargen en la sopa.",
        },
        [34] = {
            "Las Mazmorras. Comida de cárcel, pero no me quejo.",
            "Las Mazmorras. Comida servida en la celda. Servicio de habitaciones.",
        },
        [389] = {
            "Sima Ígnea. Todo viene ya a la parrilla.",
            "Sima Ígnea. Buen calorcito. La carne está prácticamente ahumada.",
        },
        [48] = {
            "Cavernas de Brazanegra. La marisquería está abierta.",
            "Cavernas de Brazanegra. Todo empapado, pero las vistas son preciosas.",
        },
        [90] = {
            "Gnomeregan. Leves notas de aceite y radiación.",
            "Gnomeregan. Todo brilla un poco aquí. Condimento extra.",
        },
        [47] = RAZORFEN,
        [129] = RAZORFEN,
        [189] = {
            "Monasterio Escarlata. Tenían una cocina piadosa. La mía tiene hambre.",
            "El Monasterio. Juraron purgar a los míos. Está saliendo al revés.",
            "Monasterio Escarlata. Adobo de agua bendita. Pica un poco.",
        },
        [70] = {
            "Uldaman. Más viejo que la carta. Más viejo que el restaurante.",
            "Uldaman. Polvoriento, pero la cocina lleva aquí siglos.",
        },
        [209] = {
            "Zul'Farrak. Secado al sol. Un manjar del desierto.",
            "Zul'Farrak. Traigan agua. Aquí todo está saladísimo.",
        },
        [349] = {
            "Maraudon. Morado, húmedo y extrañamente floral.",
            "Maraudon. La ensalada del jardín muerde.",
        },
        [109] = {
            "El Templo Sumergido. Del pantano a la mesa.",
            "Templo Sumergido. Todo está empapado. Muy auténtico.",
        },
        [230] = {
            "Profundidades de Roca Negra. Cocina ardiente, cocineros Hierro Negro y un bar. No me voy nunca.",
            "Profundidades de Roca Negra. Marida bien con una cerveza Hierro Negro.",
        },
        [429] = {
            "La Masacre. Catering ogro, arquitectura élfica. Combinación rara.",
            "La Masacre. Palacio en ruinas, comida en ruinas. Me la como igual.",
        },
        [289] = {
            "Scholomance. Vuelta al colegio. El comedor no ha cambiado.",
            "Scholomance. Una vez asistí a una clase aquí. El profesor estaba delicioso.",
        },
        [329] = {
            "Stratholme. Comida casera. Literalmente, para algunos de nosotros.",
            "Stratholme. El grano estaba malo, la carne está peor. Me encanta.",
        },
        [229] = SPIRE,
        [409] = {
            "Núcleo de Magma. Todo está muy hecho. Demasiado hecho.",
            "Núcleo de Magma. La cocina está en llamas, y es la decoración.",
        },
        [249] = {
            "Guarida de Onyxia. Tantas crías, y ninguna de mi gusto.",
            "Guarida de Onyxia. Dragón en la carta, pero me toca conformarme con el personal.",
        },
        [469] = {
            "Guarida Alanegra. Los dragones arriba, la comida del personal abajo.",
            "Guarida Alanegra. Ahumada, escamosa, y una larga espera para conseguir mesa.",
        },
        [309] = {
            "Zul'Gurub. Cocina de la selva. Las sobras del dios de la sangre.",
            "Zul'Gurub. Picante. Aquí todo está empapado de mojo.",
        },
        [509] = AQ,
        [531] = AQ,
        [533] = {
            "Naxxramas. Cena en la vieja casa familiar.",
            "Naxxramas. Kel'Thuzad nunca nos alimentó tan bien.",
            "Naxxramas. La cocina de la Plaga en persona. Me sé las recetas.",
        },

        -- New in Forever
        [3065] = {
            "Comer entre reyes enanos. Ya no se quejan.",
            "Los saqueadores se llevaron el oro y dejaron lo bueno.",
            "Tumba real, raciones reales.",
        },
        [2999] = {
            "Ruinas de Lordaeron. Comida casera. Yo vivía arriba.",
            "Lordaeron. La vieja capital aún sirve una Plaga excelente.",
            "Ruinas de Lordaeron. Comer en el suelo del salón del trono. Arthas estaría horrorizado. Mejor.",
        },
        [2998] = {
            "Parte de esta carne es más vieja que la excavación.",
            "La excavación. Ellos vinieron por las reliquias. Yo, por el almuerzo.",
            "Intacto durante siglos, y ahora con mi mordisco.",
        },
        [2959] = {
            "Dalaran. Todo sabe un poco a arcano. Como lamer una varita.",
            "Dalaran. Los hechizos se desbocan, y mi apetito también.",
            "Dalaran. Espero que este no fuera una oveja hace cinco minutos.",
        },
        [2970] = {
            "Una ciudad sumergida. Mar y montaña, sobre todo mar.",
            "Viejas ruinas trols, saladas al punto por el mar.",
            "Guarnición de algas en todo. El chef insiste.",
        },
        [3039] = {
            "Krol'dok. Raciones de ogro. Lo apruebo.",
            "Krol'dok. Los ogros guardaban cautivos para la olla. Yo solo sigo la receta de la casa.",
            "Krol'dok. Cocina grande, cocineros aún más grandes.",
        },
        [2994] = {
            "Alcaz. Defias y nagas en el mismo menú. Cocina fusión.",
            "Alcaz. Comida de cárcel otra vez. Siempre acabo en estos sitios.",
            "Alcaz. Celdas húmedas, invitados salados.",
        },
        [2974] = {
            "Aquí algo no va bien. Hasta yo lo noto en el sabor.",
            "Corrompido, dicen. Madurado, digo yo.",
            "Peludo, fuerte de sabor y un poco enfermo. Como en casa.",
        },
        [3001] = {
            "Piedra de titanes, vistas a Un'Goro. Cinco estrellas por el entorno.",
            "Los cristales zumban mientras como. Música de sobremesa.",
            "Aquí todo fue moldeado alguna vez. Ahora lo remodelo yo.",
        },
        [3109] = {
            "La mansión encantada del Bosque del Ocaso. El comedor más bonito de la zona.",
            "Bonita casa vieja. El anfitrión es un poco posesivo.",
            "A la luz de las velas, entre telarañas, y nadie volverá a fregar los platos.",
        },
    },
}
