-- ========================================================================================
-- Comparación de consultas: Normalizado vs Dimensional
-- =======================================================================================
USE nueva_tienda;
-- Consulta en esquema NORMALIZADO (complejo, lento)
SELECT 
    c.nombre as 'cliente',
    p.nombre as 'producto',
    cat.nombre as 'categoria',
    SUM(v.cantidad * v.precio_unitario) as total_ventas,
    AVG(v.cantidad * v.precio_unitario) as ticket_promedio
FROM hechos_ventas v
JOIN dim_cliente c ON v.id_cliente = c.id
JOIN dim_producto p ON v.id_producto = p.id
JOIN dim_categoria cat ON p.id_categoria = cat.id
WHERE v.fecha_venta BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY c.nombre, p.nombre, cat.nombre
ORDER BY total_ventas DESC;

