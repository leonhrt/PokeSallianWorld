-------------------------- DROP TEMP TABLES -----------------------------
-------------------------------------------------------------------------
DROP TABLE IF EXISTS INSERTION_TYPE;
DROP TABLE IF EXISTS INSERTION_STATS;
DROP TABLE IF EXISTS INSERTION_GROWTH_RATE;
DROP TABLE IF EXISTS INSERTION_POKEMON;
DROP TABLE IF EXISTS INSERTION_ABILITIES;
DROP TABLE IF EXISTS INSERTION_ABILITIES_POKEMON;
DROP TABLE IF EXISTS INSERTION_NATURE;
DROP TABLE IF EXISTS INSERTION_MOVES;
DROP TABLE IF EXISTS INSERTION_ITEM;
DROP TABLE IF EXISTS INSERTION_BERRY;
DROP TABLE IF EXISTS INSERTION_BERRIES_FLAVOURS;
DROP TABLE IF EXISTS DAMAGE_RELATIONS;
DROP TABLE IF EXISTS INSERTION_TRAINERS;
DROP TABLE IF EXISTS INSERTION_ORGANIZATION;
DROP TABLE IF EXISTS INSERTION_BATTLE;
DROP TABLE IF EXISTS INSERTION_BATTLE_STATS;
DROP TABLE IF EXISTS LOCATIONS_INSERTION;
DROP TABLE IF EXISTS ROUTE_INSERTION;
DROP TABLE IF EXISTS GYM_INSERTION;
DROP TABLE IF EXISTS ENCOUNTERS_INSERTION;
DROP TABLE IF EXISTS POKEMON_INSTANCES_INSERTION;
DROP TABLE IF EXISTS TRAINER_ITEMS_INSERTION;
DROP TABLE IF EXISTS INSERTION_TO_TEAMS;
DROP TABLE IF EXISTS INSERTION_EVOLUTIONS;
DROP TABLE IF EXISTS INSERTION_STORES;
DROP TABLE IF EXISTS INSERTION_ITEM_STORES;


---------------------- SCRIPT INSERTION IN TABLES ------------------------
-- Aquest script es divideix en dues parts:
--
-- PART 1) La de creacio de taules temporals.
--
-- Serviran per poder llegir els fitxers .csv a una taula preparada
-- per suportar els camps del fitxer.
--
-- ATENCIO! Aquestes taules seran esborrades al final de l'script i, per
-- tant, no es podra realitzar cap consulta d'informacio des de 
-- fora d'aquest script.
--
-- PART 2) La propia insercio a les taules de la BBDD.
--
-- Seran les insercions a la bbdd amb els pertanyents camps d'aquesta.
-- Aquesta part tambe tindra comentaris sobre cada comanda amb el nom 
-- de la taula a la qual fa insercio, i tambe les taules que han d'omplir-se
-- obligatoriament abans de fer la insercio.
--
-- Damunt d'aquests te el recompte de camps que han d'estar previament
-- inserits "(0..n)", un asterisc si en la insercio es
-- necessita una taula que no es del propi creador de la comanda d'insercio.
-- (Els camps que s'han d'afegir en els casos asterisc es deixen en format
-- comentari per poder visualitzar quin camp quedaria amb informacio erronia) 
--
-- Finalment tambe es posara el nom del creador d'aquesta
--
-- (*) Si es dona un dels casos d'asterisc voldra dir que aquella taula
-- s'omplira a partir de dues insercions, una primera que omplira totes
-- les dades de la taula i una segona que modificara algunes d'aquestes.
--
-- ATENCIO! S'ha d'executar TOT el script per que les taules quedin ben
-- creades. Si nomes s'executa la part 1 i 2 sense la contemplacio dels
-- casos asterisc les taules poden contenir informacio erronia.
--
-- ATENCIO! No es pot tocar l'ordre d'insercio "2)" a les taules pero si
-- que es pot afegir altres ordres d'insercio tant al principi 
-- com al final d'aquest script.
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--                               PART 1                                 --
--------------------------------------------------------------------------

CREATE TEMPORARY TABLE IF NOT EXISTS INSERTION_ITEM (
	id SERIAL PRIMARY KEY,
	name VARCHAR (50),
	cost INTEGER,
	effect VARCHAR (5000),
	healing VARCHAR(50),
	can_revive BOOLEAN,
	statistic VARCHAR (50),
	stat_increase_time INTEGER,
	top_capture_rate INTEGER,
	min_capture_rate INTEGER,
	quick_sell_price INTEGER,
	collector_price INTEGER,
	move VARCHAR (50)
);

COPY INSERTION_ITEM (id,name,cost,effect,healing,can_revive,statistic,stat_increase_time,top_capture_rate,min_capture_rate,quick_sell_price,collector_price,move)
FROM 'C:\Users\Public\bbdd_csv\items.csv'
DELIMITER ',' CSV HEADER;

CREATE TEMPORARY TABLE IF NOT EXISTS INSERTION_BERRY (
	id SERIAL PRIMARY KEY,
	name VARCHAR (50),
	growth_time INTEGER,
	max_num_harvest INTEGER,
	natural_gift_powder INTEGER,
	berry_avg_size INTEGER,
	smoothness INTEGER,
	soil_dryness INTEGER,
	firmness VARCHAR (50)
);

COPY INSERTION_BERRY (id,name,growth_time, max_num_harvest, natural_gift_powder, berry_avg_size, smoothness, soil_dryness, firmness)
FROM 'C:\Users\Public\bbdd_csv\berries.csv'
DELIMITER ',' CSV HEADER;

