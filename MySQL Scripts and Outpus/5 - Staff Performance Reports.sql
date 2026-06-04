# Revenue generated per staff member
SELECT 
    CONCAT(st.first_name, ' ', st.last_name)             AS staff_name,
    sr.store_name,
    COUNT(DISTINCT o.order_id)                            AS total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount))  AS total_revenue
FROM orders o
JOIN staffs     st ON o.staff_id  = st.staff_id
JOIN stores     sr ON o.store_id  = sr.store_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY st.staff_id, staff_name, sr.store_name
ORDER BY total_revenue DESC;

# Staff order count by month
SELECT 
    CONCAT(st.first_name, ' ', st.last_name) AS staff_name,
    DATE_FORMAT(o.order_date, '%Y-%m')        AS month,
    COUNT(DISTINCT o.order_id)                AS orders_handled
FROM orders o
JOIN staffs st ON o.staff_id = st.staff_id
GROUP BY st.staff_id, staff_name, month
ORDER BY staff_name, month;

# Manager and their team performance
SELECT 
    CONCAT(m.first_name, ' ', m.last_name)               AS manager,
    CONCAT(st.first_name, ' ', st.last_name)              AS staff_member,
    COUNT(DISTINCT o.order_id)                            AS total_orders,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount))  AS total_revenue
FROM staffs st
LEFT JOIN staffs      m  ON st.manager_id = m.staff_id
JOIN      orders      o  ON st.staff_id   = o.staff_id
JOIN      order_items oi ON o.order_id    = oi.order_id
GROUP BY manager, staff_member
ORDER BY manager, total_revenue DESC;