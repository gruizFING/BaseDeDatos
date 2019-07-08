SELECT A1.idPersonal, count(*) AS "Cantidad"
FROM alquileres A1
WHERE A1.idPelicula IN
	(SELECT idPelicula
	FROM (idiomasDePeliculas NATURAL JOIN idiomas)
	WHERE idioma = 'English'
	UNION
	SELECT idPelicula
	FROM peliculas P, idiomas I
	WHERE P.idIdiomaOriginal = I.idIdioma AND I.idioma = 'English'
	)
GROUP BY A1.idPersonal
HAVING count(*) >= ALL(
	SELECT count(*)
	FROM alquileres A2
	WHERE A2.idPelicula IN
		(SELECT idPelicula
		FROM (idiomasDePeliculas NATURAL JOIN idiomas)
		WHERE idioma = 'English'
		UNION
		SELECT idPelicula
		FROM peliculas P, idiomas I
		WHERE P.idIdiomaOriginal = I.idIdioma AND I.idioma = 'English'
		)
	GROUP BY A2.idPersonal
	)
;