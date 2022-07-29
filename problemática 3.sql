--seleccionar las cuentas con saldo negativo
SELECT * FROM cuenta
WHERE balance < 0

--seleccionar nombre, apellido y edad de clientes que tienen z en su apellido
SELECT nombre_cliente, apellido_cliente, edad_cliente
FROM vista_clientes
WHERE apellido_cliente LIKE '%Z%' OR apellido_cliente LIKE '%z%'

--seleccionar el nombre, apellido, edad y nombre de sucursal de las personas
--cuyo nombre sea “Brendan” y el resultado ordenarlo por nombre de
--sucursal
SELECT
	vista_clientes.nombre_cliente,
	vista_clientes.apellido_cliente,
	vista_clientes.edad_cliente,
	sucursal.branch_name
FROM vista_clientes
INNER JOIN sucursal ON vista_clientes.numero_sucursal=sucursal.branch_number
WHERE vista_clientes.nombre_cliente='Brendan'
ORDER BY sucursal.branch_name

--seleccionar préstamos de monto mayor a 80000 (teniendo en cuenta que los últimos dos dígitos son centavos) de tipo prendario
SELECT * FROM prestamo
WHERE loan_total > 8000000 AND loan_type='PRENDARIO'

--seleccionar los prestamos cuyo importe sea mayor que el importe medio de todos los prestamos
SELECT * FROM prestamo
WHERE loan_total > (SELECT avg(loan_total) FROM prestamo)

--contar la cantidad de clientes menores a 50 años
SELECT count(*) from vista_clientes WHERE edad_cliente < 50

--seleccionar las primeras 5 cuentas con saldo mayor a $8000
SELECT * FROM cuenta
WHERE balance > 800000
LIMIT 5

--seleccionar los préstamos que tengan fecha en abril, junio y agosto
ordenándolos por importe
SELECT * FROM prestamo
WHERE substr(loan_date, 6, 2)='04' OR substr(loan_date, 6, 2)='06' OR substr(loan_date, 6, 2)='08'
ORDER BY loan_total

--