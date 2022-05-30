-- TRIGGER 1:
-- Comprueba que si un vuelo esta cancelado, no pueda tener desvios
CREATE OR REPLACE TRIGGER EXC_DESVIOS
BEFORE INSERT ON desvios
FOR EACH ROW
DECLARE 
    flag NUMBER;
BEGIN
    SELECT COUNT(*) INTO flag
    FROM cancelaciones
    WHERE idVuelo = :NEW.idVuelo;

    IF flag >= 1 THEN
        RAISE_APPLICATION_ERROR (-20001, 'No puede haber desvio puesto que el vuelo ha sido cancelado');
    END IF;
END; 
/

-- TRIGGER 2:
-- compurbe a que exista un primer vuelo desvio correcto
CREATE OR REPLACE TRIGGER EXT_PRIMER_DESVIO
BEFORE INSERT ON desvios
FOR EACH ROW
DECLARE 
    flag NUMBER;
    origin VARCHAR2(4);
BEGIN
    SELECT origin INTO origin
    FROM vuelo
    WHERE id = :NEW.idVuelo;

    SELECT COUNT(*) INTO flag
    FROM desvios
    WHERE idVuelo = :NEW.idVuelo;

    IF origin <> :NEW.origin and flag = 0 THEN   -- No es el mismo avion que el del vuelo original vuelo
        RAISE_APPLICATION_ERROR (-20002, 'No existe el primer desvio del vuelo: ' || :NEW.idVuelo || ', con matricula: ' || origin);
    END IF;
END; 
/

-- TRIGGER 3: 
-- Un vuelo no puede tener una fecha de salida anterior a la creacion del avion
CREATE OR REPLACE TRIGGER FECHAS
BEFORE INSERT ON vuelo
FOR EACH ROW
DECLARE 
    flag NUMBER;
BEGIN
    SELECT COUNT(*) INTO flag
    FROM avion
    WHERE year > SUBSTR(:NEW.flightDate,1,4);
    IF flag >= 1 THEN
        RAISE_APPLICATION_ERROR (-20003, 'Error al añadir el vuelo: la fecha del vuelo no puede ser anterior a la de creacion del avion');
    END IF;
END; 