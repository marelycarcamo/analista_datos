
-- Particionamiento por rangos para datos históricos
-- (Requiere recrear tabla - en producción planificar cuidadosamente)

-- Estrategia de particionamiento propuesta:
-- 1. Particionar hechos_ventas por id_tiempo (rangos mensuales)
-- 2. Subparticionar por hash de id_cliente para distribución uniforme
-- 3. Mantener particiones de los últimos 24 meses activas
-- 4. Archivar particiones más antiguas a storage económico

-- PRIMERO: Asegurarse que la tabla principal está particionada
-- Esto debe ejecutarse ANTES del DO block


CREATE TABLE IF NOT EXISTS hechos_ventas (
    id BIGSERIAL,
    id_tiempo INTEGER NOT NULL,
    id_cliente INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    total_neto DECIMAL(15,2) NOT NULL,
    fecha_venta DATE NOT NULL,
    -- Otros campos según tu estructura...
    PRIMARY KEY (id, fecha_venta)  -- IMPORTANTE: La PK debe incluir la columna de particionamiento
) PARTITION BY RANGE (fecha_venta);  -- O por id_tiempo si prefieres

-- Script de particionamiento (PostgreSQL)
DO $$
DECLARE
    fecha_inicio DATE := '2023-01-01';
    fecha_fin DATE := '2024-12-31';
    mes_actual DATE;
    nombre_particion TEXT;
BEGIN
    -- Crear particiones mensuales
    mes_actual := fecha_inicio;
    
    WHILE mes_actual <= fecha_fin LOOP
        nombre_particion := format('hechos_ventas_y%s_m%s', 
            EXTRACT(YEAR FROM mes_actual), 
            LPAD(EXTRACT(MONTH FROM mes_actual)::TEXT, 2, '0'));
        
        EXECUTE format(
            'CREATE TABLE IF NOT EXISTS %s PARTITION OF hechos_ventas
            FOR VALUES FROM (%L) TO (%L)',
            nombre_particion,
            mes_actual,
            mes_actual + INTERVAL '1 month'
        );
        
        RAISE NOTICE 'Partición creada: %', nombre_particion;
        mes_actual := mes_actual + INTERVAL '1 month';
    END LOOP;
END $$;

-- Verificar particiones creadas (CORRECCIÓN)
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname || '.' || tablename)) as tamanio
FROM pg_tables
WHERE tablename LIKE 'hechos_ventas_y%'
   OR tablename = 'hechos_ventas'
ORDER BY tablename;

-- Otra forma más precisa
SELECT 
    inhrelid::regclass as nombre_particion,
    pg_size_pretty(pg_total_relation_size(inhrelid)) as tamanio,
    pg_stat_get_live_tuples(inhrelid) as filas_vivas
FROM pg_inherits 
WHERE inhparent = 'hechos_ventas'::regclass
ORDER BY nombre_particion;