CREATE TEMPORARY TABLE IF NOT EXISTS INSERTION_BERRIES_FLAVOURS (
	berry VARCHAR(50),
	flavour VARCHAR(50),
	potency INTEGER
);

COPY INSERTION_BERRIES_FLAVOURS (berry, flavour, potency)
FROM 'C:\Users\Public\bbdd_csv\berries_flavours.csv'
DELIMITER ',' CSV HEADER;

CREATE TEMPORARY TABLE INSERTION_GROWTH_RATE (
	id INTEGER,
	name varchar (50),
	formula varchar(1000),
	level INTEGER,
	experience INTEGER
);

COPY INSERTION_GROWTH_RATE (id,name,formula,level,experience)
FROM 'C:\Users\Public\bbdd_csv\growth_rates.csv'
DELIMITER ',' CSV HEADER;

CREATE TEMPORARY TABLE IF NOT EXISTS INSERTION_TYPE (
	id SERIAL primary key,
	name VARCHAR(50)
);

COPY INSERTION_TYPE (id,name)
FROM 'C:\Users\Public\bbdd_csv\types.csv'
DELIMITER ',' CSV HEADER;

CREATE TEMPORARY TABLE IF NOT EXISTS DAMAGE_RELATIONS(
	id SERIAL PRIMARY KEY,
	attacker VARCHAR(50),
	defender VARCHAR(50),
	multiplier VARCHAR(10)
);

COPY DAMAGE_RELATIONS (attacker,defender,multiplier)
FROM 'C:\Users\Public\bbdd_csv\damage_relations.csv'
DELIMITER ',' CSV HEADER;

CREATE TEMPORARY TABLE IF NOT EXISTS INSERTION_POKEMON (
	id_pokemon SERIAL,
	pokemon VARCHAR(50),
	baseExperience INTEGER,
	height INTEGER,
	weight INTEGER,
	dex_order INTEGER,
	growth_rate_ID INTEGER,
	type1  VARCHAR(50),
    type2  VARCHAR(50)

);

COPY INSERTION_POKEMON (id_pokemon,pokemon,baseExperience,height,weight,dex_order,growth_rate_ID,type1,type2)
FROM 'C:\Users\Public\bbdd_csv\pokemon.csv'
DELIMITER ',' CSV HEADER;

CREATE TEMPORARY TABLE IF NOT EXISTS INSERTION_STATS(
	id SERIAL PRIMARY KEY,
	stat VARCHAR(20),
	pokemon VARCHAR (30),
	base_stat INTEGER,
	effort INTEGER
);

COPY INSERTION_STATS (stat,pokemon,base_stat,effort)
FROM 'C:\Users\Public\bbdd_csv\stats.csv'
DELIMITER ',' CSV HEADER;

CREATE TEMPORARY TABLE IF NOT EXISTS INSERTION_ABILITIES(
	id SERIAL PRIMARY KEY,
	name VARCHAR (50),
	effect VARCHAR (5000),
	short_effect VARCHAR (300)
);

COPY INSERTION_ABILITIES (id,name,effect,short_effect)
FROM 'C:\Users\Public\bbdd_csv\abilities.csv'
DELIMITER ',' CSV HEADER;

CREATE TEMPORARY TABLE IF NOT EXISTS INSERTION_ABILITIES_POKEMON(
	id SERIAL PRIMARY KEY,
	speciesID INTEGER,
	abilityID INTEGER,
	slot INTEGER,
	is_hidden BOOLEAN
);

COPY INSERTION_ABILITIES_POKEMON (speciesID,abilityID,slot,is_hidden)
FROM 'C:\Users\Public\bbdd_csv\pokemon_abilities.csv'
DELIMITER ',' CSV HEADER;
SELECT * FROM INSERTION_ABILITIES_POKEMON;

CREATE TEMPORARY TABLE IF NOT EXISTS INSERTION_NATURE(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	decreased_stat VARCHAR (50),
	increased_stat VARCHAR (50),
	likes_flavor VARCHAR (50),
	hates_flavor  VARCHAR (50)
);

COPY INSERTION_NATURE (name, id,decreased_stat,increased_stat,likes_flavor,hates_flavor)
FROM 'C:\Users\Public\bbdd_csv\natures.csv'
DELIMITER ',' CSV HEADER;

CREATE TEMPORARY TABLE IF NOT EXISTS INSERTION_MOVES(
	move_id SERIAL PRIMARY KEY,
	name VARCHAR (50),
	accuracy INTEGER, 
	effect VARCHAR (200),
	pp INTEGER,
	priority INTEGER,
	target VARCHAR (50),
	type VARCHAR (50),
	move_damage_class VARCHAR (50),
	hp_healing INTEGER,
	hp_drain INTEGER,
	power INTEGER,
	flinch_chance INTEGER,
	min_hits INTEGER,
	max_hits INTEGER,
	ailment VARCHAR(50),
	ailment_chance INTEGER,
	stat VARCHAR (50),
	stat_change_rate INTEGER,
	change_amount INTEGER
);

COPY INSERTION_MOVES (move_id,name,accuracy,effect,pp,priority,target,type,move_damage_class,hp_healing,hp_drain,power,flinch_chance,min_hits,max_hits,ailment,ailment_chance,stat,stat_change_rate,change_amount)
FROM 'C:\Users\Public\bbdd_csv\moves.csv'
DELIMITER ',' CSV HEADER;
SELECT * FROM INSERTION_MOVES;

