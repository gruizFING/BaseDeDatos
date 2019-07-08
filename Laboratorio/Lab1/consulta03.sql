SELECT nombre, apellido, email
FROM clientes
WHERE idCliente IN
	(SELECT idCliente
	FROM alquileres
	GROUP BY idCliente
	HAVING count(DISTINCT idPelicula) > 6
	)
;
