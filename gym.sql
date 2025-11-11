CREATE TABLE Cliente (
  idCliente SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  edad INT,
  genero VARCHAR(50),
  telefono VARCHAR(20),
  email VARCHAR(255)
);

CREATE TABLE Entrenador (
  idEntrenador SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  edad INT,
  genero VARCHAR(50),
  especialidad VARCHAR(255)
);

CREATE TABLE Rutina (
  idRutina SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  descripcion VARCHAR(255),
  duracion VARCHAR(50),
  idEntrenador INT REFERENCES Entrenador(idEntrenador)
);

CREATE TABLE Clase (
  idClase SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  hora_inicio TIME,
  hora_fin TIME,
  dias_semana VARCHAR(100),
  idEntrenador INT REFERENCES Entrenador(idEntrenador)
);

CREATE TABLE Membresia (
  idMembresia SERIAL PRIMARY KEY,
  tipo VARCHAR(50),
  monto DECIMAL(10,2),
  duracion VARCHAR(50),
  idCliente INT REFERENCES Cliente(idCliente)
);

CREATE TABLE Asistencia (
  idAsistencia SERIAL PRIMARY KEY,
  fecha DATE NOT NULL,
  estado VARCHAR(50),
  idCliente INT REFERENCES Cliente(idCliente)
);