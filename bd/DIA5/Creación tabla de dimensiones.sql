-- Database: ecommerce

DROP TABLE dim_customer;
DROP TABLE dim_product;
DROP TABLE dim_location;


-- 1. Dimensión de Clientes
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id INTEGER PRIMARY KEY,
    email VARCHAR(255) UNIQUE,
    registration_date DATE,
    customer_segment VARCHAR(50),
    total_orders INTEGER,
    lifetime_value DECIMAL(12,2)
);

-- 2. Dimensión de Productos
CREATE TABLE IF NOT EXISTS dim_product (
    product_id INTEGER PRIMARY KEY,
    sku VARCHAR(100) UNIQUE,
    product_name VARCHAR(255), -- Ajustado para coincidir con tu vista del Paso 3
    category VARCHAR(100),
    brand VARCHAR(100),
    unit_cost DECIMAL(10,2),
    current_price DECIMAL(10,2)
);

-- 3. Dimensión de Ubicación
CREATE TABLE IF NOT EXISTS dim_location (
    location_id INTEGER PRIMARY KEY,
    country VARCHAR(100),
    region VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    timezone VARCHAR(50)
);

-- 4. Dimensión de Tiempo
-- Esta es vital para tus análisis de crecimiento mensual
CREATE TABLE dim_time (
    date_key INTEGER PRIMARY KEY, -- Formato YYYYMMDD (ej: 20240509)
    full_date DATE,
    year INTEGER,
    quarter INTEGER,
    month INTEGER,
    day_of_week INTEGER,
    is_weekend BOOLEAN,
    is_holiday BOOLEAN
);



-- Insertar Clientes
INSERT INTO dim_customer (customer_id, email, registration_date, customer_segment, total_orders, lifetime_value) VALUES
(1, 'marely.data@email.com', '2024-01-15', 'VIP', 10, 500.00),
(2, 'juan.perez@email.cl', '2024-02-10', 'Regular', 2, 45.50),
(3, 'ana.valdivia@email.cl', '2024-03-05', 'Nuevo', 1, 120.00),
(4, 'pedro.sur@email.cl', '2024-04-12', 'Regular', 5, 210.00),
(5, 'lucia.tech@email.com', '2024-05-01', 'VIP', 12, 850.00);

-- Insertar Productos
INSERT INTO dim_product (product_id, sku, product_name, category, brand, unit_cost, current_price) VALUES
(101, 'LAP-001', 'Laptop Gamer Pro', 'Electrónica', 'TechBrand', 800.00, 1200.00),
(102, 'MOU-002', 'Mouse Ergonómico', 'Accesorios', 'LogiX', 15.00, 45.00),
(103, 'MON-003', 'Monitor 27 Pulgadas', 'Electrónica', 'ViewMax', 150.00, 250.00),
(104, 'KEY-004', 'Teclado Mecánico', 'Accesorios', 'Clicky', 40.00, 85.00),
(105, 'AUD-005', 'Audífonos Bluetooth', 'Audio', 'SoundPro', 30.00, 75.00);

-- Insertar Ubicaciones (Con un guiño a tu ciudad)
INSERT INTO dim_location (location_id, country, region, city, postal_code, timezone) VALUES
(1, 'Chile', 'Los Ríos', 'Valdivia', '5090000', 'GMT-4'),
(2, 'Chile', 'Metropolitana', 'Santiago', '8320000', 'GMT-4'),
(3, 'Chile', 'Biobío', 'Concepción', '4030000', 'GMT-4'),
(4, 'Chile', 'Antofagasta', 'Antofagasta', '1240000', 'GMT-4'),
(5, 'Chile', 'Los Lagos', 'Puerto Montt', '5480000', 'GMT-4');

-- Insertar Tiempo (Días clave de 2024)
INSERT INTO dim_time (date_key, full_date, year, quarter, month, day_of_week, is_weekend, is_holiday) VALUES
(20240115, '2024-01-15', 2024, 1, 1, 1, FALSE, FALSE),
(20240210, '2024-02-10', 2024, 1, 2, 6, TRUE, FALSE),
(20240315, '2024-03-15', 2024, 1, 3, 5, FALSE, FALSE),
(20240420, '2024-04-20', 2024, 2, 4, 6, TRUE, FALSE),
(20240509, '2024-05-09', 2024, 2, 5, 4, FALSE, FALSE);

