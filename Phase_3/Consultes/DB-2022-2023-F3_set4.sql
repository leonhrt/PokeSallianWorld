----------------
----------------
-- #Query 4.1.1#
--

SELECT REGION.region_name
FROM REGION
	INNER JOIN AREA ON AREA.id_region = REGION.id_region
	INNER JOIN SUBAREA ON SUBAREA.id_area = AREA.id_area
GROUP BY REGION.region_name
ORDER BY COUNT(SUBAREA.id_subarea) DESC
LIMIT 1;


-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

SELECT REGION.id_region,
    REGION.region_name,
    COUNT(SUBAREA.id_subarea) as num_subareas
FROM REGION
    INNER JOIN AREA ON AREA.id_region = REGION.id_region
	INNER JOIN SUBAREA ON SUBAREA.id_area = AREA.id_area
GROUP BY REGION.id_region,
    REGION.region_name
ORDER BY COUNT(SUBAREA.id_subarea) DESC;

----------------
----------------
-- #Query 4.1.2#
--

SELECT REGION.region_name
FROM REGION
WHERE REGION.id_region = (
		SELECT AREA.id_region
		FROM AREA
			INNER JOIN SUBAREA ON SUBAREA.id_area = AREA.id_area
		GROUP BY AREA.id_region
		ORDER BY COUNT(SUBAREA.id_subarea) DESC
		LIMIT 1
	);

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

SELECT REGION.id_region,
    REGION.region_name,
    COUNT(SUBAREA.id_subarea) as num_subareas
FROM REGION
    INNER JOIN AREA ON AREA.id_region = REGION.id_region
	INNER JOIN SUBAREA ON SUBAREA.id_area = AREA.id_area
GROUP BY REGION.id_region,
    REGION.region_name
ORDER BY COUNT(SUBAREA.id_subarea) DESC;

----------------
-- #Query 4.2#
--

SELECT DISTINCT ON (GYM.gym_name) gym_name,
	AREA.area_name AS city_name,
	AREA_ROUTE.area_name AS route_name,
	A1.area_name AS north,
	A2.area_name AS east,
	A3.area_name AS west,
	A4.area_name AS south
FROM AREA
	INNER JOIN CITY ON CITY.id_area = AREA.id_area
	INNER JOIN GYM ON GYM.id_city = CITY.id_city
	LEFT JOIN ROUTE ON (
		ROUTE.north = AREA.id_area
		OR ROUTE.east = AREA.id_area
		OR ROUTE.west = AREA.id_area
		OR ROUTE.south = AREA.id_area
	)
	LEFT JOIN AREA AS A1 ON A1.id_area = ROUTE.north
	LEFT JOIN AREA AS A2 ON A2.id_area = ROUTE.east
	LEFT JOIN AREA AS A3 ON A3.id_area = ROUTE.west
	LEFT JOIN AREA AS A4 ON A4.id_area = ROUTE.south
	LEFT JOIN AREA AS AREA_ROUTE ON AREA_ROUTE.id_area = ROUTE.id_area;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

----------------
-- #Query 4.3#
--

SELECT id_encounter,
	id_pokemon,
	ENCOUNTERS.id_subarea,
	chance,
	condition_type,
	condition_value,
	method_to_find,
	min_level,
	max_level,
	region_name
FROM ENCOUNTERS
	INNER JOIN SUBAREA ON SUBAREA.id_subarea = ENCOUNTERS.id_subarea
	INNER JOIN AREA ON AREA.id_area = SUBAREA.id_area
	INNER JOIN REGION ON REGION.id_region = AREA.id_region
WHERE ENCOUNTERS.method_to_find LIKE 'surf'
	AND REGION.region_name LIKE 'sinnoh';

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

SELECT * 
FROM ENCOUNTERS
WHERE ENCOUNTERS.method_to_find LIKE 'surf';

SELECT SUBAREA.id_subarea
FROM SUBAREA
    INNER JOIN AREA ON AREA.id_area = SUBAREA.id_area
    INNER JOIN REGION ON REGION.id_region = AREA.id_region
WHERE REGION.region_name LIKE 'sinnoh';

----------------
-- #Query 4.4#
--

SELECT DISTINCT POKEMON.name_pokemon,
	ENCOUNTERS.chance,
	ENCOUNTERS.min_level
FROM ENCOUNTERS
	INNER JOIN POKEMON ON POKEMON.id_pokemon = ENCOUNTERS.id_pokemon
WHERE ENCOUNTERS.chance <= 1
ORDER BY ENCOUNTERS.min_level ASC
LIMIT 1;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

----------------
-- #Query 4.5#
--

-- good
UPDATE ENCOUNTERS
SET method_to_find = 'good rod'
WHERE method_to_find = 'good';

