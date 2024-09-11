------------------------------------------------------------------
--                         POKEMON (POL)                        --
------------------------------------------------------------------


--Query per buscar la formula del growth_rate associat a un pokemon, juntamanet amb l'experiència per pujar 
--a cada nivell.

SELECT * FROM GROWTH_RATE
WHERE GROWTH_RATE.formula = 
(SELECT GROWTH_RATE.formula
FROM GROWTH_RATE
INNER JOIN POKEMON ON POKEMON.id_growth_rate = GROWTH_RATE.id_pk
WHERE POKEMON.name_pokemon like 'sentret');


--Query per mostrar els tipus de cada pokemon, on el primer és obligatori i el segon opcional
SELECT POKEMON.name_pokemon, type1.name_type,  type2.name_type
FROM POKEMON
INNER JOIN TYPE_POKEMON AS type1 ON type1.id_type = POKEMON.id_type_1
LEFT JOIN TYPE_POKEMON AS type2 ON type2.id_type = POKEMON.id_type_2;

--Query per buscar els stats base d'una espècie pokemon en concret
SELECT stat.name  , acstat.base_value,  acstat.effort
FROM POKEMON 
INNER JOIN ACQUIRE_BASE_STAT as acstat ON acstat.id_pokemon = POKEMON.id_pokemon
INNER JOIN BASE_STAT as stat ON stat.id_base_stat = acstat.id_base_stat
WHERE POKEMON.name_pokemon LIKE 'dratini';

--Query per mostrar el stat que incrementnta i que decrementa i quin sabaor li agrada i desagrada
SELECT NATURE.name_nature as nature ,b1.name as stat_increase, b2.name as stat_decrease, f1.name as flavour_like, f2.name as flavour_dislike 
FROM NATURE
LEFT JOIN BASE_STAT as b1 ON b1.id_base_stat = NATURE.id_stat_incremented
LEFT JOIN BASE_STAT as b2 ON b2.id_base_stat = NATURE.id_stat_decremented
LEFT JOIN FLAVOUR as f1 ON f1.id_flavour = NATURE.id_flavour_like
LEFT JOIN FLAVOUR as f2 ON f2.id_flavour = NATURE.id_flavour_dislike;

--Query per mostrar les possibles habilitats de cada pokemon
SELECT POKEMON.name_pokemon, ABILITY.name_ability , slot, is_hidden 
FROM ABILITY_POKEMON
INNER JOIN POKEMON ON POKEMON.id_pokemon = ABILITY_POKEMON.id_pokemon
INNER JOIN ABILITY ON ABILITY.id_ability = ABILITY_POKEMON.id_ability;

--Query per mostrar quin els multiplicadors que té un tipus en concret contra uns altres
SELECT type2.name_type as defender, TYPE_AGAINST.multiplier
FROM TYPE_AGAINST 
INNER JOIN TYPE_POKEMON as type1 ON type1.id_type = TYPE_AGAINST.id_type_attacker
INNER JOIN TYPE_POKEMON as type2 ON type2.id_type = TYPE_AGAINST.id_type_defender
WHERE type1.name_type LIKE 'water'
ORDER BY TYPE_AGAINST.multiplier DESC;


--Query per mostrar tots els objectes que enseyen un moviment i el nom d'aquest 
SELECT ITEM.name_object, POKEMON_MOVE.name_move
FROM TM_HM
INNER JOIN ITEM ON ITEM.id_object = TM_HM.id_mt
INNER JOIN POKEMON_MOVE ON POKEMON_MOVE.id_move = TM_HM.id_move
ORDER BY name_object asc;


------------------------------------------------------------------
--                       TRAINERS (JOAN)                        --
------------------------------------------------------------------


-- Aquesta comanda mostrara a l'entrenadora que hem escollit com a ratolí de laboratori per fer aquesta
-- comprovació. Hola Gema, benvinguda al mon POKEMON!
-- (C1)
SELECT * FROM TRAINER where id_trainer = 0;

