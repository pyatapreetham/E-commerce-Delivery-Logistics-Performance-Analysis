# Exploratory Data Analysis (EDA)

## Project
E-Commerce Delivery and Logistics Performance Analysis

## 1. Project Overview

This project analyzes historical e-commerce and logistics data to understand order trends, sales performance, delivery delays, customer purchasing behavior, profitability indicators, and regional performance.

The main objective is to identify business challenges and provide data-driven insights for improving operational and financial performance.

## 2. Tools Used

- Python
- Pandas and NumPy
- Matplotlib and Seaborn
- Jupyter Notebook
- Visual Studio Code

## 3. Key EDA Findings

### 3.1 Year-wise Order Analysis

| Year | Total Orders | Yearly Growth |
|---|---:|---:|
| 2015 | 20,904 | — |
| 2016 | 20,859 | -0.22% |
| 2017 | 21,866 | +4.83% |

**Findings:**

- Orders remained almost stable between 2015 and 2016.
- In 2017, total orders increased by approximately 4.83%.
- Monthly order volume increased noticeably during October–December 2017.
- Only January data is available for 2018, so it is excluded from full-year comparisons.

**Business Insight:** Order volume increased in 2017, indicating higher order activity. However, order volume alone does not indicate higher sales or profitability.

### 3.2 Delivery Performance Analysis

| Year | KPI-Eligible Orders | Late Delivery Rate |
|---|---:|---:|
| 2015 | 9,214 | 56.54% |
| 2016 | 9,227 | 58.33% |
| 2017 | 9,568 | 57.23% |

**Findings:**

- More than 56% of KPI-eligible unique orders were marked late in every complete year.
- The highest annual late delivery rate occurred in 2016.
- In 2017, late delivery rates decreased slightly despite increased order volume.

**Business Insight:** Delivery delays represent a persistent operational concern. The data does not establish that increasing order volume caused these delays.

### 3.3 Shipping Mode Performance

| Shipping Mode | 2015 | 2016 | 2017 |
|---|---:|---:|---:|
| First Class | 100% | 100% | 100% |
| Second Class | 79.92% | 81.06% | 79.29% |
| Same Day | 45.10% | 44.51% | 55.45% |
| Standard Class | 39.40% | 41.01% | 38.71% |

**Findings:**

- First Class orders were consistently classified as late, requiring verification of scheduled delivery targets and status definitions.
- Second Class had approximately 79–81% late deliveries.
- Same Day late delivery rate increased by 10.94 percentage points from 2016 to 2017.
- Standard Class had the lowest late delivery rate among the analyzed shipping modes.

**Business Insight:** Shipping mode performance varies significantly, suggesting that delivery targets and operational processes should be investigated separately for each mode.

### 3.4 Year-wise Recorded Sales Analysis

| Year | Recorded Item Sales | Annual Change |
|---|---:|---:|
| 2015 | 10,859,735.36 | — |
| 2016 | 10,838,544.62 | -0.20% |
| 2017 | 10,396,867.83 | -4.08% |

**Findings:**

- Recorded item sales remained nearly stable between 2015 and 2016.
- Sales decreased by approximately 4.08% in 2017.
- During the same period, order volume increased by 4.83%.

**Business Insight:** The increase in order activity did not translate into higher recorded sales. This suggests investigating average order value, basket composition, discounts, and data coverage.

*Note: The values represent recorded order-item sales, not independently verified net revenue. The dataset's currency has not been confirmed.*

### 3.5 Average Recorded Sales per Order

| Year | Average Sales per Order | Order-Item Lines per Order |
|---|---:|---:|
| 2015 | 530.70 | 3.00 |
| 2016 | 530.57 | 3.00 |
| 2017 | 485.47 | 2.43 |

**Findings:**

- Average recorded sales per order declined by approximately 8.5% in 2017 compared with 2016.
- Average order-item lines per order decreased from 3.00 to 2.43.
- The reduction in item lines may partly explain the decline in sales per order.

**Business Insight:** The business should investigate purchasing patterns, basket size, product mix, and discounts to understand the lower recorded sales per order.

