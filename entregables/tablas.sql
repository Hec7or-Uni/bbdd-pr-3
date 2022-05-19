CREATE TABLE aeropuerto (
  iata    VARCHAR2(4),
  airport VARCHAR2(45)  NOT NULL,
  country VARCHAR2(30)  NOT NULL,
  state   VARCHAR2(2)   NOT NULL,
  city    VARCHAR2(35)  NOT NULL,
  lat     NUMBER        NOT NULL,
  lon     NUMBER        NOT NULL,
  CONSTRAINT pk_aeropuerto  PRIMARY KEY (iata),
  UNIQUE (lat, lon),
  UNIQUE (state, city)
);

CREATE TABLE fabricante (
  manufacturer  VARCHAR2(30),
  CONSTRAINT pk_fabricante  PRIMARY KEY (manufacturer)
);

CREATE TABLE modelo (
  id            VARCHAR2(40),
  model         VARCHAR2(20) NOT NULL,
  aircraftType  VARCHAR2(25) NOT NULL,
  engineType    VARCHAR2(15) NOT NULL,
  manufacturer  VARCHAR2(30) NOT NULL,
  CONSTRAINT pk_modelo  PRIMARY KEY (id),
  CONSTRAINT fk_modelo_manufacturer FOREIGN KEY (manufacturer)  REFERENCES fabricante(manufacturer),
  UNIQUE (model, manufacturer)
);

CREATE TABLE aerolinea (
  code  VARCHAR2(7),
  name  VARCHAR2(100) NOT NULL,
  CONSTRAINT pk_aerolinea  PRIMARY KEY (code)
);

CREATE TABLE avion (
  tailNum VARCHAR2(7),
  modelId VARCHAR2(40),
  year    NUMBER,
  CONSTRAINT pk_avion  PRIMARY KEY (tailNum),
  CONSTRAINT fk_avion_modelId  FOREIGN KEY (modelId) REFERENCES modelo(id),
  CONSTRAINT ck_avion_year CHECK (year >= 1890)
);

CREATE TABLE vuelo (
  id                VARCHAR2(40),
  flightDate        VARCHAR2(10)  NOT NULL,
  flightNum         NUMBER        NOT NULL,
  distance          NUMBER        NOT NULL,
  origin            VARCHAR2(4)   NOT NULL,
  destination       VARCHAR2(4)   NOT NULL,
  tailNum           VARCHAR2(7),
  carrier           VARCHAR2(7)   NOT NULL,
  depTime           VARCHAR2(4),
  arrTime           VARCHAR2(4),
  crsDepTime        VARCHAR2(4)   NOT NULL,
  crsArrTime        VARCHAR2(4)   NOT NULL,
  crsElapsedTime    NUMBER        NOT NULL,
  actualElapsedTime NUMBER,
  CONSTRAINT pk_vuelo             PRIMARY KEY (id),
  CONSTRAINT fk_vuelo_origin      FOREIGN KEY (origin)      REFERENCES aeropuerto(iata),
  CONSTRAINT fk_vuelo_destination FOREIGN KEY (destination) REFERENCES aeropuerto(iata),
  CONSTRAINT fk_vuelo_tailNum     FOREIGN KEY (tailNum)     REFERENCES avion(tailNum),
  CONSTRAINT fk_avion_carrier     FOREIGN KEY (carrier)     REFERENCES aerolinea(code),
  UNIQUE (origin, flightNum, flightDate),
  CONSTRAINT ck_vuelo_distance            CHECK (distance >= 0),
  CONSTRAINT ck_vuelo_origin_destination  CHECK (origin <> destination)
);

CREATE TABLE cancelaciones (
  id            VARCHAR2(40),
  idVuelo       VARCHAR2(40)  NOT NULL,
  cancellation  VARCHAR2(100) NOT NULL,
  CONSTRAINT pk_cancelaciones         PRIMARY KEY (id, idVuelo),
  CONSTRAINT fk_cancelaciones_idVuelo FOREIGN KEY (idVuelo)  REFERENCES vuelo(id)
);

CREATE TABLE desvios (
  id          VARCHAR2(40),
  idVuelo     VARCHAR2(40)  NOT NULL,
  origin      VARCHAR2(4)   NOT NULL,
  tailNum     VARCHAR2(7)   NOT NULL,
  destination VARCHAR2(4)   NOT NULL,
  CONSTRAINT pk_desvios               PRIMARY KEY (id, idVuelo),
  CONSTRAINT fk_desvios_idVuelo       FOREIGN KEY (idVuelo)     REFERENCES vuelo(id),
  CONSTRAINT fk_desvios_origin        FOREIGN KEY (origin)      REFERENCES aeropuerto(iata),
  CONSTRAINT fk_desvios_tailnum       FOREIGN KEY (tailNum)     REFERENCES avion(tailNum),
  CONSTRAINT fk_desvios_destination   FOREIGN KEY (destination) REFERENCES aeropuerto(iata)
);

CREATE TABLE retrasos (
  id        VARCHAR2(40),
  idVuelo   VARCHAR2(40)  NOT NULL,
  delay     NUMBER        NOT NULL,
  delayType VARCHAR2(50)  NOT NULL,
  CONSTRAINT pk_retrasos          PRIMARY KEY (id, idVuelo),
  CONSTRAINT fk_retrasos_idvuelo  FOREIGN KEY (idVuelo)  REFERENCES vuelo(id),
  CONSTRAINT ck_retrasos_delay    CHECK (delay >= 0)
);