CREATE TEMPORARY TABLE INSERTION_EVOLUTIONS(
	id SERIAL PRIMARY KEY,
	baseID VARCHAR(50),
	evolutionID VARCHAR (50),
	is_baby BOOLEAN,
	trigger_ie VARCHAR (50),
	gender VARCHAR(50),
	min_level INTEGER,
	time_of_day VARCHAR (50),
	location_ie VARCHAR(50),
	item VARCHAR (50),
	known_move VARCHAR(50),
	min_happiness VARCHAR(50)	
);

COPY INSERTION_EVOLUTIONS (baseID,evolutionID,is_baby,trigger_ie,gender,min_level,time_of_day,location_ie,item,known_move,min_happiness)
FROM 'C:\BBDD_csv\DB-2022-2023-datasets\evolutions.csv'
DELIMITER ',' CSV HEADER;

SELECT * FROM INSERTION_EVOLUTIONS
WHERE min_level::INTEGER = 20;

-- Lectura del fitxer "villainous_organizations.csv".
CREATE TABLE IF NOT EXISTS INSERTION_ORGANIZATION (
	name varchar (50),
	building varchar (50),
	hq varchar (50),
	leader varchar (50),
	region varchar (50)
);

COPY INSERTION_ORGANIZATION (name,building,hq,leader,region)
FROM 'C:\Users\Public\bbdd_csv\villainous_organizations.csv'
DELIMITER ',' CSV HEADER;

-- Lectura del fitxer "trainer.csv"
CREATE TABLE IF NOT EXISTS INSERTION_TRAINERS (
	id_tr serial primary key,
	trainer_class varchar (50),
	name varchar (50),
	experience varchar(50),
	gold varchar(50),
	gift_item varchar(50),
	villain_team varchar(50),
	partnerID varchar(50),
	phrase varchar (200),
	money_stolen varchar(50)
);

COPY INSERTION_TRAINERS (id_tr,trainer_class,name,experience,gold,gift_item,villain_team,partnerID,phrase,money_stolen)
FROM 'C:\Users\Public\bbdd_csv\trainers.csv'
DELIMITER ',' CSV HEADER;

-- Lectura del fitxer "battles.csv"
CREATE TABLE IF NOT EXISTS INSERTION_BATTLE (
	battleID integer,
	winnerID integer,
	loserID integer,
	date_time date,
	gold_reward integer,
	experience integer,
	duration integer
);

COPY INSERTION_BATTLE (battleID, winnerID, loserID, date_time, gold_reward, experience, duration)
FROM 'C:\Users\Public\bbdd_csv\battles.csv'
DELIMITER ',' CSV HEADER;

-- Lectura del fitxer "battle_statistics.csv"
CREATE TABLE IF NOT EXISTS INSERTION_BATTLE_STATS (
	battleID INTEGER,
	pokemon_instanceID INTEGER,
	remaining_hp INTEGER,
	damage_received INTEGER,
	damage_dealt INTEGER
)
;

COPY INSERTION_BATTLE_STATS (battleID,pokemon_instanceID,remaining_hp,damage_received,damage_dealt)
FROM 'C:\Users\Public\bbdd_csv\battle_statistics.csv'
DELIMITER ',' CSV HEADER;

-- Lectura del fitxer "locations.csv"
CREATE TABLE IF NOT EXISTS LOCATIONS_INSERTION(
	region VARCHAR(50),
	area VARCHAR(50),
	subarea VARCHAR(50),
	subareaID INTEGER,
	population INTEGER
);

COPY LOCATIONS_INSERTION 
FROM 'C:\Users\Public\bbdd_csv\locations.csv'
DELIMITER ',' 
CSV HEADER;

-- Lectura del fitxer "routes.csv"
CREATE TABLE IF NOT EXISTS ROUTE_INSERTION(
	route VARCHAR(50),
	north VARCHAR(50),
	east VARCHAR(50),
	west VARCHAR(50),
	south VARCHAR(50),
	pavement VARCHAR(50)
);

COPY ROUTE_INSERTION 
FROM 'C:\Users\Public\bbdd_csv\routes.csv'
DELIMITER ',' 
CSV HEADER;

-- Lectura del fitxer "gyms.csv"
CREATE TABLE IF NOT EXISTS GYM_INSERTION(
	leader VARCHAR(50),
	location_name VARCHAR(50),
	type_name VARCHAR(50),
	badge VARCHAR(50),
	gym_name VARCHAR(50)
);

COPY GYM_INSERTION 
FROM 'C:\Users\Public\bbdd_csv\gyms.csv'
DELIMITER ',' 
CSV HEADER;

-- Lectura del fitxer "encounters.csv"
CREATE TABLE IF NOT EXISTS ENCOUNTERS_INSERTION(
	pokemon VARCHAR(50),
	subareaID INTEGER,
	method_to_find VARCHAR(50),
	condition_type VARCHAR(50),
	condition_value VARCHAR(50),
	chance INTEGER,
	min_level INTEGER,
	max_level INTEGER
);

COPY ENCOUNTERS_INSERTION 
FROM 'C:\Users\Public\bbdd_csv\encounters.csv'
DELIMITER ',' 
CSV HEADER;

-- Lectura del fitxer "pokemon_instances.csv"
CREATE TABLE IF NOT EXISTS POKEMON_INSTANCES_INSERTION (
	id integer,
	pokemon_speciesID integer,
	nickname varchar (50),
	ownerID integer,
	level integer,
	experience integer,
	gender varchar (50),
	nature varchar (50),
	item varchar (50),
	datetime date,
	location_subareaID integer,
	obtention_method varchar (50),
	pokeballID varchar (50),
	move1 integer,
	move2 integer,
	move3 integer,
	move4 integer
);

