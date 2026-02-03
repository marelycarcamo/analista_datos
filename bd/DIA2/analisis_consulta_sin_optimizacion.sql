-- Consulta analítica típica SIN optimización
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

-- Resultado típico SIN índices:
-- Execution time: ~5000ms
-- Plan: Sequential Scan on hechos_ventas (cost=10000.00..50000.00 rows=50000)
--       Hash Join, Nested Loop, etc.