-- Aquesta comanda mostrara als gym leaders importats al fitxer trainer.
-- (C2)
SELECT * 
FROM TRAINER
where item_gift_leader is not null
;

-- Aquesta comanda mostrara que les id's dels gym leaders han estat ben relacionades amb la taula GYM
-- Podem veure com el nom coincideix amb la medalla que atorga en el joc, i tambe amb el nom del gimnas.
-- (C3)
SELECT GYM.id_gym, GYM.id_city, GYM.id_type, TRAINER.name_trainer, GYM.gym_name, GYM.gym_badge_leader 
FROM GYM
JOIN TRAINER ON TRAINER.id_trainer = GYM.id_trainer
;

-- Aquesta comanda mostrara tots els entrenadors malvats, la seva id amb el seu nom i la id del seu company
-- i també el seu nom.
-- (C4)
SELECT EV1.id_trainer, TR1.name_trainer, EV1.id_partner, TR2.name_trainer
FROM EVIL_TRAINER as EV1 
JOIN TRAINER as TR1 ON EV1.id_trainer = TR1.id_trainer
JOIN TRAINER as TR2 ON EV1.id_partner = TR2.id_trainer
;

-- Aquesta comanada mostrara la id dels entrenadors malvats i a quina organitzacio pertanyen així com el nom
-- d'aquesta i el del seu líder.
-- (C5)
SELECT EV.id_trainer, O.id_organization, O.leader_name, O.name_organization
FROM EVIL_TRAINER as EV
JOIN ORGANIZATION as O ON EV.id_organization = O.id_organization
;

-- Aquesta comanda mostrara tots els gimnasos que ha completat l'entrenador amb id (0..n). Podem veure que hi ha 32
-- columnes que coincideixen amb el nombre de gimnasos del fitxer gyms.csv
-- (C6)
SELECT * FROM BATTLES_IN WHERE id_trainer = 0;
-- Tambe es interessant saber que al igual que en els jocs oficials, tant liders de gimnas com entrenadors
-- malvats no poden pas participar en gimnasos, i per tant no seran inclosos en aquesta taula.
-- per fer la demostracio provarem amb 2 id's de entrenadors amb aquestes caracteristiques i veurem
-- com no apareixen
-- (C7)
SELECT * FROM BATTLES_IN WHERE id_trainer = 403;
SELECT * FROM BATTLES_IN WHERE id_trainer = 500
;

-- Aquesta comanda mostrara quins pokemons ha capturat l'entrendor amb id (0..n). Per l'exemple posarem
-- a la nostra Gema!
-- (C8)
SELECT PC.id_pokemon_caught, PC.id_pokemon, PC.nick_name, PC.pokemon_status_condition, PC.pokemon_max_hp,
	PC.pokemon_remaining_hp
FROM POKEMON_CAUGHT as PC
JOIN TRAINER as TR ON TR.id_trainer = PC.id_trainer
WHERE TR.id_trainer = 0
ORDER BY 1
;

-- Veurem que aquells que tenen "null" en l'estatus seran els que no pertanyen a l'equip de Pokemon
-- que ara porta l'entrenadora amb ella. I els te guardats al PC del Centre Pokemon.
-- Amb la comanda que hi ha a continuacio posarem llum a la foscor, seleccionant els Pokemon que la
-- Gema porta ara mateix amb ella.
-- (C9)
SELECT TEAM.id_pokemon_caught, PC.nick_name, TEAM.slot
FROM TEAM
JOIN POKEMON_CAUGHT as PC ON TEAM.id_pokemon_caught = PC.id_pokemon_caught
JOIN TRAINER as TR ON TEAM.id_trainer = TR.id_trainer
WHERE TR.id_trainer = 0
ORDER BY 1
;

