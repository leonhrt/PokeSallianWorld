---------------------- SCRIPT CREATION TABLES ------------------------
-- Aquest script te comentaris damunt de cada taula indicant
-- quines taules s'han d'haver creat abans per poder crear la
-- taula corresponent, dit d'altre manera, quantes claus foranes (FK) 
-- tenen.
--
-- Damunt d'aquests te el recompte de claus foranes (FK) "(0..n)" i
-- un asterisc (*) si la taula depen de taules d'altres creadors o dos
-- asteriscos (**) si la taula conte un camp que fa referencia a un camp
-- d'una altre taula que te el camp de referencia a la taula
-- d'un altre creador. 
--
-- (*) Si es dona algun dels casos d'asterisc vol dir que la taula esta creada
-- en 2 passes i te un ALTER TABLE al final d'aquest script,
-- per poder relacionar les taules amb la dels seus creadors.
-- (Els camps de les taules que s'afegiran despres estaran comentats
-- en la creacio per visualitzar com sera la taula al final)
--
-- Finalment tambe porta el nom del creador de la taula en questio.
-------------------------------------------------------------------------
------------------------------ DROP TABLES ------------------------------
-------------------------------------------------------------------------
DROP TABLE IF EXISTS ITEM CASCADE;
DROP TABLE IF EXISTS TREASURE CASCADE;
DROP TABLE IF EXISTS HEAL CASCADE;
DROP TABLE IF EXISTS POKEBALL CASCADE;
DROP TABLE IF EXISTS BERRY CASCADE;
DROP TABLE IF EXISTS FLAVOUR CASCADE;
DROP TABLE IF EXISTS BERRY_FLAVOUR CASCADE;
DROP TABLE IF EXISTS GROWTH_RATE CASCADE;
DROP TABLE IF EXISTS TYPE_POKEMON CASCADE;
DROP TABLE IF EXISTS TYPE_AGAINST CASCADE;
DROP TABLE IF EXISTS POKEMON CASCADE;
DROP TABLE IF EXISTS BASE_STAT CASCADE;
DROP TABLE IF EXISTS ACQUIRE_BASE_STAT CASCADE;
DROP TABLE IF EXISTS ABILITY CASCADE;
DROP TABLE IF EXISTS ABILITY_POKEMON CASCADE;
DROP TABLE IF EXISTS NATURE CASCADE;
DROP TABLE IF EXISTS POKEMON_MOVE CASCADE;
DROP TABLE IF EXISTS BOOSTER CASCADE;
DROP TABLE IF EXISTS EVOLVES CASCADE;
DROP TABLE IF EXISTS ENCOUNTERS CASCADE;
DROP TABLE IF EXISTS ROUTE CASCADE;
DROP TABLE IF EXISTS EVIL_TRAINER CASCADE;
DROP TABLE IF EXISTS BATTLE_STATS CASCADE;
DROP TABLE IF EXISTS BACKPACK CASCADE;
DROP TABLE IF EXISTS BATTLE CASCADE;
DROP TABLE IF EXISTS TEAM CASCADE;
DROP TABLE IF EXISTS POKEMON_CAUGHT CASCADE;
DROP TABLE IF EXISTS SUBAREA CASCADE;
DROP TABLE IF EXISTS BUYS CASCADE;
DROP TABLE IF EXISTS BATTLES_IN CASCADE;
DROP TABLE IF EXISTS ORGANIZATION CASCADE;
DROP TABLE IF EXISTS CONTAINS_ITEM CASCADE;
DROP TABLE IF EXISTS GYM CASCADE;
DROP TABLE IF EXISTS CITY CASCADE;
DROP TABLE IF EXISTS AREA CASCADE;
DROP TABLE IF EXISTS REGION CASCADE;
DROP TABLE IF EXISTS TRAINER CASCADE;
DROP TABLE IF EXISTS TM_HM CASCADE;
DROP TABLE IF EXISTS STORE CASCADE;
DROP TABLE IF EXISTS SELLS CASCADE;
DROP TABLE IF EXISTS BUYS CASCADE;

