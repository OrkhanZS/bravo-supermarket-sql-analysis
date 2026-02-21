-- ============================================================
-- Task 1: Data Cleaning (Oracle SQL)
-- Goal: Standardize raw product data before analysis.
--
-- Issues found in raw data:
--   - weight column contains strings like "602.61 grams"
--   - price column contains strings like "$4.70"
--   - Missing values in product_type, brand, stock_location
--   - Missing values in weight, price, average_units_sold, year_added
--
-- Rules applied:
--   - product_type / brand: NULL or '' → 'Unknown'
--   - weight / price: strip non-numeric chars, NULL → overall median
--   - average_units_sold: NULL → 0
--   - year_added: NULL → 2022
--   - stock_location: A=Bakı, B=Gəncə, C=Sumqayıt, D=Lənkəran
--                     NULL or '' → 'Unknown'
-- ============================================================

WITH median_vals AS (
    SELECT
        MEDIAN(TO_NUMBER(REGEXP_REPLACE(weight, '[^0-9.]', ''))) AS median_weight,
        MEDIAN(TO_NUMBER(REGEXP_REPLACE(price,  '[^0-9.]', ''))) AS median_price
    FROM products
    WHERE weight IS NOT NULL
      AND price  IS NOT NULL
)
SELECT
    product_id,
    COALESCE(NULLIF(product_type, ''), 'Unknown')                             AS product_type,
    COALESCE(NULLIF(brand, ''), 'Unknown')                                    AS brand,
    ROUND(COALESCE(
        TO_NUMBER(REGEXP_REPLACE(weight, '[^0-9.]', '')),
        (SELECT median_weight FROM median_vals)
    ), 2)                                                                      AS weight,
    ROUND(COALESCE(
        TO_NUMBER(REGEXP_REPLACE(price, '[^0-9.]', '')),
        (SELECT median_price FROM median_vals)
    ), 2)                                                                      AS price,
    COALESCE(average_units_sold, 0)                                            AS average_units_sold,
    COALESCE(year_added, 2022)                                                 AS year_added,
    CASE COALESCE(NULLIF(stock_location, ''), 'Unknown')
        WHEN 'A' THEN 'Bakı'
        WHEN 'B' THEN 'Gəncə'
        WHEN 'C' THEN 'Sumqayıt'
        WHEN 'D' THEN 'Lənkəran'
        ELSE 'Unknown'
    END                                                                        AS stock_location
FROM products;
