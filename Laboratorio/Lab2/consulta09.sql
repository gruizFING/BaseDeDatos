SELECT TBTIEMPO.idPelicula, TBTIEMPO.idCliente, TBTIEMPO.idSucursal,TBTIEMPO."Tiempo"
FROM (SELECT pl.idPelicula, al.idCliente, al.idSucursal, current_date - al.fecha AS "Tiempo"
FROM alquileres al NATURAL JOIN peliculas pl
WHERE al.fechaDevolucion is null
UNION
SELECT pl.idPelicula, al.idCliente, al.idSucursal, al.fechaDevolucion - al.fecha AS "Tiempo"
FROM alquileres al NATURAL JOIN peliculas pl
WHERE al.fechaDevolucion is not null) AS TBTIEMPO,clientes cl, peliculas pl
WHERE  cl.idCliente = TBTIEMPO.idCliente AND pl.idPelicula = TBTIEMPO.idPelicula AND NOT EXISTS(SELECT *
												FROM (SELECT pl.idPelicula, al.idCliente, al.idSucursal, current_date - al.fecha AS "Tiempo"
												FROM alquileres al NATURAL JOIN peliculas pl
												WHERE al.fechaDevolucion is null
												UNION
												SELECT pl.idPelicula, al.idCliente, al.idSucursal, al.fechaDevolucion - al.fecha AS "Tiempo"
												FROM alquileres al NATURAL JOIN peliculas pl
												WHERE al.fechaDevolucion is not null) AS TBTIEMPO2
												WHERE TBTIEMPO.idPelicula = TBTIEMPO2.idPelicula AND TBTIEMPO2."Tiempo">TBTIEMPO."Tiempo"
												);