CREATE TABLE IF NOT EXISTS ITEM (
	id_object SERIAL PRIMARY KEY,
	name_object VARCHAR (50),
	base_price_object INTEGER,
	description_object VARCHAR (1000),
	quick_sell_price INTEGER
);

CREATE TABLE IF NOT EXISTS TREASURE (
	id_treasure SERIAL PRIMARY KEY REFERENCES ITEM (id_object),
	collector_price INTEGER
);

CREATE TABLE IF NOT EXISTS HEAL (
	id_heal SERIAL PRIMARY KEY REFERENCES ITEM (id_object),
	heal_points INTEGER,
	can_revive BOOLEAN
);

CREATE TABLE IF NOT EXISTS POKEBALL (
	id_pokeball SERIAL PRIMARY KEY REFERENCES ITEM (id_object),
	max_ratium INTEGER,
	min_ratium INTEGER
);

CREATE TABLE IF NOT EXISTS BERRY (
	id_berry SERIAL PRIMARY KEY REFERENCES ITEM (id_object),
	name VARCHAR (50),
	growth_time INTEGER,
	size_berry INTEGER,
	smoothness VARCHAR (50),
	firmness VARCHAR (50),
	max_num_harvest INTEGER,
	natural_gift_powder INTEGER,
	soil_dryness INTEGER
);

CREATE TABLE IF NOT EXISTS FLAVOUR (
	id_flavour SERIAL PRIMARY KEY,
	name VARCHAR (50)
);

CREATE TABLE IF NOT EXISTS BERRY_FLAVOUR (
	id SERIAL PRIMARY KEY,
	id_flavour INTEGER REFERENCES FLAVOUR (id_flavour),
	id_berry INTEGER REFERENCES BERRY (id_berry),
	boost INTEGER
);

CREATE TABLE IF NOT EXISTS GROWTH_RATE(
	id_pk SERIAL PRIMARY KEY,
    id_growth_rate SERIAL,
    name_growth_rate VARCHAR (50),
    formula VARCHAR (1000),
    level_pokemon INTEGER,
    xp INTEGER
);

CREATE TABLE IF NOT EXISTS TYPE_POKEMON (
	id_type SERIAL PRIMARY KEY,
	name_type VARCHAR (50)
);

CREATE TABLE IF NOT EXISTS TYPE_AGAINST(
	id_relation SERIAL PRIMARY KEY,
	id_type_attacker INTEGER REFERENCES TYPE_POKEMON(id_type),
	id_type_defender INTEGER REFERENCES TYPE_POKEMON(id_type),
	multiplier DECIMAL	
);

CREATE TABLE IF NOT EXISTS POKEMON (
    id_pokemon SERIAL PRIMARY KEY,
    name_pokemon VARCHAR(50),
    height_pokemon INTEGER,
    weight_pokemon INTEGER,
	dex_order INTEGER,
	base_xp_pokemon INTEGER,
	id_growth_rate INTEGER REFERENCES GROWTH_RATE (id_pk),
	id_type_1 INTEGER REFERENCES TYPE_POKEMON (id_type),
	id_type_2 INTEGER REFERENCES TYPE_POKEMON (id_type)

	
);