### 3.6 Profitability Indicators

| Year | Negative-Benefit Rate | Average Benefit per Record |
|---|---:|---:|
| 2015 | 18.71% | 20.99 |
| 2016 | 18.86% | 20.93 |
| 2017 | 18.50% | 24.72 |

**Findings:**

- Approximately 18.5–18.9% of analyzed item records had negative benefit values.
- The average benefit per analyzed record increased in 2017.
- Negative-benefit rates remained relatively stable across the three years.

**Business Insight:** Negative-benefit records require investigation into pricing, discounts, costs, and product category performance.

*Note: The benefit field varies within many orders. These results are item-record-level indicators, not verified company-level net profit.*

### 3.7 Regional Sales Analysis

**Findings:**

- Western Europe recorded high sales in 2015 and 2017 but unusually limited data in 2016.
- Central America had no available records for 2016.
- Oceania and Southeast Asia recorded lower sales values in 2017 than in 2016.
- West of USA records appeared only in 2016.
- Missing region-year combinations were classified as N/A rather than zero sales.

**Business Insight:** Regional comparisons require additional data-quality verification because incomplete coverage and differences in record granularity can affect the results.

## 4. Major Business Problems Identified

The exploratory analysis highlights the following areas for further investigation:

1. **High Late Delivery Rates:** More than half of KPI-eligible orders were marked late throughout 2015–2017.
2. **Declining Sales per Order:** Recorded sales per order decreased in 2017 despite increasing order volume.
3. **Shipping Mode Inefficiencies:** First Class and Second Class showed consistently high late-delivery classifications.
4. **Negative-Benefit Records:** Approximately 18.5% of analyzed item records had negative benefit values.
5. **Regional Data Inconsistencies:** Missing and uneven data coverage limit reliable regional comparisons.

## 5. Business Recommendations

- Review shipping schedules and investigate causes of delivery delays.
- Monitor delivery performance separately for each shipping mode.
- Analyze product pricing, discounts, and basket composition.
- Investigate declining average sales per order.
- Identify products and categories associated with negative benefit.
- Validate regional data before making business decisions.
- Develop Power BI dashboards for continuous monitoring of validated KPIs.

## 6. Analysis Methodology and Limitations

- Order trends use unique Order IDs.
- Delivery performance uses unique KPI-eligible orders.
- Sales analysis uses recorded `Order Item Total` values at the order-item level.
- Cancelled records were excluded where the cancellation flag was available.
- Average recorded sales per order uses orders retained in the sales analysis.
- Negative-benefit rates are calculated at the item-record level.
- Regional missing values are represented as N/A.
- Only 2015–2017 are included in full-year comparisons.
- Historical associations do not establish causation.

## 7. Project Files

| File | Description |
|---|---|
| `delivery_eda.ipynb` | Complete Python exploratory analysis |
| `EDA_Findings.md` | Detailed findings and analysis notes |
| `README.md` | Project overview, numerical findings, and recommendations |
| `visualizations/` | 27 EDA visualization charts |

## 8. Conclusion

The EDA identified two major business concerns: consistently high delivery delays and declining recorded sales per order.

In 2017, total order volume increased by 4.83%, while recorded item sales decreased by approximately 4.08% and average sales per order declined by approximately 8.5%.

Additionally, late delivery rates remained above 56% across all three complete years.

These findings provide a foundation for further business analysis and the development of a Power BI dashboard to monitor sales, delivery performance, and profitability indicators.

Additional validation is required before interpreting the financial indicators as accounting revenue or profit, or treating regional changes as confirmed business trends.

## 9. Shipping Mode Analysis – Key Findings

The shipping mode analysis was performed using 28,965 unique orders to identify delivery performance issues.

The overall late delivery rate was 57.42%. First Class showed the highest late delivery rate of 100%, followed by Second Class at 80.09%. Same Day had a late delivery rate of 48.51%, while Standard Class performed comparatively better at 39.76%.

Although Standard Class had a lower late delivery rate, it recorded the highest number of late orders (6,872) due to its high order volume.

