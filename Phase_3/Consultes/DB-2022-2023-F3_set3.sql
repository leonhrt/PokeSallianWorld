----------------
----------------
-- #Query 3.1#
-- Mostreu el jugador que ha gastat més diners a les botigues i quin és el seu objecte preferit a comprar.
SELECT TRAINER.name_trainer, ITEM.name_object FROM BUYS
INNER JOIN ITEM ON BUYS.id_object = ITEM.id_object
INNER JOIN TRAINER ON BUYS.id_trainer = TRAINER.id_trainer
WHERE TRAINER.name_trainer LIKE (
	SELECT TRAINER.name_trainer FROM BUYS 
	INNER JOIN TRAINER ON BUYS.id_trainer = TRAINER.id_trainer
	WHERE BUYS.id_trainer = TRAINER.id_trainer
	GROUP BY TRAINER.name_trainer
	ORDER BY SUM (BUYS.cost) DESC
	LIMIT 1)
GROUP BY TRAINER.name_trainer, ITEM.name_object
ORDER BY SUM (BUYS.amount) DESC
LIMIT 1;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

-- Amb aquesta query podem trobar el player (entrenador) que s'ha gastat més diners a la botiga
SELECT TRAINER.name_trainer FROM BUYS 
INNER JOIN TRAINER ON BUYS.id_trainer = TRAINER.id_trainer
WHERE BUYS.id_trainer = TRAINER.id_trainer
GROUP BY TRAINER.name_trainer
ORDER BY SUM (BUYS.cost) DESC
LIMIT 1;

-- Amb aquesta query trobem el objecte que més a comprat 'Eliseo' que és el jugador (entrenador) que s'ha gastat més diners a la botiga (resultat de la query anterior)
SELECT ITEM.name_object, SUM (BUYS.amount) AS total_bought FROM BUYS
INNER JOIN ITEM ON BUYS.id_object = ITEM.id_object
INNER JOIN TRAINER ON BUYS.id_trainer = TRAINER.id_trainer
WHERE TRAINER.name_trainer LIKE ('Eliseo')
GROUP BY ITEM.name_object
ORDER BY total_bought DESC
LIMIT 1;

----------------
-- #Query 3.2# 
-- Llisteu els jugadors que tenen més de 10 objectes diferents a la seva motxilla i més de 3000 punts d’experiència però mai han comprat res a les botigues.
SELECT DISTINCT(TRAINER.name_trainer) FROM TRAINER
WHERE TRAINER.exp_trainer> 3000
AND TRAINER.name_trainer IN (
	SELECT TRAINER.name_trainer FROM TRAINER
	INNER JOIN BACKPACK ON TRAINER.id_trainer = BACKPACK.id_trainer
	INNER JOIN CONTAINS_ITEM ON CONTAINS_ITEM.id_backpack = BACKPACK.id_backpack
	INNER JOIN ITEM ON ITEM.id_object = CONTAINS_ITEM.id_object
	GROUP BY TRAINER.name_trainer
	HAVING COUNT(DISTINCT(ITEM.id_object)) > 10
	)
AND TRAINER.name_trainer IN (
	SELECT TRAINER.name_trainer FROM TRAINER
	LEFT JOIN BUYS ON TRAINER.id_trainer = BUYS.id_trainer
	WHERE BUYS.id_trainer IS NULL);

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

-- Amb aquesta query trobem els jugadors (entrenadors) que tenen més de 3000 punts d'experiència
SELECT TRAINER.name_trainer, TRAINER.exp_trainer FROM TRAINER
WHERE TRAINER.exp_trainer > 3000  
ORDER BY TRAINER.name_trainer ASC;

-- Amb aquesta query trobem els jugadors (entrenadors) que mai han comprat res a la botiga
SELECT TRAINER.name_trainer, TRAINER.id_trainer FROM TRAINER
LEFT JOIN BUYS ON TRAINER.id_trainer = BUYS.id_trainer
WHERE BUYS.id_trainer IS NULL
ORDER BY TRAINER.name_trainer ASC;

