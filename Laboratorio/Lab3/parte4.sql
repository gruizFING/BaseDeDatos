CREATE OR REPLACE FUNCTION disponoblealq() RETURNS TRIGGER AS $disponoblealq$
DECLARE
    alquilerDisponible integer := NULL;
BEGIN
	SELECT a.idPelicula INTO alquilerDisponible
		FROM alquileres a , inventario i
		WHERE a.idPelicula = new.idPelicula AND a.idSucursal = new.idSucursal AND a.idPelicula = i.idPelicula AND a.idSucursal = i.idSucursal AND
		      i.cantEjemplares > (SELECT count(*)
									FROM alquileres b
									WHERE a.idSucursal = b.idSucursal AND a.idPelicula = b.idPelicula AND ( b.fechaDevolucion IS NULL) and NEW.fecha >= a.fecha)
									+
									(SELECT count(*)
									FROM alquileres b
									WHERE a.idSucursal = b.idSucursal AND a.idPelicula = b.idPelicula AND ( b.fechaDevolucion IS NOT NULL) AND (NEW.fecha < a.fechaDevolucion) AND NEW.fecha >= a.fecha)
									;
									
	IF (alquilerDisponible IS NULL) THEN		
			RAISE EXCEPTION 'No hay ejemplares disponibles.';
			RETURN NULL;
	END IF;
	RETURN NEW;
END;
$disponoblealq$ LANGUAGE plpgsql;	

CREATE TRIGGER disponoblealq BEFORE INSERT OR UPDATE ON alquileres FOR EACH ROW EXECUTE PROCEDURE disponoblealq();