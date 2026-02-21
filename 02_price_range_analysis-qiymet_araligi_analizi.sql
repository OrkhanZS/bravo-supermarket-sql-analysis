-- ============================================================
-- Task 2: Price Range Analysis by Product Type (Oracle SQL)
-- Goal: Understand how prices vary across product categories.
--
-- Business question:
--   Which product categories have the widest price range?
--   This helps the pricing team identify categories that may
--   need better standardization or targeted promotions.
-- ============================================================

SELECT
    COALESCE(NULLIF(product_type, ''), 'Unknown')                         AS product_type,
    ROUND(MIN(TO_NUMBER(REGEXP_REPLACE(price, '[^0-9.]', ''))), 2)        AS min_price,
    ROUND(MAX(TO_NUMBER(REGEXP_REPLACE(price, '[^0-9.]', ''))), 2)        AS max_price
FROM products
GROUP BY COALESCE(NULLIF(product_type, ''), 'Unknown')
ORDER BY product_type;
