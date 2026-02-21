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
--   - weight / price: strip non-numeric chars, NULL or '' → overall median
--   - average_units_sold: NULL → 0
--   - year_added: NULL → 2022
--   - stock_location: already stored as city names (Bakı, Gəncə, Sumqayıt, Lənkəran)
--                     NULL or '' → 'Unknown'
-- ============================================================

WITH median_vals AS (
    SELECT
        -- FIX #2: Her sutun ucun ayri-ayri NULL filtrasi (əvvəlki AND şərti
        --         hər iki sütun eyni anda NULL olmayanları götürürdü,
        --         bu isə median dəyərini əyirdi)
        MEDIAN(
            CASE
                WHEN NULLIF(TRIM(weight), '') IS NOT NULL
                THEN TO_NUMBER(REGEXP_REPLACE(weight, '[^0-9.]', ''))
            END
        ) AS median_weight,
        MEDIAN(
            CASE
                WHEN NULLIF(TRIM(price), '') IS NOT NULL
                THEN TO_NUMBER(REGEXP_REPLACE(price, '[^0-9.]', ''))
            END
        ) AS median_price
    FROM products
)
SELECT
    product_id,
    COALESCE(NULLIF(TRIM(product_type), ''), 'Unknown')                        AS product_type,
    COALESCE(NULLIF(TRIM(brand), ''), 'Unknown')                               AS brand,

    -- FIX #3: NULLIF(TRIM(weight),'') əlavə edildi — boş string halını idarə edir
    ROUND(COALESCE(
        TO_NUMBER(REGEXP_REPLACE(NULLIF(TRIM(weight), ''), '[^0-9.]', '')),
        (SELECT median_weight FROM median_vals)
    ), 2)                                                                       AS weight,

    -- FIX #3: NULLIF(TRIM(price),'') əlavə edildi — boş string halını idarə edir
    ROUND(COALESCE(
        TO_NUMBER(REGEXP_REPLACE(NULLIF(TRIM(price), ''), '[^0-9.]', '')),
        (SELECT median_price FROM median_vals)
    ), 2)                                                                       AS price,

    COALESCE(average_units_sold, 0)                                             AS average_units_sold,
    COALESCE(year_added, 2022)                                                  AS year_added,

    -- FIX #4: CSV-də stock_location artıq şəhər adı ilə saxlanılır (Bakı, Gəncə...),
    --         A/B/C/D kodları yoxdur. Əvvəlki CASE kodu real datada heç vaxt
    --         uyğunluq tapmırdı və hamısını 'Unknown' qaytarırdı.
    COALESCE(NULLIF(TRIM(stock_location), ''), 'Unknown')                      AS stock_location

FROM products;
