----------------
----------------
-- #Query 5.1#
--

SELECT REGION.region_name
FROM REGION
    INNER JOIN ORGANIZATION ON ORGANIZATION.id_region = REGION.id_region
    INNER JOIN EVIL_TRAINER ON EVIL_TRAINER.id_organization = ORGANIZATION.id_organization
    INNER JOIN TRAINER AS evil ON evil.id_trainer = EVIL_TRAINER.id_trainer
    INNER JOIN BATTLE ON BATTLE.trainer_winner = evil.id_trainer
    INNER JOIN TRAINER AS good ON good.id_trainer = BATTLE.trainer_loser
GROUP BY REGION.region_name
ORDER BY COUNT(good.id_trainer) DESC
LIMIT 1;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

SELECT REGION.region_name,
    COUNT(good.id_trainer)
FROM REGION
    INNER JOIN ORGANIZATION ON ORGANIZATION.id_region = REGION.id_region
    INNER JOIN EVIL_TRAINER ON EVIL_TRAINER.id_organization = ORGANIZATION.id_organization
    INNER JOIN TRAINER AS evil ON evil.id_trainer = EVIL_TRAINER.id_trainer
    INNER JOIN BATTLE ON BATTLE.trainer_winner = evil.id_trainer
    INNER JOIN TRAINER AS good ON good.id_trainer = BATTLE.trainer_loser
GROUP BY REGION.region_name
ORDER BY COUNT(good.id_trainer) DESC;

----------------
-- #Query 5.2#
--

(
    SELECT DISTINCT POKEMON.name_pokemon
    FROM POKEMON
        INNER JOIN POKEMON_CAUGHT ON POKEMON_CAUGHT.id_pokemon = POKEMON.id_pokemon
)
EXCEPT (
        SELECT DISTINCT POKEMON.name_pokemon
        FROM POKEMON
            INNER JOIN ENCOUNTERS ON ENCOUNTERS.id_pokemon = POKEMON.id_pokemon
    );

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

----------------
-- #Query 5.3#
--

DELETE FROM ENCOUNTERS USING POKEMON,
    EVOLVES
WHERE POKEMON.id_pokemon = EVOLVES.id_pokemon_base
    AND ENCOUNTERS.id_pokemon = POKEMON.id_pokemon
    AND ENCOUNTERS.method_to_find LIKE 'only'
RETURNING *;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

SELECT POKEMON.name_pokemon
FROM ENCOUNTERS
    INNER JOIN POKEMON ON POKEMON.id_pokemon = ENCOUNTERS.id_pokemon
    INNER JOIN EVOLVES ON EVOLVES.id_pokemon_base = POKEMON.id_pokemon
WHERE ENCOUNTERS.method_to_find LIKE 'only';

----------------
-- #Query 5.4#
--

SELECT TRAINER.name_trainer,
    POKEMON.name_pokemon,
    M1.name_move AS move_1,
    M2.name_move AS move_2,
    M3.name_move AS move_3,
    M4.name_move AS move_4
FROM POKEMON
    INNER JOIN POKEMON_CAUGHT ON POKEMON_CAUGHT.id_pokemon = POKEMON.id_pokemon
    INNER JOIN TRAINER ON TRAINER.id_trainer = POKEMON_CAUGHT.id_trainer
    INNER JOIN GYM ON GYM.id_trainer = TRAINER.id_trainer
    INNER JOIN TYPE_POKEMON AS T1 ON T1.id_type <> GYM.id_type
    AND POKEMON.id_type_1 = T1.id_type
    INNER JOIN TYPE_POKEMON AS T2 ON T2.id_type <> GYM.id_type
    AND POKEMON.id_type_2 = T2.id_type
    INNER JOIN POKEMON_MOVE AS M1 ON M1.id_move = POKEMON_CAUGHT.id_move1
    INNER JOIN POKEMON_MOVE AS M2 ON M2.id_move = POKEMON_CAUGHT.id_move2
    INNER JOIN POKEMON_MOVE AS M3 ON M3.id_move = POKEMON_CAUGHT.id_move3
    INNER JOIN POKEMON_MOVE AS M4 ON M4.id_move = POKEMON_CAUGHT.id_move4
WHERE TRAINER.class_trainer LIKE '%Gym Leader%';

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

