/*
Business Problem:
Total orders declined in 2017 compared to 2016.

Objective of this file:
Establish the baseline BEFORE testing hypotheses: confirm the decline, decide how
"orders" is measured, and locate WHEN the change happened.

Tables used: fact_ecom only.

Conventions used in ALL files (performance):
 - Date filters are written as ranges (order_date >= '2016-01-01' AND order_date < '2018-01-01')
   so MySQL can use idx_order_date. Never wrap order_date in YEAR() inside WHERE.
 - Year pivots use SUM(order_date < '2017-01-01') = 2016 and SUM(order_date >= '2017-01-01') = 2017
   (valid because the WHERE clause already restricts to 2016-2017). One scan, no repeated sub-queries.
 - fact_ecom grain = ONE ROW PER ORDER ITEM (order_id repeats). So there are two "order" measures:
        order_lines     = COUNT(*)                 -> number of order items
        distinct_orders = COUNT(DISTINCT order_id) -> number of baskets
*/

-- Optional one-time indexes (covering indexes make the scans below index-only)
-- CREATE INDEX idx_fact_date_cust_prod ON fact_ecom (order_date, customer_id, product_card_id);
-- CREATE INDEX idx_fact_cust_date      ON fact_ecom (customer_id, order_date);

-- Step 1 : Data coverage (is 2017 a full year? is 2016 comparable?)

SELECT
    MIN(order_date)               AS first_order_date,
    MAX(order_date)               AS last_order_date,
    COUNT(*)                      AS order_lines,
    COUNT(DISTINCT order_id)      AS distinct_orders,
    COUNT(DISTINCT customer_id)   AS customers
FROM fact_ecom;

-- Step 2 : Yearly KPIs (which "orders" measure shows the decline?)

SELECT
    YEAR(order_date)                                   AS order_year,
    COUNT(*)                                           AS order_lines,
    COUNT(DISTINCT order_id)                           AS distinct_orders,
    ROUND(COUNT(*) / COUNT(DISTINCT order_id), 2)      AS lines_per_order,
    SUM(order_item_quantity)                           AS units_sold,
    SUM(is_cancelled)                                  AS cancelled_lines
FROM fact_ecom
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Step 3 : 2016 vs 2017 headline comparison

SELECT
    SUM(order_date <  '2017-01-01')                        AS lines_2016,
    SUM(order_date >= '2017-01-01')                        AS lines_2017,
    ROUND((SUM(order_date >= '2017-01-01') - SUM(order_date < '2017-01-01')) * 100.0
          / SUM(order_date < '2017-01-01'), 1)             AS lines_yoy_pct,
    COUNT(DISTINCT CASE WHEN order_date <  '2017-01-01' THEN order_id END) AS orders_2016,
    COUNT(DISTINCT CASE WHEN order_date >= '2017-01-01' THEN order_id END) AS orders_2017
FROM fact_ecom
WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01';

-- Step 4 : Monthly trend 2016 vs 2017 (find the month the pattern breaks)

SELECT
    MONTH(order_date)       AS month_no,
    MONTHNAME(order_date)   AS month_name,
    SUM(order_date <  '2017-01-01')   AS lines_2016,
    SUM(order_date >= '2017-01-01')   AS lines_2017,
    ROUND((SUM(order_date >= '2017-01-01') - SUM(order_date < '2017-01-01')) * 100.0
          / NULLIF(SUM(order_date < '2017-01-01'), 0), 1) AS lines_yoy_pct,
    COUNT(DISTINCT CASE WHEN order_date <  '2017-01-01' THEN order_id END) AS orders_2016,
    COUNT(DISTINCT CASE WHEN order_date >= '2017-01-01' THEN order_id END) AS orders_2017,
    ROUND((COUNT(DISTINCT CASE WHEN order_date >= '2017-01-01' THEN order_id END)
         - COUNT(DISTINCT CASE WHEN order_date <  '2017-01-01' THEN order_id END)) * 100.0
          / NULLIF(COUNT(DISTINCT CASE WHEN order_date < '2017-01-01' THEN order_id END), 0), 1) AS orders_yoy_pct
FROM fact_ecom
WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY month_no;

-- Step 5 : Basket size (items per order) by year -> distribution

WITH basket AS (
    SELECT order_id,
           MIN(order_date) AS order_date,
           COUNT(*)        AS items_in_order
    FROM fact_ecom
    WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
    GROUP BY order_id
)
SELECT
    items_in_order,
    SUM(order_date <  '2017-01-01') AS orders_2016,
    SUM(order_date >= '2017-01-01') AS orders_2017
FROM basket
GROUP BY items_in_order
ORDER BY items_in_order;

-- Step 6 : Isolate the break point inside 2017 (Jan-Sep vs Oct-Dec)

SELECT
    CASE
        WHEN order_date <  '2017-01-01' THEN '2016 full year'
        WHEN order_date <  '2017-10-01' THEN '2017 Jan-Sep'
        ELSE                                 '2017 Oct-Dec'
    END                                                    AS period,
    COUNT(*)                                               AS order_lines,
    COUNT(DISTINCT order_id)                               AS distinct_orders,
    ROUND(COUNT(*) / COUNT(DISTINCT order_id), 2)          AS lines_per_order,
    COUNT(DISTINCT customer_id)                            AS customers,
    COUNT(DISTINCT product_card_id)                        AS products_sold
FROM fact_ecom
WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
GROUP BY period
ORDER BY MIN(order_date);

/*
How to read this file:
 - If order_lines fall but distinct_orders do not, the "decline" is a basket-size (items per order)
   effect, not a drop in the number of purchases. State clearly which measure the business means.
 - Step 6 shows whether the change is gradual or a structural break at a specific date.
*/
