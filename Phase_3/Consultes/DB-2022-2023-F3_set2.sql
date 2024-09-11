---------------------
-- JOAN TARRAGO PINA
---------------------
----------------
-- #Query 2.1#
--

SELECT PC.nick_name AS Pokemon_Name, PC.id_pokemon_caught AS Id_Pokemon_Caught
FROM POKEMON_CAUGHT AS PC
JOIN TEAM ON TEAM.id_trainer =
(SELECT TR1.id_trainer FROM TRAINER AS TR1
	JOIN BATTLE AS BE ON BE.trainer_winner = TR1.id_trainer
	JOIN TRAINER AS TR2 ON TR2.id_trainer = BE.trainer_loser
 	WHERE TR2.item_gift_leader IS NOT null
	GROUP BY TR1.id_trainer
	ORDER BY count(TR1.name_trainer) DESC
	LIMIT 1)
WHERE TEAM.slot = 1 AND PC.id_pokemon_caught = TEAM.id_pokemon_caught
;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

-- this is the subquery you can validate if wants.
SELECT TR1.id_trainer FROM TRAINER AS TR1
	JOIN BATTLE AS BE ON BE.trainer_winner = TR1.id_trainer
	JOIN TRAINER AS TR2 ON TR2.id_trainer = BE.trainer_loser
 	WHERE TR2.item_gift_leader IS NOT null
	GROUP BY TR1.id_trainer
	ORDER BY count(TR1.name_trainer) DESC
	--LIMIT 1
;

----------------
-- #Query 2.2#
--

SELECT PC.id_pokemon_caught AS pokemon_ID, PC.nick_name AS nickname, count(PC.id_pokemon_caught) AS times_defeated, (SELECT max(PC2.date_caught) AS date_caughted FROM POKEMON_CAUGHT AS PC2 WHERE PC2.id_trainer = TR1.id_trainer)
FROM POKEMON_CAUGHT AS PC
JOIN BATTLE_STATS AS BS ON PC.id_pokemon_caught = BS.id_pokemon_caught
JOIN BATTLE AS BE ON BE.id_battle = BS.id_battle
JOIN TRAINER AS TR1 ON TR1.id_trainer = BE.trainer_winner
WHERE PC.pokemon_max_hp - BS.damage_received = 0 AND PC.id_trainer = TR1.id_trainer
GROUP BY PC.id_pokemon_caught, PC.nick_name, TR1.id_trainer
ORDER BY 3 DESC, 4
LIMIT 5
;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
--
--
----------------
-- #Query 2.3#
--

SELECT TR1.id_trainer AS trainer, count(PC.id_pokemon_caught) AS pokemon_caughted
FROM TRAINER AS TR1
JOIN POKEMON_CAUGHT AS PC ON PC.id_trainer = TR1.id_trainer
JOIN BATTLE AS BE ON TR1.id_trainer <> BE.trainer_winner
WHERE TR1.exp_trainer > power(TR1.pokeCoins_trainer, 2)
GROUP BY TR1.id_trainer
;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
--
SELECT TR1.id_trainer AS trainer, count(PC.id_pokemon_caught) AS pokemon_caughted , exp_trainer, power(TR1.pokeCoins_trainer,2)
FROM TRAINER AS TR1
JOIN POKEMON_CAUGHT AS PC ON PC.id_trainer = TR1.id_trainer
JOIN BATTLE AS BE ON TR1.id_trainer <> BE.trainer_winner
WHERE TR1.exp_trainer > power(TR1.pokeCoins_trainer, 2)
GROUP BY TR1.id_trainer
;
----------------
-- #Query 2.4#
--

SELECT DISTINCT ON (ORG.name_organization) TR1.name_trainer, TR2.name_trainer, ORG.name_organization, 
       MAX(ET1.money_stolen + ET2.money_stolen) AS total_money_stolen
FROM EVIL_TRAINER AS ET1
JOIN ORGANIZATION AS ORG ON ET1.id_organization = ORG.id_organization
JOIN TRAINER AS TR1 ON TR1.id_trainer = ET1.id_trainer
JOIN TRAINER AS TR2 ON TR2.id_trainer = ET1.id_partner
JOIN EVIL_TRAINER AS ET2 ON ET2.id_trainer = ET1.id_partner
GROUP BY ORG.name_organization, TR1.name_trainer, TR2.name_trainer
ORDER BY ORG.name_organization, total_money_stolen DESC
;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
--
--
----------------
-- #Query 2.5#
--

