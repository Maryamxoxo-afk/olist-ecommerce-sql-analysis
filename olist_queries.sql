-- Olist Brazilian E-commerce: SQL analysis
-- Database: SQLite (DB Browser for SQLite)
-- Tables: orders, order_items, payments, reviews, customers, products, sellers, category_translation

-- Q1: Monthly orders and revenue (delivered orders only)
SELECT strftime('%Y-%m', o.order_purchase_timestamp) AS month,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(SUM(p.payment_value), 2) AS revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

-- Q2: Top 10 product categories by revenue
SELECT COALESCE(t.product_category_name_english, p.product_category_name) AS category,
       COUNT(DISTINCT oi.order_id) AS orders,
       ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category_translation t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;

-- Q3: Delivery time and late-delivery rate
SELECT COUNT(*) AS delivered_orders,
       ROUND(AVG(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)), 1) AS avg_delivery_days,
       SUM(CASE WHEN julianday(order_delivered_customer_date) > julianday(order_estimated_delivery_date) THEN 1 ELSE 0 END) AS late_orders,
       ROUND(100.0 * SUM(CASE WHEN julianday(order_delivered_customer_date) > julianday(order_estimated_delivery_date) THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_late
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date <> '';

-- Q4: Do late deliveries get lower review scores?
SELECT CASE WHEN julianday(o.order_delivered_customer_date) > julianday(o.order_estimated_delivery_date)
            THEN 'Late' ELSE 'On time' END AS delivery_status,
       COUNT(*) AS reviews,
       ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_delivered_customer_date <> ''
GROUP BY delivery_status;

-- Q5: Slowest states for delivery (states with 100+ orders)
SELECT c.customer_state AS state,
       COUNT(*) AS orders,
       ROUND(AVG(julianday(o.order_delivered_customer_date) - julianday(o.order_purchase_timestamp)), 1) AS avg_delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_delivered_customer_date <> ''
GROUP BY state
HAVING COUNT(*) >= 100
ORDER BY avg_delivery_days DESC
LIMIT 10;