The analysis suggests that First Class and Second Class require detailed investigation, while Standard Class should be prioritized for large-scale delivery improvement. Further analysis of regional performance, processing time, and actual shipping duration can help identify potential causes and optimization opportunities.

## 10. Regional Processing Time and Late Delivery Analysis

### Key Findings

Regional processing time and late delivery performance were analyzed to identify regions with potential delivery optimization opportunities.

South of USA recorded the highest late delivery rate at 61%, followed by Eastern Europe, West Asia, and South Asia at approximately 60%.

West Africa recorded the lowest late delivery rate at 53% among the analyzed regions.

Southern Africa had the highest average processing time of 3.65 days, while North Africa had the lowest average processing time of 3.38 days.

The analysis indicates that regions with higher average processing times do not necessarily have the highest late delivery rates. Therefore, processing time alone may not explain regional delivery performance differences.

### Recommendations

- Investigate delivery performance in South of USA and Eastern Europe.
- Analyze shipping routes and transportation processes in high-risk regions.
- Compare regional shipping modes and scheduled delivery durations.
- Identify operational factors contributing to regional delivery delays.
- Use regional performance indicators to prioritize delivery optimization efforts.

## 11. Weekday-Wise Delivery Delay Analysis

### Key Findings
- Thursday recorded the highest late delivery rate at 58.29%.
- Tuesday followed closely with a late delivery rate of 58.20%.
- Saturday recorded the lowest late delivery rate at 56.24%.
- Late delivery rates varied by only 2.05 percentage points across weekdays.
- Average processing time remained consistent across weekdays, ranging from 3.47 to 3.54 days.
- Order volumes were relatively similar across all seven weekdays.

### Recommendations
- Monitor weekday-wise delivery performance regularly.
- Investigate whether Thursday and Tuesday have any operational workload differences.
- Avoid prioritizing weekdays based only on the small differences in late delivery rates.
- Focus on other factors such as shipping mode, regional performance, and processing time for further delivery optimization.

### Conclusion
The analysis indicates that delivery delays are relatively consistent across weekdays. Although Thursday and Tuesday show slightly higher late delivery rates, weekday differences alone do not explain the overall delivery performance problem.


## 12. Shipping Mode vs Scheduled Delivery Time Analysis

### Key Findings
- First Class recorded a 100% late delivery rate, with average actual delivery taking 2 days against 1 scheduled day.
- Second Class had an average delivery delay of 1.98 days and a late delivery rate of 80.09%.
- Same Day shipping recorded an average actual delivery time of 0.49 days against a scheduled time of 0 days.
- Standard Class had an average actual delivery time of 3.99 days against 4 scheduled days, with a late delivery rate of 39.76%.
- Standard Class recorded the highest number of late orders (6,872), mainly because it handled the largest order volume.

### Recommendations
- Investigate the unusually high late delivery rate for First Class shipping.
- Review operational factors affecting Second Class delivery delays.
- Focus on improving Standard Class delivery performance because it contributes the highest number of late orders.
- Compare actual delivery times with scheduled delivery times regularly.
- Investigate the reasons behind delays instead of assuming that shipping mode alone causes them.

### Conclusion
The analysis shows considerable differences in delivery performance across shipping modes. First Class and Second Class show substantial delays compared with their scheduled delivery times, while Standard Class performs close to its schedule. Standard Class should also receive attention because of its high late-order volume.


## 13. Monthly Delivery Delay Analysis

### Key Findings
- December recorded the highest late delivery rate at 58.33%.
- August followed closely with a late delivery rate of 58.23%.
- April recorded the lowest late delivery rate at 56.01%.
- Late delivery rates varied by only 2.32 percentage points across months.
- June had the highest average processing time at 3.57 days.
- January recorded the highest order volume with 3,258 orders.

### Recommendations
- Monitor delivery performance during December and August.
- Investigate whether seasonal workload or operational factors contribute to delays during these months.
- Continue monitoring monthly delivery trends.
- Avoid making major operational decisions based only on small monthly differences.

### Conclusion
The monthly analysis shows that late delivery rates remain relatively consistent throughout the year. Although December and August recorded slightly higher late delivery rates, monthly variation alone does not explain the overall delivery performance problem.


