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
    -- FIX #8: Anbar planlaması üçün lazımi sütunlar əlavə edildi
    COALESCE(NULLIF(TRIM(product_type), ''), 'Unknown')                        AS product_type,
    COALESCE(NULLIF(TRIM(brand), ''), 'Unknown')                               AS brand,
    ROUND(TO_NUMBER(REGEXP_REPLACE(NULLIF(TRIM(price), ''), '[^0-9.]', '')), 2) AS price,
    average_units_sold,
    COALESCE(NULLIF(TRIM(stock_location), ''), 'Unknown')                      AS stock_location
FROM products
WHERE COALESCE(NULLIF(TRIM(product_type), ''), 'Unknown') IN ('Meat', 'Dairy')
  -- FIX #7: COALESCE(average_units_sold, 0) > 10 yanlış idi —
  --         NULL satışlı məhsul 0-a çevrilir və filtrdən düşürdü,
  --         README isə NULL ilə 0-ın fərqli olduğunu vurğulayır.
  --         Birbaşa > 10 şərti NULL-ları avtomatik kənar qoyur,
  --         bu isə daha düzgün davranışdır.
  AND average_units_sold > 10
ORDER BY average_units_sold DESC, product_id;
