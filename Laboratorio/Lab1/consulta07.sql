SELECT p1.nombre, p1.email
FROM personal p1,sucursales s1
WHERE (p1.idSucursal = s1.idSucursal AND p1.idCiudad <> s1.idCiudad)
EXCEPT
SELECT p2.nombre, p2.email
FROM personal p2, ciudades c1
WHERE (p2.idCiudad = c1.idCiudad AND c1.idCiudad NOT IN
	(SELECT c2.idCiudad
	FROM (ciudades c2 NATURAL JOIN sucursales s2)
	GROUP BY idCiudad
	HAVING count(*) > 5
	)
    )
;
