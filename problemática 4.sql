--Listar la cantidad de clientes por nombre de sucursal ordenando de mayor a menor
SELECT
	sucursal.branch_name,
	count(vista_clientes.id_cliente) AS cantidad_en_sucursal
FROM vista_clientes
INNER JOIN sucursal ON vista_clientes.numero_sucursal=sucursal.branch_number
GROUP BY sucursal.branch_name
ORDER BY cantidad_en_sucursal DESC

--obtener la cantidad de empleados por cliente por sucursal en un número real
SELECT
	sucursal.branch_id AS sucursal,
	cast(count(distinct(empleado.employee_id)) AS REAL) / count(distinct(cliente.customer_id)) AS empleados_por_cliente
FROM sucursal
LEFT JOIN empleado ON sucursal.branch_id=empleado.branch_id
LEFT JOIN cliente ON sucursal.branch_id=cliente.branch_id
GROUP BY sucursal.branch_id

--obtener la cantidad de tarjetas por tipo por sucursal
SELECT 
	branch_id AS id_sucursal,
	Tipo,
	count(*) AS cantidad_tarjetas
FROM tarjetas
INNER JOIN cliente ON tarjetas.CustomerId=cliente.customer_id
GROUP BY branch_id, Tipo
ORDER BY branch_id

--obtener el promedio de créditos otorgado por sucursal
SELECT
	sucursal.branch_id AS id_sucursal,
	CASE 
		WHEN prestamo.loan_total IS NOT NULL
			THEN avg(prestamo.loan_total)
		ELSE 'No ha otorgado prestamos'
	END AS monto_promedio
FROM sucursal
LEFT JOIN cliente on cliente.branch_id=sucursal.branch_id
LEFT JOIN prestamo on prestamo.customer_id=cliente.customer_id
GROUP BY sucursal.branch_id

--crear tabla de auditoria cuenta
CREATE TABLE auditoria_cuenta(
	old_id INTEGER,
	new_id INTEGER,
	old_balance INTEGER,
	new_balance INTEGER,
	old_iban TEXT,
	new_iban TEXT,
	old_type TEXT,
	new_type TEXT,
	user_action TEXT,
	created_at TEXT
);

--crear triger de update para auditoria cuenta
CREATE TRIGGER updater
AFTER UPDATE OF 'balance', 'iban', 'typeId' ON cuenta
BEGIN
	INSERT INTO auditoria_cuenta
	VALUES (
		OLD.account_id,
		NEW.account_id,
		OLD.balance,
		NEW.balance,
		OLD.iban,
		NEW.iban,
		OLD.typeId,
		NEW.typeId,
		CASE
			WHEN OLD.balance <> NEW.balance
				THEN 'update_balance'
			WHEN OLD.iban <> NEW.iban
				THEN 'update_iban'
			WHEN OLD.typeId <> NEW.typeId
				THEN 'update_type'
		END,
		datetime('now')
		);
END;

--restar $100 a las cuentas 10, 11, 12, 13 y 14
UPDATE cuenta
SET balance=balance - 10000
WHERE account_id=10 OR account_id=11 OR account_id=12 OR account_id=13 OR account_id=14

--crear indice de dni
CREATE INDEX dni_search ON cliente(customer_DNI)

--crear tabla movimientos
CREATE TABLE movimientos(
	mov_id INTEGER PRIMARY KEY AUTOINCREMENT,
	account_id INTEGER,
	mov_total INTEGER,
	mov_type TEXT,
	mov_datetime TEXT
	);

--registrar transferencia en transacción
BEGIN;
	UPDATE cuenta
	SET balance=balance-100000
	WHERE account_id=200;
	UPDATE cuenta
	SET balance=balance+100000
	WHERE account_id=400;
	INSERT INTO movimientos (account_id, mov_total, mov_type, mov_datetime)
	VALUES(
		200,
		100000,
		'transferencia_enviada',
		datetime('now')
		);;
	INSERT INTO movimientos (account_id, mov_total, mov_type, mov_datetime)
	VALUES(
		400,
		100000,
		'transferencia_recibida',
		datetime('now')
		);
END;