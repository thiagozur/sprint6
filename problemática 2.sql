--vista de clientes general:
CREATE VIEW vista_clientes
AS
	SELECT
		cliente.customer_id AS id_cliente,
		sucursal.branch_number AS numero_sucursal,
		cliente.customer_name AS nombre_cliente,
		cliente.customer_surname AS apellido_cliente,
		cliente.customer_DNI AS DNI_cliente,
		cast((julianday('now') - julianday(dob))/365.25 as INTEGER) as edad_cliente
	FROM cliente
	INNER JOIN sucursal ON cliente.branch_id=sucursal.branch_id

--ordenados por DNI de menor a mayor con edades superiores a 40 años:
SELECT
	id_cliente,
	numero_sucursal,
	nombre_cliente,
	apellido_cliente,
	DNI_cliente,
	edad_cliente
FROM vista_clientes
WHERE edad_cliente > 40
ORDER BY DNI_cliente

--clientes llamados Anne o Tyler ordenados por edad de menor a mayor:
SELECT
	id_cliente,
	numero_sucursal,
	nombre_cliente,
	apellido_cliente,
	DNI_cliente,
	edad_cliente
FROM vista_clientes
WHERE nombre_cliente='Anne' OR nombre_cliente='Tyler'
ORDER BY edad_cliente

--inserción de los cinco nuevos clientes
BEGIN TRANSACTION;
INSERT INTO cliente (customer_name, customer_surname, customer_DNI, dob, branch_id)
VALUES
	('Lois', 'Stout', '47730534', '1984-07-07', '80'),
	('Hall', 'McConnell', '52055464', '1968-04-30', '45'),
	('Hilel', 'Mclean', '43625213', '1993-03-28' , '77'),
	('Jin', 'Cooley', '21207908', '1959-08-24', '96'),
	('Gabriel', 'Harmon', '57063950', '1976-04-01', '27');
COMMIT;

--cambiar id de sucursal de los clientes agregados
UPDATE cliente
SET branch_id='10'
WHERE customer_DNI='57063950' OR customer_DNI='21207908' OR customer_DNI='43625213' OR customer_DNI='52055464' OR customer_DNI='47730534'

--eliminar registro de Noel David
DELETE FROM cliente
WHERE customer_surname='David'

--consultar tipo de préstamo del préstamo de mayor importe
SELECT loan_type
FROM prestamo
ORDER BY loan_total DESC
LIMIT 1