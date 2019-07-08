SELECT DISTINCT (C.nombre || ' ' || C.apellido) AS "NomCompleto", (A1.fechaDevolucion - A1.fecha) AS "TiempoAlq"
FROM clientes C, alquileres A1
WHERE 	(C.idCliente = A1.idCliente
	AND
	A1.fechaDevolucion IS NOT NULL
	AND
	C.idCliente IN
		(SELECT idCliente
		FROM alquileres
		WHERE fechaDevolucion IS NOT NULL
		GROUP BY idCliente
		HAVING count(*) > 1
		)
	AND
	(A1.fechaDevolucion - A1.fecha) = ALL
		(SELECT A2.fechaDevolucion - A2.fecha
		FROM alquileres A2
		WHERE	(A2.idCliente = A1.idCliente
			AND
			A2.fechaDevolucion IS NOT NULL
			)
		)
	)
;