CREATE SEQUENCE logidseq
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;
	
CREATE TABLE regalqpag (
  idop integer DEFAULT nextval('logidseq'::regclass) NOT NULL,
  accion character(1) NOT NULL,
  tabla name NOT NULL,
  fecha date NOT NULL,
  usuario text NOT NULL,
  idpel integer NOT NULL,
  idcli integer NOT NULL,
  idsuc integer NOT NULL,
  fechaalq date NOT NULL
);

ALTER TABLE regalqpag
  ADD CONSTRAINT regalqpagpk PRIMARY KEY(idop);
  
CREATE OR REPLACE FUNCTION grabar_operaciones() RETURNS TRIGGER AS $grabar_operaciones$
DECLARE
	accion character(1);
	tupla RECORD;
BEGIN
	IF (TG_OP = 'INSERT') THEN
		accion := 'I';
		tupla := NEW;
	ELSIF (TG_OP = 'UPDATE') THEN
		accion := 'U';
		tupla := NEW;
	ELSE
		accion := 'D';
		tupla := OLD;
	END IF;
	IF (TG_TABLE_NAME = 'alquileres') THEN
		INSERT INTO regalqpag VALUES (
			nextval('logidseq'),
			accion,
			TG_TABLE_NAME,
			current_date,
			current_user,
			tupla.idPelicula,
			tupla.idCliente,
			tupla.idSucursal,
			tupla.fecha
		);
	ELSE
		INSERT INTO regalqpag VALUES (
			nextval('logidseq'),
			accion,
			TG_TABLE_NAME,
			current_date,
			current_user,
			tupla.idPeliculaAlquilo,
			tupla.idClienteAlquilo,
			tupla.idSucursalAlquilo,
			tupla.fechaAlquilo
		);
	END IF;
	RETURN NULL;
END;
$grabar_operaciones$ LANGUAGE plpgsql;

CREATE TRIGGER grabar_operaciones_alq AFTER INSERT OR UPDATE OR DELETE ON alquileres FOR EACH ROW EXECUTE PROCEDURE grabar_operaciones();
CREATE TRIGGER grabar_operaciones_pag AFTER INSERT OR UPDATE OR DELETE ON pagos 	 FOR EACH ROW EXECUTE PROCEDURE grabar_operaciones();
