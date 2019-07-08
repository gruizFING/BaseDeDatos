SELECT Distinct  ci.nombre,  ci.apellido,  suc.idSucursal
FROM clientes ci, sucursales suc
WHERE (SELECT DISTINCT count(*)
		FROM alquileres al
		WHERE al.idCliente = ci.idCliente AND al.idSucursal = suc.idSucursal and suc.idSucursal<>ci.idSucursal)
		>
		(SELECT DISTINCT count(*)
		FROM alquileres al
		WHERE al.idCliente = ci.idCliente AND al.idSucursal = ci.idSucursal)

AND
	EXISTS((SELECT al.idSucursal
	FROM alquileres al ,peliculas pl
	WHERE al.fechaDevolucion - al.fecha - pl.duracionAlquiler > 0 AND pl.idPelicula = al.idPelicula AND al.fechaDevolucion IS NOT NULL AND suc.idSucursal=al.idSucursal
		AND ci.idCliente = al.idCliente
	)
	UNION
	(SELECT al.idSucursal
	FROM alquileres al ,peliculas pl
	WHERE (current_date - al.fecha) - pl.duracionAlquiler > 0  AND pl.idPelicula = al.idPelicula AND al.fechaDevolucion IS NULL AND suc.idSucursal=al.idSucursal
		AND ci.idCliente = al.idCliente
	)
	)
;