-- Ara anem a veure les estadistiques de combat de'n Shorty, Pokemon que pertany a l'equip de l'entrenadora
-- amb id 0, Gema! El pobre Shorty si ens fixem en comandes anteriors podem veure que ha estat congelat i 
-- en aquests moments debilitat amb 0 PS restants.
-- Aquesta comanda ens mostrara que es el que ha passat.
-- (C10)
SELECT BE.id_battle, PC.nick_name, TR.name_trainer, BS.damage_received, BS.damage_dealt
FROM BATTLE_STATS as BS
JOIN BATTLE as BE on BE.id_battle = BS.id_battle
JOIN TRAINER as TR on TR.id_trainer = BE.trainer_winner or TR.id_trainer = BE.trainer_loser
JOIN POKEMON_CAUGHT as PC on BS.id_pokemon_caught = PC.id_pokemon_caught
WHERE TR.id_trainer = 0 and PC.nick_name LIKE '%Shorty%'
;

-- S'han disputat un total de 600 combats entre tots els entrenadors. La comanda que hi ha a
-- continuacio provara que no dic mentides.
-- (C11)
SELECT DISTINCT id_battle FROM BATTLE
ORDER BY 1 DESC
;

-- Per tant tindrem com a minim informacio de 600 combats en la taula de estadistiques, nomes
-- mostrarem 1 pokemon per combat independentment sigui de l'entrenador guanyador o perdedor
-- (C12)
SELECT DISTINCT ON (id_battle) id_pokemon_caught, id_battle FROM BATTLE_STATS
ORDER BY 2 DESC
;
-- i ara tots els pokemons de cada combat, al ser 6 Pokemon per 2 entrenadors tindrem 12 camps per
-- cada batalla realitzada (com a maxim). Selecionarem el combat 600.
-- (C13)
SELECT id_pokemon_caught, id_battle FROM BATTLE_STATS
WHERE id_battle = 599
;

-- finalment, com tots els entrenadors tenen motxilla, independentment si son malevols o liders de gimnas,
-- ja que tots poden tenir objectes en combat. Verificarem que tots els entrenadors, tingui objectes a la seva motxilla.
-- Aquesta comanda realitza un analisi exhaustiu de la bossa de tots els entrenadors (en el csv 8357 columnes)
-- (C14)
SELECT * FROM CONTAINS_ITEM as CI
JOIN BACKPACK as BK on BK.id_backpack = CI.id_backpack
JOIN TRAINER as TR on TR.id_trainer = BK.id_backpack
;

------------------------------------------------------------------
--                       ITEMS (ANDREA)                         --
------------------------------------------------------------------

-- QUERY 1 - ITEMS
SELECT name_object, quick_sell_price FROM ITEM
WHERE quick_sell_price is not NULL
ORDER BY ITEM.id_object ASC;

-- QUERY 2 - TREASURE
SELECT ITEM.name_object, collector_price FROM TREASURE
INNER JOIN ITEM on TREASURE.id_treasure = item.id_object
ORDER BY ITEM.id_object asc;

--QUERY 3 - POKEBALL
SELECT ITEM.name_object, max_ratium, min_ratium FROM POKEBALL
INNER JOIN ITEM ON POKEBALL.id_pokeball = ITEM.id_object
ORDER BY POKEBALL.id_pokeball desc;

-- QUERY 4 - BERRY
SELECT name, growth_time, firmness, max_num_harvest FROM BERRY
INNER JOIN ITEM ON BERRY.id_berry = ITEM.id_object
WHERE ITEM.name_object = BERRY.name AND BERRY.firmness = 'soft' AND BERRY.max_num_harvest = 10
ORDER BY BERRY.id_berry ASC;

-- QUERY 5 - FLAVOUR
SELECT* FROM FLAVOUR
ORDER BY FLAVOUR.id_flavour ASC;

-- QUERY 6 - BERRY_FLAVOUR
SELECT BERRY.name, BERRY_FLAVOUR.boost, FLAVOUR.name FROM BERRY_FLAVOUR
INNER JOIN BERRY ON BERRY.id_berry = BERRY_FLAVOUR.id_berry
INNER JOIN FLAVOUR ON FLAVOUR.id_flavour = BERRY_FLAVOUR.id_flavour
WHERE BERRY.id_berry = BERRY_FLAVOUR.id_berry AND BERRY_FLAVOUR.boost < 15 AND FLAVOUR.name = 'spicy'
ORDER BY BERRY.name ASC
LIMIT 10;