## 14. Customer Segment vs Delivery Performance

### Key Findings
- Home Office recorded the highest late delivery rate at 58.02%.
- Consumer recorded a late delivery rate of 57.44%.
- Corporate recorded the lowest late delivery rate at 57.04%.
- Consumer had the highest order volume with 15,000 orders and 8,616 late orders.
- Average processing time was nearly identical across all customer segments, ranging from 3.49 to 3.50 days.
- The difference between the highest and lowest late delivery rates was only 0.98 percentage points.

### Recommendations
- Monitor delivery performance across all customer segments.
- Investigate Home Office delivery patterns for possible operational differences.
- Focus on overall delivery improvements rather than making major changes based only on customer segment.
- Consider shipping mode, region, and processing time for further investigation.

### Conclusion
The analysis shows that delivery performance is relatively consistent across customer segments. Home Office has a slightly higher late delivery rate, but customer segment alone does not explain the overall delivery delay problem.


## 15. Order Status vs Delivery Performance

### Key Findings
- COMPLETE orders recorded a late delivery rate of 57.66%.
- CLOSED orders recorded a late delivery rate of 56.73%.
- COMPLETE orders had the highest order volume, with 21,716 orders and 12,521 late orders.
- Average processing time was nearly identical for both statuses.
- The difference in late delivery rates was only 0.93 percentage points.

### Recommendations
- Monitor delivery performance across both order statuses.
- Investigate whether order status is related to any operational differences.
- Focus on shipping mode, regional performance, and processing time for further delivery optimization.
- Avoid making major decisions based only on small differences in order status.

### Conclusion
The analysis shows that delivery performance is relatively consistent across COMPLETE and CLOSED orders. Order status alone does not explain the overall delivery delay problem.


## 16. Market-Wise Delivery Performance Analysis

### Key Findings
- Pacific Asia recorded the highest late delivery rate at 58.53%.
- USCA followed with a late delivery rate of 58.22%.
- Africa recorded the lowest late delivery rate at 55.98%.
- Europe had the highest number of late orders, with 4,744 late orders out of 8,232 total orders.
- Average processing time was nearly consistent across all markets, ranging from 3.48 to 3.52 days.
- The difference between the highest and lowest market late delivery rates was 2.55 percentage points.

### Recommendations
- Investigate delivery performance in Pacific Asia and USCA.
- Monitor regional delivery performance across all markets.
- Investigate possible operational differences between markets.
- Focus on shipping modes, processing time, and regional logistics for further optimization.

### Conclusion
The analysis shows that delivery performance is relatively consistent across markets. Pacific Asia and USCA have slightly higher late delivery rates, while Africa has the lowest. Market differences alone do not explain the overall delivery delay problem.


## 17. Product Category vs Delivery Performance Analysis

### Key Findings
- Sporting Goods recorded the highest late delivery rate at 62.58%, based on 155 orders.
- Health and Beauty recorded a late delivery rate of 62.07%.
- Women's Clothing recorded a late delivery rate of 61.97%.
- Men's Golf Clubs recorded the lowest late delivery rate at 52.46%.
- Computers recorded a late delivery rate of 53.14%.
- The difference between the highest and lowest category late delivery rates was approximately 10.12 percentage points.
- Some categories had relatively low order volumes, which may affect the reliability of their delivery rate estimates.

### Recommendations
- Investigate delivery performance for Sporting Goods, Health and Beauty, and Women's Clothing.
- Monitor categories with higher late delivery rates and sufficient order volumes.
- Consider category-specific packaging, handling, and shipping requirements as possible areas for investigation.
- Avoid making major decisions based only on categories with very few orders.
- Compare category performance with shipping mode and regional delivery patterns.

### Conclusion
The analysis shows differences in late delivery rates across product categories. Sporting Goods recorded the highest rate, while Men's Golf Clubs recorded the lowest. Product category may be associated with delivery performance, but further investigation is required to understand the reasons behind these differences.


## 18. Department-Wise Delivery Performance Analysis

