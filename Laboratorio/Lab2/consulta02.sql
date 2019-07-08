SELECT (nombre || ' ' || apellido) AS "NomCompleto", round(sum((costoAlquiler * 0.007) / cantActoresPelicula), 4) AS "Ganancia"
FROM (actores NATURAL JOIN actoresDePeliculas NATURAL JOIN peliculas NATURAL JOIN alquileres NATURAL JOIN 
	(SELECT idPelicula, count(*) AS cantActoresPelicula
	FROM (actoresDePeliculas NATURAL JOIN peliculas)
	GROUP BY idPelicula
	) AS actPelCost 
	 ) 	
GROUP BY idActor, nombre, apellido;