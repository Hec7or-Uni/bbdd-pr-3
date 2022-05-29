CREATE TABLE aeropuerto (
  iata    VARCHAR(4),
  airport VARCHAR(45)  NOT NULL,
  country VARCHAR(30)  NOT NULL,
  state   VARCHAR(2),
  city    VARCHAR(35),
  lat     INTEGER        NOT NULL,
  lon     INTEGER        NOT NULL,
  CONSTRAINT pk_aeropuerto  PRIMARY KEY (iata),
  UNIQUE (lat, lon)
);

CREATE TABLE fabricante (
  manufacturer  VARCHAR(30),
  CONSTRAINT pk_fabricante  PRIMARY KEY (manufacturer)
);

CREATE TABLE modelo (
  id            VARCHAR(40),
  model         VARCHAR(20) NOT NULL,
  aircraftType  VARCHAR(25) NOT NULL,
  engineType    VARCHAR(15) NOT NULL,
  manufacturer  VARCHAR(30) NOT NULL,
  CONSTRAINT pk_modelo  PRIMARY KEY (id),
  CONSTRAINT fk_modelo_manufacturer FOREIGN KEY (manufacturer)  REFERENCES fabricante(manufacturer),
  UNIQUE (model, manufacturer)
);

CREATE TABLE aerolinea (
  code  VARCHAR(7),
  name  VARCHAR(100) NOT NULL,
  CONSTRAINT pk_aerolinea  PRIMARY KEY (code)
);

CREATE TABLE avion (
  tailNum VARCHAR(7),
  modelId VARCHAR(40),
  year    INTEGER,
  CONSTRAINT pk_avion  PRIMARY KEY (tailNum),
  CONSTRAINT fk_avion_modelId  FOREIGN KEY (modelId) REFERENCES modelo(id),
  CONSTRAINT ck_avion_year CHECK (year >= 1890)
);

CREATE TABLE vuelo (
  id                VARCHAR(40),
  flightDate        VARCHAR(10)  NOT NULL,
  flightNum         INTEGER      NOT NULL,
  distance          INTEGER      NOT NULL,
  origin            VARCHAR(4)   NOT NULL,
  destination       VARCHAR(4)   NOT NULL,
  tailNum           VARCHAR(7),
  carrier           VARCHAR(7)   NOT NULL,
  depTime           VARCHAR(4),
  arrTime           VARCHAR(4),
  crsDepTime        VARCHAR(4)   NOT NULL,
  crsArrTime        VARCHAR(4)   NOT NULL,
  crsElapsedTime    INTEGER      NOT NULL,
  actualElapsedTime INTEGER,
  CONSTRAINT pk_vuelo             PRIMARY KEY (id),
  CONSTRAINT fk_vuelo_origin      FOREIGN KEY (origin)      REFERENCES aeropuerto(iata),
  CONSTRAINT fk_vuelo_destination FOREIGN KEY (destination) REFERENCES aeropuerto(iata),
  CONSTRAINT fk_vuelo_tailNum     FOREIGN KEY (tailNum)     REFERENCES avion(tailNum),
  CONSTRAINT fk_vuelo_carrier     FOREIGN KEY (carrier)     REFERENCES aerolinea(code),
  UNIQUE (origin, carrier, flightNum, flightDate),
  CONSTRAINT ck_vuelo_distance            CHECK (distance >= 0),
  CONSTRAINT ck_vuelo_origin_destination  CHECK (origin <> destination)
);

CREATE TABLE cancelaciones (
  id            VARCHAR(40),
  idVuelo       VARCHAR(40)  NOT NULL,
  cancellation  VARCHAR(100) NOT NULL,
  CONSTRAINT pk_cancelaciones         PRIMARY KEY (id, idVuelo),
  CONSTRAINT fk_cancelaciones_idVuelo FOREIGN KEY (idVuelo)  REFERENCES vuelo(id),
  UNIQUE (id, idVuelo)
);

CREATE TABLE desvios (
  id          VARCHAR(40),
  idVuelo     VARCHAR(40)  NOT NULL,
  origin      VARCHAR(4)   NOT NULL,
  tailNum     VARCHAR(7)   NOT NULL,
  destination VARCHAR(4)   NOT NULL,
  CONSTRAINT pk_desvios               PRIMARY KEY (id, idVuelo),
  CONSTRAINT fk_desvios_idVuelo       FOREIGN KEY (idVuelo)     REFERENCES vuelo(id),
  CONSTRAINT fk_desvios_origin        FOREIGN KEY (origin)      REFERENCES aeropuerto(iata),
  CONSTRAINT fk_desvios_tailnum       FOREIGN KEY (tailNum)     REFERENCES avion(tailNum),
  CONSTRAINT fk_desvios_destination   FOREIGN KEY (destination) REFERENCES aeropuerto(iata)
);

CREATE TABLE retrasos (
  id        VARCHAR(40),
  idVuelo   VARCHAR(40)  NOT NULL,
  delay     INTEGER        NOT NULL,
  delayType VARCHAR(50)  NOT NULL,
  CONSTRAINT pk_retrasos          PRIMARY KEY (id, idVuelo),
  CONSTRAINT fk_retrasos_idvuelo  FOREIGN KEY (idVuelo)  REFERENCES vuelo(id),
  CONSTRAINT ck_retrasos_delay    CHECK (delay >= 0),
  UNIQUE (id, idVuelo)
);
