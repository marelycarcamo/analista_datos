
-- Crear esquema dimensional optimizado
CREATE TABLE IF NOT EXISTS dim_tiempo (
    id SERIAL PRIMARY KEY,
    fecha DATE UNIQUE,
    anio INTEGER,
    mes INTEGER,
    trimestre INTEGER,
    dia_semana VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS dim_cliente (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    segmento VARCHAR(20),
    region VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS hechos_ventas (
    id SERIAL PRIMARY KEY,
    id_tiempo INTEGER REFERENCES dim_tiempo(id),
    id_cliente INTEGER REFERENCES dim_cliente(id),
    total_venta DECIMAL(10,2),
    cantidad INTEGER,
    margen DECIMAL(5,2)
);

-- Generar datos de ejemplo (100,000 ventas)
INSERT INTO dim_tiempo (fecha, anio, mes, trimestre, dia_semana)
SELECT 
    fecha,
    EXTRACT(YEAR FROM fecha),
    EXTRACT(MONTH FROM fecha),
    EXTRACT(QUARTER FROM fecha),
    TO_CHAR(fecha, 'Day')
FROM generate_series('2023-01-01'::date, '2024-12-31'::date, '1 day') as fecha;

-- Insertar datos de ventas (simulado)
-- Nota: En producción usar COPY o INSERT masivo