-- Amb aquesta query trobem els jugadors (entrenadors) que tenen més de 10 objectes diferents a la motxilla 
SELECT TRAINER.name_trainer, COUNT(DISTINCT(ITEM.id_object)) AS objects FROM TRAINER
INNER JOIN BACKPACK ON TRAINER.id_trainer = BACKPACK.id_trainer
INNER JOIN CONTAINS_ITEM ON CONTAINS_ITEM.id_backpack = BACKPACK.id_backpack
INNER JOIN ITEM ON ITEM.id_object = CONTAINS_ITEM.id_object
GROUP BY TRAINER.name_trainer
HAVING COUNT(DISTINCT(ITEM.id_object)) > 10
ORDER BY TRAINER.name_trainer ASC;

----------------
-- #Query 3.3#
-- Trobeu quin sabor és més difícil de trobar d’entre els objectes disponibles a les botigues.
SELECT FLAVOUR.name FROM ITEM
JOIN BERRY ON BERRY.id_berry = ITEM.id_object
JOIN SELLS ON SELLS.id_object = ITEM.id_object
JOIN BERRY_FLAVOUR ON BERRY.id_berry = BERRY_FLAVOUR.id_berry
JOIN FLAVOUR ON FLAVOUR.id_flavour = BERRY_FLAVOUR.id_flavour
GROUP BY FLAVOUR.name
ORDER BY COUNT(FLAVOUR.id_flavour) ASC
LIMIT 1;


-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
SELECT FLAVOUR.name from FLAVOUR;

SELECT BERRY_FLAVOUR.id_flavour, BERRY.name from BERRY_FLAVOUR
INNER JOIN BERRY ON BERRY.id_berry = BERRY_FLAVOUR.id_berry;

SELECT COUNT(BERRY_FLAVOUR.id_flavour), FLAVOUR.name 
FROM BERRY_FLAVOUR
INNER JOIN FLAVOUR ON FLAVOUR.id_flavour = BERRY_FLAVOUR.id_flavour
GROUP BY BERRY_FLAVOUR.id_flavour, FLAVOUR.name;

SELECT COUNT(BERRY_FLAVOUR.id) from BERRY_FLAVOUR;
----------------
-- #Query 3.4#
-- Descobriu quin objecte és més difícil de trobar (més escàs), tenint en compte el total d’objectes que tenen els entrenadors, 
-- l’inventari de cadascuna de les botigues, i el nombre de vegades que l’objecte ha estat comprat.
SELECT ITEM.name_object FROM ITEM
JOIN BUYS ON BUYS.id_object = ITEM.id_object
JOIN CONTAINS_ITEM ON CONTAINS_ITEM.id_object = ITEM.id_object
JOIN SELLS ON SELLS.id_object = ITEM.id_object
GROUP BY ITEM.id_object
ORDER BY COUNT(ITEM.id_object) ASC
LIMIT 1;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
SELECT COUNT(ITEM.id_object) as total, ITEM.name_object FROM ITEM
JOIN BUYS ON BUYS.id_object = ITEM.id_object
JOIN CONTAINS_ITEM ON CONTAINS_ITEM.id_object = ITEM.id_object
JOIN SELLS ON SELLS.id_object = ITEM.id_object
GROUP BY ITEM.id_object
ORDER BY TOTAL ASC;
----------------
-- #Query 3.5#
-- Obteniu el total (en quantitat d’or) de descomptes donats amb objectes venuts durant l’any 2020.

SELECT SUM(BUYS.discount) as discount FROM BUYS
WHERE BUYS.date_time LIKE '%2020%';

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

-- Mirem els descomptes que s'han fet i comprovem que s'han fet al 2020
SELECT BUYS.discount, BUYS.date_time FROM BUYS
WHERE BUYS.date_time LIKE '%2020%';
----------------
-- #Query 3.6.1#
-- Obteniu la baia que ha estat conreada (harvested) més vegades i mostreu tots els 
-- seus atributs. Realitzeu dos consultes diferents per obtenir el mateix resultat.
SELECT * FROM BERRY
ORDER BY BERRY.max_num_harvest DESC
LIMIT 1;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)

