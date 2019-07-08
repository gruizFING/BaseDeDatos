SELECT A.idSucursal, C.idCategoria, A.idPersonal, count(*) AS "Total"
FROM (categoriasDePeliculas C NATURAL JOIN alquileres A)
WHERE A.fechaDevolucion IS NULL
GROUP BY C.idCategoria, A.idSucursal, A.idPersonal
HAVING count(*) >= ALL(
	SELECT count(*)
	FROM (categoriasDePeliculas NATURAL JOIN alquileres) 
	WHERE idCategoria = C.idCategoria
		AND
		idSucursal = A.idSucursal
		AND
		fechaDevolucion IS NULL
	GROUP BY idPersonal 
	)
;
