-- ============================================================
-- Task 2: Price Range Analysis by Product Type (Oracle SQL)
-- Goal: Understand how prices vary across product categories.
--
-- Business question:
--   Which product categories have the widest price range?
--   This helps the pricing team identify categories that may
--   need better standardization or targeted promotions.
--
-- Note: 'Unknown' product_type rows are excluded from this
--       analysis to avoid misleading the pricing team with
--       uncategorized products. (FIX #6)
-- ============================================================

SELECT
    COALESCE(NULLIF(TRIM(product_type), ''), 'Unknown')                              AS product_type,
    -- FIX #5: NULLIF(TRIM(price),'') əlavə edildi — boş string halında
    --         TO_NUMBER xəta verirdi
    ROUND(MIN(TO_NUMBER(REGEXP_REPLACE(NULLIF(TRIM(price), ''), '[^0-9.]', ''))), 2) AS min_price,
    ROUND(MAX(TO_NUMBER(REGEXP_REPLACE(NULLIF(TRIM(price), ''), '[^0-9.]', ''))), 2) AS max_price
FROM products
-- FIX #6: 'Unknown' kateqoriyası analitik cəhətdən yanıltıcıdır,
--         qiymət komandasına real kateqoriyalar göstərilməlidir
WHERE NULLIF(TRIM(product_type), '') IS NOT NULL
GROUP BY COALESCE(NULLIF(TRIM(product_type), ''), 'Unknown')
ORDER BY product_type;
