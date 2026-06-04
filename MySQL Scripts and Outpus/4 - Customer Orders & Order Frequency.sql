-- Total orders and spend per customer
SELECT 
    CONCAT(c.first_name, ' ', c.last_name)               AS customer_name,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id)                            AS total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount))  AS total_spent
FROM customers c
JOIN orders      o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
GROUP BY c.customer_id, customer_name, c.city, c.state
ORDER BY total_spent DESC;

-- Repeat customers (more than 1 order)
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(DISTINCT o.order_id)              AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name, c.email
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;

-- Top 10 highest spenders
SELECT 
    CONCAT(c.first_name, ' ', c.last_name)               AS customer_name,
    c.email,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount))  AS total_spent
FROM customers c
JOIN orders      o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
GROUP BY c.customer_id, customer_name, c.email
ORDER BY total_spent DESC
LIMIT 10;

-- Customers who have never ordered
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;