SELECT PC1.nick_name AS Pokemon_with_status_condition, PC1.id_pokemon_caught, PC1.pokemon_status_condition, PC2.nick_name AS Pokemon_attacker, PC2.id_pokemon_caught
FROM POKEMON_CAUGHT AS PC1
JOIN BATTLE_STATS AS BS ON PC1.id_pokemon_caught = BS.id_pokemon_caught
JOIN BATTLE AS BE ON BE.id_battle = BS.id_battle
JOIN TRAINER AS TR ON TR.id_trainer = BE.trainer_winner OR TR.id_trainer = BE.trainer_loser
JOIN TEAM AS TE ON TE.id_trainer = TR.id_trainer
JOIN POKEMON_CAUGHT AS PC2 ON TE.id_pokemon_caught = PC2.id_pokemon_caught
JOIN POKEMON_MOVE AS PM1 ON PM1.id_move = PC2.id_move1
JOIN POKEMON_MOVE AS PM2 ON PM2.id_move = PC2.id_move2
JOIN POKEMON_MOVE AS PM3 ON PM3.id_move = PC2.id_move3
JOIN POKEMON_MOVE AS PM4 ON PM4.id_move = PC2.id_move4
WHERE 	PC1.pokemon_status_condition <> 'none'
	AND (PM1.ailment is not null OR PM2.ailment is not null OR PM3.ailment is not null OR PM4.ailment is not null)
;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

SELECT * FROM POKEMON_MOVE WHERE name_move = 'flamethrower';

----------------
-- #Query 2.6#
--

SELECT PT.name_type, count(BE.trainer_loser) 
FROM BATTLE AS BE
JOIN TRAINER AS TR1 ON TR1.id_trainer = BE.trainer_loser
JOIN GYM ON GYM.id_trainer = TR1.id_trainer
JOIN TYPE_POKEMON AS PT ON GYM.id_type = PT.id_type
GROUP BY PT.name_type
ORDER BY count(BE.trainer_loser) ASC
;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
--
--
----------------
-- #Trigger 2.1#
--

DROP TABLE IF EXISTS WARNING_TABLE;
CREATE TABLE IF NOT EXISTS WARNING_TABLE (
	id SERIAL PRIMARY KEY,
	id_user VARCHAR(100),
	id_trainer INTEGER,
	table_afected VARCHAR (100),
	warning_message VARCHAR (1000),
	date_time date
);

CREATE OR REPLACE FUNCTION teach_move_trigger()
RETURNS TRIGGER AS $$
BEGIN

  IF NOT EXISTS (
    SELECT 1
    FROM POKEMON_MOVE AS PM
	JOIN TM_HM AS TH ON TH.id_move = PM.id_move
	JOIN ITEM AS IM ON IM.id_object = TH.id_mt
	JOIN CONTAINS_ITEM AS CI ON CI.id_object = IM.id_object
	JOIN BACKPACK AS BP ON BP.id_backpack = CI.id_backpack
	JOIN TRAINER AS TR ON TR.id_trainer = BP.id_trainer
	WHERE new.id_trainer = TR.id_trainer 
	  		and (	(TH.id_move = new.id_move1 and old.id_move1 <> new.id_move1)
				 or	(TH.id_move = new.id_move2 and old.id_move2 <> new.id_move2)
				 or (TH.id_move = new.id_move3 and old.id_move3 <> new.id_move3)
				 or (TH.id_move = new.id_move4 and old.id_move4 <> new.id_move4)
				 )
  ) THEN

    INSERT INTO WARNING_TABLE (id_trainer, warning_message)
    SELECT new.id_trainer, 
	format('%s %s attempted to teach his %s the move %s without the necessary move machine.', TR.class_trainer, TR.name_trainer, new.id_pokemon, PM.name_move)
	FROM TRAINER AS TR, POKEMON_MOVE AS PM
	WHERE TR.id_trainer = new.id_trainer
	AND (	(PM.id_move = new.id_move1 and old.id_move1 <> new.id_move1)
				 or	(PM.id_move = new.id_move2 and old.id_move2 <> new.id_move2)
				 or (PM.id_move = new.id_move3 and old.id_move3 <> new.id_move3)
				 or (PM.id_move = new.id_move4 and old.id_move4 <> new.id_move4)
				 );

    RETURN NULL;
  END IF;

  DELETE FROM CONTAINS_ITEM WHERE (id_backpack, id_object) = (SELECT CI.id_backpack, CI.id_object
	FROM POKEMON_MOVE AS PM
	JOIN TM_HM AS TH ON TH.id_move = PM.id_move
	JOIN ITEM AS IM ON IM.id_object = TH.id_mt
	JOIN CONTAINS_ITEM AS CI ON CI.id_object = IM.id_object
	JOIN BACKPACK AS BP ON BP.id_backpack = CI.id_backpack
	JOIN TRAINER AS TR ON TR.id_trainer = BP.id_trainer
	WHERE TR.id_trainer = new.id_trainer
	AND (	(PM.id_move = new.id_move1 and old.id_move1 <> new.id_move1)
				 or	(PM.id_move = new.id_move2 and old.id_move2 <> new.id_move2)
				 or (PM.id_move = new.id_move3 and old.id_move3 <> new.id_move3)
				 or (PM.id_move = new.id_move4 and old.id_move4 <> new.id_move4)
				 ));

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS teach_move ON POKEMON_CAUGHT;
CREATE TRIGGER teach_move
AFTER UPDATE
ON POKEMON_CAUGHT
FOR EACH ROW
WHEN (old.id_move1 is distinct from new.id_move1 or
	 old.id_move2 is distinct from new.id_move2 or
	 old.id_move3 is distinct from new.id_move3 or
	 old.id_move4 is distinct from new.id_move4)
EXECUTE FUNCTION teach_move_trigger();

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)