-- QUERY 7 - HEAL
SELECT ITEM.name_object, HEAL.heal_points, HEAL.can_revive FROM HEAL
INNER JOIN ITEM ON HEAL.id_heal = ITEM.id_object
WHERE ITEM.id_object = HEAL.id_heal AND HEAL.heal_points IS NOT NULL
ORDER BY HEAL.id_heal ASC;

-- QUERY 8 - BOOSTER
SELECT BOOSTER.stat_increase_time, BOOSTER.id_booster, 
BASE_STAT.name FROM BOOSTER
INNER JOIN ITEM ON BOOSTER.id_booster = ITEM.id_object
INNER JOIN BASE_STAT ON BASE_STAT.id_base_stat = BOOSTER.id_stat
WHERE ITEM.id_object = BOOSTER.id_booster 
ORDER BY BOOSTER.id_booster ASC;

-- QUERY 9 - SELLS + STORE
SELECT ITEM.name_object, STORE.store_name, ITEM.base_price_object, 
SELLS.discount, SELLS.stock FROM ITEM
INNER JOIN SELLS ON SELLS.id_object = ITEM.id_object
INNER JOIN STORE ON STORE.id_store = SELLS.id_store
WHERE ITEM.id_object = SELLS.id_object AND SELLS.discount > 50 AND SELLS.stock < 10
ORDER BY SELLS.discount ASC;

-- QUERY 10 - TMHM + MOVES
SELECT ITEM.name_object, POKEMON_MOVE.name_move
FROM TM_HM
INNER JOIN ITEM ON ITEM.id_object = TM_HM.id_mt
INNER JOIN POKEMON_MOVE ON POKEMON_MOVE.id_move = TM_HM.id_move
ORDER BY name_object asc;

-- QUERY 11 - BUYS + TRAINER + ITEM + STORE
SELECT TRAINER.name_trainer, ITEM.name_object, ITEM.description_object, 
ITEM.base_price_object, BUYS.amount, BUYS.discount, 
BUYS.cost as TOTAL_PRICE, BUYS.date_time, 
STORE.store_name FROM BUYS
INNER JOIN ITEM ON BUYS.id_object = ITEM.id_object
INNER JOIN TRAINER ON TRAINER.id_trainer = BUYS.id_trainer
INNER JOIN STORE ON STORE.id_store = BUYS.id_store AND TRAINER.name_trainer = 'Adan'
ORDER BY TRAINER.name_trainer ASC;

-- GENERAL QUERIES
SELECT * FROM ITEM;
SELECT * FROM SELLS;
SELECT * FROM STORE;
SELECT * FROM BUYS;
SELECT * FROM BOOSTER;
SELECT * FROM TMHM;
SELECT * FROM TREASURE;
SELECT * FROM HEAL;
SELECT * FROM BERRY;
SELECT * FROM POKEBALL;
SELECT * FROM BERRY_FLAVOUR;
SELECT * FROM FLAVOUR;


------------------------------------------------------------------
--                        REGION (LEO)                          --
------------------------------------------------------------------

-- QUERY 1 - REGION
(SELECT region FROM LOCATIONS_INSERTION)
EXCEPT
(SELECT region_name FROM REGION);

-- QUERY 2 - AREA
(SELECT region, area 
FROM LOCATIONS_INSERTION)
EXCEPT
(SELECT region_name, area_name 
FROM AREA
INNER JOIN REGION ON REGION.id_region = AREA.id_region);

-- QUERY 3 - SUBAREA
(SELECT 
        region, 
        area, 
        subarea, 
        subareaID 
FROM 
        LOCATIONS_INSERTION 
WHERE 
        subareaID IS NOT NULL)
EXCEPT
(SELECT 
        region_name, 
        area_name, 
        subarea_name,
        id_subarea 
FROM 
        SUBAREA
        INNER JOIN AREA ON AREA.id_area = SUBAREA.id_area
        INNER JOIN REGION ON REGION.id_region = AREA.id_region);

