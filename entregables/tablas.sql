CREATE TABLE aeropuerto (
  IATA    VARCHAR2(4),
  airport VARCHAR2(45)  NOT NULL,
  country VARCHAR2(30)  NOT NULL,
  state   VARCHAR2(2)   NOT NULL,
  city    VARCHAR2(35)  NOT NULL,
  lat     NUMBER        NOT NULL,
  lon     NUMBER        NOT NULL,
  CONSTRAINT pk_  PRIMARY KEY (IATA),
);

CREATE TABLE vuelo (
  id                NUMBER,
  flightNum         NUMBER      NOT NULL,
  distance          NUMBER      NOT NULL,
  origin            VARCHAR2(4) NOT NULL, -- Eliminar del e/r
  destination       VARCHAR2(4) NOT NULL, -- Eliminar del e/r
  tailNum           VARCHAR2(7) NOT NULL,
  depTime           VARCHAR2(4) NOT NULL,
  arrTime           VARCHAR2(4) NOT NULL,
  crsDepTime        VARCHAR2(4) NOT NULL,
  crsArrTime        VARCHAR2(4) NOT NULL,
  crsElapsedTime    NUMBER      NOT NULL,
  actualElapsedTime NUMBER      NOT NULL,
  -- incidencias
  CONSTRAINT pk_  PRIMARY KEY (id),
  CONSTRAINT fk_  FOREIGN KEY (origin)      REFERENCES aeropuerto(IATA),
  CONSTRAINT fk_  FOREIGN KEY (destination) REFERENCES aeropuerto(IATA),
  CONSTRAINT fk_  FOREIGN KEY (tailNum)     REFERENCES avion(tailNum),
  -- incidencias
);

CREATE TABLE avion (
  tailNum VARCHAR2(7),
  year    NUMBER        NOT NULL,
  carrier VARCHAR2(7)   NOT NULL,
  model   VARCHAR2(20)  NOT NULL,
  CONSTRAINT pk_  PRIMARY KEY (tailNum),
  CONSTRAINT fk_  FOREIGN KEY (carrier) REFERENCES aerolinea(code),
  CONSTRAINT fk_  FOREIGN KEY (model)   REFERENCES modelo(model),
);

CREATE TABLE aerolinea (
  code  VARCHAR2(7),            -- No se repite (pk?)
  name  VARCHAR2(100) NOT NULL, -- No se repite (pk?)
  CONSTRAINT pk_  PRIMARY KEY (code),
);

CREATE TABLE modelo (
  model         VARCHAR2(20),
  aircraftType  VARCHAR2(25) NOT NULL,
  engineType    VARCHAR2(15) NOT NULL,
  manufacturer  VARCHAR2(15) NOT NULL,
  CONSTRAINT pk_  PRIMARY KEY (model),
  CONSTRAINT fk_  FOREIGN KEY (manufacturer)  REFERENCES fabricante(manufacturer),
);

CREATE TABLE fabricante (
  manufacturer  VARCHAR2(15),
  CONSTRAINT pk_  PRIMARY KEY (manufacturer),
);

-- INCIDENCIAS -- PENDIENTE DE REVISION LOS TIPOS DE INCIDENCIAS (TIPO DE TRADUCCION)
CREATE TABLE cancelaciones (
  id            NUMBER,
  cancellation  VARCHAR2(100) NOT NULL,
  CONSTRAINT pk_  PRIMARY KEY (id),
);

CREATE TABLE desvio (
  id  NUMBER,
  CONSTRAINT pk_  PRIMARY KEY (id),
  CONSTRAINT fk_  FOREIGN KEY (id) REFERENCES avion(tailNum)
  CONSTRAINT fk_  FOREIGN KEY (id) REFERENCES aeropuerto(IATA)
);

CREATE TABLE retraso (
  id        NUMBER,
  delay     NUMBER  NOT NULL,
  delayType VARCHAR2(50),
  CONSTRAINT pk_  PRIMARY KEY (id),
);