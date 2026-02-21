# 🛒 Bravo Supermarket — Məhsul Datası Analizi

SQL əsaslı data təmizləmə və analiz layihəsi — **Bravo**, Azərbaycanda fəaliyyət göstərən və sürətlə genişlənən supermarket şəbəkəsi üçün.

---

## 📌 Biznes Konteksti

Bravo supermarket şəbəkəsi son illərdə Bakı və regionlarda yeni mağazalar açaraq əməliyyatlarını genişləndirib. Şirkətin məhsul bazası 4 müxtəlif anbar məntəqəsindən (A, B, C, D) idarə olunur və minlərlə məhsulu əhatə edir.

Lakin şirkətin böyüməsi ilə birlikdə məhsul verilənlər bazasında ciddi keyfiyyət problemləri yaranmağa başladı. Müxtəlif anbarlardan daxil olan məlumatlar fərqli formatlarda idi, bəzi sahələrdə dəyərlər çatışmırdı, bəzilərində isə rəqəm yerinə mətn yazılmışdı. Bu vəziyyət analitika komandası üçün etibarlı hesabatlar hazırlamağı çətinləşdirirdi.

---

## 🚨 Biznes Problemlər

### 1. 📦 Anbar İdarəetməsi Problemləri
Bəzi məhsulların `stock_location` sahəsi boş və ya NULL idi. Bu o deməkdir ki, anbar işçiləri hansı məhsulun harada saxlandığını bilmirdi — bu isə vaxt itkisinə, çatdırılma gecikmələrinə və müştəri narazılığına yol açırdı.

### 2. 💰 Qiymət Şəffaflığı Problemləri
`price` sütununda dəyərlər bəzən `"$12.99"` kimi mətn formatında saxlanılırdı, bəzən isə tam boş idi. Bu format uyğunsuzluğu avtomatik qiymət hesabatlarının düzgün işləməməsinə səbəb olurdu. Qiymət analizi aparıla bilmirdi, endirim kampaniyaları üçün dəqiq baza müəyyən edilə bilmirdi.

### 3. ⚖️ Çəki Məlumatlarının Uyğunsuzluğu
`weight` sütununda dəyərlər `"874.50 grams"` kimi yazılmışdı — yəni ədəd ilə vahid bir yerdə saxlanılırdı. Bu, çəkiyə görə çeşidləməni, filtrasiyani və hesablamaları tamamilə bloke edirdi. Çəkiyə əsaslanan qiymətləndirmə modeli işə düşmürdü.

### 4. 🏷️ Məhsul Kategoriyası Çatışmazlıqları
`product_type` sahəsinin boş olduğu məhsullar heç bir kateqoriyaya aid deyildi. Bu məhsullar kateqoriya üzrə satış hesabatlarından düşürdü, nəticədə menecerlər yanlış qərarlara gəlirdi — bəzi kateqoriyalar olduğundan az, bəziləri isə olduğundan çox sərfəli görünürdü.

### 5. 📅 Məhsul Tarixi Boşluqları
`year_added` sahəsinin boş olması məhsulun nə vaxt stoka əlavə edildiyini müəyyən etməyi çətinləşdirirdi. Bu, köhnə məhsulları yeniləri ilə müqayisə etməyi, tendensiyaları izləməyi və stok rotasiyasını planlaşdırmağı mümkünsüz edirdi.

### 6. 📉 Satış Həcmi Qeyri-dəqiqlikləri
`average_units_sold` sütunundakı NULL dəyərlər satış analitikasını pozurdu. Satışı NULL olan məhsul, satışı 0 olan məhsuldan fərqlidir — lakin sistem bu iki vəziyyəti bir-birindən ayıra bilmirdi. Bu, ən çox satan məhsulların müəyyən edilməsini çətinləşdirirdi.

### 7. 🧾 Brend Məlumatlarının Natamamlığı
`brand` sahəsindəki boşluqlar brend üzrə performans analizini mümkünsüz edirdi. Hansı brendin daha çox satıldığını, hansının stokda çox qaldığını müəyyən etmək üçün brend məlumatı tam olmalıdır.

---

## 🎯 Layihənin Məqsədləri

1. Orijinal cədvəli dəyişdirmədən raw datanı standartlaşdırmaq
2. Məhsul kateqoriyaları üzrə qiymət diapazonunu analiz etmək
3. Yüksək tələbatlı Ət və Süd məhsullarını müəyyən etmək
4. Anbar planlaşdırması və satış strategiyası üçün dəyərli fikirlər əldə etmək

---

## 🗂️ Layihə Strukturu

