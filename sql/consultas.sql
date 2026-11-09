USE cafeteria;
-- -----------------------------------------------------
-- obtener el nombre, el precio y el stock de los productos que tienen existencias bajas, es decir, más de 0 y menos de 10 unidades, 
-- para decidir cuáles conviene volver a preparar. Se excluyen las bebidas, que se preparan al momento y tienen stock 0.
-- -----------------------------------------------------
SELECT nombre, precio, cantidad_disponible
FROM   producto
WHERE  cantidad_disponible > 0
  AND  cantidad_disponible < 10;


-- -----------------------------------------------------
-- listar, para cada pedido, los datos del cliente que lo encargó, la fecha de entrega, el anticipo pagado, 
-- el saldo pendiente (total de la venta menos anticipo) y el estado del pedido. Combina las tablas cliente, 
-- venta y pedido mediante sus llaves foráneas y calcula el saldo con una proyección generalizada.
-- -----------------------------------------------------
SELECT c.cedula, c.apellidos, c.nombres,
       p.fecha_entrega, p.anticipo,
       v.total - p.anticipo AS saldo,
       p.estado
FROM   cliente c
JOIN   venta  v ON v.CI_cliente = c.cedula
JOIN   pedido p ON p.id_venta   = v.id
ORDER BY p.fecha_entrega;


-- -----------------------------------------------------
-- identificar los productos del catálogo que nunca se han vendido, restando del conjunto de todos los códigos de 
-- producto el conjunto de códigos que aparecen en algún detalle de venta. Sirve para detectar productos que no rotan.
-- -----------------------------------------------------
SELECT p.codigo, p.nombre
FROM   producto p
WHERE  NOT EXISTS (
         SELECT 1
         FROM   detalle_de_venta d
         WHERE  d.codigo_producto = p.codigo
       );


-- -----------------------------------------------------
-- encontrar los insumos que se usan tanto en la receta del pastel de chocolate con manjar como en la del brownie, para saber 
-- qué insumos son comunes a ambas preparaciones y deben mantenerse siempre en existencia. Se obtienen los insumos de cada receta 
-- y se intersecan.
-- -----------------------------------------------------
SELECT i.codigo, i.nombre
FROM   insumo i
WHERE  i.codigo IN (
         SELECT r.codigo_insumo
         FROM   receta r
         JOIN   producto p ON p.codigo = r.codigo_producto
         WHERE  p.nombre = 'Pastel de chocolate con manjar (porción)')
  AND  i.codigo IN (
         SELECT r.codigo_insumo
         FROM   receta r
         JOIN   producto p ON p.codigo = r.codigo_producto
         WHERE  p.nombre = 'Brownie')
ORDER BY i.codigo;


-- -----------------------------------------------------
-- calcular, por producto, las unidades vendidas y el ingreso generado (cantidad por precio unitario), mostrando solo los 
-- productos cuyo ingreso total es de al menos 10 dólares y ordenándolos de mayor a menor. Une detalle_de_venta con producto, 
-- agrupa por producto y filtra el resultado de la agregación (HAVING).
-- -----------------------------------------------------
SELECT   p.nombre,
         SUM(d.cantidad)                    AS unidades,
         SUM(d.cantidad * d.precio_unitario) AS ingreso
FROM     detalle_de_venta d
JOIN     producto p ON p.codigo = d.codigo_producto
GROUP BY p.codigo, p.nombre
HAVING   SUM(d.cantidad * d.precio_unitario) >= 10
ORDER BY ingreso DESC;
