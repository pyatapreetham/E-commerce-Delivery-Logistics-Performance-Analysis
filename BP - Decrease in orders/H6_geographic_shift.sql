/*
Business Problem:
Total orders declined in 2017 compared to 2016.

Hypothesis H6:
Customer demand shifted across geographical regions.

Columns used: customer_city, customer_state, customer_country, order_date

Decision rule:
 H6 is supported if the decline is concentrated in specific countries/states/cities, or if the
 geographic share of orders changed. If every region falls by a similar % it is NOT a geographic issue.

Performance: fact_ecom is first aggregated to ONE ROW PER CUSTOMER, then joined to the
customer table. The join then touches ~20k rows instead of ~115k order lines.
(Each order belongs to exactly one customer, so per-customer order counts can be summed safely.)
*/

-- Step 1 : Country level

WITH cust AS (
    SELECT
        customer_id,
        SUM(order_date <  '2017-01-01') AS lines_2016,
        SUM(order_date >= '2017-01-01') AS lines_2017,
        COUNT(DISTINCT CASE WHEN order_date <  '2017-01-01' THEN order_id END) AS orders_2016,
        COUNT(DISTINCT CASE WHEN order_date >= '2017-01-01' THEN order_id END) AS orders_2017
    FROM fact_ecom
    WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
    GROUP BY customer_id
),
geo AS (
    SELECT
        c.customer_country,
        SUM(x.lines_2016)  AS lines_2016,
        SUM(x.lines_2017)  AS lines_2017,
        SUM(x.orders_2016) AS orders_2016,
        SUM(x.orders_2017) AS orders_2017
    FROM cust x
    JOIN customer c ON c.customer_id = x.customer_id
    GROUP BY c.customer_country
)
SELECT
    customer_country,
    lines_2016,
    lines_2017,
    lines_2017 - lines_2016                                                AS line_change,
    ROUND((lines_2017 - lines_2016) * 100.0 / NULLIF(lines_2016, 0), 1)    AS lines_yoy_pct,
    ROUND(lines_2016 * 100.0 / SUM(lines_2016) OVER (), 1)                 AS share_2016_pct,
    ROUND(lines_2017 * 100.0 / SUM(lines_2017) OVER (), 1)                 AS share_2017_pct,
    orders_2016,
    orders_2017,
    ROUND((orders_2017 - orders_2016) * 100.0 / NULLIF(orders_2016, 0), 1) AS orders_yoy_pct
FROM geo
ORDER BY line_change;

-- Step 2 : State level (country + state)

WITH cust AS (
    SELECT
        customer_id,
        SUM(order_date <  '2017-01-01') AS lines_2016,
        SUM(order_date >= '2017-01-01') AS lines_2017,
        COUNT(DISTINCT CASE WHEN order_date <  '2017-01-01' THEN order_id END) AS orders_2016,
        COUNT(DISTINCT CASE WHEN order_date >= '2017-01-01' THEN order_id END) AS orders_2017
    FROM fact_ecom
    WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
    GROUP BY customer_id
),
geo AS (
    SELECT
        c.customer_country,
        c.customer_state,
        SUM(x.lines_2016)  AS lines_2016,
        SUM(x.lines_2017)  AS lines_2017,
        SUM(x.orders_2016) AS orders_2016,
        SUM(x.orders_2017) AS orders_2017
    FROM cust x
    JOIN customer c ON c.customer_id = x.customer_id
    GROUP BY c.customer_country, c.customer_state
)
SELECT
    customer_country,
    customer_state,
    lines_2016,
    lines_2017,
    lines_2017 - lines_2016                                                AS line_change,
    ROUND((lines_2017 - lines_2016) * 100.0 / NULLIF(lines_2016, 0), 1)    AS lines_yoy_pct,
    ROUND((lines_2017 - lines_2016) * 100.0
          / NULLIF(SUM(lines_2017 - lines_2016) OVER (), 0), 1)            AS share_of_net_change_pct,
    orders_2016,
    orders_2017