```
bravo-sql-analysis/
├── README.md
├── data/
│   └── products.csv                   # Nümunə dataset (100 sətir)
└── queries/
    ├── 01_data_cleaning.sql           # Data təmizləmə
    ├── 02_price_range_analysis.sql    # Qiymət diapazonu analizi
    └── 03_meat_dairy_analysis.sql     # Yüksək tələbatlı məhsullar
```

---

## 🧹 Task 1 — Data Təmizləmə (`01_data_cleaning.sql`)

**Problem:** Raw data 8 sütun üzrə çoxsaylı keyfiyyət problemləri ehtiva edirdi.

| Sütun | Problem | Tətbiq edilən düzəliş |
|---|---|---|
| `product_type` | NULL və ya boş sətir | → `'Unknown'` |
| `brand` | NULL və ya boş sətir | → `'Unknown'` |
| `weight` | `"874.50 grams"` formatı, NULL | Qeyri-rəqəm simvolları silinir, NULL → median |
| `price` | `"$12.99"` formatı, NULL | Qeyri-rəqəm simvolları silinir, NULL → median |
| `average_units_sold` | NULL dəyərlər | → `0` |
| `year_added` | NULL dəyərlər | → `2022` |
| `stock_location` | NULL və ya boş sətir | → `'Unknown'` |

**İstifadə edilən texnikalar:**
- `REGEXP_REPLACE` — weight və price-dakı mətn simvollarını silmək üçün
- `COALESCE` + `NULLIF` — NULL və boş sətirləri idarə etmək üçün
- `OFFSET` subquery ilə manual median hesablaması (köhnə Oracle SQL versiyaları ilə uyğun)

---

## 📊 Task 2 — Kateqoriya üzrə Qiymət Diapazonu (`02_price_range_analysis.sql`)

**Biznes sualı:** Hansı məhsul kateqoriyalarında qiymət fərqi ən böyükdür?

Bu analiz qiymətləndirmə komandasına standartlaşdırma tələb edən kateqoriyaları və hədəflənmiş promosyon kampaniyaları üçün uyğun sahələri müəyyən etməyə kömək edir.

**Nümunə nəticə:**

| product_type | min_price | max_price |
|---|---|---|
| Bakery | 1.20 | 48.90 |
| Dairy | 0.75 | 45.30 |
| Meat | 2.50 | 49.80 |
| Produce | 0.50 | 47.60 |
| Snacks | 1.10 | 46.20 |

---

## 🥩 Task 3 — Yüksək Tələbatlı Ət & Süd Məhsulları (`03_meat_dairy_analysis.sql`)

**Biznes sualı:** Aylıq ortalama 10-dan çox satılan Ət və Süd məhsulları hansılardır?

Bu məhsullar anbar planlaşdırması üçün prioritetdir — bu kateqoriyalarda stok kəsintisi birbaşa gəlir itkisinə və müştəri itkisinə yol açır. Bravo-nun yüksək trafikli mağazaları üçün bu məhsulların daima stokda olması kritik əhəmiyyət daşıyır.

**Filter şərtləri:**
- `product_type` → `'Meat'` və ya `'Dairy'`
- `average_units_sold > 10`

---

## 🛠️ İstifadə Edilən Texnologiyalar

- **Verilənlər bazası:** Oracle SQL
- **Dil:** SQL
- **Texnikalar:** `REGEXP_REPLACE`, `COALESCE`, `NULLIF`, CTE, subquery, aqreqat funksiyalar

---

## 📁 Dataset Haqqında

`data/products.csv` — 100 sətirlik nümunə dataset, real dünya ssenarilərini əks etdirən qəsdən yaradılmış keyfiyyət problemləri ilə:
- Qarışıq format rəqəm sahələri (`"602.61 grams"`, `"$4.70"`)
- Çoxsaylı sütunlarda NULL və boş sətir dəyərləri
- 5 məhsul kateqoriyası: Produce, Meat, Dairy, Bakery, Snacks
- 4 anbar məntəqəsi: Bakı, Gəncə, Sumqayıt, Lənkəran
- 7 brend

---

## 💡 Əsas Nəticələr

- Real dünya datası nadir hallarda təmizdir — `REGEXP_REPLACE` və `COALESCE` uyğunsuz formatları idarə etmək üçün vacib alətlərdir
- Orta (median) imputation — ortalama (mean) ilə müqayisədə çərçivə dəyərləri olan datasetlərdə daha etibarlıdır
- Təmizləmə məntiqi ilə analiz sorğularını ayrı fayllarda saxlamaq kodun oxunmasını və auditini asanlaşdırır
- Azərbaycan bazarında supermarket şəbəkələri üçün anbar və kateqoriya analizi operativ qərar qəbuletmə üçün kritik əhəmiyyət daşıyır