COPY POKEMON_INSTANCES_INSERTION (id,pokemon_speciesID,nickname,ownerID,level,experience,gender,nature,item,datetime,location_subareaID,obtention_method,pokeballID,move1,move2,move3,move4)
FROM 'C:\Users\Public\bbdd_csv\pokemon_instances.csv'
DELIMITER ',' CSV HEADER
;

-- Lectura del fitxer "traineritems.csv"
CREATE TABLE IF NOT EXISTS TRAINER_ITEMS_INSERTION (
	trainerID INTEGER,
	itemID INTEGER,
	obtention_method VARCHAR (50),
	date_time DATE
)
;

COPY TRAINER_ITEMS_INSERTION 
FROM 'C:\Users\Public\bbdd_csv\traineritems.csv'
DELIMITER ',' 
CSV HEADER;

-- Lectura del fitxer "poketeams.csv"
CREATE TABLE IF NOT EXISTS INSERTION_TO_TEAMS (
	id serial primary key,
	id_trainer integer,
	pokemon_number serial,
	slot integer,
	hp integer,
	status varchar(50)
);

COPY INSERTION_TO_TEAMS (id_trainer,pokemon_number, slot, hp, status)
FROM 'C:\Users\Public\bbdd_csv\poketeams.csv'
DELIMITER ',' CSV HEADER
;


-- Lectura del fitxer "stores.csv"
CREATE TABLE IF NOT EXISTS INSERTION_STORES (
	storeID serial PRIMARY KEY,
	store_name VARCHAR(50),
	floors INTEGER,
	city VARCHAR(50)
);

COPY INSERTION_STORES (storeID, store_name, floors, city)
FROM 'C:\BBDD_csv\DB-2022-2023-datasets\stores.csv'
DELIMITER ',' CSV HEADER
;

-- Lectura del fitxer "itemstores.csv"
CREATE TABLE IF NOT EXISTS INSERTION_ITEM_STORES (
	id serial PRIMARY KEY,
	storeID INTEGER,
	itemID INTEGER,
	stock INTEGER,
	discount INTEGER
);

COPY INSERTION_ITEM_STORES (storeID, itemID, stock, discount)
FROM 'C:\BBDD_csv\DB-2022-2023-datasets\storeitems.csv'
DELIMITER ',' CSV HEADER
;

--Lectura del fitxer "purchases.csv"
CREATE TABLE IF NOT EXISTS INSERTION_PURCHASES (
	id serial PRIMARY KEY,
	storeID INTEGER,
	itemID INTEGER,
	trainerID INTEGER,
	amount INTEGER,
	cost INTEGER,
	discount INTEGER,
	date_time VARCHAR(100)
);

COPY INSERTION_PURCHASES (storeID, itemID, trainerID, amount, cost, discount, date_time)
FROM 'C:\BBDD_csv\DB-2022-2023-datasets\purchases.csv'
DELIMITER ',' CSV HEADER
;

--------------------------------------------------------------------------
--                               PART 2                                 --
--------------------------------------------------------------------------
-- POL
-- ITEM INSERTION
INSERT INTO ITEM (
		id_object,
		name_object,
		base_price_object,
		description_object,
		quick_sell_price)
SELECT 
		id,
		name,
		cost,
		effect,
		quick_sell_price
FROM 
		INSERTION_ITEM;

-- TREASURE INSERTION
INSERT INTO TREASURE(
		id_treasure,
		collector_price)
SELECT 
		id,
		collector_price 
FROM 
		INSERTION_ITEM
		INNER JOIN ITEM ON ITEM.id_object = INSERTION_ITEM.id
WHERE 
		INSERTION_ITEM.collector_price is not NULL;

-- HEAL INSERTION
INSERT INTO HEAL(
		id_heal,
		heal_points,
		can_revive)
SELECT 
		id,
		CAST(nullif(healing, '') AS integer),
		can_revive 
FROM 
		INSERTION_ITEM
		INNER JOIN ITEM ON ITEM.id_object = INSERTION_ITEM.id
WHERE 
		INSERTION_ITEM.healing is not null OR INSERTION_ITEM.can_revive = true;

-- POKEBALL INSERTION
INSERT INTO POKEBALL (
		id_pokeball,
		max_ratium,
		min_ratium)
SELECT 
		id,
		top_capture_rate,
		min_capture_rate 
FROM 
		INSERTION_ITEM
		INNER JOIN ITEM ON ITEM.id_object = INSERTION_ITEM.id
WHERE 
		INSERTION_ITEM.top_capture_rate IS NOT NULL;

-- BERRY INSERTION
INSERT INTO BERRY (
		id_berry,
		name,
		growth_time,
		size_berry,
		smoothness,
		firmness,
		max_num_harvest,
		natural_gift_powder,
		soil_dryness)
SELECT 
		ITEM.id_object,
		INSERTION_BERRY.name,
		INSERTION_BERRY.growth_time,
		INSERTION_BERRY.berry_avg_size,
		INSERTION_BERRY.smoothness,
		INSERTION_BERRY.firmness,
		INSERTION_BERRY.max_num_harvest,
		INSERTION_BERRY.natural_gift_powder,
		INSERTION_BERRY.soil_dryness
FROM
		INSERTION_BERRY
		INNER JOIN ITEM ON ITEM.name_object = INSERTION_BERRY.name;

-- FLAVOUR INSERTION
INSERT INTO FLAVOUR (name)
SELECT DISTINCT INSERTION_BERRIES_FLAVOURS.flavour 
FROM INSERTION_BERRIES_FLAVOURS;

-- BERRY_FLAVOUR INSERTION
INSERT INTO BERRY_FLAVOUR (
		id_flavour,
		id_berry,
		boost)