### Key Findings
- Health and Beauty recorded the highest late delivery rate at 62.07%, based on 174 orders.
- Pet Shop recorded a late delivery rate of 61.80%, based on 233 orders.
- Book Shop recorded a late delivery rate of 59.76%.
- Fan Shop had the highest order volume, with 18,066 orders and 10,308 late orders.
- Apparel recorded 15,395 orders and 8,839 late orders.
- Average processing time was relatively similar across departments.
- High late delivery rates in departments with fewer orders should be interpreted cautiously.

### Recommendations
- Investigate delivery performance in Health and Beauty and Pet Shop.
- Prioritize Fan Shop and Apparel for improvement because they contribute a large number of late orders.
- Monitor departments with high late delivery rates and sufficient order volumes.
- Compare department performance with shipping mode and regional delivery patterns.
- Avoid making major decisions based only on small departments with limited orders.

### Conclusion
The analysis shows differences in delivery performance across departments. Health and Beauty and Pet Shop have the highest late delivery rates, while Fan Shop and Apparel contribute the largest number of late orders due to their high order volumes. Department-level differences should be investigated further before drawing conclusions about their causes.


## 19. Order Quantity vs Delivery Performance Analysis

### Key Findings
- Orders containing 1 unit recorded the highest late delivery rate at 58.08%.
- Orders containing 2–3 units recorded the lowest late delivery rate at 56.23%.
- Orders containing 6–10 units had the highest order volume, with 9,487 orders.
- Average processing time remained similar across all quantity groups, ranging from 3.45 to 3.51 days.
- Late delivery rates varied by only 1.85 percentage points across quantity groups.

### Recommendations
- Monitor delivery performance across different order quantity groups.
- Investigate whether packaging or handling requirements differ for larger orders.
- Avoid making major operational decisions based only on small differences in quantity-wise delivery rates.
- Consider shipping mode, region, and processing time for further delivery optimization.

### Conclusion
The analysis shows that delivery performance is relatively consistent across different order quantity groups. Although single-unit orders recorded a slightly higher late delivery rate, order quantity alone does not explain the overall delivery delay problem.


## 20. Processing Time vs Delivery Performance Analysis

### Key Findings
- Orders processed in 1 day recorded a 100% late delivery rate, based on 751 orders.
- Orders processed in 5 and 6 days also recorded 100% late delivery rates.
- Orders processed in 3 and 4 days recorded late delivery rates of 24.92% and 25.02%, respectively.
- Orders processed in 2 days recorded a late delivery rate of 49.50%.
- Orders processed in 0 days recorded no late deliveries among 797 orders.
- Delivery performance showed a non-linear pattern across processing durations.

### Recommendations
- Investigate why orders processed in 1, 5, and 6 days have unusually high late delivery rates.
- Verify processing duration calculations and scheduled delivery time.
- Compare processing duration with shipping mode and delivery status.
- Avoid assuming that processing time alone causes late delivery.

### Conclusion
The analysis reveals substantial differences in late delivery rates across processing durations. However, the relationship is non-linear, and processing time alone does not explain delivery delays. Further investigation of scheduled delivery times and operational factors is required.


## 21. Scheduled Delivery Days vs Delivery Performance Analysis

### Key Findings
- Orders with a scheduled delivery time of 1 day recorded a 100% late delivery rate.
- Orders scheduled for 2 days recorded an 80.09% late delivery rate.
- Orders scheduled for 4 days recorded the lowest late delivery rate of 39.76%.
- Same-day scheduled orders recorded a late delivery rate of 48.51%.
- Scheduled delivery days correspond directly to shipping modes in this dataset.

### Recommendations
- Investigate why orders scheduled for 1 and 2 days have high late delivery rates.
- Review scheduling practices for First Class and Second Class shipments.
- Compare scheduled delivery targets with actual delivery performance.
- Avoid interpreting scheduled days as an independent factor because they are directly associated with shipping modes.

### Conclusion
The analysis shows substantial differences in late delivery rates across scheduled delivery durations. Orders scheduled for shorter delivery periods generally show higher late delivery rates, except for same-day shipments. Since scheduled days correspond directly to shipping modes, the findings reinforce the earlier shipping mode analysis.


