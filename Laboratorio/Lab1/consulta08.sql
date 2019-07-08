SELECT  (nombre || ' ' || apellido) AS "NomCompleto" ,titulo, alquileres.idSucursal, alquileres.fechaDevolucion - alquileres.fecha AS tiempo, alquileres.fechaDevolucion - alquileres.fecha - peliculas.duracionAlquiler AS demora
FROM alquileres NATURAL JOIN peliculas,clientes
WHERE clientes.idCliente = alquileres.idCliente AND alquileres.fechaDevolucion IS NOT NULL
UNION 
SELECT  (nombre || ' ' || apellido) AS "NomCompleto" ,titulo, alquileres.idSucursal, current_date - alquileres.fecha AS tiempo, (current_date - alquileres.fecha) - peliculas.duracionAlquiler AS demora
FROM alquileres NATURAL JOIN peliculas,clientes
WHERE clientes.idCliente = alquileres.idCliente AND alquileres.fechaDevolucion IS NULL;
