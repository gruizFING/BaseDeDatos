CREATE TABLE boletines (
  fecha date NOT NULL,
  idcliente integer NOT NULL,
  idpelicula integer NOT NULL,
  titulo char varying(255)  NOT NULL,
  nombrecliente text NOT NULL,
  mail char varying(50)  NOT NULL,
  categorias text NOT NULL,
  actores text NOT NULL
);

ALTER TABLE ONLY boletines
  ADD CONSTRAINT boletineskey PRIMARY KEY (idcliente , idpelicula);


CREATE OR REPLACE FUNCTION boletin() RETURNS TRIGGER AS $boletin$
DECLARE  
  cliente clientes%ROWTYPE;
  alquiler alquileres%ROWTYPE;
  idCategoria integer;
  idActor integer;
  categoriasPelicula integer[];
  actoresPelicula integer[];
  categ text;
  nombreActor text;
  bCategorias text := '';
  bActores text := '';
  btitulo text;
  cumple boolean := false;
  aux integer[1];
  i integer := 0;
BEGIN
  FOR idCategoria IN
    SELECT CP.idCategoria FROM categoriasDePeliculas CP WHERE NEW.idPelicula = CP.idPelicula
  LOOP
    categoriasPelicula[i] := idCategoria;
    i := i + 1;
    SELECT categoria INTO categ FROM categorias WHERE categorias.idCategoria = idCategoria;
    IF (bCategorias = '') THEN
      bCategorias := bCategorias || categ;
    ELSE
      bCategorias := bCategorias || ',' || categ;
    END IF;
  END LOOP;
  i := 0;
  FOR idActor IN
    SELECT AP.idActor FROM actoresDePeliculas AP WHERE NEW.idPelicula = AP.idPelicula
  LOOP
    actoresPelicula[i] := idActor;
    i := i + 1;
    SELECT nombre || ' ' || apellido INTO nombreActor FROM actores WHERE actores.idActor = idActor;
    IF (bActores = '') THEN
      bActores := bActores || nombreActor;
    ELSE
      bActores := bActores || ',' || nombreActor;
    END IF;
  END LOOP;
  
  FOR cliente IN
    SELECT * FROM clientes
  LOOP
    IF (cliente.idSucursal = NEW.idSucursal) THEN
      cumple := false;
      FOR alquiler IN
		SELECT * FROM alquileres WHERE idCliente = cliente.idCliente AND (current_date - 365) <= fecha
      LOOP
	 --Primero vemos la primer condicion
	 FOR idCategoria IN
	  SELECT C.idCategoria FROM categoriasDePeliculas C WHERE C.idPelicula = alquiler.idPelicula
	 LOOP
	  aux[0] := idCategoria;
	  IF (categoriasPelicula @> aux) THEN
	    cumple := true;
	    EXIT;
	  END IF;
	 END LOOP;
	 FOR idActor IN
	  SELECT A.idActor FROM actoresDePeliculas A WHERE A.idPelicula = alquiler.idPelicula
	 LOOP
	  aux[0] := idActor;
	  IF (actoresPelicula @> aux) THEN
	    cumple := true;
	    EXIT;
	  END IF;
	 END LOOP;
	 IF (cumple) THEN
	  SELECT titulo INTO btitulo FROM peliculas WHERE peliculas.idPelicula = NEW.idpelicula;
	  INSERT INTO boletines VALUES (current_date, cliente.idCliente, NEW.idPelicula, btitulo, cliente.nombre || ' ' || cliente.apellido, cliente.email, bCategorias, bActores);
	  EXIT;
	 END IF;
      END LOOP;
    END IF;
  END LOOP;
  
  RETURN NULL;
END;
$boletin$ LANGUAGE plpgsql;	

CREATE TRIGGER boletin AFTER INSERT ON inventario FOR EACH ROW EXECUTE PROCEDURE boletin();		
