/*
Business Problem:
Total orders declined in 2017 compared to 2016.

Hypothesis H2:
Discounts decreased, so customers had less incentive to buy.

Columns used: order_item_discount, order_item_discount_rate, order_date
(order_item_product_price and order_item_quantity are used to express discount as % of gross value)

Decision rule:
 H2 is supported only if average discount rate / discount share / share of discounted lines FELL in 2017.
*/

-- Step 1 : Yearly discount KPIs

SELECT
    YEAR(order_date)                                              AS order_year,
    COUNT(*)                                                      AS order_lines,
    ROUND(AVG(order_item_discount_rate) * 100, 2)                 AS avg_discount_rate_pct,
    ROUND(AVG(order_item_discount), 2)                            AS avg_discount_amount,
    ROUND(SUM(order_item_discount) * 100.0
          / SUM(order_item_product_price * order_item_quantity), 2) AS discount_pct_of_gross,
    ROUND(SUM(order_item_discount > 0) * 100.0 / COUNT(*), 1)     AS pct_lines_discounted,
    SUM(order_item_discount)                                      AS total_discount_given
FROM fact_ecom
WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Step 2 : Monthly discount rate vs volume, 2016 vs 2017

SELECT
    MONTH(order_date)       AS month_no,
    MONTHNAME(order_date)   AS month_name,
    ROUND(AVG(CASE WHEN order_date <  '2017-01-01' THEN order_item_discount_rate END) * 100, 2) AS avg_disc_rate_2016,
    ROUND(AVG(CASE WHEN order_date >= '2017-01-01' THEN order_item_discount_rate END) * 100, 2) AS avg_disc_rate_2017,
    SUM(order_date <  '2017-01-01') AS lines_2016,
    SUM(order_date >= '2017-01-01') AS lines_2017
FROM fact_ecom
WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY month_no;

-- Step 3 : Distribution of discount rate buckets (did the mix of deals change?)

SELECT
    CASE WHEN order_item_discount_rate = 0     THEN '1. No discount'
         WHEN order_item_discount_rate <= 0.05 THEN '2. up to 5%'
         WHEN order_item_discount_rate <= 0.10 THEN '3. 5-10%'
         WHEN order_item_discount_rate <= 0.15 THEN '4. 10-15%'
         WHEN order_item_discount_rate <= 0.20 THEN '5. 15-20%'
         ELSE                                       '6. Over 20%' END AS discount_bucket,
    SUM(order_date <  '2017-01-01')                                    AS lines_2016,
    SUM(order_date >= '2017-01-01')                                    AS lines_2017,
    ROUND(SUM(order_date <  '2017-01-01') * 100.0 /
          (SELECT COUNT(*) FROM fact_ecom
            WHERE order_date >= '2016-01-01' AND order_date < '2017-01-01'), 1) AS share_2016_pct,
    ROUND(SUM(order_date >= '2017-01-01') * 100.0 /
          (SELECT COUNT(*) FROM fact_ecom
            WHERE order_date >= '2017-01-01' AND order_date < '2018-01-01'), 1) AS share_2017_pct
FROM fact_ecom
WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
GROUP BY discount_bucket
ORDER BY discount_bucket;

-- Step 4 : Discount rate by department (aggregate fact by product first, then roll up)

WITH prod AS (
    SELECT
        product_card_id,
        SUM(order_date <  '2017-01-01')                                                  AS lines_2016,
        SUM(order_date >= '2017-01-01')                                                  AS lines_2017,
        SUM(CASE WHEN order_date <  '2017-01-01' THEN order_item_discount_rate END)      AS rate_sum_2016,
        SUM(CASE WHEN order_date >= '2017-01-01' THEN order_item_discount_rate END)      AS rate_sum_2017
    FROM fact_ecom
    WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
    GROUP BY product_card_id
)
SELECT
    p.department_name,
    SUM(x.lines_2016)                                                       AS lines_2016,
    SUM(x.lines_2017)                                                       AS lines_2017,
    ROUND(SUM(x.rate_sum_2016) * 100.0 / NULLIF(SUM(x.lines_2016), 0), 2)   AS avg_disc_rate_2016_pct,
    ROUND(SUM(x.rate_sum_2017) * 100.0 / NULLIF(SUM(x.lines_2017), 0), 2)   AS avg_disc_rate_2017_pct
FROM prod x
JOIN product p ON p.product_card_id = x.product_card_id
GROUP BY p.department_name
ORDER BY lines_2016 DESC;

-- Step 5 : Does discounting hold in the weak period? (2016 vs 2017 Jan-Sep vs 2017 Oct-Dec)

SELECT
    CASE WHEN order_date <  '2017-01-01' THEN '2016 full year'
         WHEN order_date <  '2017-10-01' THEN '2017 Jan-Sep'
         ELSE                                 '2017 Oct-Dec' END           AS period,
    COUNT(*)                                                               AS order_lines,
    ROUND(AVG(order_item_discount_rate) * 100, 2)                          AS avg_discount_rate_pct,
    ROUND(SUM(order_item_discount > 0) * 100.0 / COUNT(*), 1)              AS pct_lines_discounted
FROM fact_ecom
WHERE order_date >= '2016-01-01' AND order_date < '2018-01-01'
GROUP BY period
ORDER BY MIN(order_date);
