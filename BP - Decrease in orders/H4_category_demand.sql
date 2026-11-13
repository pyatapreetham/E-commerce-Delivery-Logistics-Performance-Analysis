/*
Business Problem:
Total orders declined in 2017 compared to 2016.

Hypothesis H4:
Demand for popular categories decreased.

Columns used: category_name, department_name, order_date, order_id

Decision rule:
 H4 is supported if the biggest 2016 categories/departments lost volume in 2017 and explain most of
 the net decline. Also check whether new categories appeared (mix change).
*/

-- Step 1 : Department level - 2016 vs 2017

WITH d AS (
    SELECT
        p.department_name,
        SUM(f.order_date <  '2017-01-01')  AS lines_2016,
        SUM(f.order_date >= '2017-01-01')  AS lines_2017,
        COUNT(DISTINCT CASE WHEN f.order_date <  '2017-01-01' THEN f.order_id END) AS orders_2016,
        COUNT(DISTINCT CASE WHEN f.order_date >= '2017-01-01' THEN f.order_id END) AS orders_2017
    FROM fact_ecom f
    JOIN product p ON p.product_card_id = f.product_card_id
    WHERE f.order_date >= '2016-01-01' AND f.order_date < '2018-01-01'
    GROUP BY p.department_name
)
SELECT
    department_name,
    lines_2016,
    lines_2017,
    lines_2017 - lines_2016                                                   AS line_change,
    ROUND((lines_2017 - lines_2016) * 100.0 / NULLIF(lines_2016, 0), 1)       AS lines_yoy_pct,
    ROUND((lines_2017 - lines_2016) * 100.0
          / NULLIF(SUM(lines_2017 - lines_2016) OVER (), 0), 1)               AS share_of_net_change_pct,
    orders_2016,
    orders_2017,
    CASE WHEN lines_2016 = 0 THEN 'New in 2017'
         WHEN lines_2017 = 0 THEN 'Discontinued'
         ELSE 'Continuing' END                                                AS status
FROM d
ORDER BY line_change;

-- Step 2 : Category level - 2016 vs 2017, ranked by contribution to the decline

WITH c AS (
    SELECT
        p.category_name,
        p.department_name,
        SUM(f.order_date <  '2017-01-01')  AS lines_2016,
        SUM(f.order_date >= '2017-01-01')  AS lines_2017,
        COUNT(DISTINCT CASE WHEN f.order_date <  '2017-01-01' THEN f.order_id END) AS orders_2016,
        COUNT(DISTINCT CASE WHEN f.order_date >= '2017-01-01' THEN f.order_id END) AS orders_2017
    FROM fact_ecom f
    JOIN product p ON p.product_card_id = f.product_card_id
    WHERE f.order_date >= '2016-01-01' AND f.order_date < '2018-01-01'
    GROUP BY p.category_name, p.department_name
)
SELECT
    category_name,
    department_name,
    lines_2016,
    lines_2017,
    lines_2017 - lines_2016                                                   AS line_change,
    ROUND((lines_2017 - lines_2016) * 100.0 / NULLIF(lines_2016, 0), 1)       AS lines_yoy_pct,
    ROUND((lines_2017 - lines_2016) * 100.0
          / NULLIF(SUM(lines_2017 - lines_2016) OVER (), 0), 1)               AS share_of_net_change_pct,
    orders_2016,
    orders_2017,
    RANK() OVER (ORDER BY lines_2016 DESC)                                    AS popularity_rank_2016,
    CASE WHEN lines_2016 = 0 THEN 'New in 2017'
         WHEN lines_2017 = 0 THEN 'Discontinued'
         ELSE 'Continuing' END                                                AS status
FROM c
ORDER BY line_change;

-- Step 3 : Top 10 most popular 2016 categories - did they lose demand?

WITH c AS (
    SELECT
        p.category_name,
        SUM(f.order_date <  '2017-01-01')  AS lines_2016,
        SUM(f.order_date >= '2017-01-01')  AS lines_2017
    FROM fact_ecom f
    JOIN product p ON p.product_card_id = f.product_card_id
    WHERE f.order_date >= '2016-01-01' AND f.order_date < '2018-01-01'
    GROUP BY p.category_name
)
SELECT
    category_name,
    lines_2016,
    lines_2017,
    ROUND((lines_2017 - lines_2016) * 100.0 / NULLIF(lines_2016, 0), 1) AS lines_yoy_pct
FROM c
ORDER BY lines_2016 DESC
LIMIT 10;

-- Step 4 : Department timing - 2016 vs 2017 Jan-Sep vs 2017 Oct-Dec (when did each one drop?)

SELECT
    p.department_name,
    SUM(f.order_date <  '2017-01-01')                                       AS lines_2016,
    SUM(f.order_date >= '2017-01-01' AND f.order_date < '2017-10-01')       AS lines_2017_jan_sep,
    SUM(f.order_date >= '2017-10-01')                                       AS lines_2017_oct_dec,
    -- Monthly run-rate makes 12 vs 9 vs 3 months comparable
    ROUND(SUM(f.order_date <  '2017-01-01') / 12.0, 0)                      AS avg_monthly_2016,
    ROUND(SUM(f.order_date >= '2017-01-01' AND f.order_date < '2017-10-01') / 9.0, 0) AS avg_monthly_2017_jan_sep,
    ROUND(SUM(f.order_date >= '2017-10-01') / 3.0, 0)                       AS avg_monthly_2017_oct_dec
FROM fact_ecom f
JOIN product p ON p.product_card_id = f.product_card_id
WHERE f.order_date >= '2016-01-01' AND f.order_date < '2018-01-01'
GROUP BY p.department_name
ORDER BY lines_2016 DESC;

-- Step 5 : Monthly trend of the top departments (2016 vs 2017)

SELECT
    p.department_name,
    MONTH(f.order_date) AS month_no,
    SUM(f.order_date <  '2017-01-01') AS lines_2016,
    SUM(f.order_date >= '2017-01-01') AS lines_2017
FROM fact_ecom f
JOIN product p ON p.product_card_id = f.product_card_id
WHERE f.order_date >= '2016-01-01' AND f.order_date < '2018-01-01'
  AND p.department_name IN ('Fan Shop', 'Apparel', 'Golf', 'Footwear')
GROUP BY p.department_name, MONTH(f.order_date)
ORDER BY p.department_name, month_no;
