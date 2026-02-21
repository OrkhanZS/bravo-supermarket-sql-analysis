🛒 Bravo Supermarket — Product Data Analysis
A SQL-based data cleaning and analysis project for Bravo, a fast-growing supermarket chain operating across Azerbaijan.

📌 Business Context
Bravo has expanded rapidly in recent years, opening new stores in Baku and across the regions. The company's product inventory is managed through 4 warehouse locations (Baku, Ganja, Sumgayit, Lankaran) and covers thousands of products.
However, rapid growth came with a cost — the product database accumulated significant data quality issues. Records arriving from different warehouses used inconsistent formats, some fields had missing values, and numeric columns contained embedded text (e.g., "602.61 grams", "$4.70"). This made it increasingly difficult for the analytics team to produce reliable reports.

🚨 Business Problems
1. 📦 Warehouse Management Issues
Several products had a blank or NULL stock_location field. This meant warehouse staff had no way of knowing where a product was stored — leading to wasted time, delayed deliveries, and customer dissatisfaction.
2. 💰 Price Transparency Issues
The price column stored values in inconsistent formats such as "$12.99" as text, and some records were entirely missing. This broke automated pricing reports and made it impossible to set accurate baselines for discount campaigns.
3. ⚖️ Weight Data Inconsistencies
The weight column contained values like "874.50 grams" — the number and unit were stored together as a string. This completely blocked sorting, filtering, and any calculations based on weight, including weight-based pricing models.
4. 🏷️ Missing Product Category Data
Products with a blank product_type were not assigned to any category. These products dropped out of category-level sales reports, causing managers to draw incorrect conclusions — some categories appeared more or less profitable than they actually were.
5. 📅 Product History Gaps
Missing values in the year_added field made it impossible to determine when a product was first introduced to stock. This prevented meaningful comparison of old vs. new products, trend tracking, and stock rotation planning.
6. 📉 Sales Volume Inaccuracies
NULL values in average_units_sold corrupted sales analytics. A product with NULL sales is fundamentally different from one with 0 sales — the system could not distinguish between the two, making it harder to identify top-selling products.
7. 🧾 Incomplete Brand Data
Gaps in the brand field made brand-level performance analysis impossible. Knowing which brands sell best and which tend to sit on shelves is essential for procurement and supplier negotiations.

🎯 Project Objectives

Standardize raw product data without modifying the original table
Analyze price ranges across product categories
Identify high-demand Meat and Dairy products
Generate actionable insights for inventory planning and sales strategy


🗂️ Project Structure
bravo-sql-analysis/
├── README.md                          # Azerbaijani version
├── README_EN.md                       # English version
├── data/
│   └── products.csv                   # Sample dataset (100 rows)
└── queries/
    ├── 01_data_cleaning.sql           # Task 1 – Standardize raw data
    ├── 02_price_range_analysis.sql    # Task 2 – Min/max price by category
    └── 03_meat_dairy_analysis.sql     # Task 3 – High-demand products

🧹 Task 1 — Data Cleaning (01_data_cleaning.sql)
Problem: The raw data contained multiple quality issues across 8 columns.
ColumnIssueFix Appliedproduct_typeNULL or empty string→ 'Unknown'brandNULL or empty string→ 'Unknown'weightText like "874.50 grams", NULLs, empty stringsStrip non-numeric chars, NULL/empty → medianpriceText like "$12.99", NULLs, empty stringsStrip non-numeric chars, NULL/empty → medianaverage_units_soldNULL values→ 0year_addedNULL values→ 2022stock_locationNULL or empty string→ 'Unknown'
Key techniques used:

REGEXP_REPLACE to strip non-numeric characters from weight and price
NULLIF(TRIM(col), '') to safely handle both NULL and empty string values
COALESCE for null fallback logic
MEDIAN() with per-column CASE filtering for robust imputation of missing numeric values (each column's median is calculated independently, so a NULL in one column does not affect the other's median)
stock_location is already stored as city names in the dataset (Bakı, Gəncə, Sumqayıt, Lənkəran) — no code mapping needed


📊 Task 2 — Price Range by Product Type (02_price_range_analysis.sql)
Business question: Which product categories have the widest price spread?
This helps the pricing team identify categories with inconsistent pricing that may benefit from standardization or targeted promotions. Products with no category (Unknown) are excluded to avoid misleading the analysis.
Sample output (based on actual dataset):
product_typemin_pricemax_priceBakery11.9550.00Dairy5.8548.29Meat0.7949.40Produce1.5145.29Snacks0.7738.18

🥩 Task 3 — High-Demand Meat & Dairy (03_meat_dairy_analysis.sql)
Business question: Which Meat and Dairy products consistently sell more than 10 units per month?
These products are high-priority for inventory planning — stockouts in these categories directly impact revenue and customer satisfaction. For Bravo's high-traffic stores, keeping these products in stock at all times is critical.
Filter criteria:

product_type is 'Meat' or 'Dairy'
average_units_sold > 10 (NULL values are intentionally excluded — a product with unknown sales history is not the same as one with confirmed high sales)

