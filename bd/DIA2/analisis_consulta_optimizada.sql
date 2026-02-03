-- Re-ejecutar consulta CON optimización
EXPLAIN ANALYZE
SELECT 
    dt.anio,
    dt.trimestre,
    dc.segmento,
    COUNT(*) as num_ventas,
    SUM(hv.total_venta) as ventas_total,
    AVG(hv.margen) as margen_promedio
FROM hechos_ventas hv
JOIN dim_tiempo dt ON hv.id_tiempo = dt.id
JOIN dim_cliente dc ON hv.id_cliente = dc.id
WHERE dt.anio = 2024
  AND dc.segmento IN ('VIP', 'Premium')
  AND hv.total_venta > 100
GROUP BY dt.anio, dt.trimestre, dc.segmento
ORDER BY dt.anio, dt.trimestre, SUM(hv.total_venta) DESC;

-- Resultado esperado CON índices:
-- Execution time: ~50ms (100x más rápido)
-- Plan: Index Scan, Bitmap Index Scan, Hash Join optimizado