-- QUERY 4 - CITY
(SELECT 
        region, 
        area, 
        population 
FROM 
        LOCATIONS_INSERTION
WHERE 
        population IS NOT NULL)
EXCEPT
(SELECT 
        region_name, 
        area_name, 
        population 
FROM 
        CITY
        INNER JOIN AREA ON AREA.id_area = CITY.id_area
        INNER JOIN REGION ON REGION.id_region = AREA.id_region);

-- QUERY 5 - ROUTE
(SELECT 
        LOWER(route) route,
        LOWER(north) north, 
        LOWER(east) east, 
        LOWER(west) west, 
        LOWER(south) south, 
        pavement 
FROM 
        ROUTE_INSERTION)
EXCEPT
(SELECT 
        a1.area_name, 
        north.area_name, 
        east.area_name, 
        west.area_name, 
        south.area_name, 
        pavement 
FROM 
        ROUTE
        INNER JOIN AREA AS a1 ON a1.id_area = ROUTE.id_area
	LEFT JOIN AREA AS north ON north.id_area = ROUTE.north
	LEFT JOIN AREA AS east ON east.id_area = ROUTE.east
	LEFT JOIN AREA AS west ON west.id_area = ROUTE.west
	LEFT JOIN AREA AS south ON south.id_area = ROUTE.south);

-- QUERY 6 - ENCOUNTERS
(SELECT 
        pokemon,
        subareaID, 
        method_to_find, 
        condition_type, 
        condition_value, 
        chance, min_level, 
        max_level 
FROM 
        ENCOUNTERS_INSERTION)
EXCEPT
(SELECT 
        POKEMON.name_pokemon, 
        ENCOUNTERS.id_subarea, 
        method_to_find, 
        condition_type, 
        condition_value, 
        chance, 
        min_level, 
        max_level
FROM 
        ENCOUNTERS
        INNER JOIN POKEMON ON POKEMON.id_pokemon = ENCOUNTERS.id_pokemon
        INNER JOIN SUBAREA ON SUBAREA.id_subarea = ENCOUNTERS.id_subarea);

-- QUERY 7 - GYM
(SELECT 
        leader, 
        LOWER(location_name) location_name,
        LOWER(type_name) type_name, 
        badge, 
        gym_name
FROM 
        GYM_INSERTION)
EXCEPT
(SELECT 
        TRAINER.name_trainer, 
        AREA.area_name, 
        TYPE_POKEMON.name_type, 
        gym_badge_leader, 
        gym_name
FROM 
        GYM
        INNER JOIN CITY ON CITY.id_city = GYM.id_city
        INNER JOIN AREA ON AREA.id_area = CITY.id_area
        INNER JOIN TYPE_POKEMON ON TYPE_POKEMON.id_type = GYM.id_type
        INNER JOIN TRAINER ON TRAINER.id_trainer = GYM.id_trainer);

-- GENERAL QUERIES
SELECT * FROM REGION;
SELECT * FROM AREA;
SELECT * FROM CITY;
SELECT * FROM GYM;
SELECT * FROM ROUTE;
SELECT * FROM SUBAREA;
SELECT * FROM ENCOUNTERS;
SELECT * FROM POKEMON;
SELECT * FROM TYPE_POKEMON;

SELECT * FROM ROUTE
INNER JOIN AREA ON AREA.id_area = ROUTE.id_area
LEFT JOIN AREA AS a1 ON a1.id_area = ROUTE.north
LEFT JOIN AREA AS a2 ON a2.id_area = ROUTE.east
LEFT JOIN AREA AS a3 ON a3.id_area = ROUTE.west
LEFT JOIN AREA AS a4 ON a4.id_area = ROUTE.south
WHERE AREA.area_name LIKE 'route 48';

SELECT * FROM ROUTE;

SELECT * FROM AREA WHERE area_name LIKE 'hoenn pokemon league' OR 'johto pokemon league';