----------------
-- #Query 5.5#
--

SELECT TRAINER.name_trainer,
    POKEMON.name_pokemon
FROM TRAINER
    INNER JOIN EVIL_TRAINER ON EVIL_TRAINER.id_trainer = TRAINER.id_trainer
    INNER JOIN ORGANIZATION ON ORGANIZATION.id_organization = EVIL_TRAINER.id_organization
    INNER JOIN POKEMON_CAUGHT ON POKEMON_CAUGHT.id_trainer = TRAINER.id_trainer
    INNER JOIN POKEMON ON POKEMON.id_pokemon = POKEMON_CAUGHT.id_pokemon
    INNER JOIN ENCOUNTERS ON ENCOUNTERS.id_pokemon = POKEMON.id_pokemon
    INNER JOIN POKEMON_MOVE AS M1 ON M1.id_move = POKEMON_CAUGHT.id_move1
    INNER JOIN POKEMON_MOVE AS M2 ON M2.id_move = POKEMON_CAUGHT.id_move2
    INNER JOIN POKEMON_MOVE AS M3 ON M3.id_move = POKEMON_CAUGHT.id_move3
    INNER JOIN POKEMON_MOVE AS M4 ON M4.id_move = POKEMON_CAUGHT.id_move4
WHERE TRAINER.class_trainer LIKE '%Leader%'
    AND ENCOUNTERS.method_to_find LIKE 'gift'
    AND (
        M1.effect LIKE '%Drain%'
        OR M2.effect LIKE '%Drain%'
        OR M3.effect LIKE '%Drain%'
        OR M4.effect LIKE '%Drain%'
    );

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

SELECT ENCOUNTERS.method_to_find,
    M1.effect AS move1,
    M2.effect AS move2,
    M3.effect AS move3,
    M4.effect AS move4
FROM ENCOUNTERS
    INNER JOIN POKEMON ON POKEMON.id_pokemon = ENCOUNTERS.id_pokemon
    INNER JOIN POKEMON_CAUGHT ON POKEMON_CAUGHT.id_pokemon = POKEMON.id_pokemon
    INNER JOIN POKEMON_MOVE AS M1 ON M1.id_move = POKEMON_CAUGHT.id_move1
    INNER JOIN POKEMON_MOVE AS M2 ON M2.id_move = POKEMON_CAUGHT.id_move2
    INNER JOIN POKEMON_MOVE AS M3 ON M3.id_move = POKEMON_CAUGHT.id_move3
    INNER JOIN POKEMON_MOVE AS M4 ON M4.id_move = POKEMON_CAUGHT.id_move4
WHERE ENCOUNTERS.method_to_find LIKE 'gift'
    AND (
        M1.effect LIKE '%Drain%'
        OR M2.effect LIKE '%Drain%'
        OR M3.effect LIKE '%Drain%'
        OR M4.effect LIKE '%Drain%'
    );

----------------
-- #Query 5.6#
--

SELECT ITEM.name_object,
    TRAINER.name_trainer,
    POKEMON.name_pokemon
FROM POKEMON
    INNER JOIN EVOLVES ON (
        EVOLVES.id_pokemon_base = POKEMON.id_pokemon
        OR EVOLVES.id_pokemon_final = POKEMON.id_pokemon
    )
    INNER JOIN POKEMON_CAUGHT ON POKEMON_CAUGHT.id_pokemon = POKEMON.id_pokemon
    INNER JOIN TRAINER ON TRAINER.id_trainer = POKEMON_CAUGHT.id_trainer
    INNER JOIN BUYS ON BUYS.id_trainer = TRAINER.id_trainer
    INNER JOIN ITEM ON (
        ITEM.id_object = BUYS.id_object
        AND ITEM.id_object = EVOLVES.id_item
    )
WHERE ITEM.name_object = (
        SELECT ITEM.name_object
        FROM POKEMON
            INNER JOIN EVOLVES ON EVOLVES.id_pokemon_base = POKEMON.id_pokemon
            INNER JOIN POKEMON_CAUGHT ON POKEMON_CAUGHT.id_pokemon = POKEMON.id_pokemon
            INNER JOIN TRAINER ON TRAINER.id_trainer = POKEMON_CAUGHT.id_trainer
            INNER JOIN BUYS ON BUYS.id_trainer = TRAINER.id_trainer
            INNER JOIN ITEM ON ITEM.id_object = BUYS.id_object
            AND ITEM.id_object = EVOLVES.id_item
        GROUP BY ITEM.name_object
        ORDER BY COUNT(TRAINER.id_trainer) DESC
        LIMIT 1
    )
