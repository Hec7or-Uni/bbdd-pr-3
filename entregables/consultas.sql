-- CONSULTA 1
-- Calcular el número de compañías que operan en al menos cinco aeropuertos de Alaska
select count(*) as "Número de aerolineas"
from (
	select carrier
	from (
		select distinct V.origin, carrier
		from aeropuerto A, vuelo V
		where A.iata = V.origin and A.state = 'AK'
	) A
	group by carrier
	having count(*) >= 5
) N;


-- CONSULTA 2
-- Obtener el aeropuerto en el que operan los aviones más modernos (es decir, con menor media de edad). Obtener
-- tanto el nombre y el código del aeropuerto como la media de edad de los aviones que operan en él.

select S.airport, S.iata, FLOOR(S.average)
from (
	select AE.airport, AE.iata, AVG(2022 - AV.year) as average
	from aeropuerto AE, vuelo V, avion AV
	where (AE.iata = V.origin or AE.iata = V.origin) and AV.tailNum = V.tailNum and
		AV.year is not null
	group by AE.airport, AE.iata
) S
where S.average = (
	select MIN(average) as minimo
	from (
		select AE.airport, AE.iata, AVG(2022 - AV.year) as average
		from aeropuerto AE, vuelo V, avion AV
		where (AE.iata = V.origin or AE.iata = V.origin) and AV.tailNum = V.tailNum and
			AV.year is not null
		group by AE.airport, AE.iata
	) A
);

-- CONSULTA 3
-- Obtener la compañía (o compañías, en caso de empate) con el mayor porcentaje de vuelos que despegan y aterrizan
-- en un mismo estado.

select A.name
from aerolinea A, (
	select A.carrier, ROUND((A.num / B.num * 100), 2) as 'porcentaje'
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
) B
where A.code = B.carrier and B.porcentaje = (
	select MAX(porcentaje)
	from (
		select A.carrier, ROUND((A.num / B.num * 100), 2) as 'porcentaje'
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
	) A
);