SELECT 
		FLAVOUR.id_flavour,
		BERRY.id_berry,
		INSERTION_BERRIES_FLAVOURS.potency
FROM 
		INSERTION_BERRIES_FLAVOURS
		INNER JOIN FLAVOUR ON FLAVOUR.name = INSERTION_BERRIES_FLAVOURS.flavour
		INNER JOIN BERRY ON BERRY.name LIKE '%' || INSERTION_BERRIES_FLAVOURS.berry || '%';

-- GROWTH_RATE INSERTION
INSERT INTO GROWTH_RATE (
		id_growth_rate,
		name_growth_rate,
		formula,
		level_pokemon,
		xp)
SELECT 
		id,
		name,
		formula,
		level,
		experience
FROM 
		INSERTION_GROWTH_RATE;

-- TYPE_POKEMON INSERTION
INSERT INTO TYPE_POKEMON (
		id_type,
		name_type)
SELECT 
		id,
		name 
FROM 
		INSERTION_TYPE;

-- TYPE_AGAINST INSERTION
INSERT INTO TYPE_AGAINST(
		id_type_attacker,
		id_type_defender,
		multiplier)
SELECT 
		t1.id_type,
		t2.id_type,
		SUBSTRING(DAMAGE_RELATIONS.multiplier,2)::DECIMAL
FROM 
		DAMAGE_RELATIONS
		INNER JOIN TYPE_POKEMON AS t1 ON t1.name_type = DAMAGE_RELATIONS.attacker
		INNER JOIN TYPE_POKEMON AS t2 ON t2.name_type = DAMAGE_RELATIONS.defender;

-- POKEMON INSERTION
INSERT INTO POKEMON (
		id_pokemon,
		name_pokemon,
		height_pokemon,
		weight_pokemon,
		dex_order,
		base_xp_pokemon,
		id_growth_rate,
		id_type_1,
		id_type_2)
SELECT DISTINCT ON 
		(INSERTION_POKEMON.id_pokemon) id_pokemon,
		INSERTION_POKEMON.pokemon,
		INSERTION_POKEMON.height,
		INSERTION_POKEMON.weight,
		INSERTION_POKEMON.dex_order,
		INSERTION_POKEMON.baseExperience,
		GROWTH_RATE.id_pk + 1,
		t1.id_type,
		t2.id_type
FROM 
		INSERTION_POKEMON
		INNER JOIN GROWTH_RATE ON GROWTH_RATE.id_growth_rate = INSERTION_POKEMON.growth_rate_ID
		INNER JOIN TYPE_POKEMON as t1 ON t1.name_type LIKE INSERTION_POKEMON.type1
		LEFT JOIN TYPE_POKEMON as t2 ON t2.name_type LIKE INSERTION_POKEMON.type2
WHERE
		GROWTH_RATE.xp < INSERTION_POKEMON.baseExperience;

-- BASE_STAT INSERTION
INSERT INTO BASE_STAT(name)
SELECT DISTINCT stat
FROM INSERTION_STATS;

-- ACQUIRE_BASE_STAT INSERTION
INSERT INTO ACQUIRE_BASE_STAT (
		id_base_stat,
		id_pokemon,
		base_value,effort)
SELECT 
		BASE_STAT.id_base_stat,
		POKEMON.id_pokemon,
		INSERTION_STATS.base_stat,
		INSERTION_STATS.effort
FROM 
		INSERTION_STATS
		INNER JOIN POKEMON ON INSERTION_STATS.pokemon = replace(POKEMON.name_pokemon, '-', ' ') 
		INNER JOIN BASE_STAT ON BASE_STAT.name = INSERTION_STATS.stat;

-- ABILITY INSERTION
INSERT INTO ABILITY(
		id_ability,
		name_ability,
		full_description,
		short_description)
SELECT DISTINCT 
		id,
		name,
		effect,short_effect
FROM 
		INSERTION_ABILITIES;

-- ABILITY_POKEMON INSERTION
INSERT INTO ABILITY_POKEMON (
		id_ability,
		id_pokemon,
		slot,
		is_hidden)
SELECT 
		ABILITY.id_ability,
		POKEMON.id_pokemon,
		INSERTION_ABILITIES_POKEMON.slot,
		INSERTION_ABILITIES_POKEMON.is_hidden
FROM 
		INSERTION_ABILITIES_POKEMON
		INNER JOIN ABILITY ON ABILITY.id_ability = INSERTION_ABILITIES_POKEMON.abilityID
		INNER JOIN POKEMON ON POKEMON.id_pokemon = INSERTION_ABILITIES_POKEMON.speciesID;

-- NATURE INSERTION
INSERT INTO NATURE(
		id_nature,
		name_nature,
		id_stat_incremented,
		id_stat_decremented,
		id_flavour_like,
		id_flavour_dislike)
SELECT 
		INSERTION_NATURE.id,
		INSERTION_NATURE.name,
		b1.id_base_stat,
		b2.id_base_stat,
		f1.id_flavour,
		f2.id_flavour
FROM 
		INSERTION_NATURE
		LEFT JOIN BASE_STAT as b1 ON b1.name = INSERTION_NATURE.increased_stat
		LEFT JOIN BASE_STAT as b2 ON b2.name = INSERTION_NATURE.decreased_stat
		LEFT JOIN FLAVOUR as f1 ON f1.name = INSERTION_NATURE.likes_flavor
		LEFT JOIN FLAVOUR as f2 ON f2.name = INSERTION_NATURE.hates_flavor;

