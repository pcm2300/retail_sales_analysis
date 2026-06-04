USE retail_sales;

-- Total revenue by store
SELECT 
    s.store_name,
    s.city,
    s.state,
    COUNT(DISTINCT o.order_id)                        AS total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM orders o
JOIN stores s      ON o.store_id = s.store_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_id, s.store_name, s.city, s.state
ORDER BY total_revenue DESC;

-- Revenue by state (region-wise)
SELECT 
    s.state,
    COUNT(DISTINCT o.order_id)                           AS total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM orders o
JOIN stores s       ON o.store_id = s.store_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.state
ORDER BY total_revenue DESC;

-- Monthly sales trend by store
SELECT 
    s.store_name,
    DATE_FORMAT(o.order_date, '%Y-%m')                   AS month,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS monthly_revenue
FROM orders o
JOIN stores s       ON o.store_id = s.store_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_name, month
ORDER BY s.store_name, month;