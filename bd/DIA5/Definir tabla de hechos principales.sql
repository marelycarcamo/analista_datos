-- Database: ecommerce

-- Tabla de hechos para pedidos de e-commerce
CREATE TABLE fact_orders (
    order_id BIGINT PRIMARY KEY,
    customer_id INTEGER REFERENCES dim_customer(customer_id),
    product_id INTEGER REFERENCES dim_product(product_id),
    time_id INTEGER REFERENCES dim_time(date_key),
    location_id INTEGER REFERENCES dim_location(location_id),

    -- Métricas del pedido
    quantity_ordered INTEGER,
    unit_price DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    tax_amount DECIMAL(10,2),
    shipping_cost DECIMAL(10,2),
    total_amount DECIMAL(10,2),

    -- Métricas calculadas
    profit_margin DECIMAL(10,2),  -- (total_amount - cost) / total_amount
    is_first_purchase BOOLEAN,
    order_channel TEXT,  -- 'web', 'mobile', 'api'
    payment_method TEXT
);