-- old
UPDATE ENCOUNTERS
SET method_to_find = 'old rod'
WHERE method_to_find = 'old';

-- super
UPDATE ENCOUNTERS
SET method_to_find = 'super rod'
WHERE method_to_find = 'super';

-- rock
UPDATE ENCOUNTERS
SET method_to_find = (
		SELECT method_to_find
		FROM ENCOUNTERS
		WHERE method_to_find LIKE 'good rod'
			OR method_to_find LIKE 'old rod'
			OR method_to_find LIKE 'super rod'
		ORDER BY RANDOM()
		LIMIT 1
	)
WHERE method_to_find = 'rock';

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)


SELECT COUNT(method_to_find) AS num_good_method
FROM ENCOUNTERS
WHERE method_to_find = 'good';

SELECT COUNT(method_to_find) AS num_good_rod_method
FROM ENCOUNTERS
WHERE method_to_find = 'good rod';

SELECT COUNT(method_to_find) AS num_old_method
FROM ENCOUNTERS
WHERE method_to_find = 'old';

SELECT COUNT(method_to_find) AS num_old_rod_method
FROM ENCOUNTERS
WHERE method_to_find = 'old rod';

SELECT COUNT(method_to_find) AS num_super_method
FROM ENCOUNTERS
WHERE method_to_find = 'super';

SELECT COUNT(method_to_find) AS num_super_rod_method
FROM ENCOUNTERS
WHERE method_to_find = 'super rod';

SELECT COUNT(method_to_find) AS num_rock_method
FROM ENCOUNTERS
WHERE method_to_find = 'rock';

----------------
-- #Query 4.6#
--

SELECT DISTINCT AREA.area_name
FROM AREA
	INNER JOIN ROUTE ON ROUTE.id_area = AREA.id_area
	INNER JOIN SUBAREA ON SUBAREA.id_area = AREA.id_area
	INNER JOIN ENCOUNTERS ON ENCOUNTERS.id_subarea = SUBAREA.id_subarea
WHERE pavement LIKE 'Grass'
	AND (
		condition_value LIKE '%night%'
		OR condition_value LIKE '%rain%'
	);

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

SELECT AREA.id_area, SUBAREA.id_subarea
FROM AREA
    INNER JOIN ROUTE ON ROUTE.id_area = AREA.id_area
    INNER JOIN SUBAREA ON SUBAREA.id_area = AREA.id_area
WHERE pavement LIKE 'Grass';

SELECT *
FROM ENCOUNTERS
WHERE condition_value LIKE '%night%' 
    OR condition_value LIKE '%rain%';

----------------
-- #Trigger 4.1#
--

CREATE
OR REPLACE FUNCTION create_city_trigger() RETURNS TRIGGER AS $$
DECLARE 
	lasalia_id INT;
	leader_id INT;
BEGIN
    INSERT INTO region (region_name) VALUES ('Lasalià')
    ON CONFLICT (region_name) DO NOTHING;
    
	SELECT AREA.id_area INTO lasalia_id
	FROM AREA
	JOIN REGION ON AREA.id_region = REGION.id_region 
	WHERE region_name = 'Lasalià';
    
    UPDATE CITY SET id_area = lasalia_id
	WHERE id_city = new.id_city;
	    
    INSERT INTO trainer (id_trainer, name_trainer, class_trainer, pokeCoins_trainer, exp_trainer)
	VALUES ((SELECT max(id_trainer) + 1 FROM TRAINER), 'Laureano', 'Líder de Gimnasio', 1932420,3248523);
    

    SELECT id_trainer INTO leader_id FROM trainer WHERE name_trainer = 'Laureano';
    
    INSERT INTO gym (id_gym, id_city, id_type, id_trainer, gym_name, gym_badge_leader) 
	VALUES ((SELECT max(id_city) + 1 FROM CITY),new.id_city, 4, leader_id, 'Trigger Gym', 'Trigger Badge' );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS city_trigger ON CITY;
CREATE TRIGGER city_trigger
AFTER
INSERT ON city FOR EACH ROW
EXECUTE
    FUNCTION create_city_trigger();

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

INSERT INTO CITY (id_city, population)
VALUES ((SELECT max(id_city) + 1 FROM CITY), 283946)
;

SELECT * FROM AREA
JOIN REGION ON AREA.id_region = REGION.id_region
WHERE REGION.region_name = 'Lasalià';

SELECT * FROM CITY 
ORDER BY id_city DESC;

SELECT GYM.* FROM GYM
JOIN CITY ON CITY.id_city = GYM.id_city
JOIN AREA ON AREA.id_area = CITY.id_area
JOIN REGION ON AREA.id_region = REGION.id_region
WHERE REGION.region_name = 'Lasalià';

----------------
-- #Trigger 4.2#
--

