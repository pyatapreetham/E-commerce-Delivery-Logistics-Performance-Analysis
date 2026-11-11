
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



## 10. Year-wise Order Analysis (2015-2017)

| Year | Total Orders | Late Delivery Rate |
|------|-------------:|-------------------:|
| 2015 | 20,904 | 56.54% |
| 2016 | 20,859 | 58.33% |
| 2017 | 21,866 | 57.23% |

### Key Findings
- Order volume remained stable in 2015 and 2016.
- Orders increased by 4.83% in 2017.
- Late delivery rates remained above 56% in all three years.
- Increased annual order volume did not correspond
  to an increase in the annual late delivery rate.
- 2018 has only January data and is excluded
  from full-year comparisons.

## 11. Year-wise Shipping Mode Analysis

| Shipping Mode | 2015 | 2016 | 2017 |
|---------------|------|------|------|
| First Class | 100% | 100% | 100% |
| Same Day | 45.10% | 44.51% | 55.45% |
| Second Class | 79.92% | 81.06% | 79.29% |
| Standard Class | 39.40% | 41.01% | 38.71% |

### Key Findings
- First Class was consistently marked 100% late.
- Second Class showed persistent high late rates.
- Same Day late rate increased by 10.94
  percentage points from 2016 to 2017.
- Standard Class had the lowest late rate
  among the analyzed shipping modes.

### Proposed Business Problem
How can e-commerce logistics improve on-time
delivery performance and reduce delivery delays
across shipping modes?

### Recommendations
1. Verify scheduled delivery rules for First Class.
2. Investigate Same Day performance deterioration.
3. Review Second Class delivery targets.
4. Identify operational reasons for late deliveries.
5. Monitor shipping-mode KPIs every month.

### Methodology Note
Delivery rates use KPI-eligible unique orders.
Associations do not establish causation.

## 12. Year-wise Financial Performance Analysis

The analysis uses recorded order-item sales values.
These figures are not independently verified net revenue.

| Year | Recorded Sales | All Orders | Avg Sales/Order | Item Lines/Order | Negative Benefit Rate |
|------|---------------:|-----------:|----------------:|-----------------:|----------------------:|
| 2015 | 10,859,735.36 | 20,904 | 530.70 | 3.00 | 18.71% |
| 2016 | 10,838,544.62 | 20,859 | 530.57 | 3.00 | 18.86% |
| 2017 | 10,396,867.83 | 21,866 | 485.47 | 2.43 | 18.50% |

### Key Findings

1. Recorded sales decreased by 4.08% in 2017
   compared with 2016.

2. Average recorded sales per order declined
   from 530.57 in 2016 to 485.47 in 2017.

3. Order volume increased by 4.83% in 2017,
   while recorded sales decreased.

4. Item lines per order declined from approximately
   3.00 to 2.43.

5. Negative-benefit record rates remained
   between 18.50% and 18.86%.

### Important Limitations

- Sales values are based on Order Item Total.
- Some orders were excluded from sales calculations.
- Benefit per order varies within many orders.
- Negative-benefit rates are record-level indicators.
- Currency, refunds and accounting revenue require
  independent verification.

## 13. Regional Sales Analysis

### Findings

- Western Europe has unusually low recorded
  sales and order coverage in 2016.
- Central America has no available 2016 records.
- Oceania recorded lower sales in 2017 than 2016.
- Southeast Asia also recorded lower sales in 2017.
- West of USA records appear only in 2016.

### Data Quality Notes

Missing region-year combinations are marked N/A,
not zero sales.

Regional comparisons may be affected by changes
in data coverage and order-item granularity.

Regional changes should not automatically be
interpreted as business growth or decline.

## 14. Financial Business Problem

How can the business improve recorded sales per
order and delivery reliability while investigating
financial performance and regional data quality?

### Recommendations

1. Monitor average sales per order every month.
2. Investigate the reduction in item lines per order.
3. Analyze product categories with negative benefit.
4. Review shipping performance and delivery delays.
5. Validate regional data coverage before comparison.
6. Investigate changes in customer purchasing patterns.
7. Verify sales and profitability metric definitions.

### 15. Delivery Delay Analysis – Key Findings

The delivery delay analysis was conducted using 28,965 unique orders.

The analysis identified 16,633 late orders, representing an overall late delivery rate of 57.42%.

Late orders had an average processing duration of 4.07 days, compared to 2.71 days for non-late orders. This indicates that late orders took approximately 1.36 additional days on average.

Late orders exceeded their scheduled shipping duration by an average of 1.61 days, while non-late orders were delivered approximately 0.84 days before their scheduled duration.

These findings highlight a relationship between longer delivery duration and late delivery status. Further investigation of regional performance, shipping modes, and order processing stages is required to identify potential causes and improvement opportunities.

### 16. Delivery Performance Optimization – Root Cause Analysis

#### Objective
To identify the major factors associated with late deliveries and recommend practical improvements.

#### 1. Shipping Mode Analysis

- First Class recorded a 100% late delivery rate across all markets.
- Second Class recorded approximately 79–81% late deliveries.
- Same Day recorded approximately 46–50% late deliveries.
- Standard Class recorded approximately 38–41% late deliveries.

**Finding:** First Class and Second Class show consistently high late delivery rates across all markets. Their service-level configuration and delivery performance require investigation.

#### 2. Delivery Time Analysis

- Average actual delivery time for late orders was 4.06 days.
- Average scheduled delivery time was 2.46 days.
- Late orders exceeded the scheduled delivery duration by approximately 1.60 days.

**Finding:** Actual delivery duration frequently exceeds the promised schedule for late orders.

#### 3. Regional Analysis

- South of USA recorded the highest late delivery rate at 61.23%.
- South Asia recorded 60.16%.
- West Africa recorded the lowest rate at 52.98%.

**Finding:** Delivery delays occur across all regions, but some regions experience higher late delivery rates.

#### 4. Product Category Analysis

- Sporting Goods recorded a 62.58% late delivery rate.
- Health and Beauty recorded 62.07%.
- Women's Clothing recorded 61.97%.
- Cleats contributed 5,165 late orders due to its high order volume.

**Finding:** Some product categories show higher late delivery rates and require further monitoring.

#### 5. Recommendations

1. Review First Class and Second Class shipping service performance.
2. Reassess delivery commitments using historical delivery-time data.
3. Monitor regional delivery performance and investigate high-delay regions.
4. Track high-volume product categories for recurring delivery issues.
5. Regularly monitor late delivery rates by shipping mode, market, and region.
6. Investigate delayed orders and take corrective action before the promised delivery date.

#### 6. Conclusion

Shipping mode performance and delivery schedule mismatches are the strongest observed areas associated with late deliveries. Regional and product-category variations also provide useful signals for further investigation.

The recommendations focus on improving delivery planning, reviewing shipping service performance, and monitoring operational delays.

**Limitation:** The available dataset does not directly establish causes such as traffic, weather, warehouse staffing, inventory shortages, or individual carrier failures. These factors require further operational investigation.