----------------
-- #Query 3.6.2#
-- 
SELECT *
FROM BERRY
WHERE max_num_harvest = (
    SELECT MAX(max_num_harvest)
    FROM BERRY
)
LIMIT 1;

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
SELECT * FROM BERRY
ORDER BY BERRY.max_num_harvest DESC;
----------------
-- #Trigger 3.1#
-- Dissenyeu un disparador que curi al primer Pokémon de l’equip d’un entrenador 
-- per la quantitat de curació d’un objecte cada vegada que aquest s’elimini o resti de 
-- la motxilla del jugador. Assegureu-vos de que la vida curada no supera el màxima 
-- de HP del Pokémon, que es pot calcular a partir de la fórmula a la pregunta 5.7.
CREATE OR REPLACE FUNCTION heals()
RETURNS TRIGGER AS $$

BEGIN
	IF EXISTS (SELECT 1
	   	FROM ITEM AS IT
	   	JOIN HEAL AS H ON IT.id_object = H.id_heal
		WHERE IT.id_object = old.id_object)
	THEN

	UPDATE POKEMON_CAUGHT AS PC
	SET pokemon_remaining_hp = 
				(SELECT ROUND(LEAST (PC.pokemon_remaining_hp + 
									   (SELECT H.heal_points
										FROM ITEM AS IT
										JOIN HEAL AS H ON IT.id_object = H.id_heal
										WHERE IT.id_object = 26)
									  , CASE WHEN N.id_stat_incremented = BS.id_base_stat AND BS.name = 'hp' THEN (((2*AB.base_value+ (pow(PC.level,2)/4))/100 + 5) * 1.1)
											 WHEN N.id_stat_decremented = BS.id_base_stat AND BS.name = 'hp' THEN (((2*AB.base_value+ (pow(PC.level,2)/4))/100 + 5) * 0.9)
											 ELSE (((2*AB.base_value+ (pow(PC.level,2)/4))/100 + 5)) END)) prova
				FROM TEAM AS TE 
						JOIN TRAINER AS TP ON TE.id_trainer = TP.id_trainer
						JOIN NATURE AS N ON N.id_nature = PC.id_nature
						JOIN POKEMON AS POK ON POK.id_pokemon = PC.id_pokemon
						JOIN ACQUIRE_BASE_STAT AS AB ON AB.id_pokemon = POK.id_pokemon
						JOIN BASE_STAT AS BS ON BS.id_base_stat = AB.id_base_stat
						JOIN BACKPACK AS BP ON BP.id_trainer = TP.id_trainer
						WHERE TE.slot = 1 and BS.name = 'hp' AND TE.id_pokemon_caught = PC.id_pokemon_caught
						AND BP.id_backpack = old.id_backpack)
	WHERE PC.id_pokemon_caught = (SELECT PC2.id_pokemon_caught
		FROM POKEMON_CAUGHT AS PC2
		JOIN TEAM AS TE ON TE.id_pokemon_caught = PC2.id_pokemon_caught
		JOIN TRAINER AS TP ON TE.id_trainer = TP.id_trainer
		JOIN BACKPACK AS BP ON BP.id_trainer = TP.id_trainer
		WHERE TE.slot = 1 AND BP.id_backpack = old.id_backpack
		);

	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS healing ON CONTAINS_ITEM;
CREATE TRIGGER healing
AFTER DELETE ON CONTAINS_ITEM
FOR EACH ROW
EXECUTE FUNCTION heals();

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
SELECT * FROM BASE_STAT;

SELECT * 
		FROM POKEMON_CAUGHT AS PC2
		JOIN TEAM AS TE ON TE.id_pokemon_caught = PC2.id_pokemon_caught
		JOIN TRAINER AS TP ON TE.id_trainer = TP.id_trainer
		JOIN BACKPACK AS BP ON BP.id_trainer = TP.id_trainer
		WHERE TE.slot = 1 AND 
		BP.id_backpack = 260 
		;

select * from backpack;

select LOWER(PC.pokemon_remaining_hp + H.heal_points
		  , CASE WHEN N.id_stat_incremented = BS.id_base_stat AND BS.name = 'hp' THEN (((2*AB.base_value+ (pow(PC.level,2)/4))/100 + 5) * 1.1)
				 WHEN N.id_stat_decremented = BS.id_base_stat AND BS.name = 'hp' THEN (((2*AB.base_value+ (pow(PC.level,2)/4))/100 + 5) * 0.9)
				 ELSE (((2*AB.base_value+ (pow(PC.level,2)/4))/100 + 5)) END)
