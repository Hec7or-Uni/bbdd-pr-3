-- TRIGGER 1:
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
        RAISE_APPLICATION_ERROR (-20000, 'No puede haber desvio puesto que el vuelo ha sido cancelado');
    END IF;
END; 
/

-- TRIGGER 2:
CREATE OR REPLACE TRIGGER EXT_PRIMER_DESVIO
AFTER INSERT ON desvios
FOR EACH ROW
DECLARE 
    flag NUMBER;
    o_tailNum VARCHAR(7);
BEGIN
    SELECT tailNum INTO origin
    FROM vuelo
    WHERE id = :NEW.idVuelo;

    IF origin <> :NEW.origin THEN   -- No es el primer vuelo
        SELECT COUNT(*) INTO flag
        FROM desvios
        WHERE tailNum = :NEW.tailNum;
        IF flag < 1 THEN
            RAISE_APPLICATION_ERROR (-20000, 'No existe el primer desvio del vuelo: ' || :NEW.idVuelo || ', con matricula: ' || o_tailNum);
        END IF;
    END IF;
END; 
/

-- TRIGGER 3: NO puede haber retraso si hay cancelacion
CREATE OR REPLACE TRIGGER EXC_RETRASOS
BEFORE INSERT ON retrasos
FOR EACH ROW
DECLARE 
    flag NUMBER;
BEGIN
    SELECT COUNT(*) INTO flag
    FROM cancelaciones
    WHERE idVuelo = :NEW.idVuelo;

    IF flag >= 1 THEN
        RAISE_APPLICATION_ERROR (-20000, 'No puede haber retraso puesto que el vuelo ha sido cancelado');
    END IF;
END; 
/