## 22. Delivery Schedule Adherence Analysis

### Key Findings
- A total of 6,951 orders were delivered ahead of schedule, with no late deliveries recorded.
- 16,633 orders were delivered behind schedule, and all were marked as late deliveries.
- 5,381 orders were delivered exactly on schedule, with no late deliveries recorded.
- Orders delivered behind schedule had an average delay of 1.61 days.
- The average actual delivery time for behind-schedule orders was 4.07 days, compared with 2.47 scheduled days.

### Recommendations
- Investigate operational reasons behind delayed deliveries.
- Review actual delivery time against scheduled delivery targets.
- Monitor orders that exceed their scheduled delivery duration.
- Interpret the findings carefully because the late-delivery indicator is closely related to schedule adherence.

### Conclusion
The analysis shows a clear relationship between delivery schedule adherence and late delivery status. Orders delivered behind schedule were consistently marked as late, while orders delivered on or ahead of schedule were not. This supports the importance of monitoring delivery timelines, although the relationship should not be treated as independent proof of causation.


## 23. Final Project Conclusion and Business Recommendations

### Overall Project Summary

The E-Commerce Delivery and Logistics Performance Analysis project examined delivery performance, processing time, shipping modes, customer segments, markets, product categories, departments, order quantities, and delivery schedules.

The analysis was performed using Python, Pandas, NumPy, Matplotlib, and Seaborn.

### Overall Key Findings

- The dataset contained 28,965 unique orders used for order-level delivery analysis.
- A total of 16,633 orders were marked as late deliveries.
- The overall late delivery rate was 57.42%.
- Average processing time and actual shipping time were both 3.49 days.
- Average scheduled shipping time was 2.93 days.
- Actual shipping time exceeded scheduled shipping time by an average of 0.56 days.
- First Class recorded a 100% late delivery rate, while Second Class recorded 80.09%.
- Standard Class had the largest number of late orders because it accounted for the highest order volume.
- Late delivery rates varied across markets, regions, customer segments, and product categories.
- Processing time and delivery performance showed different patterns across groups, suggesting that processing time alone does not explain late deliveries.

### Business Recommendations

1. **Improve Delivery Performance:** Investigate operational reasons behind the overall late delivery rate of 57.42%.

2. **Review Shipping Modes:** Examine First Class and Second Class shipments because of their unusually high late delivery rates.

3. **Optimize Standard Class Operations:** Standard Class had the highest late-order volume, making it an important area for operational investigation.

4. **Monitor Delivery Schedules:** Track actual delivery time against scheduled delivery targets and investigate orders that exceed their expected duration.

5. **Investigate Regional Differences:** Review markets and regions with comparatively high late delivery rates to identify possible operational improvement opportunities.

6. **Improve Processing Efficiency:** Examine orders with unusually high processing durations and identify possible workflow bottlenecks.

7. **Develop Delivery KPIs:** Regularly monitor late delivery rate, average processing time, average shipping time, and schedule adherence.

### Project Limitations

- The dataset contains multiple item-level records for individual orders. Order-level analysis requires proper grouping or deduplication.
- Some product categories and departments have relatively small order counts, so their percentages should be interpreted cautiously.
- Late delivery status and schedule adherence are closely related, so they should not be treated as independent evidence of causation.
- The analysis identifies patterns and associations but does not establish the exact causes of late deliveries.
- Further investigation using carrier, warehouse, staffing, and operational information may help identify underlying causes.

### Final Conclusion

The analysis identified a substantial late delivery rate of 57.42% across 28,965 unique orders. Actual shipping time exceeded scheduled shipping time by an average of 0.56 days.

Shipping mode analysis revealed particularly high late delivery rates for First Class and Second Class shipments, while Standard Class accounted for the largest number of late orders.

The project provides useful insights into delivery performance and highlights areas requiring further investigation. By monitoring delivery KPIs, reviewing shipping operations, and improving schedule adherence, the business may identify opportunities to improve customer satisfaction and logistics efficiency.
