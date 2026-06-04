CREATE VIEW vw_store_sales AS
SELECT 
    s.store_id,
    s.store_name,
    s.city,
    s.state,
    YEAR(o.order_date)                                   AS order_year,
    MONTH(o.order_date)                                  AS order_month,
    DATE_FORMAT(o.order_date, '%Y-%m')                   AS yr_month,
    COUNT(DISTINCT o.order_id)                           AS total_orders,
    SUM(oi.quantity * oi.list_price)                     AS gross_revenue,
    SUM(oi.quantity * oi.list_price * oi.discount)       AS total_discount,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS net_revenue
FROM orders o
JOIN stores      s  ON o.store_id  = s.store_id
JOIN order_items oi ON o.order_id  = oi.order_id
GROUP BY s.store_id, s.store_name, s.city, s.state, order_year, order_month, yr_month;

CREATE VIEW vw_product_sales AS
SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    p.model_year,
    s.store_name,
    s.city,
    s.state,
    YEAR(o.order_date)                                   AS order_year,
    MONTH(o.order_date)                                  AS order_month,
    DATE_FORMAT(o.order_date, '%Y-%m')                   AS yr_month,
    SUM(oi.quantity)                                     AS units_sold,
    SUM(oi.quantity * oi.list_price)                     AS gross_revenue,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS net_revenue
FROM order_items oi
JOIN orders     o  ON oi.order_id  = o.order_id
JOIN products   p  ON oi.product_id = p.product_id
JOIN brands     b  ON p.brand_id    = b.brand_id
JOIN categories c  ON p.category_id = c.category_id
JOIN stores     s  ON o.store_id    = s.store_id
GROUP BY p.product_id, p.product_name, b.brand_name, c.category_name, 
         p.model_year, s.store_name, s.city, s.state, 
         order_year, order_month, yr_month;


CREATE VIEW vw_inventory AS
SELECT 
    st.store_id,
    st.store_name,
    st.city,
    st.state,
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    sk.quantity                    AS stock_remaining,
    CASE 
        WHEN sk.quantity = 0 THEN 'Out of Stock'
        WHEN sk.quantity < 5 THEN 'Low Stock'
        ELSE 'In Stock'
    END                            AS stock_status
FROM stocks sk
JOIN stores     st ON sk.store_id   = st.store_id
JOIN products   p  ON sk.product_id = p.product_id
JOIN brands     b  ON p.brand_id    = b.brand_id
JOIN categories c  ON p.category_id = c.category_id;

CREATE VIEW vw_staff_performance AS
SELECT 
    st.staff_id,
    CONCAT(st.first_name, ' ', st.last_name)             AS staff_name,
    CONCAT(m.first_name, ' ', m.last_name)               AS manager_name,
    sr.store_name,
    sr.city,
    sr.state,
    YEAR(o.order_date)                                   AS order_year,
    MONTH(o.order_date)                                  AS order_month,
    DATE_FORMAT(o.order_date, '%Y-%m')                   AS yr_month,
    COUNT(DISTINCT o.order_id)                           AS total_orders,
    SUM(oi.quantity * oi.list_price)                     AS gross_revenue,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS net_revenue
FROM staffs st
LEFT JOIN staffs      m  ON st.manager_id = m.staff_id
JOIN      stores      sr ON st.store_id   = sr.store_id
JOIN      orders      o  ON st.staff_id   = o.staff_id
JOIN      order_items oi ON o.order_id    = oi.order_id
GROUP BY st.staff_id, staff_name, manager_name, sr.store_name, 
         sr.city, sr.state, order_year, order_month, yr_month;

CREATE VIEW vw_customer_analysis AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)               AS customer_name,
    c.email,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id)                           AS total_orders,
    SUM(oi.quantity * oi.list_price)                     AS gross_spent,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS net_spent,
    MIN(o.order_date)                                    AS first_order_date,
    MAX(o.order_date)                                    AS last_order_date,
    CASE
        WHEN COUNT(DISTINCT o.order_id) = 1 THEN 'One Time'
        WHEN COUNT(DISTINCT o.order_id) BETWEEN 2 AND 5 THEN 'Returning'
        ELSE 'Loyal'
    END                                                  AS customer_type
FROM customers c
JOIN orders      o  ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
GROUP BY c.customer_id, customer_name, c.email, c.city, c.state;


CREATE VIEW vw_revenue_discount AS
SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    YEAR(o.order_date)                                   AS order_year,
    MONTH(o.order_date)                                  AS order_month,
    DATE_FORMAT(o.order_date, '%Y-%m')                   AS yr_month,
    s.store_name,
    s.city,
    s.state,
    p.product_name,
    b.brand_name,
    c.category_name,
    oi.quantity,
    oi.list_price,
    oi.discount,
    ROUND(oi.discount * 100, 2)                          AS discount_pct,
    oi.quantity * oi.list_price                          AS gross_amount,
    oi.quantity * oi.list_price * oi.discount            AS discount_amount,
    oi.quantity * oi.list_price * (1 - oi.discount)      AS net_amount
FROM orders o
JOIN order_items oi ON o.order_id    = oi.order_id
JOIN stores      s  ON o.store_id    = s.store_id
JOIN products    p  ON oi.product_id = p.product_id
JOIN brands      b  ON p.brand_id    = b.brand_id
JOIN categories  c  ON p.category_id = c.category_id;


SHOW FULL TABLES WHERE Table_type = 'VIEW';
