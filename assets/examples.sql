-- Ejemplo 1: Sistema de Biblioteca
CREATE TABLE libros (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    año_publicacion INT,
    editorial VARCHAR(100),
    disponible BOOLEAN DEFAULT TRUE
);

CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE prestamos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    libro_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha_prestamo DATETIME NOT NULL,
    fecha_devolucion_estimada DATETIME NOT NULL,
    fecha_devolucion_real DATETIME,
    estado VARCHAR(20) DEFAULT 'activo',
    FOREIGN KEY (libro_id) REFERENCES libros(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Ejemplo 2: Sistema de E-commerce
CREATE TABLE categorias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    categoria_id INT,
    imagen_url VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT,
    ciudad VARCHAR(100),
    pais VARCHAR(100),
    codigo_postal VARCHAR(10)
);

CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    fecha_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'pendiente',
    direccion_envio TEXT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE detalles_pedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Ejemplo 3: Sistema de Gestión Escolar
CREATE TABLE estudiantes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    matricula VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    direccion TEXT,
    nivel_educativo VARCHAR(50)
);

CREATE TABLE profesores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    codigo_empleado VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20)
);

CREATE TABLE materias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    creditos INT NOT NULL,
    horas_semanales INT,
    nivel VARCHAR(50)
);

CREATE TABLE grupos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    materia_id INT NOT NULL,
    profesor_id INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    horario VARCHAR(100),
    aula VARCHAR(50),
    cupo_maximo INT DEFAULT 30,
    FOREIGN KEY (materia_id) REFERENCES materias(id),
    FOREIGN KEY (profesor_id) REFERENCES profesores(id)
);

CREATE TABLE inscripciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    estudiante_id INT NOT NULL,
    grupo_id INT NOT NULL,
    fecha_inscripcion DATETIME DEFAULT CURRENT_TIMESTAMP,
    calificacion DECIMAL(5,2),
    estado VARCHAR(20) DEFAULT 'activo',
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
    FOREIGN KEY (grupo_id) REFERENCES grupos(id)
);

-- Ejemplo 4: Sistema de Gestión Hotelera
CREATE TABLE habitaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    numero VARCHAR(10) UNIQUE NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    capacidad INT NOT NULL,
    precio_noche DECIMAL(10,2) NOT NULL,
    piso INT,
    descripcion TEXT,
    estado VARCHAR(20) DEFAULT 'disponible'
);

CREATE TABLE huespedes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    documento VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100),
    telefono VARCHAR(20),
    pais VARCHAR(100),
    ciudad VARCHAR(100)
);

CREATE TABLE reservas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    habitacion_id INT NOT NULL,
    huesped_id INT NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    numero_personas INT NOT NULL,
    precio_total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'confirmada',
    observaciones TEXT,
    FOREIGN KEY (habitacion_id) REFERENCES habitaciones(id),
    FOREIGN KEY (huesped_id) REFERENCES huespedes(id)
);

CREATE TABLE servicios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    disponible BOOLEAN DEFAULT TRUE
);

CREATE TABLE servicios_reserva (
    id INT PRIMARY KEY AUTO_INCREMENT,
    reserva_id INT NOT NULL,
    servicio_id INT NOT NULL,
    cantidad INT DEFAULT 1,
    fecha_servicio DATETIME,
    precio_total DECIMAL(10,2),
    FOREIGN KEY (reserva_id) REFERENCES reservas(id),
    FOREIGN KEY (servicio_id) REFERENCES servicios(id)
);
