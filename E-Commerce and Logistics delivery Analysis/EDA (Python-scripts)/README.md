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