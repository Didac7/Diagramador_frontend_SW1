-- Tabla de Proveedores
CREATE TABLE Proveedor (
  idProveedor SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  telefono VARCHAR(20),
  email VARCHAR(255)
);

-- Tabla de Clientes
CREATE TABLE Cliente (
  idCliente SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  telefono VARCHAR(20),
  direccion VARCHAR(255)
);

-- Tabla de Productos
CREATE TABLE Producto (
  idProducto SERIAL PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  stock INTEGER NOT NULL,
  proveedor_id INT REFERENCES Proveedor(idProveedor)
);

-- Tabla de Ventas
CREATE TABLE Venta (
  idVenta SERIAL PRIMARY KEY,
  fecha DATE NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  cliente_id INT REFERENCES Cliente(idCliente)
);

-- Tabla intermedia VentaProducto
CREATE TABLE VentaProducto (
  venta_id INT REFERENCES Venta(idVenta),
  producto_id INT REFERENCES Producto(idProducto),
  cantidad INTEGER NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (venta_id, producto_id)
);
