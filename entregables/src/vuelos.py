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
from uuid import uuid1


with open("entregables/data/vuelos.csv","r",encoding="utf-8") as f:
  lines = f.readlines()
  cabecera, allFlights = lines[0].replace("\n",""), lines[1:]
allFlights = [line.replace("\n","") for line in allFlights]

# Vuelos
vuelos_all = [",".join(flight.split(',')[:13]) for flight in allFlights]  # data para la tabla vuelos
vuelos = []
for flight in vuelos_all:
  aux = flight.split(',')
  vuelos.append("\'" + aux[0] + "\'," + aux[1] + ",\'" + "\',\'".join(aux[2:6]) + "\'," + ",".join(aux[6:]))

# Incidencias
# Incidencias - cancelaciones
cancellationType = {
  'A':'Carrier',
  'B':'Weather',
  'C':'National Air System',
  'D':'Security'
}

inc_cancelaciones = [str(flight) for flight in allFlights if flight.split(',')[13] == "1"]
cancelaciones = []
for flight in inc_cancelaciones:
  aux  = flight.split(',')
  uuid = aux[0]
  data = aux[14]
  cancelaciones.append("\'" + str(uuid1()) + "\',\'" + uuid + "\',\'" + cancellationType[data] + "\'")

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
      retrasos.append("\'" + str(uuid1()) + "\',\'" + uuid + "\',\'" + delayTypes[str(i[0])] + "\'," + i[1])

# Incidencias - desvios
inc_desvios = [flight for flight in allFlights if flight.split(',')[20] == "1"]
desvios = []
for flight in inc_desvios:
  aux  = flight.split(',') 
  uuid = aux[0]
  tailnum = aux[3]
  origen, destino = aux[4], aux[5]
  data = aux[21:26]
  div1, div2 = aux[26:28], aux[28:30]

  # PREFIX = "\'" + str(uuid1()) + "\',\'" + uuid + "\'," + str(data).replace("[","").replace("]","").replace(" ","").replace("\'\'","NULL").replace("\'","") + ","
  PREFIX = "\'" + str(uuid1()) + "\',\'" + uuid + "\',"

  if (div1[0] != "NULL" and div1[0] != "") and (div2[0] != "NULL" and div2[0] != "") and data[1] == "0":
    desvios.append(PREFIX + "\'" + origen + "\',\'" + tailnum + "\',\'" + div1[0] + "\'")
    desvios.append(PREFIX + "\'" + div1[0]+ "\',\'" + div1[1] + "\',\'" + div2[0] + "\'")
  elif (div1[0] != "NULL" and div1[0] != "") and (div2[0] != "NULL" and div2[0] != "") and data[1] == "1":
    desvios.append(PREFIX + "\'" + origen + "\',\'" + tailnum + "\',\'" + div1[0] + "\'")
    desvios.append(PREFIX + "\'" + div1[0]+ "\',\'" + div1[1] + "\',\'" + div2[0] + "\'")
    desvios.append(PREFIX + "\'" + div2[0]+ "\',\'" + div2[1] + "\',\'" + destino + "\'")
  elif (div1[0] != "NULL" and div1[0] != "") and data[1] == "0":
    desvios.append(PREFIX + "\'" + origen + "\',\'" + tailnum + "\',\'" + div1[0] + "\'")
  elif (div1[0] != "NULL" and div1[0] != "") and data[1] == "1":
    desvios.append(PREFIX + "\'" + origen + "\',\'" + tailnum + "\',\'" + div1[0] + "\'")
    desvios.append(PREFIX + "\'" + div1[0]+ "\',\'" + div1[1] + "\',\'" + destino + "\'")
  else:
    desvios.append(PREFIX + "\'" + origen + "\',\'" + tailnum + "\',\'" + origen + "\'")

def createInsert(tabla: str, cabeceras: str, values: str) -> str:
  return f"INSERT INTO {tabla} {cabeceras} VALUES ({values});\n"

cabeceraVuelos = ["id","flightNum","flightDate","tailNum","origin","destination","distance","depTime","arrTime","crsDepTime","crsArrTime","crsElapsedTime","actualElapsedTime"]
cabeceraCancelaciones = ["id", "idVuelo", "cancellationCode"]
cabeceraDesvios = ["id", "idVuelo","origin","tailNum","destination"]
cabeceraDelays = ["id", "idVuelo", "delayType", "delay"]

for cabeceras, tabla, data in zip([cabeceraVuelos, cabeceraCancelaciones, cabeceraDesvios, cabeceraDelays], ["vuelo", "cancelaciones", "desvios", "retrasos"], [vuelos, cancelaciones, desvios, retrasos]):
  with open(f"entregables/sql/{tabla}.sql", "w", encoding="utf-8") as f:
    cabeceras = str(cabeceras).replace("[","(").replace("]",")").replace(" ","").replace("\'","")
    for row in data:
      f.write(createInsert(tabla, cabeceras, row))