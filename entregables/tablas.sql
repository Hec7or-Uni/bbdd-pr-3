CREATE TABLE aeropuerto (
  iata    VARCHAR2(4),
  airport VARCHAR2(45)  NOT NULL,
  country VARCHAR2(30)  NOT NULL,
  state   VARCHAR2(2)   NOT NULL,
  city    VARCHAR2(35)  NOT NULL,
  lat     NUMBER        NOT NULL,
  lon     NUMBER        NOT NULL,
  CONSTRAINT pk_aeropuerto  PRIMARY KEY (iata)
);

CREATE TABLE vuelo (
  id                VARCHAR2(40),
  flightDate        VARCHAR2(10)  NOT NULL,
  flightNum         NUMBER        NOT NULL,
  distance          NUMBER        NOT NULL,
  origin            VARCHAR2(4)   NOT NULL,
  destination       VARCHAR2(4)   NOT NULL,
  tailNum           VARCHAR2(7),
  depTime           VARCHAR2(4),
  arrTime           VARCHAR2(4),
  crsDepTime        VARCHAR2(4)   NOT NULL,
  crsArrTime        VARCHAR2(4)   NOT NULL,
  crsElapsedTime    NUMBER        NOT NULL,
  actualElapsedTime NUMBER,
  CONSTRAINT pk_vuelo             PRIMARY KEY (id),
  CONSTRAINT fk_vuelo_origin      FOREIGN KEY (origin)      REFERENCES aeropuerto(iata),
  CONSTRAINT fk_vuelo_destination FOREIGN KEY (destination) REFERENCES aeropuerto(iata),
  CONSTRAINT fk_vuelo_tailNum     FOREIGN KEY (tailNum)     REFERENCES avion(tailNum)
);

CREATE TABLE avion (
  tailNum VARCHAR2(7),
  carrier VARCHAR2(7),
  modelId VARCHAR2(40),
  year    NUMBER,
  CONSTRAINT pk_avion  PRIMARY KEY (tailNum),
  CONSTRAINT fk_avion_carrier  FOREIGN KEY (carrier) REFERENCES aerolinea(code),
  CONSTRAINT fk_avion_modelId  FOREIGN KEY (modelId) REFERENCES modelo(id)
);

CREATE TABLE aerolinea (
  code  VARCHAR2(7),
  name  VARCHAR2(100) NOT NULL,
  CONSTRAINT pk_aerolinea  PRIMARY KEY (code)
);

CREATE TABLE modelo (
  id            VARCHAR2(40),
  model         VARCHAR2(20) NOT NULL,
  aircraftType  VARCHAR2(25) NOT NULL,
  engineType    VARCHAR2(15) NOT NULL,
  manufacturer  VARCHAR2(30) NOT NULL,
  CONSTRAINT pk_modelo  PRIMARY KEY (id),
  CONSTRAINT fk_modelo_manufacturer FOREIGN KEY (manufacturer)  REFERENCES fabricante(manufacturer)
);

CREATE TABLE fabricante (
  manufacturer  VARCHAR2(30),
  CONSTRAINT pk_fabricante  PRIMARY KEY (manufacturer)
);

-- INCIDENCIAS
CREATE TABLE incidencias (
  id  VARCHAR2(40),
  CONSTRAINT pk_  PRIMARY KEY (id),
);

CREATE TABLE cancelaciones (
  id            VARCHAR2(40),
  cancellation  VARCHAR2(100) NOT NULL,
  CONSTRAINT pk_  PRIMARY KEY (id),
  CONSTRAINT fk_  FOREIGN KEY (id)  REFERENCES incidencias(id),
);

CREATE TABLE desvio (
  id  VARCHAR2(40),
  CONSTRAINT pk_  PRIMARY KEY (id),
  CONSTRAINT fk_  FOREIGN KEY (id)  REFERENCES incidencias(id),
  CONSTRAINT fk_  FOREIGN KEY (id) REFERENCES avion(tailNum)
  CONSTRAINT fk_  FOREIGN KEY (id) REFERENCES aeropuerto(iata)
);

CREATE TABLE retraso (
  id        VARCHAR2(40),
  delay     NUMBER  NOT NULL,
  delayType VARCHAR2(50),
  CONSTRAINT pk_  PRIMARY KEY (id),
  CONSTRAINT fk_  FOREIGN KEY (id)  REFERENCES incidencias(id),
);