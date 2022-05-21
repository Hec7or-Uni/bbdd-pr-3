-- TRIGGER 1:
CREATE OR REPLACE TRIGGER EXC_PELIS
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
CREATE OR REPLACE TRIGGER EXC_PELIS
AFTER INSERT ON desvios
FOR EACH ROW
DECLARE 
    flag NUMBER;
BEGIN
    SELECT COUNT(*) INTO flag
    FROM desvios
    WHERE idVuelo = :NEW.idVuelo;

    IF flag < 1 THEN
        RAISE_APPLICATION_ERROR (-20000, 'No existe el primer desvio del vuelo' || :NEW.idVuelo);
    END IF;
END; 
/

-- TRIGGER 3:
