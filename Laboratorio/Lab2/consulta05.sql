SELECT cli.nombre, cli.apellido, SUM(pg.monto) AS "MontoTotal"
FROM clientes cli, pagos pg
WHERE  pg.idClienteAlquilo=cli.idCliente AND (SELECT SUM(pg1.monto)
					     FROM pagos pg1
					     WHERE pg1.idClienteAlquilo = cli.idCliente) 
					     >
					     (SELECT (SUM(pg2.monto)/COUNT(DISTINCT cli.idCliente))
					      FROM pagos pg2 ,clientes cli
                                              WHERE cli.idCliente = pg2.idClienteAlquilo AND pg2.fecha > timestamp '2006-01-01')					     
group by cli.nombre, cli.apellido;