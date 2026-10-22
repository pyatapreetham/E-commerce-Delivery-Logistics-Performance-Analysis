
# E-Commerce & Logistics Performance Analysis
## Exploratory Data Analysis Findings

### 1. Dataset Overview
- Total Records: 180,519
- Total Columns: 54
- KPI-Eligible Unique Orders: 28,965

### 2. Delivery Performance
- Late Orders: 16,633
- Late Delivery Rate: 57.42%
- Average Delay Among Late Orders: 1.61 days

### 3. Shipping Mode Analysis
- First Class Late Rate: 100%
- Second Class Late Rate: 80.09%
- Same Day Late Rate: 48.51%
- Standard Class Late Rate: 39.76%

### 4. Customer Analysis
- Total Unique Customers: 20,652
- Repeat Customers: 11,768
- Repeat Customer Rate: 56.98%

### 5. Product Category Analysis
- Highest Sales Category: Fishing

### 6. Regional Delivery Analysis
- Highest Late Rate Among Top Sales Regions:
  South Asia (60.16%)

### 7. Data Redundancy Findings
- processing_days matches actual shipping days
  in all 28,965 compared eligible unique orders.
- Avoid treating both fields as independent features.

### 8. Business Recommendations
1. Investigate First Class and Second Class delivery targets.
2. Improve on-time delivery performance.
3. Investigate regions with higher late delivery rates.
4. Review categories with negative benefit records.
5. Analyze repeat purchasing and customer retention.

### 9. Analysis Notes
- Delivery KPIs use unique KPI-eligible orders.
- Sales analysis uses order-item records.
- Correlation does not establish causation.
- Shipping-mode results should be checked against
  scheduled delivery definitions.
