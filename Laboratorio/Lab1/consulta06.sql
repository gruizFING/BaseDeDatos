SELECT alquileres.idSucursal,alquileres.idPersonal,categoria,COUNT(alquileres.*) AS "PendCat"
FROM  categorias, alquileres NATURAL JOIN peliculas,categoriasDePeliculas
WHERE (alquileres.fechaDevolucion IS NULL)  AND (SELECT COUNT(alquileres.*) FROM alquileres) > 0 
      AND categoriasDePeliculas.idCategoria = categorias.idCategoria AND categoriasDePeliculas.idPelicula = peliculas.idPelicula
GROUP BY alquileres.idSucursal,alquileres.idPersonal,categoria;