SELECT * FROM WARNING_TABLE;

SELECT * FROM POKEMON_MOVE WHERE id_move = 1;

SELECT * FROM POKEMON_CAUGHT WHERE id_move1 = 6 and id_trainer = 10;
SELECT * FROM POKEMON_CAUGHT WHERE id_trainer = 10;

SELECT I.name_object FROM CONTAINS_ITEM AS CI
JOIN ITEM AS I ON CI.id_object = I.id_object
WHERE id_backpack = 10;

SELECT * 
FROM CONTAINS_ITEM WHERE (id_backpack, id_object) = (SELECT CI.id_backpack, CI.id_object
	FROM POKEMON_MOVE AS PM
	JOIN TM_HM AS TH ON TH.id_move = PM.id_move
	JOIN ITEM AS IM ON IM.id_object = TH.id_mt
	JOIN CONTAINS_ITEM AS CI ON CI.id_object = IM.id_object
	JOIN BACKPACK AS BP ON BP.id_backpack = CI.id_backpack
	JOIN TRAINER AS TR ON TR.id_trainer = BP.id_trainer
	WHERE TR.id_trainer = 10
	AND PM.id_move = 1);

UPDATE POKEMON_CAUGHT SET id_move1 = 1 WHERE id_move1 = 6 and id_trainer = 10 and level = 4;


----------------
-- #Trigger 2.2#
--


CREATE OR REPLACE FUNCTION give_gold_and_exp()
RETURNS TRIGGER AS $$
BEGIN 
	IF EXISTS (SELECT 1
			   FROM TRAINER AS TR
			   JOIN EVIL_TRAINER AS ET ON ET.id_trainer = TR.id_trainer
			   WHERE TR.id_trainer = new.trainer_winner)
	THEN
		UPDATE TRAINER 
		SET pokeCoins_trainer = GREATEST(pokeCoins_trainer + new.pokeCoins_battle * 2 / 3, 0),
			exp_trainer = exp_trainer + new.experience_battle * 2 / 3
		WHERE id_trainer = new.trainer_winner;
		
		UPDATE TRAINER 
		SET pokeCoins_trainer = GREATEST(pokeCoins_trainer - new.pokeCoins_battle, 0),
			exp_trainer = exp_trainer + new.experience_battle * 1 / 3
		WHERE id_trainer = new.trainer_loser;
		INSERT INTO WARNING_TABLE (id_trainer) VALUES (new.trainer_winner);
	ELSE
		UPDATE TRAINER 
		SET pokeCoins_trainer = GREATEST(pokeCoins_trainer + new.pokeCoins_battle * 2 / 3, 0),
			exp_trainer = exp_trainer + new.experience_battle * 2 / 3
		WHERE id_trainer = new.trainer_winner;
		
		UPDATE TRAINER 
		SET pokeCoins_trainer = GREATEST(pokeCoins_trainer + new.pokeCoins_battle * 1 / 3, 0),
			exp_trainer = exp_trainer + new.experience_battle * 1 / 3
		WHERE id_trainer = new.trainer_loser;
		/*INSERT INTO WARNING_TABLE (warning_message) VALUES (format('pokeC: %s, EXP: %s, t_win: %s, t_los: %s', new.pokeCoins_battle, new.experience_battle, new.trainer_winner, new.trainer_loser));*/
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS give_gold_exp ON BATTLE;
CREATE TRIGGER give_gold_exp
AFTER INSERT ON BATTLE
FOR EACH ROW
EXECUTE FUNCTION give_gold_and_exp();

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

SELECT * FROM WARNING_TABLE;

SELECT * FROM BATTLE LIMIT 1;

UPDATE TRAINER 
SET pokeCoins_trainer = 11297,
	exp_trainer = 1175748
WHERE TRAINER.id_trainer = 511;

UPDATE TRAINER 
SET pokeCoins_trainer = 10210,
	exp_trainer = 1365328
WHERE TRAINER.id_trainer = 511;

SELECT * FROM TRAINER WHERE id_trainer = 511; -- 11297 pokeCoins inicials, 1175748 exp final
SELECT * FROM TRAINER WHERE id_trainer = 343; -- 10210 pokeCoins inicials, 1365328 exp final

DELETE FROM BATTLE WHERE id_battle >= 600;
INSERT INTO BATTLE (id_battle, trainer_winner, trainer_loser, pokeCoins_battle, experience_battle, duration_battle) VALUES ((SELECT id_battle FROM BATTLE ORDER BY 1 DESC LIMIT 1) + 1, 511, 343, 999, 999, -1);
SELECT * FROM BATTLE WHERE id_battle = 600;

/*
UPDATE TRAINER 
SET pokeCoins_trainer = GREATEST(pokeCoins_trainer + 999 * 2 / 3, 0),
	exp_trainer = exp_trainer + 999 * 2 / 3
WHERE id_trainer = 511;
*/

SELECT * FROM TRAINER WHERE id_trainer = 511; -- 11963 pokeCoins finals, 1176414 exp final
SELECT * FROM TRAINER WHERE id_trainer = 343; -- 10543 pokeCoins finals, 1365661 exp final

