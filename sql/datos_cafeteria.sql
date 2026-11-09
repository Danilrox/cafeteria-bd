-- =====================================================
-- Datos de ejemplo para la base de datos cafeteria
-- Ejecutar DESPUÉS de cafeteria.sql, con Alt + X en DBeaver
-- =====================================================

USE cafeteria;

-- -----------------------------------------------------
-- CLIENTE
-- -----------------------------------------------------
INSERT INTO cliente (cedula, apellidos, nombres, correo, telefono) VALUES
('1712345678', 'Muñoz Paredes',  'Ana Lucía',   'ana.munoz@correo.com',      '0991234567'),
('1723456789', 'Torres Vega',    'Carlos Iván', 'carlos.torres@correo.com',  '0982345678'),
('0912345678', 'Salazar Rivera', 'María José',  'mj.salazar@correo.com',     '0973456789'),
('1104567890', 'Ortega León',    'Diego',       NULL,                        '0964567890'),
('1801234567', 'Cevallos Mena',  'Paola',       'paola.cevallos@correo.com', NULL);

-- -----------------------------------------------------
-- PROVEEDOR
-- (el proveedor 4 se agregó porque la compra 7 lo referencia;
--  reemplaza su nombre/teléfono/correo por los datos reales)
-- -----------------------------------------------------
INSERT INTO proveedor (id, nombre, telefono, correo) VALUES
(1, 'INDULOJA CIA. LTDA',                            '022345678', 'ventas@lacteosandinos.com'),
(2, 'COMERCIALIZADORA RAMIREZ GALVAN CIA. LTDA',     '022456789', 'pedidos@cafedealtura.com'),
(3, 'BARRETO DOMINGUEZ VERONICA ANABEL',             '022567890', 'contacto@dulcehogar.com'),
(4, 'AGROPRODUCTOS DEL VALLE (completar datos)',     '022678901', NULL);

-- -----------------------------------------------------
-- INSUMO
-- (la unidad de medida va en el nombre; el stock inicial
--  coincide con la suma de lo comprado en las siete compras de abajo)
-- -----------------------------------------------------
INSERT INTO insumo (codigo, nombre, cantidad_disponible) VALUES
(1,  'Leche entera (litros)',      70.00),   -- 40 (compra 1) + 30 (compra 6)
(2,  'Café molido (kg)',           10.00),
(3,  'Azúcar (kg)',                35.00),   -- 20 (compra 3) + 15 (compra 4)
(4,  'Harina de trigo (kg)',       45.00),   -- 25 (compra 3) + 20 (compra 4)
(5,  'Huevos (unidades)',         210.00),   -- 120 (compra 3) + 90 (compra 4)
(6,  'Mantequilla (kg)',            7.00),   -- 4 (compra 1) + 3 (compra 6)
(7,  'Chocolate en polvo (kg)',     7.00),   -- 3 (compra 2) + 4 (compra 5)
(8,  'Manjar (kg)',                 5.00),
(9,  'Fresas (kg)',                 4.00),
(10, 'Crema de leche (litros)',     5.00),
(11, 'Canela en polvo (kg)',        1.50),
(12, 'Levadura (kg)',               1.00),
(13, 'Zanahoria (kg)',              8.00),
(14, 'Nueces (kg)',                 2.00),
(15, 'Queso crema (kg)',            3.00),
(16, 'Aceite vegetal (litros)',    10.00),
(17, 'Maicena (kg)',                6.00),
(18, 'Banano (kg)',                 6.00),
(19, 'Avena en hojuelas (kg)',      5.00),
(20, 'Coco rallado (kg)',           2.00);