CREATE TABLE IF NOT EXISTS BASE_STAT(
	id_base_stat SERIAL PRIMARY KEY,
	name VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS ACQUIRE_BASE_STAT(
	id_base_stat INTEGER REFERENCES BASE_STAT(id_base_stat),
	id_pokemon INTEGER REFERENCES POKEMON(id_pokemon),
	base_value INTEGER,
	effort INTEGER
);

CREATE TABLE IF NOT EXISTS ABILITY(
	id_ability SERIAL PRIMARY KEY,
	name_ability VARCHAR (50),
	full_description VARCHAR (5000),
	short_description VARCHAR(300)	
);


CREATE TABLE IF NOT EXISTS ABILITY_POKEMON(
	id SERIAL PRIMARY KEY,
	id_ability INTEGER REFERENCES ABILITY (id_ability),
	id_pokemon INTEGER REFERENCES POKEMON (id_pokemon),
	slot INTEGER,
	is_hidden BOOLEAN
);

CREATE TABLE IF NOT EXISTS NATURE(
	id_nature SERIAL PRIMARY KEY,
	name_nature VARCHAR(50),
	id_stat_incremented INTEGER REFERENCES BASE_STAT (id_base_stat),
	id_stat_decremented INTEGER REFERENCES BASE_STAT (id_base_stat),
	id_flavour_like INTEGER REFERENCES FLAVOUR (id_flavour),
	id_flavour_dislike INTEGER REFERENCES FLAVOUR (id_flavour)

);

CREATE TABLE IF NOT EXISTS POKEMON_MOVE(
	id_move SERIAL PRIMARY KEY,
	name_move VARCHAR (50),
	accuracy INTEGER, 
	effect VARCHAR (200),
	pp INTEGER,
	priority_move INTEGER,
	range VARCHAR (50),
	type_pokemon INTEGER REFERENCES TYPE_POKEMON(id_type),
	damage_type VARCHAR (50),
	hp_healing INTEGER,
	hp_drain INTEGER,
	basepower_move INTEGER,
	flinch_chance INTEGER,
	min_hits INTEGER,
	max_hits INTEGER,
	ailment VARCHAR(50),
	ailment_chance INTEGER,
	status_move VARCHAR (50),
	stat_change_rate INTEGER,
	change_amount INTEGER
);

CREATE TABLE IF NOT EXISTS BOOSTER (
	id_booster INTEGER PRIMARY KEY REFERENCES ITEM (id_object),
	id_stat INTEGER REFERENCES BASE_STAT (id_base_stat),
	stat_increase_time INTEGER
);

CREATE TABLE IF NOT EXISTS TM_HM(
	id_mt INTEGER PRIMARY KEY REFERENCES ITEM (id_object),
	id_move INTEGER REFERENCES POKEMON_MOVE (id_move)
);


CREATE TABLE IF NOT EXISTS EVOLVES(
	id_evolve SERIAL PRIMARY KEY,
	id_pokemon_base INTEGER REFERENCES POKEMON (id_pokemon),
	id_pokemon_final INTEGER REFERENCES POKEMON (id_pokemon),
	baby BOOLEAN,
	method_initial VARCHAR (50),
	gender VARCHAR (50),
	min_level INTEGER,
	time_of_day VARCHAR (50),
	localization VARCHAR (50),
	id_item INTEGER REFERENCES ITEM (id_object),
	id_know_move INTEGER REFERENCES POKEMON_MOVE (id_move),
	min_happiness VARCHAR (50)
);


-- (0) JOAN --
-- TRAINER don't need any table before tables creation.
CREATE TABLE IF NOT EXISTS TRAINER (
	id_trainer SERIAL PRIMARY KEY,
	name_trainer VARCHAR (50) NOT NULL,
	exp_trainer INTEGER NOT NULL,
	pokeCoins_trainer INTEGER NOT NULL,
	class_trainer VARCHAR (50) NOT NULL,
	phrase_trainer VARCHAR (200),
	item_gift_leader VARCHAR (50)
);

-- (1) JOAN --
-- BACKPACK need "Trainer" before tables creation.
CREATE TABLE IF NOT EXISTS BACKPACK (
	id_backpack SERIAL PRIMARY KEY,
	id_trainer INTEGER REFERENCES TRAINER (id_trainer)
);

-- (1) JOAN --
-- BATTLE need "Trainer" before tables creation.
CREATE TABLE IF NOT EXISTS BATTLE (
	id_battle SERIAL UNIQUE NOT NULL,
	trainer_winner INTEGER REFERENCES TRAINER (id_trainer),
	trainer_loser INTEGER REFERENCES TRAINER (id_trainer),
	pokeCoins_battle INTEGER,
	inicial_date_battle DATE,
	experience_battle INTEGER,
	duration_battle INTEGER,
	PRIMARY KEY (id_battle, trainer_winner, trainer_loser)
);

-- REGION TABLE
CREATE TABLE IF NOT EXISTS REGION (
	id_region SERIAL PRIMARY KEY,
	region_name VARCHAR(50) UNIQUE NOT NULL
);

-- (1)* JOAN --
-- ORGANIZATION need "Region (Leo)" before tables creation.
CREATE TABLE IF NOT EXISTS ORGANIZATION (
	id_organization SERIAL PRIMARY KEY,
	id_region INTEGER REFERENCES REGION (id_region),
	name_organization VARCHAR(50),
	building_organization VARCHAR (50),
	leader_name VARCHAR (50),
	headquarter VARCHAR (50)
);

-- (2) JOAN --
-- EVIL_TRAINER need "Trainer" and "Organization" before tables creation.
CREATE TABLE IF NOT EXISTS EVIL_TRAINER (
	id_trainer INTEGER REFERENCES TRAINER (id_trainer),
	id_partner INTEGER REFERENCES TRAINER (id_trainer),
	id_organization INTEGER REFERENCES ORGANIZATION (id_organization),
	money_stolen INTEGER,
	PRIMARY KEY (id_trainer, id_partner, id_organization)
);

-- AREA TABLE
CREATE TABLE IF NOT EXISTS AREA(
	id_area SERIAL PRIMARY KEY,
	id_region SERIAL REFERENCES REGION(id_region),
	area_name VARCHAR(50)
);

-- SUBAREA TABLE
CREATE TABLE IF NOT EXISTS SUBAREA(
	id_subarea SERIAL PRIMARY KEY,
	id_area SERIAL REFERENCES AREA(id_area),
	subarea_name VARCHAR(50)
);

--STORE TABLE
CREATE TABLE IF NOT EXISTS STORE (
	id_store SERIAL PRIMARY KEY,
	id_area INTEGER REFERENCES AREA(id_area),
	number_floors INTEGER,
	store_name VARCHAR(50)
);

--BUYS TABLE
CREATE TABLE IF NOT EXISTS BUYS (
	id_transaction SERIAL PRIMARY KEY,
	id_trainer SERIAL REFERENCES TRAINER(id_trainer),
	id_store SERIAL REFERENCES STORE(id_store),
	id_object SERIAL REFERENCES ITEM(id_object),
	amount INTEGER,
	cost INTEGER,
	discount INTEGER,
	date_time VARCHAR(100)
);

--SELLS TABLE
CREATE TABLE IF NOT EXISTS SELLS (
	id_store SERIAL REFERENCES STORE(id_store),
	id_object SERIAL REFERENCES ITEM (id_object),
	stock INTEGER,
	discount INTEGER,
	PRIMARY KEY(id_store, id_object)
);

-- (5)* JOAN --
-- POKEMON CAUGHT need "Pokemon (Pol)", "Trainer", "Nature (Pol)", "Item (Pol)",
-- "Pokemon_Ability (Pol)" and "Item (Andrea)" before tables creation.
CREATE TABLE IF NOT EXISTS POKEMON_CAUGHT (
    id_pokemon_caught SERIAL PRIMARY KEY,
    id_trainer INTEGER REFERENCES TRAINER(id_trainer),
    nick_name VARCHAR(50),
    xp INTEGER,
    level INTEGER,
    id_subarea INTEGER REFERENCES SUBAREA(id_subarea),
    date_caught DATE,
    pokeball_used_caught VARCHAR(50),
    obtaining_method VARCHAR(50),
    pokemon_status_condition VARCHAR(50),
    pokemon_max_HP INTEGER,
    pokemon_remaining_HP INTEGER,
	id_pokemon INTEGER REFERENCES POKEMON(id_pokemon),
    id_nature INTEGER REFERENCES NATURE(id_nature),
    id_pokemon_ability INTEGER REFERENCES ABILITY(id_ability),
    id_object INTEGER REFERENCES ITEM (id_object),
	id_move1 INTEGER REFERENCES POKEMON_MOVE (id_move),
	id_move2 INTEGER REFERENCES POKEMON_MOVE (id_move),
	id_move3 INTEGER REFERENCES POKEMON_MOVE (id_move),
	id_move4 INTEGER REFERENCES POKEMON_MOVE (id_move)
);

-- (3)* JOAN --
-- BUYS need "Trainer", "Store (Andrea)" and "item (Andrea)" before
CREATE TABLE IF NOT EXISTS BUYS (
	id_trainer INTEGER REFERENCES TRAINER (id_trainer),
	id_store INTEGER REFERENCES STORE (id_store),
	id_object INTEGER REFERENCES ITEM (id_object),
	PRIMARY KEY (id_trainer) --, id_store, id_object)
);

