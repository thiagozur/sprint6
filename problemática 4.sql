--Listar la cantidad de clientes por nombre de sucursal ordenando de mayor a menor
SELECT
	sucursal.branch_name,
	count(vista_clientes.id_cliente) AS cantidad_en_sucursal
FROM vista_clientes
INNER JOIN sucursal ON vista_clientes.numero_sucursal=sucursal.branch_number
GROUP BY sucursal.branch_name
ORDER BY cantidad_en_sucursal DESC

--no entiendo como hacer esta
/* SELECT
	sucursal.branch_name,
	count(empleado.branch_id)
FROM empleado
INNER JOIN sucursal ON sucursal.branch_id=empleado.branch_id
GROUP BY sucursal.branch_name

SELECT
	sucursal.branch_name,
	count(cliente.branch_id)
FROM cliente
INNER JOIN sucursal ON sucursal.branch_id=cliente.branch_id
GROUP BY sucursal.branch_name */