-- -----------------------------------------------------
-- PRODUCTO
-- (las bebidas se preparan al momento, por eso su stock es 0;
--  los postres sí tienen stock)
-- -----------------------------------------------------
INSERT INTO producto (codigo, fecha_de_creacion, nombre, precio, cantidad_disponible) VALUES
(1,  '2026-01-15', 'Café espresso',                            1.50,  0),
(2,  '2026-01-15', 'Capuchino',                                2.25,  0),
(3,  '2026-01-15', 'Latte',                                    2.50,  0),
(4,  '2026-01-15', 'Chocolate caliente',                       2.00,  0),
(5,  '2026-02-10', 'Pastel de chocolate con manjar (porción)', 3.50, 12),
(6,  '2026-02-10', 'Pastel de vainilla con fresa (porción)',   3.50, 10),
(7,  '2026-03-05', 'Brownie',                                  2.00, 15),
(8,  '2026-11-08', 'Rollo de canela',                          2.50, 12),
(9,  '2026-11-08', 'Pastel de zanahoria (porción)',            3.50,  8),
(10, '2026-11-08', 'Dona',                                     1.25, 20),
(11, '2026-11-08', 'Alfajor de maicena',                       1.00, 25),
(12, '2026-11-08', 'Alfajor de chocolate',                     1.25, 25),
(13, '2026-11-08', 'Cupcake de chocolate',                     2.00, 15),
(14, '2026-11-08', 'Pastel de banano (porción)',               3.25,  8),
(15, '2026-11-08', 'Galleta de avena',                         1.00, 30);

-- -----------------------------------------------------
-- RECETA (cantidad de insumo por unidad de producto)
-- -----------------------------------------------------
INSERT INTO receta (codigo_producto, codigo_insumo, cantidad_requerida) VALUES
-- Café espresso
(1, 2, 0.018),
-- Capuchino
(2, 2, 0.018), (2, 1, 0.150),
-- Latte
(3, 2, 0.018), (3, 1, 0.250),
-- Chocolate caliente
(4, 7, 0.025), (4, 1, 0.200), (4, 3, 0.010),
-- Pastel de chocolate con manjar
(5, 4, 0.060), (5, 5, 1.000), (5, 3, 0.040), (5, 6, 0.030), (5, 7, 0.020), (5, 8, 0.040),
-- Pastel de vainilla con fresa
(6, 4, 0.060), (6, 5, 1.000), (6, 3, 0.040), (6, 6, 0.030), (6, 9, 0.050), (6, 10, 0.030),
-- Brownie
(7, 4, 0.040), (7, 5, 1.000), (7, 3, 0.030), (7, 6, 0.040), (7, 7, 0.030),
-- Rollo de canela
(8, 4, 0.080), (8, 12, 0.005), (8, 6, 0.020), (8, 3, 0.030), (8, 11, 0.005),
(8, 1, 0.040), (8, 15, 0.020), (8, 5, 0.500),
-- Pastel de zanahoria
(9, 4, 0.060), (9, 5, 1.000), (9, 3, 0.040), (9, 13, 0.060), (9, 14, 0.015),
(9, 11, 0.002), (9, 16, 0.020), (9, 15, 0.030),
-- Dona
(10, 4, 0.060), (10, 12, 0.004), (10, 3, 0.025), (10, 5, 0.500), (10, 1, 0.030), (10, 16, 0.050),
-- Alfajor de maicena
(11, 17, 0.040), (11, 4, 0.015), (11, 6, 0.030), (11, 3, 0.015), (11, 5, 0.500),
(11, 8, 0.020), (11, 20, 0.010),
-- Alfajor de chocolate
(12, 4, 0.030), (12, 7, 0.015), (12, 6, 0.030), (12, 3, 0.020), (12, 5, 0.500), (12, 8, 0.020),
-- Cupcake de chocolate
(13, 4, 0.040), (13, 7, 0.020), (13, 3, 0.030), (13, 5, 1.000), (13, 6, 0.025), (13, 1, 0.050),
-- Pastel de banano
(14, 4, 0.060), (14, 5, 1.000), (14, 3, 0.035), (14, 18, 0.080), (14, 6, 0.030),
-- Galleta de avena
(15, 19, 0.030), (15, 4, 0.020), (15, 6, 0.025), (15, 3, 0.020), (15, 5, 0.500), (15, 11, 0.001);