-- (2) JOAN --
-- BATTLE_STATS need "Pokemon_Caught" and "Battle" before tables creation.
CREATE TABLE IF NOT EXISTS BATTLE_STATS (
	id_pokemon_caught INTEGER REFERENCES POKEMON_CAUGHT (id_pokemon_caught),
	id_battle INTEGER REFERENCES BATTLE (id_battle),
	damage_received INTEGER,
	damage_dealt INTEGER,
	PRIMARY KEY (id_pokemon_caught, id_battle)
);

-- (2) JOAN --
-- CONTAINS_ITEM need "Trainer" and "Item" before tables creation.
CREATE TABLE IF NOT EXISTS CONTAINS_ITEM (
	id_backpack SERIAL REFERENCES TRAINER (id_trainer),
	id_object SERIAL REFERENCES ITEM (id_object),
	obtention_method VARCHAR (50),
	date_time DATE
);

-- CITY TABLE
CREATE TABLE IF NOT EXISTS CITY(
	id_city SERIAL PRIMARY KEY,
	id_area SERIAL REFERENCES AREA(id_area),
	population INTEGER
);

-- GYM TABLE
CREATE TABLE IF NOT EXISTS GYM(
	id_gym SERIAL PRIMARY KEY,
	id_city SERIAL REFERENCES CITY(id_city),
	id_type SERIAL REFERENCES TYPE_POKEMON(id_type),
	id_trainer SERIAL REFERENCES TRAINER(id_trainer),
	gym_name VARCHAR(50),
	gym_badge_leader VARCHAR(50)
);

