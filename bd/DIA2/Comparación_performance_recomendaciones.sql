-- Crear vista materializada para consultas muy frecuentes
CREATE MATERIALIZED VIEW mv_ventas_mensuales AS
SELECT 
    dt.anio,
    dt.mes,
    dc.segmento,
    COUNT(*) as num_ventas,
    SUM(hv.total_venta) as ventas_total,
    AVG(hv.margen) as margen_promedio
FROM hechos_ventas hv
JOIN dim_tiempo dt ON hv.id_tiempo = dt.id
JOIN dim_cliente dc ON hv.id_cliente = dc.id
GROUP BY dt.anio, dt.mes, dc.segmento;

-- Índice en vista materializada
CREATE INDEX idx_mv_mensual ON mv_ventas_mensuales(anio, mes, segmento);

-- Comparación de performance:
-- Consulta directa: ~50ms (con índices)
-- Vista materializada: ~5ms (precalculada)
-- Beneficio: 10x más rápido para consultas repetitivas

-- Recomendaciones de mantenimiento:
-- 1. Reindexar índices mensualmente: REINDEX INDEX CONCURRENTLY index_name;
-- 2. Actualizar estadísticas: ANALYZE hechos_ventas;
-- 3. Monitorear uso de índices: SELECT * FROM pg_stat_user_indexes;
-- 4. Refrescar vistas materializadas: REFRESH MATERIALIZED VIEW CONCURRENTLY mv_ventas_mensuales;