-- CREATE DATABASE billjobs;
-- cargar la base de datos de respaldo
--psql -U postgres -d billjobs -f unidad2.sql --en windows
--psql -U postgres -d billjobs < unidad2.sql --en linux
-- 2. El cliente usuario01 ha realizado la siguiente compra: 

--●producto: producto9 
--●cantidad: 5 
--●fecha: fecha del sistema 

--Mediante el uso de transacciones, realiza las consultas correspondientes para este                     
--requerimiento y luego consulta la tabla producto para validar si fue efectivamente                       
--descontado en el stocK
--Paso1  ingresar la venta en la tabla compra
--Paso2  agregar detalla en la tabla detalle_compra
--Paso3  descontar el stock


\c billjobs
\echo '-----------'
\echo 'TRANSACCION 1'
\echo '-----------'
BEGIN TRANSACTION;
    --Paso1  ingresar la venta en la tabla compra
    INSERT INTO compra (id, cliente_id, fecha) VALUES  (33, 1, '2023-06-01');
    --Paso2  agregar detalla en la tabla detalle_compra
    INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad) VALUES (43, 9, 33, 5);
    --Paso3  descontar el stock
    UPDATE producto 
    SET stock = stock - 5
    WHERE id = 9;
COMMIT;
--conclusión: la venta no se logra por falta de stock

--3. 3. El cliente usuario02 ha realizado la siguiente compra: 
--●producto: producto1, producto 2, producto 8 
--●cantidad: 3 de cada producto 
--●fecha: fecha del sistema 
--Mediante el uso de transacciones, realiza las consultas correspondientes para este                     
--requerimiento y luego consulta la tabla producto para validar que si alguno de ellos                           
--se queda sin stock, no se realice la compra.
--Paso1 

\echo '-----------'
\echo 'TRANSACCION 2'
\echo '-----------'
BEGIN TRANSACTION;
 --Paso1  ingresar la venta en la tabla compra
    INSERT INTO compra (id, cliente_id, fecha) VALUES  (34, 2, '2023-06-01');
--Paso2  agregar detalla en la tabla detalle_compra
    INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad) VALUES (44, 1, 34, 3);
    --Paso2  agregar detalla en la tabla detalle_compra
    INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad) VALUES (45, 2, 34, 3);
    --Paso2  agregar detalla en la tabla detalle_compra
    INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad) VALUES (46, 8, 34, 3);
     --Paso3  descontar el stock
    UPDATE producto 
    SET stock = stock - 3
    WHERE id = 1 OR id = 2 OR id = 8;
COMMIT;

\echo '-----------'
\echo 'TRANSACCION 3'
\echo '-----------'
--conclusión: los cambios no se realizan porque no hay stock del producto 8
--4.a Paso1 Desactivar autocommit 
\set AUTOCOMMIT OFF
--4.a.1 Verificar que se desactivó autocommit
\echo :AUTOCOMMIT
--4.b Ingresar un nuevo cliente
INSERT INTO cliente(id, nombre, email) VALUES (11, 'usuario011', 'usuario011@gmail.com');
--4.c Verificar que fue agregado en la tabla cliente
SELECT * FROM cliente WHERE id = 11;
--4.d Realizar un rollback para descartar los cambios
ROLLBACK;
--4.e Confirmar que se restauró la información, sin considerar la inserción del punto b
SELECT * FROM cliente WHERE id = 11;
--4.f Habilitar de nuevo el autocommit
\set AUTOCOMMIT ON
--4.f.1 Verificar que se activó autocommit
\echo :AUTOCOMMIT