-- (2)* JOAN --
-- BATTLE_IN need "Gym (Leo)" and "Trainer" before tables creation.
CREATE TABLE IF NOT EXISTS BATTLES_IN (
	id_gym INTEGER REFERENCES GYM (id_gym),
	id_trainer INTEGER REFERENCES TRAINER (id_trainer),
	completed BOOLEAN NOT NULL,
	PRIMARY	KEY(id_trainer, id_gym)
);

-- (2) JOAN --
-- TEAM need "Trainer" and "Pokemon_Caught" before tables creation.
CREATE TABLE IF NOT EXISTS TEAM (
	id_team SERIAL PRIMARY KEY,
	id_trainer INTEGER REFERENCES TRAINER (id_trainer),
	id_pokemon_caught INTEGER REFERENCES POKEMON_CAUGHT (id_pokemon_caught),
	team_number INTEGER,
	slot INTEGER
);

-- ROUTE TABLE
CREATE TABLE IF NOT EXISTS ROUTE(
	id_route SERIAL PRIMARY KEY,
	id_area SERIAL REFERENCES AREA(id_area),
	north INTEGER REFERENCES AREA(id_area),
	east INTEGER REFERENCES AREA(id_area),
	west INTEGER REFERENCES AREA(id_area),
	south INTEGER REFERENCES AREA(id_area),
	pavement VARCHAR(50),
	km DECIMAL
);

-- ENCOUNTERS TABLE
CREATE TABLE IF NOT EXISTS ENCOUNTERS(
	id_pokemon SERIAL REFERENCES POKEMON(id_pokemon),
	id_subarea SERIAL REFERENCES SUBAREA(id_subarea),
	method_to_find VARCHAR(50),
	condition_type VARCHAR(50),
	condition_value VARCHAR(50),
	chance INTEGER,
	min_level INTEGER,
	max_level INTEGER
);