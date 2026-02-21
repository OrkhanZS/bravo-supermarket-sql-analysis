-- ============================================================
-- Task 3: High-Demand Meat & Dairy Products (Oracle SQL)
-- Goal: Identify Meat and Dairy products with strong sales volume.
--
-- Business question:
--   Which Meat and Dairy products sell more than 10 units/month
--   on average? These are high-priority products for inventory
--   planning and should be kept well-stocked at all times.
-- ============================================================

SELECT
    product_id,
    ROUND(TO_NUMBER(REGEXP_REPLACE(price, '[^0-9.]', '')), 2) AS price,
    COALESCE(average_units_sold, 0)                           AS average_units_sold
FROM products
WHERE COALESCE(NULLIF(product_type, ''), 'Unknown') IN ('Meat', 'Dairy')
  AND COALESCE(average_units_sold, 0) > 10
ORDER BY product_id;
