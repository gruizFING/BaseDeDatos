SELECT  DISTINCT clientes.idCliente , titulo, duracion
FROM (alquileres NATURAL JOIN peliculas ) JOIN clientes ON clientes.idCliente=alquileres.idCliente
WHERE (85<(SELECT MIN(DURACION) FROM (alquileres NATURAL JOIN peliculas) WHERE clientes.idCliente = alquileres.idCliente ))AND(duracion = 
(SELECT MIN(DURACION) FROM (alquileres NATURAL JOIN peliculas) WHERE clientes.idCliente = alquileres.idCliente ));