-- POKEMON_MOVE INSERTION
INSERT INTO POKEMON_MOVE(
		id_move,
		name_move,
		accuracy,
		effect,
		pp,
		priority_move,
		range,
		type_pokemon,
		damage_type,
		hp_healing,
		hp_drain,
		basepower_move,
		flinch_chance,
		min_hits,
		max_hits,
		ailment,
		ailment_chance,
		status_move,
		stat_change_rate,
		change_amount)
SELECT 
		move_id,
		name,
		accuracy,
		effect,
		pp,
		priority,
		target,
		TYPE_POKEMON.id_type,
		move_damage_class,
		hp_healing,
		hp_drain,
		power,
		flinch_chance,
		min_hits,
		max_hits,
		ailment,
		ailment_chance,
		stat,
		stat_change_rate,
		change_amount
FROM 
		INSERTION_MOVES
		INNER JOIN TYPE_POKEMON ON TYPE_POKEMON.name_type = INSERTION_MOVES.type;

-- BOOSTER INSERTION
INSERT INTO BOOSTER(
		id_booster,
		id_stat,
		stat_increase_time)
SELECT 
		INSERTION_ITEM.id,
		BASE_STAT.id_base_stat,
		INSERTION_ITEM.stat_increase_time
FROM 
		INSERTION_ITEM 
		INNER JOIN BASE_STAT ON BASE_STAT.name = INSERTION_ITEM.statistic
WHERE 
		INSERTION_ITEM.statistic IS NOT NULL;

INSERT INTO TM_HM(id_mt, id_move)
SELECT INSERTION_ITEM.id,POKEMON_MOVE.id_move
FROM INSERTION_ITEM
INNER JOIN POKEMON_MOVE ON POKEMON_MOVE.name_move = INSERTION_ITEM.move;


-- () LEO --
-- REGION INSERTION
INSERT INTO REGION(region_name)
SELECT DISTINCT region 
FROM LOCATIONS_INSERTION;

-- (0) JOAN --
-- TRAINER don't need any table before insertion
INSERT INTO TRAINER (id_trainer, class_trainer, name_trainer, exp_trainer, pokeCoins_trainer, phrase_trainer, item_gift_leader)
SELECT id_tr, trainer_class, regexp_replace(name, E'[\\n\\r\\u2028]+', '', 'g' ), experience::integer, gold::integer, phrase, IM.name_object FROM INSERTION_TRAINERS
LEFT JOIN ITEM AS IM ON IM.name_object = INSERTION_TRAINERS.gift_item;


-- (1)* JOAN --
-- ORGANIZATION need the table "Region"
INSERT INTO ORGANIZATION (name_organization, building_organization, leader_name, headquarter, id_region)
SELECT name, building, leader, hq, (SELECT id_region FROM REGION WHERE region = region_name) 
FROM INSERTION_ORGANIZATION;

-- (1) JOAN --
-- EVIL_TRAINER need the table "Organization" before insertion!
INSERT INTO EVIL_TRAINER (id_trainer, id_partner, money_stolen, id_organization)
SELECT id_tr, partnerID::integer, money_stolen::integer, (SELECT id_organization FROM ORGANIZATION WHERE villain_team = organization.name_organization)
FROM INSERTION_TRAINERS WHERE partnerID is not null;

-- (1) JOAN --
-- BATTLE need the table "Trainer"
INSERT INTO BATTLE (
		id_battle, 
		trainer_winner, 
		trainer_loser, 
		inicial_date_battle, 
		pokeCoins_battle, 
		experience_battle, 
		duration_battle)
SELECT 
		battleID, 
		winnerID, 
		loserID, 
		date_time, 
		gold_reward, 
		experience, 
		duration
FROM 
		INSERTION_BATTLE;

-- () LEO --
-- AREA INSERTION
INSERT INTO AREA(
		area_name, 
		id_region)
SELECT DISTINCT 
		LOCATIONS_INSERTION.area, 
		REGION.id_region
FROM 
		LOCATIONS_INSERTION
		INNER JOIN REGION ON LOCATIONS_INSERTION.region = REGION.region_name;

-- () LEO --
-- SUBAREA INSERTION
INSERT INTO SUBAREA(
		id_subarea, 
		id_area, 
		subarea_name)
SELECT DISTINCT ON 
		(LOCATIONS_INSERTION.subareaID) subareaID, 
		AREA.id_area, 
		LOCATIONS_INSERTION.subarea
FROM 
		LOCATIONS_INSERTION
		INNER JOIN AREA ON AREA.area_name = LOCATIONS_INSERTION.area
		INNER JOIN REGION ON REGION.region_name = LOCATIONS_INSERTION.region AND
		AREA.id_region = REGION.id_region
WHERE 
		subareaID IS NOT NULL;

-- () LEO --
-- CITY INSERTION
INSERT INTO CITY(
		id_area, 
		population)
SELECT 
		AREA.id_area, 
		LOCATIONS_INSERTION.population
FROM 
		LOCATIONS_INSERTION
		INNER JOIN AREA ON AREA.area_name = LOCATIONS_INSERTION.area
WHERE 
		LOCATIONS_INSERTION.population IS NOT NULL;

-- () LEO --
-- ROUTE INSERTION
INSERT INTO ROUTE(
		north, 
		east, 
		west, 
		south, 
		pavement, 
		id_area, 
		km)
SELECT 
		north.id_area, 
		east.id_area,  
		west.id_area,  
		south.id_area, 
		ROUTE_INSERTION.pavement, 
		AREA.id_area, 
		RANDOM()*(100)
