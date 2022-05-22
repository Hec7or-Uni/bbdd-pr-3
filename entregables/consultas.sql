-- CONSULTA 1
-- Calcular el número de compañías que operan en al menos cinco aeropuertos de Alaska
-- --Aeropuertos alaska
-- SELECT iata AS IDS FROM aeropuerto WHERE STATE = 'AK';

-- SELECT carrier AS vuelosAlaska FROM vuelo,avion WHERE (origin IN IDS OR destination IN IDS) AND vuelo.tailNum == avion.tailNum;

-- SELECT COUNT(*) FROM aerolinea WHERE code IN vuelosAlaska GROUP BY code HAVING COUNT(*) > 4;

SELECT COUNT(*)
FROM AEROLINEA, (
    SELECT CARRIER
      FROM VUELO, AVION, (
          SELECT iata AS IDS
          FROM aeropuerto
          WHERE STATE = 'AK'
      )
      WHERE (VUELO.origin in IDS OR VUELO.DESTINATION in IDS) AND VUELO.tailNum = AVION.tailNum
     GROUP BY CARRIER
     HAVING COUNT(*) > 4
     ) vuelosAlaska
WHERE AEROLINEA.CODE in vuelosAlaska.CARRIER


-- CONSULTA 2
-- Obtener el aeropuerto en el que operan los aviones más modernos (es decir, con menor media de edad). Obtener
-- tanto el nombre y el código del aeropuerto como la media de edad de los aviones que operan en él.

SELECT B.iata,B.media,A.airport FROM aeropuerto A,(
    SELECT * FROM (
        SELECT * FROM (
            SELECT iata,AVG(2022-year) media FROM (
                SELECT * FROM aeropuerto,vuelo,avion WHERE avion.tailNum = vuelo.tailNum 
                AND (vuelo.destination = aeropuerto.iata OR vuelo.origin = aeropuerto.iata)
            ) GROUP BY iata)
        ORDER BY media
    ) WHERE ROWNUM = 1
) B WHERE A.iata = B.iata;

-- CONSULTA 3
-- Obtener la compañía (o compañías, en caso de empate) con el mayor porcentaje de vuelos que despegan y aterrizan
-- en un mismo estado.

--vuelos que despegan y aterrizan en el mismo estado

SELECT A.name FROM aerolinea A, (SELECT * FROM (SELECT * FROM(SELECT P.carrier, COUNT(*) veces FROM (SELECT carrier FROM avion, (SELECT tailNum FROM vuelo,aeropuerto A,aeropuerto B WHERE origin = A.iata AND destination = B.iata AND A.state = B.state) Z WHERE avion.tailNum = Z.tailNum) P GROUP BY P.carrier) ORDER BY veces DESC) WHERE ROWNUM = 1) B WHERE A.code = B.carrier;

SELECT A.name FROM aerolinea A, (
    SELECT * FROM (
        SELECT * FROM(
            SELECT P.carrier, COUNT(*) veces FROM (
                SELECT carrier FROM vuelo,aeropuerto A,aeropuerto B WHERE origin = A.iata 
                AND destination = B.iata AND A.state = B.state)
            P GROUP BY P.carrier) 
        ORDER BY veces DESC)
WHERE ROWNUM = 1) B WHERE A.code = B.carrier;