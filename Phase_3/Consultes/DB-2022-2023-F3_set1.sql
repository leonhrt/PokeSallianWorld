----------------
-- #Query 1.1#
-- Llista el nom, la defensa, i la defensa especial amb el pes dels 10 Pokémon sturdy més pesats.

SELECT POKEMON.name_pokemon as nom, POKEMON.weight_pokemon as pes, stat1.base_value as defensa,stat2.base_value as defensa_especial FROM ABILITY_POKEMON
INNER JOIN POKEMON ON POKEMON.id_pokemon = ABILITY_POKEMON.id_pokemon
INNER JOIN ABILITY ON ABILITY.id_ability = ABILITY_POKEMON.id_ability
INNER JOIN ACQUIRE_BASE_STAT as stat1 ON stat1.id_pokemon = POKEMON.id_pokemon
INNER JOIN BASE_STAT as stat_defense ON stat_defense.id_base_stat = stat1.id_base_stat
INNER JOIN ACQUIRE_BASE_STAT as stat2 ON stat2.id_pokemon = POKEMON.id_pokemon
INNER JOIN BASE_STAT as stat_defense_sp ON stat_defense_sp.id_base_stat = stat2.id_base_stat
WHERE ABILITY.name_ability LIKE 'sturdy' AND stat_defense.name LIKE 'defense' AND stat_defense_sp.name LIKE 'special defense'
ORDER BY pes DESC
LIMIT 10;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

----------------
-- #Query 1.2#
-- Mostra el dany base mitjà, el màxim i el mínim de la mateixa estadística base de tots 
-- els Pokémon que pertanyin al tipus de foc (fire).
SELECT AVG(stat_attack.base_value) as mitjana_attack, MIN(stat_attack.base_value) as min_attack,MAX(stat_attack.base_value) as max_attack FROM POKEMON
INNER JOIN TYPE_POKEMON as type1 ON type1.id_type = POKEMON.id_type_1
INNER JOIN TYPE_POKEMON as type2 ON type2.id_type = POKEMON.id_type_2
INNER JOIN ACQUIRE_BASE_STAT as stat_attack ON stat_attack.id_pokemon = POKEMON.id_pokemon
INNER JOIN BASE_STAT as stat ON stat.id_base_stat = stat_attack.id_base_stat
WHERE (type1.name_type LIKE 'fire' OR type2.name_type LIKE 'fire') AND stat.name LIKE 'attack';


-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

----------------
-- #Query 1.3#
-- Troba el nom i la descripció de les habilitats de les espècies Pokémon amb una
-- experiència base inicial més gran que la mitja de totes les experiències base.
-- Ordena els resultats d’acord al nom de l'habilitat del Pokémon i la espècies de valor
-- més alt a més baix 
SELECT POKEMON.name_pokemon , ABILITY.name_ability, ABILITY.full_description  FROM POKEMON
INNER JOIN ABILITY_POKEMON ON ABILITY_POKEMON.id_pokemon = POKEMON.id_pokemon
INNER JOIN ABILITY ON ABILITY_POKEMON.id_ability = ABILITY.id_ability
WHERE POKEMON.base_xp_pokemon > (
	SELECT AVG(POKEMON.base_xp_pokemon) FROM POKEMON
	)
ORDER BY ABILITY.name_ability, POKEMON.name_pokemon DESC;


-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

----------------
-- #Query 1.4#
-- De tots els Pokémon que poden evolucionar a partir d’un baby Pokémon, mostra 
-- per cadascuna de les estadístiques, el màxim d'estadística base que hi ha, incloent 
-- el nom del Pokémon i la estadística. Ordena els resultats per aquest valor en ordre 
-- descendent, i en cas d’haver-hi múltiples Pokémon amb el mateix valor base 
-- màxim, mostra'ls en ordre de l’ID de la espècies. 
SELECT base_stat.name, post.name_pokemon, stat.base_value FROM BASE_STAT AS base_stat
INNER JOIN ACQUIRE_BASE_STAT AS stat ON stat.id_base_stat = base_stat.id_base_stat
INNER JOIN POKEMON AS baby ON stat.id_pokemon = baby.id_pokemon
INNER JOIN EVOLVES ON EVOLVES.id_pokemon_base = baby.id_pokemon
INNER JOIN POKEMON AS post ON EVOLVES.id_pokemon_final = post.id_pokemon
WHERE EVOLVES.baby = TRUE AND stat.base_value = (
	SELECT MAX(maxstat.base_value) FROM ACQUIRE_BASE_STAT as maxstat
	INNER JOIN BASE_STAT as current_stat ON current_stat.id_base_stat = maxstat.id_base_stat
	INNER JOIN POKEMON as pokemon_baby ON maxstat.id_pokemon = pokemon_baby.id_pokemon
	INNER JOIN EVOLVES ON EVOLVES.id_pokemon_base = pokemon_baby.id_pokemon
	INNER JOIN POKEMON AS post ON EVOLVES.id_pokemon_final = post.id_pokemon
	WHERE EVOLVES.baby = TRUE AND base_stat.name = current_stat.name
);

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
SELECT base_stat.name, post.name_pokemon, stat.base_value FROM BASE_STAT AS base_stat
INNER JOIN ACQUIRE_BASE_STAT AS stat ON stat.id_base_stat = base_stat.id_base_stat
INNER JOIN POKEMON AS baby ON stat.id_pokemon = baby.id_pokemon
INNER JOIN EVOLVES ON EVOLVES.id_pokemon_base = baby.id_pokemon
INNER JOIN POKEMON AS post ON EVOLVES.id_pokemon_final = post.id_pokemon
WHERE EVOLVES.baby = TRUE AND base_stat.name LIKE '%attack'
ORDER BY stat.base_value DESC;
----------------
-- #Query 1.5#
--
(SELECT tipus.name_type as mes_fortalesa, 'MES FORT' as n FROM TYPE_POKEMON as tipus
INNER JOIN TYPE_AGAINST as contra ON contra.id_type_attacker = tipus.id_type
WHERE contra.multiplier > 1
GROUP BY tipus.name_type
HAVING COUNT(contra.multiplier) = (
	SELECT COUNT(TYPE_AGAINST.multiplier) FROM TYPE_AGAINST
	INNER JOIN TYPE_POKEMON ON TYPE_POKEMON.id_type = TYPE_AGAINST.id_type_attacker
	WHERE TYPE_AGAINST.multiplier > 1
	GROUP BY TYPE_POKEMON.name_type
	ORDER BY COUNT(TYPE_AGAINST.multiplier) DESC
	LIMIT 1)
	LIMIT 1)
	
