-- TASK1: NORMALIZACIÓN / DESNORMALIZACION.  Trade-offs para Análisis
----------------------------------------------------------------------------

-- Ejemplo: Sistema híbrido
-- OLTP: Normalizado para transacciones

USE `tienda_ejemplo.db`;

CREATE TABLE IF NOT EXISTS pedidos(
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER REFERENCES clientes(id),
    fecha_pedido DATE,
    estado VARCHAR(20)
);

-- OLAP: Desnormalizado para análisis
CREATE TABLE IF NOT EXISTS hechos_ventas(
    id_venta INTEGER,
    fecha DATE,
    cliente_nombre VARCHAR(100),
    cliente_segmento VARCHAR(20),
    producto_categoria VARCHAR(50),
    cantidad INTEGER,
    precio_unitario DECIMAL,
    total_venta DECIMAL,
    -- Columnas derivadas para análisis rápido
    mes INTEGER,
    trimestre INTEGER,
    año INTEGER,
    margen_beneficio DECIMAL
);


/*
La normalización y desnormalización representan filosofías opuestas en diseño de bases de datos,
cada una optimizada para diferentes cargas de trabajo. Para análisis de datos,
la elección apropiada puede significar la diferencia entre consultas que tardan segundos y las que tardan horas.

Normalización: Integridad Primero
Objetivos: Eliminar redundancia, asegurar consistencia, facilitar mantenimiento.

1NF: Valores atómicos, sin repetición de grupos
2NF: Dependencias funcionales completas
3NF: Dependencias transitivas eliminadas
BCNF: Dependencias más restrictivas

Ventajas para análisis:
- Integridad referencial: Datos consistentes y confiables
- Flexibilidad: Fácil añadir nuevos tipos de entidades
- Mantenimiento: Cambios localizados, sin propagación

Desventajas para análisis:
- Joins complejos: Consultas requieren múltiples joins
- Performance pobre: Especialmente con agregaciones complejas
- Complejidad: Consultas analíticas difíciles de escribir y optimizar
- Desnormalización: Performance Primero
- Objetivos: Optimizar para consultas analíticas, minimizar joins, maximizar velocidad de lectura.

Estrategias:
- Tablas resumen: Precalcular agregaciones comunes
- Columnas derivadas: Almacenar cálculos frecuentes
- Tablas anchas: Consolidar información relacionada

Ventajas para análisis:
- Consultas simples: Menos joins, más rápidas
- Performance predecible: Optimizado para patrones conocidos
- Simplicidad: Consultas más legibles y mantenibles

Desventajas para análisis:
- Redundancia: Almacenamiento duplicado
- Inconsistencia: Riesgo de datos contradictorios
- Complejidad de actualización: Cambios requieren sincronización múltiple
- Estrategia Híbrida: Lo Mejor de Ambos Mundos
- Normalización para transaccional: Sistema OLTP normalizado para operaciones diarias. Desnormalización para analítico: Data warehouse desnormalizado para reporting y análisis.

*/