

USE master;
Go

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'ElectroStore')
BEGIN
   CREATE DATABASE [ElectroStore]
END

GO
USE [ElectroStore]
GO

Use ElectroStore;
Go
--  *** ------------------------------------
--  *** Tiendas`
--  *** ------------------------------------

DROP TABLE IF EXISTS ELEFacturasDet
DROP TABLE IF EXISTS ELEFacturaEnc ;
DROP TABLE IF EXISTS ELEClientes ;
DROP TABLE IF EXISTS ELEEmpleados ;
DROP TABLE IF EXISTS ELECargos ;

DROP TABLE IF EXISTS ELETiendaProducto;
DROP TABLE IF EXISTS ELEPRODUCTOS ;
DROP TABLE IF EXISTS ELEMarcas ;
DROP TABLE IF EXISTS ELECATEGORIAS ;
DROP TABLE IF EXISTS ELETiendas ;


--  *** ------------------------------------
--  *** Tiendas
--  *** ------------------------------------

CREATE TABLE ELETiendas (
  CodTienda INT NOT NULL,
  Nombre VARCHAR(100) NULL,
  Telefono VARCHAR(15) NULL,
  Email VARCHAR(100) NULL,
  Direccion VARCHAR(100) NULL,
  PRIMARY KEY (CodTienda),
  CONSTRAINT CodTienda_UNIQUE UNIQUE (CodTienda ASC));



--  *** ------------------------------------
--  *** Cargos
--  *** ------------------------------------


CREATE TABLE ELECargos (
  CodCargo SMALLINT NOT NULL,
  Descripcion VARCHAR(100) NULL,
  PRIMARY KEY (CodCargo),
  CONSTRAINT CodCargo_UNIQUE UNIQUE (CodCargo ASC));


--  *** ------------------------------------
--  *** Empleados
--  *** ------------------------------------


CREATE TABLE ELEEmpleados (
  CodEmpleado INT NOT NULL,
  Identificacion VARCHAR(25) NULL,
  Nombre VARCHAR(45) NULL,
  Apellido1 VARCHAR(45) NULL,
  Apellido2 VARCHAR(45) NULL,
  FecIngreso DATETIME2(0) NULL,
  CodTienda INT NULL,
  CodCargo SMALLINT NULL,
  PRIMARY KEY (CodEmpleado),
  CONSTRAINT CodEmpleado_UNIQUE UNIQUE (CodEmpleado ASC),
  INDEX fk_ELEEmpleados_ELETiendas_idx (CodTienda ASC),
  INDEX fk_ELEEmpleados_ELECargos1_idx (CodCargo ASC),
  CONSTRAINT fk_ELEEmpleados_ELETiendas
    FOREIGN KEY (CodTienda)
    REFERENCES ELETiendas (CodTienda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ELEEmpleados_ELECargos1
    FOREIGN KEY (CodCargo)
    REFERENCES ELECargos (CodCargo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


--  *** ------------------------------------
--  *** Clientes
--  *** ------------------------------------


CREATE TABLE ELEClientes (
  CodCliente INT NOT NULL,
  Identificacion VARCHAR(25) NULL,
  Nombre VARCHAR(45) NULL,
  Apellido1 VARCHAR(45) NULL,
  Apellido2 VARCHAR(45) NULL,
  Direccion VARCHAR(100) NULL,
  Email VARCHAR(100) NULL,
  PRIMARY KEY (CodCliente),
  CONSTRAINT CodCliente_UNIQUE UNIQUE (CodCliente ASC));


--  *** ------------------------------------
--  *** FacturaEnc
--  *** ------------------------------------


CREATE TABLE ELEFacturaEnc (
  NumFactura INT NOT NULL,
  FecCompra DATETIME2(0) NULL,
  CodCliente INT NULL,
  CodEmpleado INT NULL,
  CodTienda INT NULL,
  Total DECIMAL(10,0) NULL,
  FecEntrega DATETIME2(0) NULL,
  Estado SMALLINT NULL,
  PRIMARY KEY (NumFactura),
  CONSTRAINT NumFactura_UNIQUE UNIQUE (NumFactura ASC),
  INDEX fk_ELEFacturaEnc_ELEClientes1_idx (CodCliente ASC),
  INDEX fk_ELEFacturaEnc_ELEEmpleados1_idx (CodEmpleado ASC),
  INDEX fk_ELEFacturaEnc_ELETiendas1_idx (CodTienda ASC),
  CONSTRAINT fk_ELEFacturaEnc_ELEClientes1
    FOREIGN KEY (CodCliente)
    REFERENCES ELEClientes (CodCliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ELEFacturaEnc_ELEEmpleados1
    FOREIGN KEY (CodEmpleado)
    REFERENCES ELEEmpleados (CodEmpleado)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ELEFacturaEnc_ELETiendas1
    FOREIGN KEY (CodTienda)
    REFERENCES ELETiendas (CodTienda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


--  *** ------------------------------------
--  *** Marcas
--  *** ------------------------------------

CREATE TABLE ELEMarcas (
  CodMarca SMALLINT NOT NULL,
  Descripcion VARCHAR(100) NULL,
  PRIMARY KEY (CodMarca))
;


--  *** ------------------------------------
--  *** Categorias
--  *** ------------------------------------

CREATE TABLE ELECategorias (
  CodCategoria SMALLINT NOT NULL,
  Descripcion VARCHAR(100) NULL,
  PRIMARY KEY (CodCategoria))
;


--  *** ------------------------------------
--  *** Productos
--  *** ------------------------------------
CREATE TABLE ELEProductos (
  CodProducto INT NOT NULL,
  Descripcion VARCHAR(100) NULL,
  Precio DECIMAL(10,0) NULL,
  CodMarca SMALLINT NULL,
  CodCategoria SMALLINT NULL,
  PRIMARY KEY (CodProducto),
  CONSTRAINT CodProducto_UNIQUE UNIQUE (CodProducto ASC),
  INDEX fk_ELEProductos_ELEMarcas1_idx (CodMarca ASC),
  INDEX fk_ELEProductos_ELECategorias1_idx (CodCategoria ASC),
  CONSTRAINT fk_ELEProductos_ELEMarcas1
    FOREIGN KEY (CodMarca)
    REFERENCES ELEMarcas (CodMarca)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ELEProductos_ELECategorias1
    FOREIGN KEY (CodCategoria)
    REFERENCES ELECategorias (CodCategoria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



--  *** ------------------------------------
--  *** FacturasDet
--  *** ------------------------------------

CREATE TABLE ELEFacturasDet (
  NumFactura INT NOT NULL,
  CodItem INT NOT NULL,
  Cantidad INT NULL,
  PrecioUnitario DECIMAL(10,0) NULL,
  Descuento DECIMAL(10,0) NULL,
  CodProducto INT NOT NULL,
  PRIMARY KEY (NumFactura, CodProducto, CodItem),
  INDEX fk_ELEFacturasDet_ELEProductos1_idx (CodProducto ASC),
  CONSTRAINT fk_ELEFacturasDet_ELEFacturaEnc1
    FOREIGN KEY (NumFactura)
    REFERENCES ELEFacturaEnc (NumFactura)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ELEFacturasDet_ELEProductos1
    FOREIGN KEY (CodProducto)
    REFERENCES ELEProductos (CodProducto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



--  *** ------------------------------------
--  *** TiendaProducto
--  *** ------------------------------------
CREATE TABLE ELETiendaProducto (
  CodTienda INT NOT NULL,
  CodProducto INT NOT NULL,
  Saldo INT NOT NULL
  INDEX CodTienda_idx (CodTienda ASC),
  INDEX CodProducto_idx (CodProducto ASC),
  CONSTRAINT CodTienda
    FOREIGN KEY (CodTienda)
    REFERENCES ELETiendas (CodTienda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT CodProducto
    FOREIGN KEY (CodProducto)
    REFERENCES ELEProductos (CodProducto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);