UNION

(SELECT tipus.name_type as mes_fluix, 'MES FLUIX' as n  FROM TYPE_POKEMON as tipus
INNER JOIN TYPE_AGAINST as contra ON contra.id_type_defender = tipus.id_type
WHERE contra.multiplier < 1
GROUP BY tipus.name_type
HAVING COUNT(contra.multiplier) = (
	SELECT COUNT(TYPE_AGAINST.multiplier) FROM TYPE_AGAINST
	INNER JOIN TYPE_POKEMON ON TYPE_POKEMON.id_type = TYPE_AGAINST.id_type_defender
	WHERE TYPE_AGAINST.multiplier < 1
	GROUP BY TYPE_POKEMON.name_type
	ORDER BY COUNT(TYPE_AGAINST.multiplier) DESC
	LIMIT 1)
	LIMIT 1)

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
--
----------------
-- #Query 1.6#
--
WITH RECURSIVE c AS (
   SELECT POK.id_pokemon AS id, id_pokemon AS inicial , 'Cad:'||id_pokemon AS Cadena, GR.xp AS level_up
		FROM POKEMON as POK
		JOIN GROWTH_RATE AS GR ON GR.id_pk = POK.id_growth_rate
		JOIN EVOLVES AS EV ON POK.id_pokemon = EV.id_pokemon_base
   UNION ALL
   SELECT EV.id_pokemon_final, EV.id_pokemon_base, c.cadena||'-'||EV.id_pokemon_final, GR.xp+c.level_up
   FROM POKEMON as POK
		JOIN GROWTH_RATE AS GR ON GR.id_pk = POK.id_growth_rate
		JOIN EVOLVES AS EV ON POK.id_pokemon = EV.id_pokemon_final
        JOIN c ON c.id = EV.id_pokemon_base
	
)
SELECT * --c.id,c.inicial, max(c.cadena), max(level_up)  
FROM c 
WHERE c.level_up =
(select max(c.level_up) FROM c 
 WHERE c.id <> c.inicial)
 ;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
--
----------------
-- #Trigger 1.1#
--
CREATE OR REPLACE FUNCTION check_more_than_limit()
RETURNS TRIGGER AS $$
BEGIN
  -- Busquem que existeixi el moviment que se li passi en la motxilla de l'entrenador
  IF EXISTS (
    SELECT 1
    	FROM ABILITY_POKEMON AS AB
	  	WHERE AB.id_pokemon = 34  
	  	AND AB.is_hidden = false
	  	GROUP BY AB.id_pokemon
	  	HAVING count(AB.id_pokemon) > 2
  ) THEN
		INSERT INTO WARNING_TABLE (id_user, date_time, warning_message)
		SELECT current_user, current_timestamp,
		format('A %s the entry has been inserted into the ABILITY POKEMON table', count(AB.id_pokemon))
		FROM ABILITY_POKEMON AS AB
		WHERE AB.id_pokemon = new.id_pokemon AND AB.is_hidden = false
		GROUP BY AB.id_pokemon
		;
	
		RETURN NULL;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_abilities ON ABILITY_POKEMON;
CREATE TRIGGER check_abilities
AFTER INSERT ON ABILITY_POKEMON
FOR EACH ROW
EXECUTE FUNCTION check_more_than_limit()
;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
SELECT * FROM POKEMON
WHERE id_pokemon = 34
;

SELECT * FROM ABILITY_POKEMON
WHERE id_pokemon = 34
;

INSERT INTO ABILITY_POKEMON (id_ability, id_pokemon, slot, is_hidden) VALUES (35, 34, 4, false);

