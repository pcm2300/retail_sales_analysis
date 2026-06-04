# Overall revenue and discount summary
SELECT 
    SUM(oi.quantity * oi.list_price)                     AS gross_revenue,
    SUM(oi.quantity * oi.list_price * oi.discount)       AS total_discount,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS net_revenue
FROM order_items oi;

# Revenue and discount by year
SELECT 
    YEAR(o.order_date)                                   AS year,
    SUM(oi.quantity * oi.list_price)                     AS gross_revenue,
    SUM(oi.quantity * oi.list_price * oi.discount)       AS total_discount,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS net_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY year
ORDER BY year;

# Average discount by category
SELECT 
    c.category_name,
    ROUND(AVG(oi.discount) * 100, 2) AS avg_discount_pct
FROM order_items oi
JOIN products   p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY avg_discount_pct DESC;

# Orders with high discounts (over 20%)
SELECT 
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.product_name,
    oi.discount * 100                       AS discount_pct,
    oi.list_price,
    oi.quantity
FROM order_items oi
JOIN orders   o ON oi.order_id   = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products  p ON oi.product_id = p.product_id
WHERE oi.discount > 0.20
ORDER BY oi.discount DESC;