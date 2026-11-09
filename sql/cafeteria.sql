-- =====================================================
-- Base de datos: cafeteria
-- Motor: MySQL 8.0.16 o superior (por las restricciones CHECK)
-- =====================================================

CREATE DATABASE IF NOT EXISTS cafeteria
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE cafeteria;

-- -----------------------------------------------------
-- CLIENTE
-- -----------------------------------------------------
CREATE TABLE cliente (
    cedula     VARCHAR(10)  NOT NULL,
    apellidos  VARCHAR(80)  NOT NULL,
    nombres    VARCHAR(80)  NOT NULL,
    correo     VARCHAR(100),
    telefono   VARCHAR(15),
    PRIMARY KEY (cedula)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- PROVEEDOR
-- -----------------------------------------------------
CREATE TABLE proveedor (
    id        INT          NOT NULL AUTO_INCREMENT,
    nombre    VARCHAR(100) NOT NULL,
    telefono  VARCHAR(15),
    correo    VARCHAR(100),
    PRIMARY KEY (id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- PRODUCTO
-- -----------------------------------------------------
CREATE TABLE producto (
    codigo               INT           NOT NULL AUTO_INCREMENT,
    fecha_de_creacion    DATE          NOT NULL,
    nombre               VARCHAR(100)  NOT NULL,
    precio               DECIMAL(10,2) NOT NULL,
    cantidad_disponible  INT           NOT NULL DEFAULT 0,
    PRIMARY KEY (codigo),
    CONSTRAINT chk_producto_precio CHECK (precio >= 0),
    CONSTRAINT chk_producto_cantidad CHECK (cantidad_disponible >= 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- INSUMO
-- -----------------------------------------------------
CREATE TABLE insumo (
    codigo               INT           NOT NULL AUTO_INCREMENT,
    nombre               VARCHAR(100)  NOT NULL,
    cantidad_disponible  DECIMAL(10,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (codigo),
    CONSTRAINT chk_insumo_cantidad CHECK (cantidad_disponible >= 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- RECETA (relación N:M entre producto e insumo)
-- -----------------------------------------------------
CREATE TABLE receta (
    codigo_producto     INT           NOT NULL,
    codigo_insumo       INT           NOT NULL,
    cantidad_requerida  DECIMAL(10,3) NOT NULL,
    PRIMARY KEY (codigo_producto, codigo_insumo),
    CONSTRAINT fk_receta_producto
        FOREIGN KEY (codigo_producto) REFERENCES producto (codigo)
        ON DELETE CASCADE,
    CONSTRAINT fk_receta_insumo
        FOREIGN KEY (codigo_insumo) REFERENCES insumo (codigo)
        ON DELETE RESTRICT,
    CONSTRAINT chk_receta_cantidad CHECK (cantidad_requerida > 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- COMPRA
-- -----------------------------------------------------
CREATE TABLE compra (
    codigo        INT           NOT NULL AUTO_INCREMENT,
    fecha         DATE          NOT NULL,
    total         DECIMAL(10,2) NOT NULL DEFAULT 0,
    id_proveedor  INT           NOT NULL,
    PRIMARY KEY (codigo),
    CONSTRAINT fk_compra_proveedor
        FOREIGN KEY (id_proveedor) REFERENCES proveedor (id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_compra_total CHECK (total >= 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- DETALLE_DE_COMPRA
-- -----------------------------------------------------
CREATE TABLE detalle_de_compra (
    id               INT           NOT NULL AUTO_INCREMENT,
    precio_unitario  DECIMAL(10,2) NOT NULL,
    cantidad         DECIMAL(10,2) NOT NULL,
    codigo_insumo    INT           NOT NULL,
    codigo_compra    INT           NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_detcompra_insumo
        FOREIGN KEY (codigo_insumo) REFERENCES insumo (codigo)
        ON DELETE RESTRICT,
    CONSTRAINT fk_detcompra_compra
        FOREIGN KEY (codigo_compra) REFERENCES compra (codigo)
        ON DELETE CASCADE,
    CONSTRAINT chk_detcompra_precio CHECK (precio_unitario >= 0),
    CONSTRAINT chk_detcompra_cantidad CHECK (cantidad > 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- VENTA
-- (CI_cliente admite NULL para ventas anónimas en el local;
--  si prefieres que sea obligatorio, agrega NOT NULL)
-- -----------------------------------------------------
CREATE TABLE venta (
    id              INT           NOT NULL AUTO_INCREMENT,
    metodo_de_pago  VARCHAR(20)   NOT NULL,
    total           DECIMAL(10,2) NOT NULL DEFAULT 0,
    hora            TIME          NOT NULL,
    fecha_de_venta  DATE          NOT NULL,
    CI_cliente      VARCHAR(10)   NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_venta_cliente
        FOREIGN KEY (CI_cliente) REFERENCES cliente (cedula)
        ON DELETE RESTRICT,
    CONSTRAINT chk_venta_total CHECK (total >= 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- PEDIDO (entidad débil: id_venta es PK y FK a la vez)
-- -----------------------------------------------------
CREATE TABLE pedido (
    id_venta       INT           NOT NULL,
    fecha_entrega  DATE          NOT NULL,
    anticipo       DECIMAL(10,2) NOT NULL DEFAULT 0,
    estado         VARCHAR(20)   NOT NULL DEFAULT 'recibido',
    PRIMARY KEY (id_venta),
    CONSTRAINT fk_pedido_venta
        FOREIGN KEY (id_venta) REFERENCES venta (id)
        ON DELETE CASCADE,
    CONSTRAINT chk_pedido_anticipo CHECK (anticipo >= 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- FACTURA (relación 1:1 con venta mediante UNIQUE)
-- numero: formato 001-001-000000123 (17 caracteres)
-- -----------------------------------------------------
CREATE TABLE factura (
    numero         VARCHAR(17)   NOT NULL,
    fecha_emision  DATE          NOT NULL,
    subtotal       DECIMAL(10,2) NOT NULL,
    iva            DECIMAL(10,2) NOT NULL,
    total          DECIMAL(10,2) NOT NULL,
    id_venta       INT           NOT NULL,
    PRIMARY KEY (numero),
    UNIQUE KEY uq_factura_venta (id_venta),
    CONSTRAINT fk_factura_venta
        FOREIGN KEY (id_venta) REFERENCES venta (id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_factura_valores CHECK (subtotal >= 0 AND iva >= 0 AND total >= 0)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- DETALLE_DE_VENTA
-- -----------------------------------------------------
CREATE TABLE detalle_de_venta (
    codigo           INT           NOT NULL AUTO_INCREMENT,
    cantidad         INT           NOT NULL,
    precio_unitario  DECIMAL(10,2) NOT NULL,
    id_venta         INT           NOT NULL,
    codigo_producto  INT           NOT NULL,
    PRIMARY KEY (codigo),
    CONSTRAINT fk_detventa_venta
        FOREIGN KEY (id_venta) REFERENCES venta (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_detventa_producto
        FOREIGN KEY (codigo_producto) REFERENCES producto (codigo)
        ON DELETE RESTRICT,
    CONSTRAINT chk_detventa_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_detventa_precio CHECK (precio_unitario >= 0)
) ENGINE=InnoDB;