FROM 
		ROUTE_INSERTION
		INNER JOIN AREA ON AREA.area_name = LOWER(ROUTE_INSERTION.route)
		LEFT JOIN AREA AS north ON north.area_name = LOWER(ROUTE_INSERTION.north)
		LEFT JOIN AREA AS east ON east.area_name = LOWER(ROUTE_INSERTION.east)
		LEFT JOIN AREA AS west ON west.area_name = LOWER(ROUTE_INSERTION.west)
		LEFT JOIN AREA AS south ON south.area_name = LOWER(ROUTE_INSERTION.south);

-- () LEO --
-- GYM INSERTION needs "Trainer" before insertion!
INSERT INTO GYM(
		id_type, 
		id_city, 
		id_trainer, 
		gym_name, 
		gym_badge_leader)
SELECT 
		TYPE_POKEMON.id_type,
		CITY.id_city, 
		TRAINER.id_trainer, 
		GYM_INSERTION.gym_name, 
		GYM_INSERTION.badge
FROM 
		GYM_INSERTION
		INNER JOIN AREA ON AREA.area_name = LOWER(GYM_INSERTION.location_name)
		INNER JOIN CITY ON CITY.id_area = AREA.id_area
		INNER JOIN TRAINER ON TRAINER.name_trainer = GYM_INSERTION.leader
		INNER JOIN TYPE_POKEMON ON TYPE_POKEMON.name_type = LOWER(GYM_INSERTION.type_name)
WHERE 
		TRAINER.class_trainer LIKE '%Gym Leader%';

-- () LEO --
-- ENCOUNTERS INSERTION needs "Pokemon" before insertion!
INSERT INTO ENCOUNTERS(
		id_pokemon, 
		id_subarea, 
		method_to_find, 
		condition_type, 
		condition_value, 
		chance, 
		min_level, 
		max_level)
SELECT 
		POKEMON.id_pokemon, 
		SUBAREA.id_subarea, 
		ENCOUNTERS_INSERTION.method_to_find, 
		ENCOUNTERS_INSERTION.condition_type, 
		ENCOUNTERS_INSERTION.condition_value, 
		ENCOUNTERS_INSERTION.chance, 
		ENCOUNTERS_INSERTION.min_level, 
		ENCOUNTERS_INSERTION.max_level
FROM 
		ENCOUNTERS_INSERTION
		INNER JOIN POKEMON ON POKEMON.name_pokemon = ENCOUNTERS_INSERTION.pokemon
		INNER JOIN SUBAREA ON SUBAREA.id_subarea = ENCOUNTERS_INSERTION.subareaID;

-- (5)* JOAN
-- POKEMON CAUGHT needs "Pokemon", "Nature", "Ability", "Item" and "Trainer" before insertion!
INSERT INTO POKEMON_CAUGHT (
		id_pokemon_caught, 
		id_subarea, 
		id_trainer, 
		nick_name, 
		xp, 
		level,
		date_caught, 
		obtaining_method, 
		id_pokemon, 
		pokeball_used_caught, 
		pokemon_max_hp, 
		pokemon_status_condition, 
		pokemon_remaining_hp,
		id_move1,
		id_move2,
		id_move3,
		id_move4,
		id_nature,
		id_pokemon_ability,
		id_object)
SELECT DISTINCT 
		PII.id, 
		SUBAREA.id_subarea, 
		ownerID, 
		nickname, 
		experience, 
		level,
		datetime, 
		obtention_method, 
		pokemon_speciesID, 
		pokeballID, 
		INSERTION_TO_TEAMS.hp, 
		INSERTION_TO_TEAMS.status, 
		(SELECT max(INSERTION_BATTLE_STATS.remaining_hp) 
			FROM INSERTION_BATTLE_STATS 
			where INSERTION_BATTLE_STATS.pokemon_instanceID = PII.id),
		M1.id_move,
		M2.id_move,
		M3.id_move,
		M4.id_move,
		NE.id_nature,
		(SELECT id_ability FROM ABILITY_POKEMON
			JOIN POKEMON ON ABILITY_POKEMON.id_pokemon = POKEMON.id_pokemon
		 	WHERE POKEMON.id_pokemon = PII.pokemon_speciesID
			ORDER BY RANDOM()
			LIMIT 1),
		IM.id_object
FROM 
		POKEMON_INSTANCES_INSERTION AS PII
		LEFT JOIN SUBAREA ON SUBAREA.id_subarea = PII.location_subareaID
		LEFT JOIN INSERTION_TO_TEAMS ON INSERTION_TO_TEAMS.pokemon_number = PII.id
		INNER JOIN POKEMON_MOVE AS M1 ON M1.id_move = PII.move1
		LEFT JOIN POKEMON_MOVE AS M2 ON M2.id_move = PII.move2
		LEFT JOIN POKEMON_MOVE AS M3 ON M3.id_move = PII.move3
		LEFT JOIN POKEMON_MOVE AS M4 ON M4.id_move = PII.move4
		LEFT JOIN ITEM AS IM ON IM.name_object = PII.item
		INNER JOIN NATURE AS NE ON NE.name_nature = PII.nature
;

-- (2) JOAN --
-- BATTLE_STATISTICS need the table "Trainer" and "Battle" before insertion!
INSERT INTO BATTLE_STATS (
		id_pokemon_caught, 
		id_battle, 
		damage_received, 
		damage_dealt)
SELECT 
		POKEMON_CAUGHT.id_pokemon_caught, 
		battleID, 
		damage_received, 
		damage_dealt
FROM 
		INSERTION_BATTLE_STATS
		INNER JOIN POKEMON_CAUGHT ON POKEMON_CAUGHT.id_pokemon_caught = INSERTION_BATTLE_STATS.pokemon_instanceID
		INNER JOIN BATTLE ON BATTLE.id_battle = INSERTION_BATTLE_STATS.battleID;

