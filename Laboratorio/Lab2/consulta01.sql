SELECT su.idSucursal , enc.nombre ,ROUND(COUNT(al.*)/6.00,2) AS "Promedio"
FROM sucursales su ,personal enc,alquileres al
WHERE (su.IdEncargado = enc.IdPersonal)AND EXTRACT(DOW FROM  al.fecha )=6 AND al.idSucursal=su.idSucursal AND al.fecha>='2009-07-01'AND al.fecha<='2009-12-31'
GROUP BY su.idSucursal, enc.nombre;