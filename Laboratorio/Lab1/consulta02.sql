SELECT titulo, categoria
FROM (peliculas NATURAL JOIN categoriasDePeliculas NATURAL JOIN categorias)
WHERE idPelicula IN
	(SELECT p1.idPelicula
	FROM (peliculas p1 NATURAL JOIN inventario i1)
	WHERE i1.idSucursal IN
	(SELECT idSucursal
	FROM alquileres a1
	WHERE (a1.idPelicula = p1.idPelicula)
	)
	EXCEPT
	SELECT p2.idPelicula
	FROM (peliculas p2 NATURAL JOIN inventario i2)
	WHERE i2.idSucursal NOT IN
	(SELECT idSucursal
	FROM alquileres a2	
	WHERE (a2.idPelicula = p2.idPelicula)
	)
	)
;