-- (1) JOAN --
-- TEAM need table "Trainer" before insertion!
INSERT INTO TEAM (
		id_trainer, 
		id_pokemon_caught, 
		slot)
SELECT DISTINCT 
		INSERTION_TO_TEAMS.id_trainer, 
		PC.id_pokemon_caught,
		slot
FROM 
		INSERTION_TO_TEAMS
		INNER JOIN POKEMON_CAUGHT AS PC ON PC.id_pokemon_caught = INSERTION_TO_TEAMS.pokemon_number;

-- (0) JOAN
-- BACKPACK don't need any table before insertion
INSERT INTO BACKPACK (
		id_backpack, 
		id_trainer)
SELECT 
		id_trainer, 
		id_trainer 
FROM 
		TRAINER;

-- (2) JOAN
-- BATTLES_IN need "Trainer" and "Gym" before insertion!
INSERT INTO BATTLES_IN (
	id_gym, 
	id_trainer, 
	completed) 
SELECT 
	GYM.id_gym, 
	TRAINER.id_trainer,	
	false
FROM 
	GYM
	INNER JOIN TRAINER ON TRAINER.item_gift_leader is null
	AND NOT EXISTS (SELECT EVIL_TRAINER.id_trainer FROM EVIL_TRAINER WHERE EVIL_TRAINER.id_trainer = TRAINER.id_trainer);

-- (1)* JOAN
-- CONTAINS_ITEM need "Item" before insertion!
INSERT INTO CONTAINS_ITEM (
		id_backpack, 
		id_object, 
		obtention_method, 
		date_time)
SELECT * FROM TRAINER_ITEMS_INSERTION; 


-- STORE insertion
INSERT INTO STORE (
		id_store,
		id_area,
		number_floors,
		store_name)
SELECT INSERTION_STORES.storeID, AREA.id_area, INSERTION_STORES.floors, INSERTION_STORES.store_name 
FROM INSERTION_STORES
INNER JOIN AREA ON AREA.area_name = INSERTION_STORES.city;

-- SELLS insertion
INSERT INTO SELLS (
		id_store,
		id_object,
		stock,
		discount)
SELECT STORE.id_store, ITEM.id_object, INSERTION_ITEM_STORES.stock, INSERTION_ITEM_STORES.discount 
FROM INSERTION_ITEM_STORES
INNER JOIN ITEM ON ITEM.id_object = INSERTION_ITEM_STORES.itemID
INNER JOIN STORE ON STORE.id_store = INSERTION_ITEM_STORES.storeID;

-- BUYS insertion
INSERT INTO BUYS (
		id_trainer,
		id_store,
		id_object,
		amount,
		cost,
		discount,
		date_time)
SELECT TRAINER.id_trainer, STORE.id_store, ITEM.id_object, INSERTION_PURCHASES.amount, INSERTION_PURCHASES.cost, INSERTION_PURCHASES.discount, INSERTION_PURCHASES.date_time
FROM INSERTION_PURCHASES
INNER JOIN TRAINER ON TRAINER.id_trainer = INSERTION_PURCHASES.trainerID
INNER JOIN STORE ON STORE.id_store = INSERTION_PURCHASES.storeID
INNER JOIN ITEM ON ITEM.id_object = INSERTION_PURCHASES.itemID;

INSERT INTO EVOLVES (
		id_pokemon_base,
		id_pokemon_final,
		baby,
		method_initial,
		gender,
		min_level,
		time_of_day,
		localization,
		id_item,
		id_know_move,
		min_happiness)
		
SELECT	P1.id_pokemon,
		P2.id_pokemon,
		is_baby,
		trigger_ie,
		gender,
		min_level,
		time_of_day,
		location_ie,
		IM.id_object,
		PM.id_move,
		min_happiness
		
FROM INSERTION_EVOLUTIONS AS IE
INNER JOIN POKEMON AS P1 ON P1.name_pokemon = IE.baseID
INNER JOIN POKEMON AS P2 ON P2.name_pokemon = IE.evolutionID
LEFT JOIN ITEM AS IM ON IM.name_object = IE.item
LEFT JOIN POKEMON_MOVE AS PM ON PM.name_move = IE.known_move

------------------------ UPDATE DATA IN TABLES ---------------------------
-- A continuacio els update tables. Tindran com a comentari
-- el nom de la taula al que pertanyen, el creador d'aquesta,
-- i el perque d'aquesta modificacio, aixi com les taules que es necessita
-- per poder dur a terme aquesta modificacio, les columnes i
-- el nom del creador de la taula.
--
-- ATENCIO! S'ha d'afegir el codi d'haver creat totes les taules abans
-- del codi de modificacio d'aquestes. I ha d'haver informacio valida
-- en els camps dels quals s'agafara la informacio
--------------------------------------------------------------------------

-- // FALTAN TAULES ENCARA // --
/*
UPDATE POKEMON_CAUGHT
SET id_object = (SELECT id_object FROM ITEM WHERE item = name_object)
FROM POKEMON_INSTANCES_INSERTION WHERE POKEMON_INSTANCES_INSERTION.id = POKEMON_CAUGHT.id_pokemon_caught
; 
UPDATE POKEMON_CAUGHT
SET id_nature = (SELECT id_nature FROM NATURE WHERE nature = name_nature)
FROM POKEMON_INSTANCES_INSERTION WHERE POKEMON_INSTANCES_INSERTION.id = POKEMON_CAUGHT.id_pokemon_caught
;

INSERT INTO OWNS SELECT (id_pokemon_caught, move1, move2, move3, move4) FROM POKEMON_CAUGHT;
*/