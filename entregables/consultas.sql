-- CONSULTA 1
-- Calcular el número de compañías que operan en al menos cinco aeropuertos de Alaska
--Aeropuertos alaska
SELECT iata AS IDS FROM aeropuerto WHERE state == "AK";

SELECT carrier AS vuelosAlaska FROM vuelo,avion WHERE (origin IN IDS OR destination IN IDS) AND vuelo.tailNum == avion.tailNum;

SELECT COUNT(*) FROM aerolinea WHERE code IN vuelosAlaska GROUP BY code HAVING COUNT(*) > 4;

-- CONSULTA 2
-- Obtener el aeropuerto en el que operan los aviones más modernos (es decir, con menor media de edad). Obtener
-- tanto el nombre y el código del aeropuerto como la media de edad de los aviones que operan en él.

SELECT iata,airport,year AS aeropuertoEdad FROM aeropuerto,vuelo,avion WHERE (vuelo.destination == aeropuerto.iata OR vuelo.origin == aeropuerto.iata) AND vuelo.tailNum == avion.tailNum;
SELECT MAX(AVG(aeropuertoEdad)) GROUP BY iata; 

-- CONSULTA 3
-- Obtener la compañía (o compañías, en caso de empate) con el mayor porcentaje de vuelos que despegan y aterrizan
-- en un mismo estado.
