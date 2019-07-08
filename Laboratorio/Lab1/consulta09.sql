SELECT p1.titulo, a1.idSucursal, count(*) AS "CantAlq"
FROM (peliculas p1 NATURAL JOIN alquileres a1)
WHERE ('Trailers' = ANY(p1.contenidosExtra) 
	AND p1.idPelicula IN
	(SELECT idPelicula
	FROM (peliculas NATURAL JOIN actoresDePeliculas)
	GROUP BY idPelicula
	HAVING count(*)>=8
	)
    )
GROUP BY p1.idPelicula, p1.titulo, a1.idSucursal
HAVING count(*) >= ALL
	(SELECT count(a2.idSucursal)
	FROM (peliculas p2 NATURAL JOIN alquileres a2)
	WHERE (p2.idPelicula = p1.idPelicula)
	GROUP BY p2.idPelicula, a2.idSucursal
	)
ORDER BY p1.idPelicula;