Output columns: product_id, product_type, brand, price, average_units_sold, stock_location — all columns needed for actionable inventory decisions.

🛠️ Tech Stack

Database: Oracle SQL
Language: SQL
Techniques: REGEXP_REPLACE, COALESCE, NULLIF, TRIM, MEDIAN(), CTEs, subqueries, aggregate functions


📁 About the Dataset
data/products.csv contains 100 rows with intentional data quality issues to reflect real-world scenarios:

Mixed-format numeric fields ("602.61 grams", "$4.70")
NULL and empty string values across multiple columns
All 5 product types: Produce, Meat, Dairy, Bakery, Snacks
4 warehouse locations: Bakı, Gəncə, Sumqayıt, Lənkəran (stored as city names)
7 brands


💡 Key Takeaways

Real-world data is rarely clean — REGEXP_REPLACE, NULLIF, and COALESCE are essential tools for handling inconsistent formats including both NULLs and empty strings
Median imputation is more robust than mean when data contains outliers; each column's median must be calculated independently to avoid cross-column bias
Separating cleaning logic from analysis queries improves maintainability and auditability
For supermarket chains in markets like Azerbaijan, warehouse and category analysis is critical for operational decision-making


🛒 Bravo Supermarket — Məhsul Datası Analizi
SQL əsaslı data təmizləmə və analiz layihəsi — Bravo, Azərbaycanda fəaliyyət göstərən və sürətlə genişlənən supermarket şəbəkəsi üçün.

📌 Biznes Konteksti
Bravo supermarket şəbəkəsi son illərdə Bakı və regionlarda yeni mağazalar açaraq əməliyyatlarını genişləndirib. Şirkətin məhsul bazası 4 müxtəlif anbar məntəqəsindən (Bakı, Gəncə, Sumqayıt, Lənkəran) idarə olunur və minlərlə məhsulu əhatə edir.
Lakin şirkətin böyüməsi ilə birlikdə məhsul verilənlər bazasında ciddi keyfiyyət problemləri yaranmağa başladı. Müxtəlif anbarlardan daxil olan məlumatlar fərqli formatlarda idi, bəzi sahələrdə dəyərlər çatışmırdı, bəzilərində isə rəqəm yerinə mətn yazılmışdı. Bu vəziyyət analitika komandası üçün etibarlı hesabatlar hazırlamağı çətinləşdirirdi.

🚨 Biznes Problemlər
1. 📦 Anbar İdarəetməsi Problemləri
Bəzi məhsulların stock_location sahəsi boş və ya NULL idi. Bu o deməkdir ki, anbar işçiləri hansı məhsulun harada saxlandığını bilmirdi — bu isə vaxt itkisinə, çatdırılma gecikmələrinə və müştəri narazılığına yol açırdı.
2. 💰 Qiymət Şəffaflığı Problemləri
price sütununda dəyərlər bəzən "$12.99" kimi mətn formatında saxlanılırdı, bəzən isə tam boş idi. Bu format uyğunsuzluğu avtomatik qiymət hesabatlarının düzgün işləməməsinə səbəb olurdu.
3. ⚖️ Çəki Məlumatlarının Uyğunsuzluğu
weight sütununda dəyərlər "874.50 grams" kimi yazılmışdı — yəni ədəd ilə vahid bir yerdə saxlanılırdı. Bu, çəkiyə görə çeşidləməni, filtrasiyani və hesablamaları tamamilə bloke edirdi.
4. 🏷️ Məhsul Kategoriyası Çatışmazlıqları
product_type sahəsinin boş olduğu məhsullar heç bir kateqoriyaya aid deyildi. Bu məhsullar kateqoriya üzrə satış hesabatlarından düşürdü, nəticədə menecerlər yanlış qərarlara gəlirdi.
5. 📅 Məhsul Tarixi Boşluqları
year_added sahəsinin boş olması məhsulun nə vaxt stoka əlavə edildiyini müəyyən etməyi çətinləşdirirdi.
6. 📉 Satış Həcmi Qeyri-dəqiqlikləri
average_units_sold sütunundakı NULL dəyərlər satış analitikasını pozurdu. Satışı NULL olan məhsul, satışı 0 olan məhsuldan fərqlidir — lakin sistem bu iki vəziyyəti bir-birindən ayıra bilmirdi.
7. 🧾 Brend Məlumatlarının Natamamlığı
brand sahəsindəki boşluqlar brend üzrə performans analizini mümkünsüz edirdi.

🎯 Layihənin Məqsədləri

Orijinal cədvəli dəyişdirmədən raw datanı standartlaşdırmaq
Məhsul kateqoriyaları üzrə qiymət diapazonunu analiz etmək
Yüksək tələbatlı Ət və Süd məhsullarını müəyyən etmək
Anbar planlaşdırması və satış strategiyası üçün dəyərli fikirlər əldə etmək


