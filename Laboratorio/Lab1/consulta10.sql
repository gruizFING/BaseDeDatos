SELECT c1.idCliente, count(*) AS "Alquileres"
FROM clientes c1, alquileres a
WHERE c1.idSucursal IN
	(SELECT s.idSucursal
	FROM clientes c, sucursales s
	WHERE c.idSucursal = s.idSucursal
	GROUP BY s.idSucursal
	HAVING count(*) > 300
	)
	AND c1.idCliente = a.idCliente
GROUP BY c1.idCliente
UNION
SELECT c2.idCliente, 0 AS "Alquileres"
FROM clientes c2
WHERE c2.idSucursal IN
	(SELECT s.idSucursal
	FROM clientes c, sucursales s
	WHERE c.idSucursal = s.idSucursal
	GROUP BY s.idSucursal
	HAVING count(*) > 300
	)
	AND c2.idCliente NOT IN
	(SELECT idCliente
	FROM alquileres)
;
