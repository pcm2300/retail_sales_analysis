USE retail_sales;

SELECT 'brands'      AS tbl, COUNT(*) AS total FROM brands      UNION ALL
SELECT 'categories'  AS tbl, COUNT(*) AS total FROM categories   UNION ALL
SELECT 'customers'   AS tbl, COUNT(*) AS total FROM customers    UNION ALL
SELECT 'stores'      AS tbl, COUNT(*) AS total FROM stores       UNION ALL
SELECT 'staffs'      AS tbl, COUNT(*) AS total FROM staffs       UNION ALL
SELECT 'products'    AS tbl, COUNT(*) AS total FROM products     UNION ALL
SELECT 'orders'      AS tbl, COUNT(*) AS total FROM orders       UNION ALL
SELECT 'order_items' AS tbl, COUNT(*) AS total FROM order_items  UNION ALL
SELECT 'stocks'      AS tbl, COUNT(*) AS total FROM stocks;

USE retail_sales;

-- Products → brands and categories
SELECT 'products → brands' AS relationship, COUNT(*) AS orphaned_rows FROM products WHERE brand_id NOT IN (SELECT brand_id FROM brands) UNION ALL
SELECT 'products → categories', COUNT(*) FROM products WHERE category_id NOT IN (SELECT category_id FROM categories) UNION ALL

-- Orders → customers, stores, staffs
SELECT 'orders → customers', COUNT(*) FROM orders WHERE customer_id NOT IN (SELECT customer_id FROM customers) UNION ALL
SELECT 'orders → stores', COUNT(*) FROM orders WHERE store_id NOT IN (SELECT store_id FROM stores) UNION ALL
SELECT 'orders → staffs', COUNT(*) FROM orders WHERE staff_id NOT IN (SELECT staff_id FROM staffs) UNION ALL

-- Order_items → orders and products
SELECT 'order_items → orders', COUNT(*) FROM order_items WHERE order_id NOT IN (SELECT order_id FROM orders) UNION ALL
SELECT 'order_items → products', COUNT(*) FROM order_items WHERE product_id NOT IN (SELECT product_id FROM products) UNION ALL

-- Stocks → stores and products
SELECT 'stocks → stores', COUNT(*) FROM stocks WHERE store_id NOT IN (SELECT store_id FROM stores) UNION ALL
SELECT 'stocks → products', COUNT(*) FROM stocks WHERE product_id NOT IN (SELECT product_id FROM products) UNION ALL

-- Staffs → stores and self (manager_id)
SELECT 'staffs → stores', COUNT(*) FROM staffs WHERE store_id NOT IN (SELECT store_id FROM stores) UNION ALL
SELECT 'staffs → staffs (manager)', COUNT(*) FROM staffs WHERE manager_id IS NOT NULL AND manager_id NOT IN (SELECT staff_id FROM staffs);