🗂️ Layihə Strukturu
bravo-sql-analysis/
├── README.md
├── README_EN.md
├── data/
│   └── products.csv                   # Nümunə dataset (100 sətir)
└── queries/
    ├── 01_data_cleaning.sql           # Data təmizləmə
    ├── 02_price_range_analysis.sql    # Qiymət diapazonu analizi
    └── 03_meat_dairy_analysis.sql     # Yüksək tələbatlı məhsullar

🧹 Task 1 — Data Təmizləmə (01_data_cleaning.sql)
Problem: Raw data 8 sütun üzrə çoxsaylı keyfiyyət problemləri ehtiva edirdi.
SütunProblemTətbiq edilən düzəlişproduct_typeNULL və ya boş sətir→ 'Unknown'brandNULL və ya boş sətir→ 'Unknown'weight"874.50 grams" formatı, NULL, boş sətirQeyri-rəqəm simvolları silinir, NULL/boş → medianprice"$12.99" formatı, NULL, boş sətirQeyri-rəqəm simvolları silinir, NULL/boş → medianaverage_units_soldNULL dəyərlər→ 0year_addedNULL dəyərlər→ 2022stock_locationNULL və ya boş sətir→ 'Unknown'
İstifadə edilən texnikalar:

REGEXP_REPLACE — weight və price-dakı mətn simvollarını silmək üçün
NULLIF(TRIM(col), '') — həm NULL, həm də boş sətir hallarını etibarlı şəkildə idarə etmək üçün
COALESCE — NULL fallback məntiqini tətbiq etmək üçün
MEDIAN() ilə hər sütun üçün ayrıca filtr — çərçivə dəyərləri olan datasetlərdə etibarlı imputation üçün (hər sütunun medianı müstəqil hesablanır ki, bir sütundakı NULL digərinin medianını əyməsin)
stock_location datasetdə artıq şəhər adı ilə saxlanılır (Bakı, Gəncə, Sumqayıt, Lənkəran) — kod→şəhər çevrilməsinə ehtiyac yoxdur


📊 Task 2 — Kateqoriya üzrə Qiymət Diapazonu (02_price_range_analysis.sql)
Biznes sualı: Hansı məhsul kateqoriyalarında qiymət fərqi ən böyükdür?
Bu analiz qiymətləndirmə komandasına standartlaşdırma tələb edən kateqoriyaları müəyyən etməyə kömək edir. Kateqoriyası bilinməyən (Unknown) məhsullar analizə daxil edilmir — əks halda nəticə yanıltıcı ola bilər.
Nümunə nəticə (real datasete əsasən):
product_typemin_pricemax_priceBakery11.9550.00Dairy5.8548.29Meat0.7949.40Produce1.5145.29Snacks0.7738.18

🥩 Task 3 — Yüksək Tələbatlı Ət & Süd Məhsulları (03_meat_dairy_analysis.sql)
Biznes sualı: Aylıq ortalama 10-dan çox satılan Ət və Süd məhsulları hansılardır?
Bu məhsullar anbar planlaşdırması üçün prioritetdir — bu kateqoriyalarda stok kəsintisi birbaşa gəlir itkisinə yol açır.
Filter şərtləri:

product_type → 'Meat' və ya 'Dairy'
average_units_sold > 10 — NULL dəyərlər şüurlu şəkildə kənar qoyulur, çünki satış tarixi bilinməyən məhsul, yüksək satışı təsdiqlənmiş məhsuldan fərqlidir

Çıxış sütunları: product_id, product_type, brand, price, average_units_sold, stock_location — anbar qərarları üçün lazım olan bütün məlumatlar daxildir.

🛠️ İstifadə Edilən Texnologiyalar

Verilənlər bazası: Oracle SQL
Dil: SQL
Texnikalar: REGEXP_REPLACE, COALESCE, NULLIF, TRIM, MEDIAN(), CTE, subquery, aqreqat funksiyalar


📁 Dataset Haqqında
data/products.csv — 100 sətirlik nümunə dataset, real dünya ssenarilərini əks etdirən keyfiyyət problemləri ilə:

Qarışıq format rəqəm sahələri ("602.61 grams", "$4.70")
Çoxsaylı sütunlarda NULL və boş sətir dəyərləri
5 məhsul kateqoriyası: Produce, Meat, Dairy, Bakery, Snacks
4 anbar məntəqəsi: Bakı, Gəncə, Sumqayıt, Lənkəran (şəhər adı formatında saxlanılır)
7 brend


💡 Əsas Nəticələr

Real dünya datası nadir hallarda təmizdir — REGEXP_REPLACE, NULLIF və COALESCE həm NULL, həm də boş sətir hallarını idarə etmək üçün vacibdir
Median imputation ortalamaya nisbətən daha etibarlıdır; hər sütunun medianı müstəqil hesablanmalıdır ki, sütunlar arasında bias yaranmasın
Təmizləmə məntiqi ilə analiz sorğularını ayrı fayllarda saxlamaq kodun oxunmasını və auditini asanlaşdırır
Azərbaycan bazarında supermarket şəbəkələri üçün anbar və kateqoriya analizi operativ qərar qəbuletmə üçün kritik əhəmiyyət daşıyır



