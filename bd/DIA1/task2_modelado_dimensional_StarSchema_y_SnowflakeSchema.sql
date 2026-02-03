-- Task 2: Modelado Dimensional: Star Schema y Snowflake Schema

USE `tienda_ejemplo.db`;
DROP TABLE IF EXISTS hechos_ventas;
DROP TABLE IF EXISTS pedidos;
-------------------------------------------------------------------

-- Star Schema para análisis de ventas
CREATE TABLE hechos_ventas (
    id_venta SERIAL PRIMARY KEY,
    id_tiempo INTEGER REFERENCES dim_tiempo(id),
    id_cliente INTEGER REFERENCES dim_cliente(id),
    id_producto INTEGER REFERENCES dim_producto(id),
    id_tienda INTEGER REFERENCES dim_tienda(id),
    cantidad INTEGER,
    precio_unitario DECIMAL,
    descuento DECIMAL,
    total_venta DECIMAL
);

CREATE TABLE dim_tiempo (
    id SERIAL PRIMARY KEY,
    fecha DATE,
    dia INTEGER,
    mes INTEGER,
    trimestre INTEGER,
    año INTEGER,
    dia_semana VARCHAR(10),
    festivo BOOLEAN
);

CREATE TABLE dim_cliente (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    segmento VARCHAR(20),
    region VARCHAR(50),
    edad INTEGER,
    genero VARCHAR(10)
);
/*
Task 2: Modelado Dimensional: Star Schema y Snowflake Schema
Los esquemas dimensionales están específicamente diseñados para análisis, sacrificando normalización por performance en consultas complejas.

Star Schema: Simplicidad y Performance
Estructura: Una tabla de hechos central rodeada de tablas de dimensiones.

Características:

Tabla de hechos: Métricas numéricas, claves foráneas a dimensiones
Tablas de dimensión: Atributos descriptivos, jerarquías naturales
Relaciones: Una dimensión conecta a hechos con una relación many-to-one
Ventajas:

Consultas intuitivas: "Ventas por producto, cliente y tiempo"
Performance: Menos joins que esquemas normalizados
Agregaciones eficientes: Optimizado para GROUP BY complejos
*/