FROM geo
ORDER BY line_change;

-- Step 3 : Top 15 cities with the largest decline in order lines

WITH cust AS (
    SELECT
        customer_id,
        SUM(order_date <  '2017-01-01') AS lines_2016,
        SUM(order_date >= '2017-01-01') AS lines_2017
    FROM fact_ecom
    WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
    GROUP BY customer_id
)
SELECT
    c.customer_country,
    c.customer_state,
    c.customer_city,
    SUM(x.lines_2016)                                                          AS lines_2016,
    SUM(x.lines_2017)                                                          AS lines_2017,
    SUM(x.lines_2017) - SUM(x.lines_2016)                                      AS line_change,
    ROUND((SUM(x.lines_2017) - SUM(x.lines_2016)) * 100.0
          / NULLIF(SUM(x.lines_2016), 0), 1)                                   AS lines_yoy_pct
FROM cust x
JOIN customer c ON c.customer_id = x.customer_id
GROUP BY c.customer_country, c.customer_state, c.customer_city
ORDER BY line_change
LIMIT 15;

-- Step 4 : Top 15 cities with the largest growth (to see if demand moved rather than vanished)

WITH cust AS (
    SELECT
        customer_id,
        SUM(order_date <  '2017-01-01') AS lines_2016,
        SUM(order_date >= '2017-01-01') AS lines_2017
    FROM fact_ecom
    WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
    GROUP BY customer_id
)
SELECT
    c.customer_country,
    c.customer_state,
    c.customer_city,
    SUM(x.lines_2016)                                    AS lines_2016,
    SUM(x.lines_2017)                                    AS lines_2017,
    SUM(x.lines_2017) - SUM(x.lines_2016)                AS line_change
FROM cust x
JOIN customer c ON c.customer_id = x.customer_id
GROUP BY c.customer_country, c.customer_state, c.customer_city
ORDER BY line_change DESC
LIMIT 15;

-- Step 5 : Country timing - 2016 vs 2017 Jan-Sep vs 2017 Oct-Dec (monthly run-rate)

WITH cust AS (
    SELECT
        customer_id,
        SUM(order_date <  '2017-01-01')                                  AS lines_2016,
        SUM(order_date >= '2017-01-01' AND order_date < '2017-10-01')    AS lines_2017_jan_sep,
        SUM(order_date >= '2017-10-01')                                  AS lines_2017_oct_dec
    FROM fact_ecom
    WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
    GROUP BY customer_id
)
SELECT
    c.customer_country,
    ROUND(SUM(x.lines_2016) / 12.0, 0)            AS avg_monthly_2016,
    ROUND(SUM(x.lines_2017_jan_sep) / 9.0, 0)     AS avg_monthly_2017_jan_sep,
    ROUND(SUM(x.lines_2017_oct_dec) / 3.0, 0)     AS avg_monthly_2017_oct_dec
FROM cust x
JOIN customer c ON c.customer_id = x.customer_id
GROUP BY c.customer_country
ORDER BY avg_monthly_2016 DESC;

-- Step 6 : Customer segment view (extra check: is the change specific to a segment?)

WITH cust AS (
    SELECT
        customer_id,
        SUM(order_date <  '2017-01-01') AS lines_2016,
        SUM(order_date >= '2017-01-01') AS lines_2017
    FROM fact_ecom
    WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
    GROUP BY customer_id
)
SELECT
    c.customer_segment,
    SUM(x.lines_2016)                                                       AS lines_2016,
    SUM(x.lines_2017)                                                       AS lines_2017,
    ROUND((SUM(x.lines_2017) - SUM(x.lines_2016)) * 100.0
          / NULLIF(SUM(x.lines_2016), 0), 1)                                AS lines_yoy_pct
FROM cust x
JOIN customer c ON c.customer_id = x.customer_id
GROUP BY c.customer_segment
ORDER BY lines_2016 DESC;