-- -----------------------------------------------------
-- COMPRA y DETALLE_DE_COMPRA
-- -----------------------------------------------------
INSERT INTO compra (codigo, fecha, total, id_proveedor) VALUES
(1, '2026-11-02',  80.50, 1),
(2, '2026-11-03', 144.00, 2),
(3, '2026-11-05',  99.00, 3),
(4, '2026-11-08', 152.20, 3),
(5, '2026-11-08',  32.00, 2),
(6, '2026-11-08',  73.50, 1),
(7, '2026-11-08',  14.20, 4);

INSERT INTO detalle_de_compra (precio_unitario, cantidad, codigo_insumo, codigo_compra) VALUES
-- Compra 1 (INDULOJA): 44.00 + 12.50 + 24.00 = 80.50
(1.10, 40.00,  1, 1),
(2.50,  5.00, 10, 1),
(6.00,  4.00,  6, 1),
-- Compra 2 (Comercializadora Ramírez Galván): 120.00 + 24.00 = 144.00
(12.00, 10.00, 2, 2),
(8.00,   3.00, 7, 2),
-- Compra 3 (Barreto Domínguez): 24.00 + 22.50 + 18.00 + 22.50 + 12.00 = 99.00
(1.20,  20.00, 3, 3),
(0.90,  25.00, 4, 3),
(0.15, 120.00, 5, 3),
(4.50,   5.00, 8, 3),
(3.00,   4.00, 9, 3),
-- Compra 4 (Barreto Domínguez): 13.50 + 5.00 + 22.00 + 13.20 + 12.00 + 9.00 + 28.00 + 18.00 + 18.00 + 13.50 = 152.20
(9.00,   1.50, 11, 4),
(5.00,   1.00, 12, 4),
(11.00,  2.00, 14, 4),
(2.20,   6.00, 17, 4),
(2.40,   5.00, 19, 4),
(4.50,   2.00, 20, 4),
(2.80,  10.00, 16, 4),
(1.20,  15.00,  3, 4),
(0.90,  20.00,  4, 4),
(0.15,  90.00,  5, 4),
-- Compra 5 (Comercializadora Ramírez Galván): 32.00
(8.00,   4.00,  7, 5),
-- Compra 6 (INDULOJA): 22.50 + 18.00 + 33.00 = 73.50
(7.50,   3.00, 15, 6),
(6.00,   3.00,  6, 6),
(1.10,  30.00,  1, 6),
-- Compra 7 (proveedor 4): 8.80 + 5.40 = 14.20
(1.10,   8.00, 13, 7),
(0.90,   6.00, 18, 7);

-- -----------------------------------------------------
-- VENTA
-- (CI_cliente = NULL en las ventas anónimas del local)
-- -----------------------------------------------------
INSERT INTO venta (id, metodo_de_pago, total, hora, fecha_de_venta, CI_cliente) VALUES
(1, 'efectivo',       6.50, '09:15:00', '2026-11-06', NULL),
(2, 'transferencia',  6.00, '16:40:00', '2026-11-06', '1712345678'),
(3, 'transferencia', 54.00, '11:00:00', '2026-11-07', '1723456789'),
(4, 'efectivo',       3.50, '08:30:00', '2026-11-07', NULL),
(5, 'efectivo',       5.25, '09:05:00', '2026-11-08', NULL),
(6, 'tarjeta',        9.75, '10:20:00', '2026-11-08', '0912345678'),
(7, 'transferencia', 66.00, '12:00:00', '2026-11-08', '1104567890'),
(8, 'efectivo',       5.75, '15:30:00', '2026-11-08', NULL);

-- -----------------------------------------------------
-- PEDIDO (las ventas 3 y 7 son pedidos; las demás son ventas en el local)
-- -----------------------------------------------------
INSERT INTO pedido (id_venta, fecha_entrega, anticipo, estado) VALUES
(3, '2026-11-09', 20.00, 'en preparación'),
(7, '2026-11-12', 30.00, 'recibido');

