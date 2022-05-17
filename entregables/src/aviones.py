# UUID, modelo
# Separamos el uuid del modelo
with open("entregables/sql/modelo.sql","r",encoding="utf-8") as f:
  model_lines = f.readlines()[7:]
  model_lines = [line[75:-3].replace("\'", "").replace("\n","") for line in model_lines]
  model_lines_uuid = [line.split(",")[0] for line in model_lines]               # Lista de UUIDs   manteniendo el orden 
  model_lines_model = [",".join(line.split(",")[1:]) for line in model_lines]   # Lista de modelos manteniendo el orden 

# Separamos informacion del avion del modelo
with open("entregables/data/aviones.csv","r",encoding="utf-8") as f:
  plane_lines = f.readlines()[1:]
  plane_lines = [line.replace("\n","") for line in plane_lines]
  # parte de la linea de avion que identifica un modelo
  plane_lines_rest  = [",".join(line.split(",")[:3]) for line in plane_lines]   # Lista de info avion manteniendo el orden 
  plane_lines_model = [",".join(line.split(",")[3:]) for line in plane_lines]   # Lista de modelos    manteniendo el orden 

# Creamos un dict({ 'modelo':'uuid' })
model_dict = dict()
for uuid, model in zip(model_lines_uuid, model_lines_model):
  model_dict.update({ str(model) : str(uuid) })

# sustitucion en avion del modelo por uuid
def getUUID(model: str) -> str:
  try:
    return model_dict[model]
  except:
    return "NULL"

planes = list()  # lista de datos para los insert
for rest, model in zip(plane_lines_rest, plane_lines_model):
  planes.append(rest + "," + getUUID(model))

# generacion de los insert
with open("entregables/sql/avion.sql","w",encoding="utf-8") as f:
  PREFIX = "INSERT INTO avion (tailNum,year,carrier,modelId) VALUES ("
  SUFIX = ");\n"
  for p_info in planes:
    p_info = str(p_info.split(',')).replace("[","").replace("]", "").replace(" ","").replace("\'NULL\'","NULL")
    f.write(PREFIX + p_info + SUFIX)