CREATE
OR REPLACE FUNCTION check_pokemon_caught_trigger() RETURNS TRIGGER AS $$
        DECLARE
            pokemon_row RECORD;
			encounter_row RECORD;
            route_row RECORD;
            trainer_row RECORD;
        BEGIN
            SELECT *
            INTO pokemon_row
            FROM POKEMON
            WHERE id_pokemon = NEW.id_pokemon;
			
			SELECT *
            INTO encounter_row
            FROM ENCOUNTERS
			WHERE id_pokemon = NEW.id_pokemon;

            SELECT ROUTE.*, AR.area_name
            INTO route_row
            FROM ROUTE
			JOIN AREA AS AR ON AR.id_area = ROUTE.id_area 
			JOIN SUBAREA AS SU ON SU.id_area = AR.id_area
            WHERE id_subarea = NEW.id_subarea;

            SELECT *
            INTO trainer_row
            FROM TRAINER
            WHERE id_trainer = NEW.id_trainer;

            IF lower(route_row.pavement) <> 'water' AND (lower(NEW.obtaining_method) <> 'walk' OR lower(NEW.obtaining_method) <> 'headbutt') THEN
                INSERT INTO WARNING_TABLE (id_trainer, warning_message)
                VALUES (trainer_row.id_trainer, 'Trainer ' || trainer_row.name_trainer || ' captured ' || pokemon_row.name_pokemon || ' in ' || route_row.area_name || ', with either incorrect method, level, or capture chance 1.');
            ELSIF lower(route_row.pavement) = 'Water' AND lower(NEW.obtaining_method) <> 'surf' THEN
                INSERT INTO WARNING_TABLE (id_trainer, warning_message)
                VALUES (trainer_row.id, 'Trainer ' || trainer_row.name_trainer || ' captured ' || pokemon_row.name_pokemon || ' in ' || route_row.area_name || ', with either incorrect method, level, or capture chance 2.');
            ELSIF encounter_row.chance <= 0 OR (NEW.level NOT BETWEEN encounter_row.min_level AND encounter_row.max_level) THEN
                INSERT INTO WARNING_TABLE (id_trainer, warning_message)
                VALUES (trainer_row.id_trainer, 'Trainer ' || trainer_row.name_trainer || ' captured ' || pokemon_row.name_pokemon || ' in ' || route_row.area_name || ', with either incorrect method, level, or capture chance 3.');
            END IF;

            RETURN NEW;
        END;
    $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_pokemon_caught ON POKEMON_CAUGHT;
CREATE TRIGGER
    check_pokemon_caught BEFORE
INSERT
    ON POKEMON_CAUGHT FOR EACH ROW
EXECUTE
    FUNCTION check_pokemon_caught_trigger();

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

SELECT * FROM POKEMON_CAUGHT;

SELECT ROUTE.*, AR.area_name, EN.*
FROM ROUTE
JOIN AREA AS AR ON AR.id_area = ROUTE.id_area 
JOIN SUBAREA AS SU ON SU.id_area = AR.id_area
JOIN ENCOUNTERS AS EN ON EN.id_subarea = SU.id_subarea
WHERE SU.id_subarea = 479 and 
id_pokemon = 418;
;
-- ERROR --
INSERT INTO POKEMON_CAUGHT (id_pokemon_caught, id_trainer, nick_name, xp, level, gender, id_subarea, date_caught, pokeball_used_caught, obtaining_method, pokemon_status_condition, pokemon_max_hp, pokemon_remaining_hp, id_pokemon, id_nature, id_pokemon_ability, id_object, id_move1, id_move2, id_move3, id_move4)
VALUES ((SELECT max(id_pokemon_caught) + 1 FROM POKEMON_CAUGHT),0,'Shorty',4681,15,'female',479,current_timestamp,'great ball','surf',	'freeze',8,0,418,19,33,510,152,NULL,NULL,NULL);

-- CORRECTO --
INSERT INTO POKEMON_CAUGHT (id_pokemon_caught, id_trainer, nick_name, xp, level, gender, id_subarea, date_caught, pokeball_used_caught, obtaining_method, pokemon_status_condition, pokemon_max_hp, pokemon_remaining_hp, id_pokemon, id_nature, id_pokemon_ability, id_object, id_move1, id_move2, id_move3, id_move4)
VALUES ((SELECT max(id_pokemon_caught) + 1 FROM POKEMON_CAUGHT),50,'Greta',4681,44,'female',496,current_timestamp,'great ball','surf',	'freeze',8,0,319,19,33,510,152,NULL,NULL,NULL);


SELECT * FROM WARNING_TABLE;
DELETE FROM WARNING_TABLE;

SELECT * FROM POKEMON_CAUGHT WHERE id_pokemon_caught >= 13716;
DELETE FROM POKEMON_CAUGHT WHERE id_pokemon_caught >= 13716;