DELETE FROM ABILITY_POKEMON WHERE id_pokemon = 34 and id_ability = 35;

SELECT * FROM WARNING_TABLE;
DELETE FROM WARNING_TABLE;
----------------
-- #Trigger 1.2#
--
CREATE OR REPLACE FUNCTION evolves()
RETURNS TRIGGER AS $$
DECLARE
    possible_evolution INT := 0;
	id_evolution INT := -1;
BEGIN
    IF EXISTS (
        SELECT ES.min_level
        FROM POKEMON AS POK
        JOIN EVOLVES AS ES ON POK.id_pokemon = ES.id_pokemon_base
        WHERE new.level >= ES.min_level AND ES.method_initial = 'level up' AND POK.id_pokemon = new.id_pokemon
    ) THEN
        IF EXISTS (
            SELECT 1
            FROM POKEMON AS POK
            JOIN EVOLVES AS ES ON POK.id_pokemon = ES.id_pokemon_base
            WHERE (ES.gender = '' OR ES.gender IS NULL) AND (ES.time_of_day = '' OR ES.time_of_day IS NULL) AND POK.id_pokemon = 387 -- new.id_pokemon
        ) THEN
			
            possible_evolution := 1;
        END IF;

        IF EXISTS (
            SELECT 1
            FROM POKEMON AS POK
            JOIN EVOLVES AS ES ON POK.id_pokemon = ES.id_pokemon_base
            WHERE ES.gender = 'female' AND ES.gender = new.gender 
			AND POK.id_pokemon = new.id_pokemon
        ) THEN
            possible_evolution := 2;
        END IF;

        IF EXISTS (
            SELECT 1
            FROM POKEMON AS POK
            JOIN EVOLVES AS ES ON POK.id_pokemon = ES.id_pokemon_base
            WHERE ES.gender = 'male' AND ES.gender = new.gender 
			AND POK.id_pokemon = new.id_pokemon
        ) THEN
            possible_evolution := 2;
        END IF;

        IF EXISTS (
            SELECT 1
            FROM POKEMON AS POK
            JOIN EVOLVES AS ES ON POK.id_pokemon = ES.id_pokemon_base
            WHERE ES.time_of_day = 'night' AND POK.id_pokemon = new.id_pokemon
                AND (
                    (date_part('hour', current_time) >= 20 AND date_part('hour', current_time) <= 24)
                    OR (date_part('hour', current_time) >= 0 AND date_part('hour', current_time) < 8)
                )
        ) THEN
            possible_evolution := 1;
        END IF;

        IF EXISTS (
            SELECT 1
            FROM POKEMON AS POK
            JOIN EVOLVES AS ES ON POK.id_pokemon = ES.id_pokemon_base
            WHERE ES.time_of_day = 'night' AND POK.id_pokemon = new.id_pokemon
                AND (date_part('hour', current_time) < 20 AND date_part('hour', current_time) >= 8)
        ) THEN
            possible_evolution := 1;
        END IF;

        IF possible_evolution = 1 THEN
            SELECT ES.id_pokemon_final INTO id_evolution 
            FROM POKEMON AS POK
            JOIN EVOLVES AS ES ON POK.id_pokemon = ES.id_pokemon_base
			WHERE POK.id_pokemon = new.id_pokemon;    
			
			UPDATE POKEMON_CAUGHT SET id_pokemon = id_evolution
			WHERE POKEMON_CAUGHT.id_pokemon_caught = new.id_pokemon_caught;
        END IF;
		
		IF possible_evolution = 2 THEN
            SELECT ES.id_pokemon_final INTO id_evolution
            FROM POKEMON AS POK
            JOIN EVOLVES AS ES ON POK.id_pokemon = ES.id_pokemon_base
			WHERE POK.id_pokemon = new.id_pokemon
			AND EV.gender = new.gender;
			
			INSERT INTO WARNING_TABLE (id_trainer) VALUES (id_evolution);
			new.id_pokemon := id_evolution;
		END IF;
	ELSE
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS evolution ON POKEMON_CAUGHT;
CREATE TRIGGER evolution
AFTER UPDATE ON POKEMON_CAUGHT
FOR EACH ROW
WHEN (NEW.level <> OLD.level)
EXECUTE FUNCTION evolves()
;
-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
SELECT POK.name_pokemon, PC.* FROM POKEMON_CAUGHT AS PC
JOIN POKEMON AS POK ON POK.id_pokemon = PC.id_pokemon
JOIN EVOLVES AS EV ON EV.id_pokemon_base = POK.id_pokemon;

SELECT * FROM POKEMON_CAUGHT AS PC
WHERE PC.id_pokemon_caught = 8;

SELECT * FROM EVOLVES
WHERE id_pokemon_base = 387;

UPDATE POKEMON_CAUGHT SET level = 20
WHERE id_pokemon_caught = 8;

SELECT id_pokemon FROM POKEMON_CAUGHT AS PC
WHERE PC.id_pokemon_caught = 8;

UPDATE POKEMON_CAUGHT SET level = 4, id_pokemon = 387
WHERE id_pokemon_caught = 8;

