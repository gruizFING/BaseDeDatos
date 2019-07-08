--
-- PostgreSQL database dump
--

-- Dumped from database version 9.0.4
-- Dumped by pg_dump version 9.0.4
-- Started on 2011-08-24 01:35:39

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


CREATE TYPE mpaarating AS ENUM (
    'G',
    'PG',
    'PG-13',
    'R',
    'NC-17'
);

CREATE DOMAIN year AS integer
	CONSTRAINT yearcheck CHECK (((VALUE >= 1901) AND (VALUE <= 2155)));


CREATE SEQUENCE actoractoridseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE actores (
    idactor integer DEFAULT nextval('actoractoridseq'::regclass) NOT NULL,
    nombre character varying(45) NOT NULL,
    apellido character varying(45) NOT NULL
);


CREATE TABLE actoresdepeliculas (
    idactor integer NOT NULL,
    idpelicula integer NOT NULL
);


CREATE TABLE alquileres (
    idpelicula integer NOT NULL,
    idsucursal integer NOT NULL,
    idcliente integer NOT NULL,
    fecha date NOT NULL,
    idpersonal integer NOT NULL,
    fechadevolucion date
);


CREATE SEQUENCE categoriacategoriaidseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

	
CREATE TABLE categorias (
    idcategoria integer DEFAULT nextval('categoriacategoriaidseq'::regclass) NOT NULL,
    categoria character varying(25) NOT NULL
);


CREATE TABLE categoriasdepeliculas (
    idpelicula integer NOT NULL,
    idcategoria integer NOT NULL
);



CREATE SEQUENCE ciudadidciudadseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE ciudades (
    idciudad integer DEFAULT nextval('ciudadidciudadseq'::regclass) NOT NULL,
    ciudad character varying(50) NOT NULL,
    idpais integer NOT NULL
);



CREATE SEQUENCE clienteclienteidseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE clientes (
    idcliente integer DEFAULT nextval('clienteclienteidseq'::regclass) NOT NULL,
    idsucursal integer NOT NULL,
    nombre character varying(45) NOT NULL,
    apellido character varying(45) NOT NULL,
    email character varying(50),
    direccion character varying(50) NOT NULL,
    idciudad integer NOT NULL,
    codigopostal character varying(10),
    telefono character varying(20) NOT NULL,
    activo boolean DEFAULT true NOT NULL
);


CREATE SEQUENCE idiomaididiomaseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE idiomas (
    ididioma integer DEFAULT nextval('idiomaididiomaseq'::regclass) NOT NULL,
    idioma character(20) NOT NULL
);


CREATE TABLE idiomasdepeliculas (
    ididioma integer NOT NULL,
    idpelicula integer NOT NULL
);


CREATE TABLE inventario (
    idpelicula integer NOT NULL,
    idsucursal integer NOT NULL,
    cantejemplares integer NOT NULL
);


CREATE TABLE pagos (
    idpeliculaalquilo integer NOT NULL,
    idclientealquilo integer NOT NULL,
    idsucursalalquilo integer NOT NULL,
    idpersonalalquilo integer NOT NULL,
    fechaalquilo date NOT NULL,
    idpersonalrecibepago integer NOT NULL,
    monto numeric(5,2) NOT NULL,
    fecha date NOT NULL
);



CREATE SEQUENCE paisidpaisseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE paises (
    idpais integer DEFAULT nextval('paisidpaisseq'::regclass) NOT NULL,
    pais character varying(50) NOT NULL
);


CREATE SEQUENCE peliculapeliculaidseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE peliculas (
    idpelicula integer DEFAULT nextval('peliculapeliculaidseq'::regclass) NOT NULL,
    titulo character varying(255) NOT NULL,
    descripcion text,
    anio year,
    ididiomaoriginal integer,
    duracionalquiler integer DEFAULT 3 NOT NULL,
    costoalquiler numeric(4,2) DEFAULT 99.8 NOT NULL,
    duracion integer,
    costoreemplazo numeric(5,2) DEFAULT 399.8 NOT NULL,
    clasificacion mpaarating DEFAULT 'G'::mpaarating,
    contenidosextra text[],
    multa integer
);


CREATE SEQUENCE personalidpersonalseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE personal (
    idpersonal integer DEFAULT nextval('personalidpersonalseq'::regclass) NOT NULL,
    nombre character varying(45) NOT NULL,
    apellido character varying(45) NOT NULL,
    direccion character varying(50) NOT NULL,
    idciudad integer NOT NULL,
    codigopostal character varying(10),
    telefono character varying(20) NOT NULL,
    email character varying(50),
    idsucursal integer NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    usuario character varying(16) NOT NULL,
    password character varying(40)
);


CREATE SEQUENCE sucursalsucursalidseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE sucursales (
    idsucursal integer DEFAULT nextval('sucursalsucursalidseq'::regclass) NOT NULL,
    idencargado integer NOT NULL,
    direccion character varying(50) NOT NULL,
    idciudad integer NOT NULL,
    codigopostal character varying(10),
    telefono character varying(20) NOT NULL
);


ALTER TABLE ONLY actoresdepeliculas
    ADD CONSTRAINT actordepeliculapkey PRIMARY KEY (idactor, idpelicula);


ALTER TABLE ONLY actores
    ADD CONSTRAINT actorespkey PRIMARY KEY (idactor);

