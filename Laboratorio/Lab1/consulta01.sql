SELECT titulo, anio
FROM (peliculas NATURAL JOIN categoriasDePeliculas NATURAL JOIN categorias)
WHERE categorias.categoria = 'New' AND peliculas.idPelicula NOT IN (SELECT idPelicula FROM alquileres)
ORDER BY titulo ASC;
