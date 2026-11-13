/*
Business Problem:
Total orders declined in 2017 compared to 2016.

Hypothesis H5:
Repeat orders or new customer acquisition declined.

Columns used: customer_id, order_id, order_date

LIMITATION (keep with limitations):
 The data starts on 2015-01-01, so a customer's "first order" is only the first one WE CAN SEE.
 - Every 2015 customer looks "new" (left-censoring).
 - Someone who last bought in 2014 and returns in 2016 will be counted as new.
 New/returning splits are therefore approximate, especially for 2016.

Performance: fact is first collapsed to ONE ROW PER CUSTOMER-YEAR (about 35k rows),
and every later step works on that small set instead of re-scanning ~180k rows.
*/

-- Step 1 : Customers per year - active, new and returning, with the orders they generate

WITH cust_year AS (
    SELECT
        customer_id,
        YEAR(order_date)          AS yr,
        COUNT(*)                  AS lines,
        COUNT(DISTINCT order_id)  AS orders
    FROM fact_ecom
    GROUP BY customer_id, YEAR(order_date)
),
first_yr AS (
    SELECT customer_id, MIN(yr) AS first_year
    FROM cust_year
    GROUP BY customer_id
)
SELECT
    cy.yr                                                         AS order_year,
    COUNT(*)                                                      AS active_customers,
    SUM(cy.yr = fy.first_year)                                    AS new_customers,
    SUM(cy.yr > fy.first_year)                                    AS returning_customers,
    SUM(cy.lines)                                                 AS order_lines,
    SUM(CASE WHEN cy.yr = fy.first_year THEN cy.lines END)        AS lines_from_new,
    SUM(CASE WHEN cy.yr > fy.first_year THEN cy.lines END)        AS lines_from_returning,
    SUM(cy.orders)                                                AS distinct_orders,
    ROUND(SUM(cy.orders) / COUNT(*), 2)                           AS orders_per_active_customer,
    ROUND(SUM(cy.lines)  / COUNT(*), 2)                           AS lines_per_active_customer
FROM cust_year cy
JOIN first_yr fy ON fy.customer_id = cy.customer_id
GROUP BY cy.yr
ORDER BY cy.yr;

-- Step 2 : Retention - of customers active in year N, how many bought again in N+1?

WITH cust_year AS (
    SELECT customer_id, YEAR(order_date) AS yr
    FROM fact_ecom
    GROUP BY customer_id, YEAR(order_date)
),
flags AS (
    SELECT
        customer_id,
        MAX(yr = 2015) AS a15,
        MAX(yr = 2016) AS a16,
        MAX(yr = 2017) AS a17
    FROM cust_year
    GROUP BY customer_id
)
SELECT '2015 -> 2016' AS transition,
       SUM(a15 = 1)                                         AS customers_base,
       SUM(a15 = 1 AND a16 = 1)                             AS retained,
       ROUND(SUM(a15 = 1 AND a16 = 1) * 100.0 / NULLIF(SUM(a15 = 1), 0), 1) AS retention_pct
FROM flags
UNION ALL
SELECT '2016 -> 2017',
       SUM(a16 = 1),
       SUM(a16 = 1 AND a17 = 1),
       ROUND(SUM(a16 = 1 AND a17 = 1) * 100.0 / NULLIF(SUM(a16 = 1), 0), 1)
FROM flags;

-- Step 3 : Monthly new-customer acquisition (first order month), 2016 vs 2017

WITH first_seen AS (
    SELECT customer_id, MIN(order_date) AS first_date
    FROM fact_ecom
    GROUP BY customer_id
)
SELECT
    MONTH(first_date)       AS month_no,
    MONTHNAME(first_date)   AS month_name,
    SUM(first_date >= '2016-01-01' AND first_date < '2017-01-01') AS new_customers_2016,
    SUM(first_date >= '2017-01-01' AND first_date < '2018-01-01') AS new_customers_2017
FROM first_seen
WHERE first_date >= '2016-01-01' AND first_date < '2018-01-01'
GROUP BY MONTH(first_date), MONTHNAME(first_date)
ORDER BY month_no;

-- Step 4 : Order frequency per customer (how many baskets did each active customer place?)

WITH cust_year AS (
    SELECT customer_id,
           YEAR(order_date)         AS yr,
           COUNT(DISTINCT order_id) AS orders
    FROM fact_ecom
    WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
    GROUP BY customer_id, YEAR(order_date)
)
SELECT
    CASE WHEN orders = 1 THEN '1 order'
         WHEN orders = 2 THEN '2 orders'
         WHEN orders = 3 THEN '3 orders'
         ELSE '4+ orders' END      AS order_frequency,
    SUM(yr = 2016)                 AS customers_2016,
    SUM(yr = 2017)                 AS customers_2017
FROM cust_year
GROUP BY order_frequency
ORDER BY order_frequency;

-- Step 5 : New vs returning mix in 2017 Jan-Sep vs Oct-Dec (is the Q4 pattern driven by new customers?)

WITH first_seen AS (
    SELECT customer_id, MIN(order_date) AS first_date
    FROM fact_ecom
    GROUP BY customer_id
)
SELECT
    CASE WHEN f.order_date <  '2017-01-01' THEN '2016 full year'
         WHEN f.order_date <  '2017-10-01' THEN '2017 Jan-Sep'
         ELSE                                   '2017 Oct-Dec' END           AS period,
    COUNT(DISTINCT f.customer_id)                                            AS active_customers,
    COUNT(DISTINCT CASE WHEN fs.first_date >= '2016-01-01' AND
                             (CASE WHEN f.order_date < '2017-01-01' THEN fs.first_date < '2017-01-01'
                                   WHEN f.order_date < '2017-10-01' THEN fs.first_date >= '2017-01-01'
                                   ELSE fs.first_date >= '2017-10-01' END)
                        THEN f.customer_id END)                              AS new_in_period,
    COUNT(*)                                                                 AS order_lines,
    COUNT(DISTINCT f.order_id)                                               AS distinct_orders
FROM fact_ecom f
JOIN first_seen fs ON fs.customer_id = f.customer_id
WHERE f.order_date >= '2016-01-01' AND f.order_date < '2018-01-01'
GROUP BY period
ORDER BY MIN(f.order_date);
