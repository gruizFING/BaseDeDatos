CREATE TABLE bonos (
  mes text NOT NULL,
  anio integer NOT NULL,
  idpersonal integer NOT NULL,
  nombrepersonal text NOT NULL,
  bonomes integer NOT NULL
);

ALTER TABLE ONLY bonos
  ADD CONSTRAINT bonospkey PRIMARY KEY (mes, anio, idpersonal);
  
CREATE OR REPLACE FUNCTION premioper(idpersonal integer, mes integer, anio integer) RETURNS integer AS $bono$
DECLARE
	idsucursal integer := NULL;
	cantAlquileres integer := 0;
	alquiler alquileres%ROWTYPE;
	bono integer := 0;
BEGIN
	SELECT p.idsucursal INTO idsucursal FROM personal p WHERE p.idpersonal = idpersonal;
	IF (idsucursal IS NULL) THEN
		RAISE EXCEPTION 'Empleado incorrecto';
	ELSIF (mes < 1 OR mes > 12) THEN
		RAISE EXCEPTION 'Mes incorrecto';
	END IF;
	FOR alquiler IN
		SELECT *
		FROM alquileres a
		WHERE idpersonal = a.idpersonal AND
				anio = EXTRACT(YEAR FROM a.fecha) AND
				mes  = EXTRACT(MONTH FROM a.fecha)
	LOOP
		cantAlquileres := cantAlquileres + 1;
	END LOOP;
	IF (cantAlquileres > 29) THEN
		bono := 1000;
		cantAlquileres := cantAlquileres - 50;
		IF (cantAlquileres > 0) THEN
			bono := bono + cantAlquileres * 5;
		END IF;
	END IF;
	RETURN bono;
END;
$bono$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION premiogral(mes integer, anio integer) RETURNS VOID AS $$
DECLARE
	pers personal%ROWTYPE;
	bono bonos%ROWTYPE;
	mesText text;
	insertar boolean := true;
BEGIN
	IF (mes < 1 OR mes > 12) THEN
		RAISE EXCEPTION 'Mes incorrecto';
	END IF;
	mesText := mesToText(mes);
	SELECT * INTO bono FROM bonos b WHERE b.mes = mesText AND b.anio = anio;
	IF (FOUND) THEN
	    insertar := false;
	END IF;
	--Para saber si hay que insertar nuevas tuplas o actualizarlas
	FOR pers IN
		SELECT *
		FROM personal
	LOOP
		IF (insertar) THEN --No existe la tupla con este mes y anio, inserto una nueva
			INSERT INTO bonos VALUES (mesText, anio, pers.idpersonal, pers.nombre || ' ' || pers.apellido, premioper(pers.idpersonal, mes, anio));
		ELSE --Existe la tupla, solo actualizo el valor bonomes de la tupla correspondiente
			UPDATE bonos b SET bonomes = premioper(pers.idpersonal, mes, anio) WHERE b.mes = mesText AND b.anio = anio AND b.idpersonal = pers.idpersonal;
		END IF;
	END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION mesToText(mes integer) RETURNS text AS $$
BEGIN
	CASE mes
		WHEN 1 THEN
			RETURN 'Enero';
		WHEN 2 THEN
			RETURN 'Febrero';
		WHEN 3 THEN
			RETURN 'Marzo';
		WHEN 4 THEN
			RETURN 'Abril';
		WHEN 5 THEN
			RETURN 'Mayo';
		WHEN 6 THEN
			RETURN 'Junio';
		WHEN 7 THEN
			RETURN 'Julio';
		WHEN 8 THEN
			RETURN 'Agosto';
		WHEN 9 THEN
			RETURN 'Setiembre';
		WHEN 10 THEN
			RETURN 'Octubre';
		WHEN 11 THEN
			RETURN 'Noviembre';
		WHEN 12 THEN
			RETURN 'Diciembre';
		ELSE
			RAISE EXCEPTION 'Mes incorrecto';
	END CASE;
END;
$$ LANGUAGE plpgsql;
