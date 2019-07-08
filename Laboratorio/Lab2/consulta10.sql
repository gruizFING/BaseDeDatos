SELECT A.idPersonal, A.idCliente, count(*) AS "faltas"
FROM alquileres A
WHERE EXISTS
	(SELECT idCliente
	FROM alquileres NATURAL JOIN peliculas
	WHERE 	idCliente = A.idCliente
		AND
		(fechaDevolucion IS NULL OR fechaDevolucion > A.fecha AND fecha < A.fecha)
		AND
		(A.fecha - fecha) > duracionAlquiler
		AND NOT EXISTS
			(SELECT *
			FROM pagos P
			WHERE (P.idClienteAlquilo = idCliente AND P.idPeliculaAlquilo = idPelicula
				AND P.idPersonalAlquilo = idPersonal AND P.idSucursalAlquilo = idSucursal
					AND P.fechaAlquilo = fecha)
			      AND
			      P.fecha < A.fecha
			)     
	GROUP BY idCliente
	HAVING count(*) > 1
	)
GROUP BY A.idPersonal, A.idCliente;