CREATE SEQUENCE idlogpel
	START WITH 1
	INCREMENT BY 1
	NO MINVALUE
	NO MAXVALUE
	CACHE 1;

CREATE TABLE operpel (
  id integer DEFAULT nextval('idlogpel'::regclass) NOT NULL,
  accion character(1) NOT NULL,
  fecha date NOT NULL,
  usuario text NOT NULL
);

ALTER TABLE operpel
  ADD CONSTRAINT operpelpk PRIMARY KEY(id);
  
CREATE OR REPLACE FUNCTION grabar_operaciones_pel() RETURNS TRIGGER AS $grabar_operaciones_pel$
DECLARE
	accion character(1);
BEGIN
	IF (TG_OP = 'INSERT') THEN
		accion := 'I';
	ELSIF (TG_OP = 'UPDATE') THEN
		accion := 'U';
	ELSE
		accion := 'D';
	END IF;
	
	INSERT INTO operpel VALUES (
		nextval('idlogpel'),
		accion,
		current_date,
		current_user
	);
	RETURN NULL;
END;
$grabar_operaciones_pel$ LANGUAGE plpgsql;

CREATE TRIGGER grabar_operaciones_pel AFTER INSERT OR UPDATE OR DELETE ON peliculas FOR EACH STATEMENT EXECUTE PROCEDURE grabar_operaciones_pel();
