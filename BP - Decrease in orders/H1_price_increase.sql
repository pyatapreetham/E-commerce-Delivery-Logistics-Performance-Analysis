/*
Business Problem:
Total orders declined in 2017 compared to 2016.

Hypothesis H1:
Product prices increased, which reduced the number of items customers bought.

Columns used: order_item_product_price, product_price, order_date (+ product for mix analysis)

Decision rule:
 H1 is supported only if like-for-like prices (same product, 2016 vs 2017) rose.
 If the average price rises only because of NEW expensive products (mix), price is NOT the cause.
*/

-- Step 1 : Data quality - do the two price columns agree?

SELECT
    COUNT(*)                                                   AS total_lines,
    SUM(order_item_product_price <> product_price)             AS price_mismatch_lines
FROM fact_ecom
WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01';

-- Step 2 : Average selling price - yearly

SELECT
    YEAR(order_date)                           AS order_year,
    ROUND(AVG(order_item_product_price), 2)    AS avg_item_price,
    MIN(order_item_product_price)              AS min_price,
    MAX(order_item_product_price)              AS max_price,
    COUNT(*)                                   AS order_lines
FROM fact_ecom
WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Step 3 : Average selling price - monthly 2016 vs 2017

SELECT
    MONTH(order_date)       AS month_no,
    MONTHNAME(order_date)   AS month_name,
    ROUND(AVG(CASE WHEN order_date <  '2017-01-01' THEN order_item_product_price END), 2) AS avg_price_2016,
    ROUND(AVG(CASE WHEN order_date >= '2017-01-01' THEN order_item_product_price END), 2) AS avg_price_2017,
    ROUND((AVG(CASE WHEN order_date >= '2017-01-01' THEN order_item_product_price END)
         - AVG(CASE WHEN order_date <  '2017-01-01' THEN order_item_product_price END)) * 100.0
         / NULLIF(AVG(CASE WHEN order_date < '2017-01-01' THEN order_item_product_price END), 0), 1) AS price_yoy_pct,
    SUM(order_date <  '2017-01-01') AS lines_2016,
    SUM(order_date >= '2017-01-01') AS lines_2017
FROM fact_ecom
WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY month_no;

-- Step 4 : Like-for-like test - same product, 2016 vs 2017 (removes mix effect)

WITH prod AS (
    SELECT
        product_card_id,
        AVG(CASE WHEN order_date <  '2017-01-01' THEN order_item_product_price END) AS price_2016,
        AVG(CASE WHEN order_date >= '2017-01-01' THEN order_item_product_price END) AS price_2017
    FROM fact_ecom
    WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
    GROUP BY product_card_id
)
SELECT
    COUNT(*)                                                         AS products_sold_in_both_years,
    SUM(ABS(price_2017 - price_2016) > 0.01)                         AS products_with_price_change,
    ROUND(AVG((price_2017 - price_2016) * 100.0 / price_2016), 2)    AS avg_like_for_like_change_pct
FROM prod
WHERE price_2016 IS NOT NULL AND price_2017 IS NOT NULL;

-- Step 5 : Mix effect - continuing vs new vs discontinued products

WITH prod AS (
    SELECT
        product_card_id,
        SUM(order_date <  '2017-01-01')                                         AS lines_2016,
        SUM(order_date >= '2017-01-01')                                         AS lines_2017,
        SUM(CASE WHEN order_date <  '2017-01-01' THEN order_item_product_price END) AS price_sum_2016,
        SUM(CASE WHEN order_date >= '2017-01-01' THEN order_item_product_price END) AS price_sum_2017
    FROM fact_ecom
    WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
    GROUP BY product_card_id
)
SELECT
    CASE WHEN lines_2016 = 0 THEN 'New in 2017 only'
         WHEN lines_2017 = 0 THEN 'Sold in 2016 only (discontinued)'
         ELSE                     'Sold in both years' END              AS product_group,
    COUNT(*)                                                            AS products,
    SUM(lines_2016)                                                     AS lines_2016,
    SUM(lines_2017)                                                     AS lines_2017,
    ROUND(SUM(price_sum_2016) / NULLIF(SUM(lines_2016), 0), 2)          AS avg_price_2016,
    ROUND(SUM(price_sum_2017) / NULLIF(SUM(lines_2017), 0), 2)          AS avg_price_2017
FROM prod
GROUP BY product_group
ORDER BY products DESC;

-- Step 6 : Average price by department (aggregate fact first, then join the small dimension)

WITH prod AS (
    SELECT
        product_card_id,
        SUM(order_date <  '2017-01-01')                                             AS lines_2016,
        SUM(order_date >= '2017-01-01')                                             AS lines_2017,
        SUM(CASE WHEN order_date <  '2017-01-01' THEN order_item_product_price END) AS price_sum_2016,
        SUM(CASE WHEN order_date >= '2017-01-01' THEN order_item_product_price END) AS price_sum_2017
    FROM fact_ecom
    WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
    GROUP BY product_card_id
)
SELECT
    p.department_name,
    SUM(x.lines_2016)                                                AS lines_2016,
    SUM(x.lines_2017)                                                AS lines_2017,
    ROUND(SUM(x.price_sum_2016) / NULLIF(SUM(x.lines_2016), 0), 2)   AS avg_price_2016,
    ROUND(SUM(x.price_sum_2017) / NULLIF(SUM(x.lines_2017), 0), 2)   AS avg_price_2017
FROM prod x
JOIN product p ON p.product_card_id = x.product_card_id
GROUP BY p.department_name
ORDER BY lines_2016 DESC;

-- Step 7 : Demand by price band (did volume move away from a price tier?)

SELECT
    CASE WHEN order_item_product_price <  50  THEN '1. Under 50'
         WHEN order_item_product_price < 100  THEN '2. 50-99'
         WHEN order_item_product_price < 200  THEN '3. 100-199'
         ELSE                                      '4. 200+' END   AS price_band,
    SUM(order_date <  '2017-01-01')                                AS lines_2016,
    SUM(order_date >= '2017-01-01')                                AS lines_2017,
    ROUND((SUM(order_date >= '2017-01-01') - SUM(order_date < '2017-01-01')) * 100.0
          / NULLIF(SUM(order_date < '2017-01-01'), 0), 1)          AS yoy_pct
FROM fact_ecom
WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
GROUP BY price_band
ORDER BY price_band;
