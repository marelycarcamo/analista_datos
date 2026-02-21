-- Database: ecommerce

-- Vista para análisis de productos populares
CREATE VIEW product_performance AS
SELECT
    dp.product_name,
    dp.category,
    dp.brand,
    SUM(fo.quantity_ordered) as total_units_sold,
    SUM(fo.total_amount) as total_revenue,
    AVG(fo.unit_price) as avg_selling_price,
    COUNT(DISTINCT fo.customer_id) as unique_customers,
    -- Ranking por categoría
    ROW_NUMBER() OVER (PARTITION BY dp.category ORDER BY SUM(fo.total_amount) DESC) as category_rank
FROM fact_orders fo
JOIN dim_product dp ON fo.product_id = dp.product_id
JOIN dim_time dt ON fo.time_id = dt.date_key
WHERE dt.year = 2024  -- Filtro temporal
GROUP BY dp.product_id, dp.product_name, dp.category, dp.brand;

-- Vista materializada para dashboards ejecutivos
CREATE MATERIALIZED VIEW executive_dashboard AS
SELECT
    dt.year,
    dt.month,
    SUM(fo.total_amount) as monthly_revenue,
    COUNT(DISTINCT fo.customer_id) as active_customers,
    COUNT(fo.order_id) as total_orders,
    AVG(fo.total_amount) as avg_order_value,
    -- Crecimiento mensual
    (SUM(fo.total_amount) - LAG(SUM(fo.total_amount)) OVER (ORDER BY dt.year, dt.month)) /
    LAG(SUM(fo.total_amount)) OVER (ORDER BY dt.year, dt.month) as growth_rate
FROM fact_orders fo
JOIN dim_time dt ON fo.time_id = dt.date_key
GROUP BY dt.year, dt.month
ORDER BY dt.year, dt.month;