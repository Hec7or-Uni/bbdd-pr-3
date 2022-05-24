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

-- TRIGGER 3: Un desvio no puede tener un origen distinto al origen del vuelo original o un desvio no puede tener un destino igual al destino del vuelo original
CREATE OR REPLACE TRIGGER DIST_DESVIO
AFTER INSERT ON desvios
FOR EACH ROW
DECLARE 
    flag NUMBER;
BEGIN
    SELECT COUNT(*) INTO flag
    FROM vuelo
    WHERE id = :NEW.idVuelo AND (origin <> NEW.origin OR destination = NEW.destination)
        IF flag < 1 THEN
            RAISE_APPLICATION_ERROR (-20000, 'Error al añadir desvio: el origen del vuelo es distinto al origen del desvio o el destino del vuelo es 
                                    igual al destino del desvio');
    END IF;
END; 