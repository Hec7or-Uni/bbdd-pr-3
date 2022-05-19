# uuid(),flightNum,flightDate,tailNum,carrier,origin,destination,distance,depTime,arrTime,crsDepTime,crsArrTime,crsElapsedTime,actualElapsedTime
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


with open("entregables/data/vuelosv2.csv","r",encoding="utf-8") as f:
  lines = f.readlines()
  cabecera, allFlights = lines[0].replace("\n",""), lines[1:]
  allFlights = [line.replace("\n","") for line in allFlights]

# Vuelos
vuelos_all = [",".join(flight.split(',')[:14]) for flight in allFlights]  # data para la tabla vuelos
vuelos = []
for flight in vuelos_all:
  aux = flight.split(',')
  # uuid(),flightNum,flightDate,tailNum,carrier,origin,destination,distance,depTime,arrTime,crsDepTime,crsArrTime,crsElapsedTime,actualElapsedTime
  vuelos.append("\'" + aux[0] + "\'," + aux[1] + ",\'" + "\',\'".join(aux[2:7]).replace(",\'NULL\',",",NULL,") + "\'," + ",".join(aux[7:]).replace(",,",",NULL,").replace(",,",",NULL,").replace(",,",",NULL,").replace(",,",",NULL,").replace(",,",",NULL,"))


# Incidencias
# Incidencias - cancelaciones
cancellationType = {
  'A':'Carrier',
  'B':'Weather',
  'C':'National Air System',
  'D':'Security'
}

inc_cancelaciones = [str(flight) for flight in allFlights if flight.split(',')[14] == "1"]
cancelaciones = []
for flight in inc_cancelaciones:
  aux  = flight.split(',')
  uuid = aux[0]
  data = aux[15]
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
  data = aux[16:21]
  delays = getDelays(data)
  if len(delays) >= 0:
    for i in delays:
      retrasos.append("\'" + str(uuid1()) + "\',\'" + uuid + "\',\'" + delayTypes[str(i[0])] + "\'," + i[1])

# Incidencias - desvios
inc_desvios = [flight for flight in allFlights if flight.split(',')[21] == "1"]
desvios = []
for flight in inc_desvios:
  aux  = flight.split(',') 
  uuid = aux[0]
  tailnum = aux[3]
  origen, destino = aux[5], aux[6]
  data = aux[22:27]
  div1, div2 = aux[27:29], aux[29:31]

  PREFIX = "\',\'" + uuid + "\',"

  if (div1[0] != "NULL" and div1[0] != "") and (div2[0] != "NULL" and div2[0] != "") and data[1] == "0":
    desvios.append("\'" + str(uuid1()) + PREFIX + "\'" + origen + "\',\'" + tailnum + "\',\'" + div1[0] + "\'")
    desvios.append("\'" + str(uuid1()) + PREFIX + "\'" + div1[0]+ "\',\'" + div1[1] + "\',\'" + div2[0] + "\'")
  elif (div1[0] != "NULL" and div1[0] != "") and (div2[0] != "NULL" and div2[0] != "") and data[1] == "1":
    desvios.append("\'" + str(uuid1()) + PREFIX + "\'" + origen + "\',\'" + tailnum + "\',\'" + div1[0] + "\'")
    desvios.append("\'" + str(uuid1()) + PREFIX + "\'" + div1[0]+ "\',\'" + div1[1] + "\',\'" + div2[0] + "\'")
    desvios.append("\'" + str(uuid1()) + PREFIX + "\'" + div2[0]+ "\',\'" + div2[1] + "\',\'" + destino + "\'")
  elif (div1[0] != "NULL" and div1[0] != "") and data[1] == "0":
    desvios.append("\'" + str(uuid1()) + PREFIX + "\'" + origen + "\',\'" + tailnum + "\',\'" + div1[0] + "\'")
  elif (div1[0] != "NULL" and div1[0] != "") and data[1] == "1":
    desvios.append("\'" + str(uuid1()) + PREFIX + "\'" + origen + "\',\'" + tailnum + "\',\'" + div1[0] + "\'")
    desvios.append("\'" + str(uuid1()) + PREFIX + "\'" + div1[0]+ "\',\'" + div1[1] + "\',\'" + destino + "\'")
  else:
    desvios.append("\'" + str(uuid1()) + PREFIX + "\'" + origen + "\',\'" + tailnum + "\',\'" + origen + "\'")

def createInsert(tabla: str, cabeceras: str, values: str) -> str:
  return f"INSERT INTO {tabla} {cabeceras} VALUES ({values});\n"

cabeceraVuelos = ["id","flightNum","flightDate","tailNum","carrier","origin","destination","distance","depTime","arrTime","crsDepTime","crsArrTime","crsElapsedTime","actualElapsedTime"]
cabeceraCancelaciones = ["id", "idVuelo", "cancellation"]
cabeceraDesvios = ["id", "idVuelo","origin","tailNum","destination"]
cabeceraDelays = ["id", "idVuelo", "delayType", "delay"]

for cabeceras, tabla, data in zip([cabeceraVuelos, cabeceraCancelaciones, cabeceraDesvios, cabeceraDelays], ["vuelo", "cancelaciones", "desvios", "retrasos"], [vuelos, cancelaciones, desvios, retrasos]):
  with open(f"entregables/sql/{tabla}.sql", "w", encoding="utf-8") as f:
    cabeceras = str(cabeceras).replace("[","(").replace("]",")").replace(" ","").replace("\'","")
    for row in data:
      f.write(createInsert(tabla, cabeceras, row))