SELECT PRINCIPAL.idCategoria
FROM (SELECT DISTINCT TABLAPrin.idCategoria,suc.idSucursal
     FROM (SELECT cat.idCategoria, al.idSucursal, rank()OVER (PARTITION BY al.idSucursal ORDER BY  count(al) DESC ) AS "Rank"
     FROM alquileres al  NATURAL JOIN peliculas  NATURAL JOIN categoriasdepeliculas cat
     group by cat.idCategoria, al.idSucursal) AS TABLAPrin, (SELECT COUNT(*) + "Rank" AS Cantidad ,suc.idSucursal,"Rank" 
						       FROM (SELECT cat.idCategoria, al.idSucursal, rank()OVER (PARTITION BY al.idSucursal ORDER BY  count(al) DESC ) AS "Rank"
						       FROM alquileres al  NATURAL JOIN peliculas  NATURAL JOIN categoriasdepeliculas cat
                                                       group by cat.idCategoria, al.idSucursal) AS TABLAPrin , sucursales suc
                                                       WHERE "Rank" <= 2 and suc.idSucursal = TABLAPrin.idSucursal
                                                       GROUP BY  suc.idSucursal, "Rank") AS CUENTA, sucursales suc
    WHERE  TABLAPrin.idSucursal= suc.idSucursal AND  TABLAPrin."Rank" <= CUENTA.Cantidad  AND CUENTA.idSucursal= suc.idSucursal 
    GROUP BY TABLAPrin.idCategoria,suc.idSucursal
    order by suc.idSucursal) AS PRINCIPAL
GROUP BY PRINCIPAL.idCategoria
HAVING (COUNT(PRINCIPAL.idCategoria )>=3);