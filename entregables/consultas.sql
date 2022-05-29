-- CONSULTA 1
-- Calcular el número de compañías que operan en al menos cinco aeropuertos de Alaska
select count(*) as "Número de aerolineas"
from (
	select carrier
	from (
		select V.origin, carrier
		from aeropuerto A, vuelo V
		where A.iata = V.origin and A.state = 'AK'
		group by iata, carrier
	) A
	group by carrier
	having count(*) >= 5
) N;


-- CONSULTA 2
-- Obtener el aeropuerto en el que operan los aviones más modernos (es decir, con menor media de edad). Obtener
-- tanto el nombre y el código del aeropuerto como la media de edad de los aviones que operan en él.

-- nueva, falta sacar la primera linea
select AE.airport, AE.iata, AVG(2022 - AV.year) as average
from aeropuerto AE, vuelo V, avion AV
where (AE.iata = V.origin or AE.iata = V.origin) and AV.tailNum = V.tailNum and
	AV.year is not null
group by AE.iata
order by 3;

-- vieja
SELECT B.iata, B.media, A.airport FROM aeropuerto A (
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

-- nueva, falta sacar la primera linea
select A.carrier, round((A.num / B.num * 100), 2) as 'porcentaje'
from (
	select S.carrier, COUNT(*) as num
	from (
		select V.carrier, A1.state as origin, A2.state as destination
		from vuelo V, aeropuerto A1, aeropuerto A2
		where V.origin = A1.iata and V.destination = A2.iata and A1.state = A2.state
	) S
	group by S.carrier
) A, (
	select T.carrier, COUNT(*) as num
	from (
		select V.carrier, A1.state as origin, A2.state as destination
		from vuelo V, aeropuerto A1, aeropuerto A2
		where V.origin = A1.iata and V.destination = A2.iata
	) T
	group by T.carrier
) B
where A.carrier = B.carrier
order by porcentaje desc;

-- vieja
SELECT A.name FROM aerolinea A, (
    SELECT * FROM (
        SELECT (A.veces/T.veces), T.carrier FROM(
            SELECT P.carrier, COUNT(*) veces FROM (
                SELECT carrier FROM vuelo,aeropuerto A,aeropuerto B WHERE origin = A.iata 
                AND destination = B.iata AND A.state = B.state)
            P GROUP BY P.carrier) A,(SELECT carrier, COUNT(*) veces FROM (
                SELECT carrier FROM vuelo) GROUP BY carrier) T
        ORDER BY (A.veces/T.veces) DESC)
WHERE ROWNUM = 1) B WHERE A.code = B.carrier;
