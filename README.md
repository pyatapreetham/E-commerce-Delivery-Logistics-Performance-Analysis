# E-commerce-Delivery-Logistics-Performance-Analysis
**Collaborative Data Analytics Project**  
**Date:** 16/10/2026

## Data Cleaning Using Power Query

Cleaned and transformed the DataCo Smart Supply Chain dataset in Power Query Editor and prepared the cleaned data as the **Ecom Logistics Cleaned Dataset** for analysis and Power BI reporting.

**Key steps performed:**
- Reviewed data quality and identified missing, unnecessary, and irrelevant columns.
- Removed empty, constant, and masked columns where appropriate.
- Corrected data types for date fields, numeric values, and identifiers.
- Cleaned text fields by trimming extra spaces and standardizing country names.
- Prepared ZIP codes to preserve leading zeros.
- Created calculated columns for order year, processing days, delivery delays, late deliveries, cancellations, and KPI eligibility.
- Retained order-item-level records for further analysis.

## Data Modeling Using Power BI

Structured the cleaned dataset into a star-schema model consisting of one fact table and three dimension tables.

**Key steps performed:**
- Created `Fact_Ecommerce_Logistics` to store transactional order-item data, sales-related values, shipping information, and delivery indicators.
- Created `Dim_Customer` to organize customer details, segments, and geographical attributes.
- Created `Dim_Product` to organize product details, categories, and departments.
- Created `Dim_Date` using DAX to support time-based analysis.
- Planned relationships between the fact table and dimension tables using customer, product, and date keys.
- Designed the model to support analysis across customers, products, dates, and logistics performance.

## Exporting Data Model Tables Using DAX Studio

Used DAX Studio to query the Power BI data model and prepare individual tables for export without creating separate table visuals.

**Key steps performed:**
- Connected DAX Studio to the Power BI Desktop data model.
- Used DAX `EVALUATE` queries to retrieve model tables.
- Prepared customer, product, date, and fact tables for export.
- Used comma-separated text output for CSV-based data storage and reuse.
 ## Sales Performance Decline – Root Cause Analysis
Business Problem
In 2017, order volume increased by 4.83%, but recorded sales decreased by approximately 4% compared with 2016. The objective was to identify when the decline occurred and what changed in order and customer behaviour.
What the SQL Analysis Found
- The decline was concentrated in Q4 2017. January–September 2017 sales were approximately 4.7% higher than the same period in 2016.
- Q4 order volume increased by about 19%, but average order value fell from approximately $596 to $351.
- The daily order analysis identified a sharp change from 3 October 2017: orders were recorded with one order line, compared with roughly three lines per order before the change.
- The annual comparison also shows average order lines per order decreasing from 3.00 in 2016 to 2.43 in 2017, while total orders increased from 20,859 to 21,866.
- Q4 2017 recorded sales were approximately $2.2M. At the Q4 2016 average order value, the illustrative comparison is approximately $3.7M. This is an estimate of the revenue opportunity, not guaranteed or confirmed lost revenue.
Root Cause Assessment
The strongest pattern in the data is smaller recorded baskets / fewer order lines per order, particularly after 3 October 2017. More orders were placed, but each order generated less recorded sales on average. This is the leading data-supported explanation for the Q4 sales decline.

The dataset does not establish why the change happened. It could reflect a real change in customer purchasing behaviour or a change in the ordering or data-recording process. The claim that the post-change customers were all new or did not return requires a correctly defined first-time-customer and repeat-purchase analysis before it can be treated as confirmed.
Recommended Actions
1. Validate the change first: Ask the data owner whether the ordering system, order-line capture, product catalogue or business process changed around 2–3 October 2017.
2. Increase basket size: Test frequently-bought-together suggestions, product bundles and multi-item offers.
3. Set a basket-value incentive: Test a free-shipping threshold or discount for orders containing two or more products.
4. Encourage a second purchase: Test a follow-up offer for verified first-time customers and measure the repeat-purchase rate.
5. Investigate affected categories and regions: Review the reported declines in Fan Shop, Golf and Footwear, and the reduced or missing recorded sales for Africa, LATAM and USCA. Confirm product availability, market coverage and data completeness before concluding that those markets stopped selling.
How the Finding Was Reached
SQLite queries were used to compare annual orders and sales, examine monthly and quarterly trends, inspect daily order patterns around 3 October 2017, compare order composition and customer activity, and review department and product performance. Supporting query screenshots are stored in SS/SQL/; the executable queries are stored in SQL/.
The first business action should be to validate the October 2017 system or process change. After that, run controlled tests to increase basket size and repeat purchases, measuring the impact on average order value, units per order, order lines per order and sales.

## Tools and Technologies

**Power BI Desktop | Power Query Editor | DAX | DAX Studio | CSV|SQLite| DB Browser for SQLite| SQL.**