-- -----------------------------------------------------
-- DETALLE_DE_VENTA
-- -----------------------------------------------------
INSERT INTO detalle_de_venta (cantidad, precio_unitario, id_venta, codigo_producto) VALUES
-- Venta 1: 2 capuchinos + 1 brownie = 6.50
(2, 2.25, 1, 2),
(1, 2.00, 1, 7),
-- Venta 2: 1 latte + 1 porción de pastel de chocolate = 6.00
(1, 2.50, 2, 3),
(1, 3.50, 2, 5),
-- Venta 3 (pedido): 12 porciones de pastel de chocolate + 6 brownies = 54.00
(12, 3.50, 3, 5),
(6,  2.00, 3, 7),
-- Venta 4: 1 café espresso + 1 chocolate caliente = 3.50
(1, 1.50, 4, 1),
(1, 2.00, 4, 4),
-- Venta 5: rollo de canela + café espresso + dona = 5.25
(1, 2.50, 5,  8),
(1, 1.50, 5,  1),
(1, 1.25, 5, 10),
-- Venta 6: 2 cupcakes + pastel de zanahoria + capuchino = 9.75
(2, 2.00, 6, 13),
(1, 3.50, 6,  9),
(1, 2.25, 6,  2),
-- Venta 7 (pedido): 24 alfajores de maicena + 24 de chocolate + 12 galletas = 66.00
(24, 1.00, 7, 11),
(24, 1.25, 7, 12),
(12, 1.00, 7, 15),
-- Venta 8: pastel de banano + latte = 5.75
(1, 3.25, 8, 14),
(1, 2.50, 8,  3);

-- -----------------------------------------------------
-- FACTURA (solo la venta 2 tiene factura)
-- Los precios incluyen IVA del 15 % (tarifa general vigente en Ecuador):
-- 6.00 / 1.15 = 5.22 + 0.78
-- Si algún producto tuviera tarifa 0 %, habría que facturarlo aparte.
-- -----------------------------------------------------
INSERT INTO factura (numero, fecha_emision, subtotal, iva, total, id_venta) VALUES
('001-001-000000001', '2026-11-06', 5.22, 0.78, 6.00, 2);

-- =====================================================
-- Consultas de verificación (selecciona una y ejecútala con Ctrl + Enter)
-- =====================================================

-- Cantidad de filas por tabla
-- SELECT 'cliente' AS tabla, COUNT(*) AS filas FROM cliente
-- UNION ALL SELECT 'proveedor', COUNT(*) FROM proveedor
-- UNION ALL SELECT 'insumo', COUNT(*) FROM insumo
-- UNION ALL SELECT 'producto', COUNT(*) FROM producto
-- UNION ALL SELECT 'receta', COUNT(*) FROM receta
-- UNION ALL SELECT 'compra', COUNT(*) FROM compra
-- UNION ALL SELECT 'detalle_de_compra', COUNT(*) FROM detalle_de_compra
-- UNION ALL SELECT 'venta', COUNT(*) FROM venta
-- UNION ALL SELECT 'pedido', COUNT(*) FROM pedido
-- UNION ALL SELECT 'factura', COUNT(*) FROM factura
-- UNION ALL SELECT 'detalle_de_venta', COUNT(*) FROM detalle_de_venta;

-- Detalle de cada venta con su producto
-- SELECT v.id AS venta, v.fecha_de_venta, p.nombre AS producto, d.cantidad, d.precio_unitario
-- FROM venta v
-- JOIN detalle_de_venta d ON d.id_venta = v.id
-- JOIN producto p ON p.codigo = d.codigo_producto
-- ORDER BY v.id;

-- Totales de compra y venta que no coinciden con su detalle (debe devolver 0 filas)
-- SELECT 'compra' AS tipo, c.codigo AS id, c.total, SUM(d.precio_unitario * d.cantidad) AS suma
-- FROM compra c JOIN detalle_de_compra d ON d.codigo_compra = c.codigo
-- GROUP BY c.codigo, c.total HAVING c.total <> SUM(d.precio_unitario * d.cantidad)
-- UNION ALL
-- SELECT 'venta', v.id, v.total, SUM(d.precio_unitario * d.cantidad)
-- FROM venta v JOIN detalle_de_venta d ON d.id_venta = v.id
-- GROUP BY v.id, v.total HAVING v.total <> SUM(d.precio_unitario * d.cantidad);