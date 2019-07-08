CREATE OR REPLACE FUNCTION cumplepol() RETURNS TRIGGER AS $cumplepol$
DECLARE
	idC integer;
BEGIN
	--Busco si para el NEW.idCliente no se cumple la politica
	SELECT idCliente INTO idC
	FROM alquileres A NATURAL JOIN peliculas P
	WHERE 	A.idCliente = NEW.idCliente
		AND
		(A.fechaDevolucion IS NULL)
		AND
		(NEW.fecha - A.fecha) > P.duracionAlquiler --Comparo con la fecha de la tupla dada, no con la actual..
		AND NOT EXISTS
			(SELECT *
			FROM pagos Pag
			WHERE (Pag.idClienteAlquilo = A.idCliente AND Pag.idPeliculaAlquilo = A.idPelicula
					AND Pag.idPersonalAlquilo = A.idPersonal AND Pag.idSucursalAlquilo = A.idSucursal
					AND Pag.fechaAlquilo = A.fecha)
			      AND
			      Pag.fecha < NEW.fecha
			)     
	GROUP BY idCliente
	HAVING count(*) > 1;
	IF (FOUND) THEN
		RAISE EXCEPTION 'Hay alquileres pendientes atrasados y sin pagos';
		RETURN NULL; --No se inserta la nueva tupla
	END IF;
	RETURN NEW;
END;
$cumplepol$ LANGUAGE plpgsql;

CREATE TRIGGER cumplepol BEFORE INSERT OR UPDATE ON alquileres FOR EACH ROW EXECUTE PROCEDURE cumplepol();