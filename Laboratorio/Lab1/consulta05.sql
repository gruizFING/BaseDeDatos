SELECT nombre
FROM clientes
WHERE idCliente IN
	(SELECT idCliente
	FROM alquileres
	GROUP BY idCliente, fecha
	HAVING count(*) > 1
	EXCEPT
	SELECT idCliente
	FROM alquileres
	GROUP BY idCliente, fecha
	HAVING count(*) = 1
	)
;
	