FROM POKEMON_CAUGHT AS PC
	JOIN TEAM AS TE ON TE.id_pokemon_caught = PC.id_pokemon_caught
	JOIN TRAINER AS TP ON TE.id_trainer = TP.id_trainer
	JOIN NATURE AS N ON N.id_nature = PC.id_nature
	JOIN POKEMON AS POK ON POK.id_pokemon = PC.id_pokemon
	JOIN ACQUIRE_BASE_STAT AS AB ON AB.id_pokemon = POK.id_pokemon
	JOIN BASE_STAT AS BS ON BS.id_base_stat = AB.id_base_stat
	JOIN ITEM AS IT ON IT.id_object = 
	JOIN HEAL AS H ON IT.id_object = H.id_heal
WHERE TE.slot = 1 AND 
		BP.id_backpack = 260 
		IT.id_object = 26    
;

select * from contains_item 
join item on contains_item.id_object = item.id_object
where id_backpack = 260 and 
item.name_object like '%potion%';

SELECT PC.pokemon_remaining_hp, ROUND(LEAST (PC.pokemon_remaining_hp + 
					   (SELECT H.heal_points
						FROM ITEM AS IT
	   					JOIN HEAL AS H ON IT.id_object = H.id_heal
						WHERE IT.id_object = 26)
					  , CASE WHEN N.id_stat_incremented = BS.id_base_stat AND BS.name = 'hp' THEN (((2*AB.base_value+ (pow(PC.level,2)/4))/100 + 5) * 1.1)
					  		 WHEN N.id_stat_decremented = BS.id_base_stat AND BS.name = 'hp' THEN (((2*AB.base_value+ (pow(PC.level,2)/4))/100 + 5) * 0.9)
					  		 ELSE (((2*AB.base_value+ (pow(PC.level,2)/4))/100 + 5)) END)) prova
FROM POKEMON_CAUGHT AS PC
		JOIN TEAM AS TE ON TE.id_pokemon_caught = PC.id_pokemon_caught
		JOIN TRAINER AS TP ON TE.id_trainer = TP.id_trainer
		JOIN NATURE AS N ON N.id_nature = PC.id_nature
		JOIN POKEMON AS POK ON POK.id_pokemon = PC.id_pokemon
		JOIN ACQUIRE_BASE_STAT AS AB ON AB.id_pokemon = POK.id_pokemon
		JOIN BASE_STAT AS BS ON BS.id_base_stat = AB.id_base_stat
		JOIN BACKPACK AS BP ON BP.id_trainer = TP.id_trainer
		WHERE TE.slot = 1 and BS.name = 'hp'
		AND BP.id_backpack = 260 --old.id_backpack
		;
		
INSERT INTO CONTAINS_ITEM VALUES (260, 26, '', CURRENT_TIMESTAMP);

DELETE FROM CONTAINS_ITEM
WHERE id_backpack = 260 
		AND id_object = 26    
		;
		
UPDATE POKEMON_CAUGHT AS PC
SET pokemon_remaining_hp = 0
WHERE PC.id_pokemon_caught = (SELECT PC2.id_pokemon_caught
	FROM POKEMON_CAUGHT AS PC2
	JOIN TEAM AS TE ON TE.id_pokemon_caught = PC2.id_pokemon_caught
	JOIN TRAINER AS TP ON TE.id_trainer = TP.id_trainer
	JOIN BACKPACK AS BP ON BP.id_trainer = TP.id_trainer
	WHERE TE.slot = 1 AND BP.id_backpack = 260 
	);
----------------
-- #Trigger 3.2#
-- Creeu un disparador que us permeti realitzar totes les modificacions necessàries a 
-- les taules sempre i quan una compra sigui feta. Per tant, actualitzeu la quantitat 
-- d’or de l’entrenador comprador restant la quantitat corresponent d’or, actualitzeu 
-- l’inventari de la botiga, i creeu una entrada o actualitzeu la quantitat de l’objecte
-- dins de la motxilla del jugador. Si l’entrenador no té suficient or a la motxilla, creeu 
-- una entrada a Warnings amb el missatge:

