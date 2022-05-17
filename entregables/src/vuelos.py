# id,flightNum,flightDate,tailNum,origin,destination,distance,depTime,arrTime,crsDepTime,crsArrTime,crsElapsedTime,actualElapsedTime
# ===================
# cancelled,cancellationCode
# ===================
# carrierDelay,weatherDelay,nasDelay,securityDelay,lateAircraftDelay
# ===================
# diverted,
# divAirportLandings,divReachedDest,divActualElapsedTime,divArrDelay,divDistance,
# div1airport,div1TailNum,
# div2airport,div2TailNum

with open("entregables/data/vuelos.csv","r",encoding="utf-8") as f:
  lines = f.readlines()
  cabecera, allFlights = lines[0], lines[1:]
  allFlights = [line.replace("\n","") for line in allFlights]

  # Vuelos
  vuelos        = [",".join(flight.split(',')[:13]) for flight in allFlights]  # data para la tabla vuelos

  # Incidencias
  # Incidencias - cancelaciones
  inc_cancelaciones = [str(flight) for flight in allFlights if flight.split(',')[13] == "1"]
  cancelaciones = []
  for flight in inc_cancelaciones:
    aux  = flight.split(',')
    uuid = aux[0]
    data = str(aux[14:15]).replace("[","").replace("]","")
    cancelaciones.append(uuid + "," + data)

  # Incidencias - retrasos
  delayTypes = {
    '0':'carrier',
    '1':'weather',
    '2':'nas',
    '3':'security',
    '4':'lateAircraft'
  }

  def getDelays(delayList: list) -> list:
    return [(iter, item) for iter, item in zip(range(len(delayList)), delayList) if item != "NULL" and item != "0" and item != ""]

  retrasos  = []
  for flight in allFlights:
    aux  = flight.split(',') 
    uuid = aux[0]
    data = aux[15:20]
    delays = getDelays(data)
    if len(delays) >= 0:
      for i in delays:
        retrasos.append(uuid + "," + delayTypes[str(i[0])] + "," + i[1])

  # Incidencias - desvios
  inc_desvios = [flight for flight in allFlights if flight.split(',')[20] == "1"]
  desvios = []


