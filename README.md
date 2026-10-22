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

## Tools and Technologies

**Power BI Desktop | Power Query Editor | DAX | DAX Studio | CSV**
