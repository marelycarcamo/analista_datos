-- -===================================================================================================
-- Ejercicio práctico para aplicar los conceptos aprendidos.
-- Ejercicio: Diseño de esquema dimensional completo para análisis de e-commerce
-- =====================================================================================================

-- Diseño de Star Schema para plataforma de e-commerce
-- Requisitos identificados:
-- - Análisis de ventas por producto, cliente, tiempo y ubicación
-- - Segmentación por categorías y comportamiento de compra
-- - Métricas: ventas, conversiones, retención, valor de vida del cliente

USE nueva_tienda;

-- 2. Dimensión Tiempo: Jerarquía temporal completa
CREATE TABLE IF NOT EXISTS dim_tiempo (
    id INTEGER PRIMARY KEY,
    fecha DATE UNIQUE,
    dia INTEGER,
    mes INTEGER,
    nombre_mes VARCHAR(20),
    trimestre INTEGER,
    año INTEGER,
    dia_semana VARCHAR(10),
    numero_semana INTEGER,
    festivo BOOLEAN,
    temporada VARCHAR(20),  -- Primavera, Verano, etc.
    fin_semana BOOLEAN,
    dia_habil BOOLEAN
);

-- 3. Dimensión Cliente: Segmentación completa
CREATE TABLE IF NOT EXISTS dim_cliente (
    id INTEGER PRIMARY KEY,
    id_cliente_natural INTEGER,  -- Para SCD Tipo 2
    nombre VARCHAR(100),
    email VARCHAR(100),
    fecha_registro DATE,
    segmento_valor VARCHAR(20),  -- Bronce, Plata, Oro, Platino
    segmento_comportamiento VARCHAR(30),  -- Nuevo, Recurrente, VIP, Inactivo
    edad INTEGER,
    genero VARCHAR(10),
    ciudad VARCHAR(50),
    region VARCHAR(50),
    pais VARCHAR(50),
    frecuencia_compras_mensual DECIMAL(4,1),
    valor_promedio_compra DECIMAL(10,2),
    ultima_compra DATE,
    activo BOOLEAN
);



-- 5. Dimensión Geografía: Ubicación jerárquica
CREATE TABLE IF NOT EXISTS dim_geografia (
    id INTEGER PRIMARY KEY,
    codigo_postal VARCHAR(10),
    ciudad VARCHAR(50),
    provincia VARCHAR(50),
    region VARCHAR(50),
    pais VARCHAR(50),
    zona_horaria VARCHAR(10),
    densidad_poblacional VARCHAR(20)
);

-- 6. Dimensión Canal: Marketing y adquisición
CREATE TABLE IF NOT EXISTS dim_canal_adquisicion (
    id INTEGER PRIMARY KEY,
    nombre_canal VARCHAR(50),
    tipo_canal VARCHAR(20),  -- Pago, Orgánico, Social, Email, etc.
    costo_adquisicion DECIMAL(8,2),
    roi_promedio DECIMAL(5,2),
    tasa_conversion DECIMAL(5,2),
    activo BOOLEAN
);

-- 7. Tablas de soporte para jerarquías
CREATE TABLE IF NOT EXISTS dim_categoria (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(50),
    categoria_padre INTEGER REFERENCES dim_categoria(id),  -- Para jerarquía
    nivel INTEGER,  -- 1=Principal, 2=Subcategoria, etc.
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS dim_marca (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(50),
    pais_origen VARCHAR(50),
    segmento VARCHAR(20),  -- Premium, Medio, Económico
    reputacion DECIMAL(3,1)  -- Puntuación 1-10
);

-- 4. Dimensión Producto: Jerarquía de catálogo
CREATE TABLE IF NOT EXISTS dim_producto (
    id INTEGER PRIMARY KEY,
    sku VARCHAR(20) UNIQUE,
    nombre VARCHAR(100),
    descripcion TEXT,
    id_categoria INTEGER,
    id_marca INTEGER,

       -- Claves foráneas con acciones definidas
    FOREIGN KEY (id_categoria) 
        REFERENCES dim_categoria(id)
        ON DELETE RESTRICT       -- O SET NULL si quieres permitir productos sin categoría
        ON UPDATE CASCADE,
    
    FOREIGN KEY (id_marca) 
        REFERENCES dim_marca(id)
        ON DELETE RESTRICT       -- Previene eliminar marcas con productos
        ON UPDATE CASCADE,
    
    
    
    precio_lista DECIMAL(10,2),
    costo DECIMAL(10,2),
    margen DECIMAL(5,2),
    stock_actual INTEGER,
    stock_minimo INTEGER,
    disponible BOOLEAN,
    fecha_lanzamiento DATE,
    temporada VARCHAR(20)
);

-- 1. Tabla de Hechos: Ventas transaccionales
CREATE TABLE IF NOT EXISTS hechos_ventas (
    id_venta INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_tiempo INTEGER,
    id_cliente INTEGER,
    id_producto INTEGER,
    id_canal INTEGER,
    id_geografia INTEGER,
    
    -- Métricas transaccionales BASE
    cantidad INTEGER NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento_aplicado DECIMAL(10,2) DEFAULT 0.00,
    costo_envio DECIMAL(10,2) DEFAULT 0.00,
    impuestos DECIMAL(10,2) DEFAULT 0.00,
    
    -- Métricas calculadas (desnormalizadas para performance)
    total_bruto DECIMAL(10,2) AS (cantidad * precio_unitario) STORED,
    total_neto DECIMAL(10,2) AS ((cantidad * precio_unitario) - descuento_aplicado + costo_envio + impuestos) STORED,
    margen_contribucion DECIMAL(10,2) AS ((cantidad * precio_unitario) - descuento_aplicado - costo_envio) STORED,
    
    -- Flags para segmentación rápida
    primera_compra BOOLEAN DEFAULT FALSE,
    compra_recurrente BOOLEAN DEFAULT FALSE,
    cliente_vip BOOLEAN DEFAULT FALSE,
    
    -- Claves foráneas
    FOREIGN KEY (id_tiempo) REFERENCES dim_tiempo(id),
    FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id),
    FOREIGN KEY (id_producto) REFERENCES dim_producto(id),
    FOREIGN KEY (id_canal) REFERENCES dim_canal_adquisicion(id),
    FOREIGN KEY (id_geografia) REFERENCES dim_geografia(id),
    
    -- Índices
    INDEX idx_tiempo (id_tiempo),
    INDEX idx_cliente (id_cliente),
    INDEX idx_producto (id_producto),
    INDEX idx_fecha_cliente (id_tiempo, id_cliente)
);

SHOW CREATE TABLE dim_producto;