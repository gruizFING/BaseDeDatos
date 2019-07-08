INSERT INTO alquileres VALUES (1000, 2, 327, current_date, 2, NULL);
INSERT INTO pagos VALUES (1000, 327, 2, 2, current_date, 2, 50, current_date);

UPDATE alquileres SET fechaDevolucion = current_date WHERE fecha = current_date;
UPDATE pagos SET fechaAlquilo = current_date WHERE fechaAlquilo = current_date;

DELETE FROM pagos WHERE fechaAlquilo = current_date;
DELETE FROM alquileres WHERE fecha = current_date;