# E-commerce-Delivery-Logistics-Performance-Analysis
**Collaborative Data Analytics Project**  
**Date:** 16/10/2026


# E-Commerce Delivery & Logistics Performance Analysis

**Integrated Business Intelligence and Data Analytics Project**

An end-to-end analytics project on the DataCo Smart Supply Chain dataset. It covers data cleaning, data modelling, exploratory analysis, SQL investigation and an interactive Power BI dashboard, and it answers three connected business problems:

1. **Sales and order-line decline in 2017**: why did recorded sales fall even though distinct orders increased?
2. **Late deliveries**: where are delays concentrated, and how reliable is the delivery data?
3. **Customer and product performance**: how did retention, repeat purchasing and department activity change?

---

## Table of Contents

- [Project Snapshot](#project-snapshot)
- [Dataset](#dataset)
- [Team](#team)
- [Tools and Technologies](#tools-and-technologies)
- [Workflow](#workflow)
- [Data Cleaning (Power Query)](#data-cleaning-power-query)
- [Data Model (Star Schema)](#data-model-star-schema)
- [Key Findings](#key-findings)
- [Power BI Dashboard](#power-bi-dashboard)
- [Recommendations](#recommendations)
- [Limitations and Data Validation](#limitations-and-data-validation)
- [Repository Structure](#repository-structure)
- [Key Definitions](#key-definitions)
- [How to Use This Repository](#how-to-use-this-repository)

---

## Project Snapshot

| Area | Result |
|---|---|
| Records retained after cleaning | **180,519** order-item rows |
| Data model | 1 fact table + 3 dimension tables (star schema) |
| Distinct orders | ~65,752 |
| Delivery late rate | **57.42%** (16,633 of 28,965 eligible distinct orders) |
| Distinct orders 2016 to 2017 | **+4.83%** (20,859 to 21,866) |
| Recorded order lines 2016 to 2017 | **-14.96%** (62,550 to 53,196) |
| Recorded sales 2016 to 2017 | **-4.08%** |
| Dashboard | 4 pages: Executive Overview, Delivery & Logistics, Customer Insights, Product Performance |

---

## Dataset

- **Source:** DataCo Smart Supply Chain dataset (`ecommerce_logistics`)
- **Size:** 180,519 rows and 54 columns
- **Period:** January 2015 to January 2018
- **Grain:** order-item level. One row is an order item, **not** necessarily one unique order.
- **Areas covered:** sales, customers, products, shipping, delivery and geography

> Counting rows as orders overstates order volume. Order-level delivery KPIs in this project use distinct `Order Id` values and a defined eligibility filter.

---

## Team

| Member | Primary responsibility |
|---|---|
| Sairandhree Shirke | Data collection and cleaning |
| Aditya Dalvi | Data cleaning and basic EDA |
| Pyata Preetham | Data normalisation and modelling |
| Deevanshu Garg | Power BI reporting and dashboard development |

The team reviewed each other's work across data preparation, modelling, SQL and visualisation. Examples include correcting a regional sales visual (wrong lookup relationship), separating order lines from distinct orders, and making sure delivery KPIs use the same eligible-order population for numerator and denominator.

---

## Tools and Technologies

| Tool | Purpose |
|---|---|
| Power BI Desktop | Data modelling, measures, interactive dashboards |
| Power Query Editor | Cleaning, transformation, helper columns |
| DAX | Date dimension and calculations |
| DAX Studio | Querying and exporting model tables to CSV |
| SQLite + DB Browser for SQLite | SQL analysis of sales, orders, customers and products |
| Jupyter Notebook | Exploratory data analysis and chart documentation |
| CSV | Source and export format |

---

## Workflow

```
Raw CSV  ->  Power Query cleaning  ->  Star-schema model (Power BI)  ->  DAX Dim_Date
   ->  DAX Studio export (CSV)  ->  EDA (Jupyter)  ->  SQL investigation (SQLite)
   ->  Power BI dashboard  ->  Findings, recommendations, validation plan
```

---

## Data Cleaning (Power Query)

- Imported the CSV with **File Origin 1252 (Western European)** to preserve accented characters.
- Profiled columns using Column Quality, Column Distribution and Column Profile.
- Removed empty or masked columns: `Product Description`, `Product Status`, `Customer Email`, `Customer Password`.
- Set correct date, whole-number and decimal types (dates converted using the English - United States locale).
- Applied **Trim** and **Clean** to text fields.
- Standardised geography (for example, `EE. UU.` replaced with `United States`; `Order Region` values corrected).
- Kept ZIP codes as text with zero-padding to preserve leading zeros.
- Confirmed all **180,519 rows** were retained.

**Helper columns created**

| Field | Meaning |
|---|---|
| `order_year` | Year of the order date |
| `order_weekday` | Weekday name of the order date |
| `processing_days` | Days between shipping date and order date |
| `delay_days` | Actual shipping days minus scheduled shipping days |
| `is_late` | 1 when Delivery Status is "Late delivery" |
| `is_cancelled` | 1 when Order Status is "CANCELED" |
| `kpi_eligible` | 1 when Order Status is COMPLETE or CLOSED |

---

## Data Model (Star Schema)

| Table | Role |
|---|---|
| `Fact_Ecommerce_Logistics` | Central transactional table: order-item and logistics data |
| `Dim_Customer` | Customer city, country, name, ID, segment, state, street, zipcode |
| `Dim_Product` | Category, department, product card ID and name, price |
| `Dim_Date` | Date, day name, month, month name, quarter (created in DAX) |

All relationships are **one-to-many** from each dimension to the fact table.

**Date dimension (DAX)**

```dax
Dim_Date =
ADDCOLUMNS(
    CALENDAR(
        MIN(Fact_Ecommerce_Logistics[Order Date]),
        MAX(Fact_Ecommerce_Logistics[Order Date])
    ),
    "Day_name",   FORMAT([Date], "dddd"),
    "Month",      MONTH([Date]),
    "Month_name", FORMAT([Date], "MMMM"),
    "Quarter",    "Q" & FORMAT([Date], "Q")
)
```

**Exporting model tables (DAX Studio)**

```dax
EVALUATE Dim_Customer
EVALUATE Dim_Product
EVALUATE Dim_Date
EVALUATE Fact_Ecommerce_Logistics
```

> The separate customer and product dimensions are a normalisation-oriented design choice. A formal 1NF/2NF/3NF audit was not performed.

---

## Key Findings

### Problem 1: Sales and order-line decline (2017)

| Metric | 2016 | 2017 | Change |
|---|---|---|---|
| Distinct orders | 20,859 | 21,866 | +4.83% |
| Recorded order lines | 62,550 | 53,196 | -14.96% |
| Order lines per order | 3.00 | 2.43 | -18.87% |
| Recorded sales | - | - | -4.08% |

- Jan-Sep 2017 sales were about **4.7% higher** than 2016; the decline was concentrated in **Q4 2017**.
- Q4 orders rose about **19%**, but average sales per order fell from about **$596 to $351**.
- From **3 October 2017**, orders show about **one recorded line each**, versus about three before. This needs validation: either customer behaviour changed or order recording / the data pipeline changed.

**Hypotheses tested**

| Hypothesis | Assessment |
|---|---|
| H1: Product price changes | Not the main cause. 54 continuing products show 0% like-for-like change; 64 new products (avg 295.35) lifted the average. |
| H2: Discount strategy | Not supported. Average discount rate 10.17% to 10.16%. |
| H3: Competition and traffic | Plausible factor. Organic -16.18%, referrals -28.42%, paid +8.24%. Priced higher in Apparel, Footwear, Fitness. |
| H4: Category demand | Provisionally supported. All 6 core departments fell (Golf -27.0%, Footwear -24.9%, Fan Shop -22.6%). |
| H5: Customer behaviour | Partially supported (see Problem 3). |
| H6: Geographical demand shift | Partially supported. Localised concentration (Caguas, Puerto Rico, about 98.5% of Puerto Rico's net decline); no broad migration between countries. |

### Problem 2: Late deliveries

| Metric | Result |
|---|---|
| KPI-eligible rows / distinct orders | 79,107 / 28,965 |
| Late orders | 16,633 |
| **Late-delivery rate** | **57.42%** |
| Avg actual vs scheduled shipping | 3.49 vs 2.93 days |
| Late orders: actual vs scheduled | 4.07 vs 2.47 days |

| Shipping mode | Eligible | Late | Late rate |
|---|---|---|---|
| First Class | 4,497 | 4,497 | 100.00% |
| Second Class | 5,635 | 4,513 | 80.09% |
| Same Day | 1,548 | 751 | 48.51% |
| Standard Class | 17,285 | 6,872 | 39.76% |

- Standard Class has the **most** late orders (highest volume); First Class has the **highest rate**, which needs validation.
- Highest regional rates: South of USA 61.23%, Central Asia 60.23%, South Asia 60.16%.
- Category examples: Sporting Goods 62.58%; Cleats 5,165 late of 8,882 orders (58.15%).

### Problem 3: Customer and product performance

| Customer metric | 2016 | 2017 |
|---|---|---|
| Active customers | 10,222 | 15,156 |
| Orders per active customer | 2.04 | 1.44 |
| One-order customers | 39.4% | 70.7% |
| Retention | 82.2% (2015 to 2016) | 72.1% (2016 to 2017) |

- **6,199** customers classed as "new" in 2017 first appeared in Oct-Dec (about 95.3% of new customers). This may reflect a campaign, customer-ID changes or migration, and needs validation.
- Fan Shop, Golf, Apparel and Footwear all recorded fewer order lines, with very sharp Q4 drops (for example Fan Shop monthly lines 2,027 to 112).

> All findings are descriptive patterns, not proven causes.

---

## Power BI Dashboard

Four pages with slicers for **Year, Month, Customer Segment and Shipping Mode**.

| Page | Purpose |
|---|---|
| Executive Overview | High-level sales, order, profit, customer and delivery indicators |
| Delivery & Logistics | Late orders, shipping days, regional patterns, delivery status distribution |
| Customer Insights | Sales by segment and region, top customers, orders by segment |
| Product Performance | Top products, profit and sales by category, sales vs profit |

**Headline KPIs:** Total sales **36.78M** | Total profit **3.97M** | Average order value **559.45** | Customers **21K** | Orders **66K**

---

## Recommendations

1. **Validate the October 2017 change first.** Ask the data owner about any system, checkout, catalogue or pipeline change around 2-3 October 2017, and reconcile sample orders before and after.
2. **Recalculate basket measures at order level**: report distinct orders, order lines, units, lines per order and average order value separately.
3. **Improve delivery performance.** Review First and Second Class service levels and promised timelines, prioritise both high-rate and high-volume issues, and flag at-risk orders early.
4. **Encourage larger baskets** with product bundles and free-shipping or multi-item thresholds set from margins and shipping costs.
5. **Strengthen repeat purchasing** with loyalty benefits and second-purchase offers, tested against control groups.
6. **Review weaker departments** (Fan Shop, Golf, Apparel, Footwear) for stock, assortment, pricing and data coverage.
7. **Investigate Caguas, Puerto Rico** at customer level, then California, Texas and Illinois.
8. **Monitor KPIs regularly** (sales, basket behaviour, retention, delivery, data quality) using the dashboard.

---

## Limitations and Data Validation

- Order-item rows are not unique orders; lines per order is **not** physical units (use `SUM(Order Item Quantity)` for units).
- The post-3 October "one line per order" pattern needs validation against quantity and source records.
- The 6,199 Q4 new customers and the extreme Q4 department drops may reflect data migration, stock issues or reporting changes.
- The First Class 100% late rate must be checked against source delivery labels and service-level configuration.
- Delivery status and schedule adherence are related, so they are not independent evidence. Processing days and actual shipping days were identical in the order-level check.
- Traffic sessions and competitor price gaps indicate possible pressure but do not prove causation.
- The Q4 revenue scenario is illustrative, not a forecast.
- Geographic analysis (H6) assumes one geography per `customer_id`, some state values look like ZIP codes, and the country-level timing result is still pending.
- Dashboard KPI cards are rounded. Confirm currency, tax treatment, filters and the KPI eligibility rule (COMPLETE or CLOSED) before external use.

---

## Repository Structure

> Adjust folder names to match your actual repository.

```
E-commerce-Delivery-Logistics-Performance-Analysis/
|-- README.md
|-- EDA_Findings.md              # EDA summary
|-- delivery_eda.ipynb           # EDA notebook
|-- SQL/                         # SQL query files
|-- SS/
|   `-- SQL/                     # SQL query screenshots
|-- Data/                        # Ecom Logistics Cleaned Dataset and exported model tables (CSV)
|-- PowerBI/                     # Power BI report (4 pages) and model
`-- Report/                      # Final project report (PDF)
```

---

## Key Definitions

| Term | Meaning |
|---|---|
| Order line / order-item row | A recorded row in the dataset; not a unique order or a physical unit |
| Distinct order | A unique `Order Id` |
| Order lines per order | Order-line rows / distinct orders |
| KPI-eligible order | Order Status COMPLETE or CLOSED |
| Late-delivery rate | Late distinct eligible orders / all distinct eligible orders |
| New customer | First observed purchasing in the year |
| Retention rate | Share of the previous year's customers who purchase again |
| Average order value | Recorded sales / distinct orders (subject to filters) |

---

## How to Use This Repository

1. Clone the repository: `git clone https://github.com/pyatapreetham/E-commerce-Delivery-Logistics-Performance-Analysis.git`
2. Open the Power BI report in **Power BI Desktop** to explore the dashboard and data model.
3. Run `delivery_eda.ipynb` in Jupyter to reproduce the delivery EDA.
4. Open the files in `SQL/` with **DB Browser for SQLite** against the cleaned dataset to reproduce the sales investigation.
5. Read the final project report for the full methodology, findings and validation plan.

---

**Project date:** 16 October 2026 | **Repository:** [github.com/pyatapreetham/E-commerce-Delivery-Logistics-Performance-Analysis](https://github.com/pyatapreetham/E-commerce-Delivery-Logistics-Performance-Analysis)

## Tools and Technologies

**Power BI Desktop | Power Query Editor | DAX | DAX Studio | CSV|SQLite| DB Browser for SQLite| SQL.**
