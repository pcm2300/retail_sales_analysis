-- Top 10 best selling products by revenue
SELECT 
    p.product_name,
    b.brand_name,
    c.category_name,
    SUM(oi.quantity)                                     AS units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM order_items oi
JOIN products   p ON oi.product_id = p.product_id
JOIN brands     b ON p.brand_id    = b.brand_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_id, p.product_name, b.brand_name, c.category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Sales by category
SELECT 
    c.category_name,
    SUM(oi.quantity)                                     AS units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM order_items oi
JOIN products   p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_revenue DESC;

-- Sales by brand
SELECT 
    b.brand_name,
    SUM(oi.quantity)                                     AS units_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN brands   b ON p.brand_id    = b.brand_id
GROUP BY b.brand_id, b.brand_name
ORDER BY total_revenue DESC;

-- Current inventory levels by product and store
SELECT 
    st.store_name,
    p.product_name,
    b.brand_name,
    sk.quantity AS stock_remaining
FROM stocks sk
JOIN stores   st ON sk.store_id   = st.store_id
JOIN products p  ON sk.product_id = p.product_id
JOIN brands   b  ON p.brand_id    = b.brand_id
ORDER BY sk.quantity ASC;

-- Low stock alert (less than 5 units)
SELECT 
    st.store_name,
    p.product_name,
    sk.quantity AS stock_remaining
FROM stocks sk
JOIN stores   st ON sk.store_id   = st.store_id
JOIN products p  ON sk.product_id = p.product_id
WHERE sk.quantity < 5
ORDER BY sk.quantity ASC;