ALTER TABLE ONLY alquileres
    ADD CONSTRAINT alquilerespkey PRIMARY KEY (idpelicula, idcliente, idsucursal, idpersonal, fecha);

ALTER TABLE ONLY categoriasdepeliculas
    ADD CONSTRAINT categoriadepeliculapkey PRIMARY KEY (idpelicula, idcategoria);

ALTER TABLE ONLY categorias
    ADD CONSTRAINT categoriaspkey PRIMARY KEY (idcategoria);

ALTER TABLE ONLY ciudades
    ADD CONSTRAINT ciudadespkey PRIMARY KEY (idciudad);

ALTER TABLE ONLY clientes
    ADD CONSTRAINT clientespkey PRIMARY KEY (idcliente);

ALTER TABLE ONLY idiomasdepeliculas
    ADD CONSTRAINT idiomadepeliculapkey PRIMARY KEY (ididioma, idpelicula);

ALTER TABLE ONLY idiomas
    ADD CONSTRAINT idiomaspkey PRIMARY KEY (ididioma);

ALTER TABLE ONLY inventario
    ADD CONSTRAINT inventariopkey PRIMARY KEY (idpelicula, idsucursal);

ALTER TABLE ONLY pagos
    ADD CONSTRAINT pagospkey PRIMARY KEY (idpeliculaalquilo, idclientealquilo, idsucursalalquilo, idpersonalalquilo, fechaalquilo, fecha);

ALTER TABLE ONLY paises
    ADD CONSTRAINT paisespkey PRIMARY KEY (idpais);

ALTER TABLE ONLY peliculas
    ADD CONSTRAINT peliculaspkey PRIMARY KEY (idpelicula);

ALTER TABLE ONLY personal
    ADD CONSTRAINT personalpkey PRIMARY KEY (idpersonal);

ALTER TABLE ONLY sucursales
    ADD CONSTRAINT sucursalpkey PRIMARY KEY (idsucursal);


ALTER TABLE ONLY actoresdepeliculas
    ADD CONSTRAINT actordepeliculaactoridfkey FOREIGN KEY (idactor) REFERENCES actores(idactor) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY actoresdepeliculas
    ADD CONSTRAINT actordepeliculapeliculaidfkey FOREIGN KEY (idpelicula) REFERENCES peliculas(idpelicula) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY alquileres
    ADD CONSTRAINT alquileresalquilerfkey FOREIGN KEY (idpelicula, idsucursal) REFERENCES inventario(idpelicula, idsucursal) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY alquileres
    ADD CONSTRAINT alquileresidclientefkey FOREIGN KEY (idcliente) REFERENCES clientes(idcliente) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY alquileres
    ADD CONSTRAINT alquileresidpersonalfkey FOREIGN KEY (idpersonal) REFERENCES personal(idpersonal) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY pagos
    ADD CONSTRAINT alquilerfkey FOREIGN KEY (idpeliculaalquilo, idclientealquilo, idsucursalalquilo, idpersonalalquilo, fechaalquilo) REFERENCES alquileres(idpelicula, idcliente, idsucursal, idpersonal, fecha) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY categoriasdepeliculas
    ADD CONSTRAINT categoriadepeliculacategoriaidfkey FOREIGN KEY (idcategoria) REFERENCES categorias(idcategoria) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY categoriasdepeliculas
    ADD CONSTRAINT categoriadepeliculapeliculaidfkey FOREIGN KEY (idpelicula) REFERENCES peliculas(idpelicula) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY ciudades
    ADD CONSTRAINT ciudadidpaisfkey FOREIGN KEY (idpais) REFERENCES paises(idpais) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY clientes
    ADD CONSTRAINT clienteciudadfkey FOREIGN KEY (idciudad) REFERENCES ciudades(idciudad) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY clientes
    ADD CONSTRAINT clientesucursalfkey FOREIGN KEY (idsucursal) REFERENCES sucursales(idsucursal) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY idiomasdepeliculas
    ADD CONSTRAINT idiomadepeliculaidiomaidfkey FOREIGN KEY (ididioma) REFERENCES idiomas(ididioma) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY idiomasdepeliculas
    ADD CONSTRAINT idiomadepeliculapeliculaidfkey FOREIGN KEY (idpelicula) REFERENCES peliculas(idpelicula) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY inventario
    ADD CONSTRAINT inventarioidpeliculafkey FOREIGN KEY (idpelicula) REFERENCES peliculas(idpelicula) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY inventario
    ADD CONSTRAINT inventarioidsucursalfkey FOREIGN KEY (idsucursal) REFERENCES sucursales(idsucursal) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY pagos
    ADD CONSTRAINT pagosidpersonalrecibepagofkey FOREIGN KEY (idpersonalrecibepago) REFERENCES personal(idpersonal) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY peliculas
    ADD CONSTRAINT peliculaoriginalididiomafkey FOREIGN KEY (ididiomaoriginal) REFERENCES idiomas(ididioma) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY personal
    ADD CONSTRAINT personalciudadfkey FOREIGN KEY (idciudad) REFERENCES ciudades(idciudad) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY personal
    ADD CONSTRAINT personalsucursalfkey FOREIGN KEY (idsucursal) REFERENCES sucursales(idsucursal) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY sucursales
    ADD CONSTRAINT sucursalidciudadfkey FOREIGN KEY (idciudad) REFERENCES ciudades(idciudad) ON UPDATE CASCADE ON DELETE RESTRICT;