-- “Trainer #<trainer_id> tried to buy <item_name> but his card has been declined, 
-- insufficient funds.”
-- Si no hi ha suficient existències a la botiga, creeu una entrada a la taula Warnings
-- amb el següent missatge:
-- “Trainer #<trainer_id> tried to buy <item_name> at <store_name> store in 
-- <store_city_name>, however the store ran out of stock.
CREATE OR REPLACE FUNCTION buying_items()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    	FROM TRAINER AS TR
	  	WHERE new.id_trainer = TR.id_trainer AND TR.pokeCoins_trainer - new.cost >= 0
  ) THEN
    INSERT INTO WARNING_TABLE (id_trainer, warning_message)
    SELECT new.id_trainer, 
	format('Trainer #%s tried to buy %s but his card has been declined, insufficient funds.', new.id_trainer, IT.name_object)
	FROM ITEM AS IT
	WHERE new.id_object = IT.id_object
	;

    RETURN NULL;
  END IF;
  
  
  IF NOT EXISTS (
    SELECT 1
    	FROM STORE AS ST
	  	JOIN SELLS AS SL ON SL.id_store = ST.id_store
	  	WHERE new.id_store = ST.id_store AND new.id_object = SL.id_object AND SL.stock > 0
  ) THEN
    INSERT INTO WARNING_TABLE (id_trainer, warning_message)
    SELECT new.id_trainer, 
	format('Trainer #%s tried to buy %s at %s store in %s, however the store ran out of stock.', new.id_trainer, IT.name_object, ST.store_name, AR.area_name)
	FROM ITEM AS IT
	JOIN SELLS AS SL ON SL.id_object = IT.id_object
	JOIN STORE AS ST ON ST.id_store = SL.id_store
	JOIN AREA AS AR ON AR.id_area = ST.id_area
	JOIN CITY AS CY ON CY.id_area = AR.id_area
	WHERE new.id_object = IT.id_object and new.id_store = ST.id_store
	;

    RETURN NULL;
  END IF;

  UPDATE SELLS SET stock = GREATEST(stock - 1, 0)
  WHERE SELLS.id_store = new.id_store and SELLS.id_object = new.id_object;
  
  INSERT INTO CONTAINS_ITEM (id_backpack, id_object, obtention_method, date_time)
  VALUES (new.id_trainer, new.id_object, 'BOUGHT', CURRENT_TIMESTAMP);

  UPDATE TRAINER SET pokeCoins_trainer = pokeCoins_trainer - new.cost
  WHERE id_trainer = new.id_trainer;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS buying ON BUYS;
CREATE TRIGGER buying
AFTER INSERT ON BUYS
FOR EACH ROW
EXECUTE FUNCTION buying_items();

-- #Validation#
-- if needed, write the validation queries (select, update, inserte, delete)
SELECT * FROM STORE
WHERE id_store = 31;

SELECT ITEM.name_object, SELLS.* FROM SELLS
JOIN ITEM ON ITEM.id_object = SELLS.id_object
WHERE id_store = 31 and name_object = 'pp max';

INSERT INTO BUYS (id_transaction, id_trainer, id_store, id_object, amount, cost, discount, date_time) 
VALUES ((SELECT max(id_transaction) FROM BUYS) + 1, 45, 31, 53, 1, 1800, 0, current_timestamp);

SELECT * FROM CONTAINS_ITEM
WHERE id_backpack = 45
;

SELECT 53, 
	format('Trainer #%s tried to buy %s at %s store in %s, however the store ran out of stock.', 45, IT.name_object, ST.store_name, AR.area_name)
	FROM ITEM AS IT
	JOIN SELLS AS SL ON SL.id_object = IT.id_object
	JOIN STORE AS ST ON ST.id_store = SL.id_store
	JOIN AREA AS AR ON AR.id_area = ST.id_area
	JOIN CITY AS CY ON CY.id_area = AR.id_area
	WHERE 53 = IT.id_object and 31 = ST.id_store;

SELECT 45, 
	format('Trainer #%s tried to buy %s but his card has been declined, insufficient funds.', 45, IT.name_object)
	FROM ITEM AS IT
	WHERE 45 = IT.id_object;

SELECT 1
    	FROM STORE AS ST
	  	JOIN SELLS AS SL ON SL.id_store = ST.id_store
	  	WHERE 31 = ST.id_store AND 53 = SL.id_object AND SL.stock > 0;

SELECT * FROM WARNING_TABLE;