GROUP BY ITEM.name_object,
    TRAINER.name_trainer,
    POKEMON.name_pokemon
HAVING COUNT(TRAINER.id_trainer) > 0;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

SELECT ITEM.name_object,
    COUNT(TRAINER.id_trainer)
FROM POKEMON
    INNER JOIN EVOLVES ON EVOLVES.id_pokemon_base = POKEMON.id_pokemon
    INNER JOIN POKEMON_CAUGHT ON POKEMON_CAUGHT.id_pokemon = POKEMON.id_pokemon
    INNER JOIN TRAINER ON TRAINER.id_trainer = POKEMON_CAUGHT.id_trainer
    INNER JOIN BUYS ON BUYS.id_trainer = TRAINER.id_trainer
    INNER JOIN ITEM ON ITEM.id_object = BUYS.id_object
    AND ITEM.id_object = EVOLVES.id_item
GROUP BY ITEM.name_object
ORDER BY COUNT(TRAINER.id_trainer) DESC;

----------------
-- #Query 5.7#
--

SELECT POKEMON_CAUGHT.id_pokemon_caught,
       POKEMON.weight_pokemon,
       POKEMON.height_pokemon,
       (((2 * ACQUIRE_BASE_STAT.base_value + (GROWTH_RATE.level_pokemon ^ 2) / 4) / 100) + 5) * (CASE WHEN NATURE.id_stat_incremented = BASE_STAT.id_base_stat THEN 1.15
            WHEN NATURE.id_stat_decremented = BASE_STAT.id_base_stat THEN 0.85
            ELSE 1
            END) AS stat
FROM POKEMON_CAUGHT
    INNER JOIN POKEMON ON POKEMON.id_pokemon = POKEMON_CAUGHT.id_pokemon
    INNER JOIN NATURE ON NATURE.id_nature = POKEMON_CAUGHT.id_nature
    INNER JOIN GROWTH_RATE ON GROWTH_RATE.id_growth_rate = POKEMON.id_growth_rate
    INNER JOIN ACQUIRE_BASE_STAT ON ACQUIRE_BASE_STAT.id_pokemon = POKEMON.id_pokemon
    INNER JOIN BASE_STAT ON BASE_STAT.id_base_stat = ACQUIRE_BASE_STAT.id_base_stat
WHERE date_part('year', POKEMON_CAUGHT.date_caught) BETWEEN 2022 AND 2023
GROUP BY POKEMON_CAUGHT.id_pokemon_caught,
       POKEMON.weight_pokemon,
       POKEMON.height_pokemon,
       stat;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

SELECT * 
FROM POKEMON_CAUGHT 
WHERE date_part('year', POKEMON_CAUGHT.date_caught) BETWEEN 2022 AND 2023;

----------------
-- #Query 5.8#
--

SELECT DISTINCT ON (TRAINER.id_trainer) TRAINER.id_trainer,
    TRAINER.name_trainer
FROM TRAINER
    INNER JOIN BUYS ON BUYS.id_trainer = TRAINER.id_trainer
    INNER JOIN STORE ON STORE.id_store = BUYS.id_store
    INNER JOIN SELLS ON SELLS.id_store = STORE.id_store
    INNER JOIN ITEM ON (
        ITEM.id_object = SELLS.id_object
        AND ITEM.id_object = BUYS.id_object
    )
    INNER JOIN AREA ON AREA.id_area = STORE.id_area
    INNER JOIN POKEMON_CAUGHT ON POKEMON_CAUGHT.id_trainer = TRAINER.id_trainer
    INNER JOIN POKEMON ON POKEMON.id_pokemon = POKEMON_CAUGHT.id_pokemon
    INNER JOIN EVOLVES ON (
        EVOLVES.id_pokemon_base = POKEMON.id_pokemon
        OR EVOLVES.id_pokemon_final = POKEMON.id_pokemon
    );

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

