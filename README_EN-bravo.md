# 🛒 Bravo Supermarket — Product Data Analysis

A SQL-based data cleaning and analysis project for **Bravo**, a fast-growing supermarket chain operating across Azerbaijan.

---

## 📌 Business Context

Bravo has expanded rapidly in recent years, opening new stores in Baku and across the regions. The company's product inventory is managed through 4 warehouse locations (Baku, Ganja, Sumgayit, Lankaran) and covers thousands of products.

However, rapid growth came with a cost — the product database accumulated significant data quality issues. Records arriving from different warehouses used inconsistent formats, some fields had missing values, and numeric columns contained embedded text (e.g., `"602.61 grams"`, `"$4.70"`). This made it increasingly difficult for the analytics team to produce reliable reports.

---

## 🚨 Business Problems

### 1. 📦 Warehouse Management Issues
Several products had a blank or NULL `stock_location` field. This meant warehouse staff had no way of knowing where a product was stored — leading to wasted time, delayed deliveries, and customer dissatisfaction.

### 2. 💰 Price Transparency Issues
The `price` column stored values in inconsistent formats such as `"$12.99"` as text, and some records were entirely missing. This broke automated pricing reports and made it impossible to set accurate baselines for discount campaigns.

### 3. ⚖️ Weight Data Inconsistencies
The `weight` column contained values like `"874.50 grams"` — the number and unit were stored together as a string. This completely blocked sorting, filtering, and any calculations based on weight, including weight-based pricing models.

### 4. 🏷️ Missing Product Category Data
Products with a blank `product_type` were not assigned to any category. These products dropped out of category-level sales reports, causing managers to draw incorrect conclusions — some categories appeared more or less profitable than they actually were.

### 5. 📅 Product History Gaps
Missing values in the `year_added` field made it impossible to determine when a product was first introduced to stock. This prevented meaningful comparison of old vs. new products, trend tracking, and stock rotation planning.

### 6. 📉 Sales Volume Inaccuracies
NULL values in `average_units_sold` corrupted sales analytics. A product with NULL sales is fundamentally different from one with 0 sales — but the system could not distinguish between the two, making it harder to identify top-selling products.

### 7. 🧾 Incomplete Brand Data
Gaps in the `brand` field made brand-level performance analysis impossible. Knowing which brands sell best and which tend to sit on shelves is essential for procurement and supplier negotiations.

---

## 🎯 Project Objectives

1. Standardize raw product data without modifying the original table
2. Analyze price ranges across product categories
3. Identify high-demand Meat and Dairy products
4. Generate actionable insights for inventory planning and sales strategy

---

## 🗂️ Project Structure

```
bravo-sql-analysis/
├── README.md                          # Azerbaijani version
├── README_EN.md                       # English version
├── data/
│   └── products.csv                   # Sample dataset (100 rows)
└── queries/
    ├── 01_data_cleaning.sql           # Task 1 – Standardize raw data
    ├── 02_price_range_analysis.sql    # Task 2 – Min/max price by category
    └── 03_meat_dairy_analysis.sql     # Task 3 – High-demand products
```

---

## 🧹 Task 1 — Data Cleaning (`01_data_cleaning.sql`)

**Problem:** The raw data contained multiple quality issues across 8 columns.

| Column | Issue | Fix Applied |
|---|---|---|
| `product_type` | NULL or empty string | → `'Unknown'` |
| `brand` | NULL or empty string | → `'Unknown'` |
| `weight` | Text like `"874.50 grams"`, NULLs | Strip non-numeric chars, NULL → median |
| `price` | Text like `"$12.99"`, NULLs | Strip non-numeric chars, NULL → median |
| `average_units_sold` | NULL values | → `0` |
| `year_added` | NULL values | → `2022` |
| `stock_location` | NULL or empty string | → `'Unknown'` |

**Key techniques used:**
- `REGEXP_REPLACE` to strip non-numeric characters from weight and price
- `COALESCE` + `NULLIF` for null and empty string handling
- `MEDIAN()` function for robust imputation of missing numeric values
- `CASE` statement to map warehouse codes to city names (A→Baku, B→Ganja, C→Sumgayit, D→Lankaran)

---

## 📊 Task 2 — Price Range by Product Type (`02_price_range_analysis.sql`)

**Business question:** Which product categories have the widest price spread?

This helps the pricing team identify categories with inconsistent pricing that may benefit from standardization or targeted promotions.

**Sample output:**

| product_type | min_price | max_price |
|---|---|---|
| Bakery | 1.20 | 48.90 |
| Dairy | 0.75 | 45.30 |
| Meat | 2.50 | 49.80 |
| Produce | 0.50 | 47.60 |
| Snacks | 1.10 | 46.20 |

---

## 🥩 Task 3 — High-Demand Meat & Dairy (`03_meat_dairy_analysis.sql`)

**Business question:** Which Meat and Dairy products consistently sell more than 10 units per month?

These products are high-priority for inventory planning — stockouts in these categories directly impact revenue and customer satisfaction. For Bravo's high-traffic stores, keeping these products in stock at all times is critical.

**Filter criteria:**
- `product_type` is `'Meat'` or `'Dairy'`
- `average_units_sold > 10`

---

## 🛠️ Tech Stack

- **Database:** Oracle SQL
- **Language:** SQL
- **Techniques:** `REGEXP_REPLACE`, `COALESCE`, `NULLIF`, `MEDIAN()`, CTEs, subqueries, aggregate functions, `CASE` statements

---

## 📁 About the Dataset

`data/products.csv` contains 100 rows with intentional data quality issues to reflect real-world scenarios:
- Mixed-format numeric fields (`"602.61 grams"`, `"$4.70"`)
- NULL and empty string values across multiple columns
- All 5 product types: Produce, Meat, Dairy, Bakery, Snacks
- 4 warehouse locations: Baku, Ganja, Sumgayit, Lankaran
- 7 brands

---

## 💡 Key Takeaways

- Real-world data is rarely clean — `REGEXP_REPLACE` and `COALESCE` are essential tools for handling inconsistent formats
- Median imputation is more robust than mean when data contains outliers
- Separating cleaning logic from analysis queries improves maintainability and auditability
- For supermarket chains in markets like Azerbaijan, warehouse and category analysis is critical for operational decision-making
