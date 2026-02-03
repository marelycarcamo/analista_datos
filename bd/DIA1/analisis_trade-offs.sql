-- 1. Índices (esto SÍ funciona)
CREATE INDEX idx_hechos_tiempo ON hechos_ventas(id_tiempo);
CREATE INDEX idx_hechos_cliente ON hechos_ventas(id_cliente);
CREATE INDEX idx_hechos_producto ON hechos_ventas(id_producto);
CREATE INDEX idx_hechos_fecha ON hechos_ventas(fecha_venta);

-- 2. Particionamiento (SOLO si tienes columna fecha_venta)
--    Ejecutar solo una vez después de crear/modificar tabla
/*
ALTER TABLE hechos_ventas
PARTITION BY RANGE (YEAR(fecha_venta)) (
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
*/

-- 3. Vista (no materializada)
CREATE OR REPLACE VIEW vw_ventas_mensuales AS
SELECT 
    dt.año,
    dt.mes,
    SUM(hv.total_neto) as ventas_total,
    COUNT(DISTINCT hv.id_cliente) as clientes_unicos,
    AVG(hv.total_neto) as ticket_promedio
FROM hechos_ventas hv
JOIN dim_tiempo dt ON hv.id_tiempo = dt.id
GROUP BY dt.año, dt.mes
ORDER BY dt.año DESC, dt.mes DESC;

-- 4. Constraints
ALTER TABLE hechos_ventas 
ADD CONSTRAINT ck_total_neto_positivo 
CHECK (total_neto >= 0);

ALTER TABLE dim_cliente 
ADD CONSTRAINT ck_segmento_valido 
CHECK (segmento_valor IN ('Bronce', 'Plata', 'Oro', 'Platino'));