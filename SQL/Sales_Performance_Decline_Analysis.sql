-- ============================================================================
-- Sales Performance Decline - SQL analysis
-- Runs directly on your table: ecommerce_logistics_cleaned  (no renaming, no view)
-- ============================================================================

--  1: PROBLEM - yearly orders, sales, order value, items per order
-- expect 2017: 21866 orders, avg_order_value 540.04, items_per_order 2.43
SELECT order_year,
       COUNT(DISTINCT "Order Id") AS orders,
       ROUND(SUM("Sales")) AS sales,
       ROUND(SUM("Sales")*1.0/COUNT(DISTINCT "Order Id"),2) AS avg_order_value,
       ROUND(COUNT(*)*1.0/COUNT(DISTINCT "Order Id"),2) AS items_per_order
FROM ecommerce_logistics_cleaned
WHERE order_year <= 2017
GROUP BY order_year
ORDER BY order_year;

--  2: WHERE - Jan-Sep vs Oct-Dec (the whole drop is in Oct-Dec 2017)
-- expect Oct-Dec avg_order_value 596 (2016) to 351 (2017)
SELECT order_year,
       CASE WHEN CAST(strftime('%m', "order date (DateOrders)") AS INT) >= 10 THEN 'Oct-Dec' ELSE 'Jan-Sep' END AS period,
       COUNT(DISTINCT "Order Id") AS orders,
       ROUND(SUM("Sales")) AS sales,
       ROUND(SUM("Sales")*1.0/COUNT(DISTINCT "Order Id")) AS avg_order_value
FROM ecommerce_logistics_cleaned
WHERE order_year IN (2016, 2017)
GROUP BY order_year, period
ORDER BY period, order_year;

--  3: WHEN - month by month in 2017 (items per order falls to 1 from October)
SELECT strftime('%m', "order date (DateOrders)") AS month,
       COUNT(DISTINCT "Order Id") AS orders,
       ROUND(SUM("Sales")) AS sales,
       ROUND(COUNT(*)*1.0/COUNT(DISTINCT "Order Id"),2) AS items_per_order
FROM ecommerce_logistics_cleaned
WHERE order_year = 2017
GROUP BY month
ORDER BY month;

--  4: EXACT DAY - items per order is exactly 1.00 from 3 Oct 2017
SELECT date("order date (DateOrders)") AS day,
       COUNT(DISTINCT "Order Id") AS orders,
       ROUND(COUNT(*)*1.0/COUNT(DISTINCT "Order Id"),2) AS items_per_order
FROM ecommerce_logistics_cleaned
WHERE "order date (DateOrders)" >= '2017-09-29' AND "order date (DateOrders)" < '2017-10-07'
GROUP BY day
ORDER BY day;

--  5: RULE OUT other causes - discount, cancellations, shipping mix (before vs after 3 Oct 2017)
-- expect discount 0.102 and cancellations about 2% in both rows
SELECT CASE WHEN "order date (DateOrders)" < '2017-10-03' THEN 'before' ELSE 'after' END AS phase,
       COUNT(DISTINCT "Order Id") AS orders,
       ROUND(AVG("Order Item Quantity"),2) AS avg_units,
       ROUND(AVG("Order Item Discount Rate"),3) AS avg_discount,
       ROUND(100.0*AVG(is_cancelled),2) AS cancelled_pct,
       ROUND(100.0*AVG(CASE WHEN "Shipping Mode"='Standard Class' THEN 1.0 ELSE 0 END),1) AS standard_ship_pct
FROM ecommerce_logistics_cleaned
WHERE order_year <= 2017
GROUP BY phase;

--  6: ORDER COMPOSITION - share of single-item orders per year
-- expect 19.9% (2016) to 42.9% (2017)
SELECT order_year,
       COUNT(*) AS orders,
       ROUND(100.0*AVG(CASE WHEN n = 1 THEN 1.0 ELSE 0 END),1) AS single_item_pct,
       ROUND(AVG(n),2) AS avg_items
FROM (SELECT "Order Id", MIN(order_year) AS order_year, COUNT(*) AS n
      FROM ecommerce_logistics_cleaned
      WHERE order_year <= 2017
      GROUP BY "Order Id")
GROUP BY order_year
ORDER BY order_year;

--  7: PURCHASING PATTERN - customers and orders per customer
-- expect orders_per_customer 2.04 (2016) to 1.44 (2017)
SELECT order_year,
       COUNT(DISTINCT "Customer Id") AS customers,
       ROUND(COUNT(DISTINCT "Order Id")*1.0/COUNT(DISTINCT "Customer Id"),2) AS orders_per_customer
FROM ecommerce_logistics_cleaned
WHERE order_year <= 2017
GROUP BY order_year
ORDER BY order_year;

-- 8: PURCHASING PATTERN - did customers after 3 Oct 2017 order before? (expect 0)
SELECT COUNT(DISTINCT "Customer Id") AS customers_after_break,
       COUNT(DISTINCT CASE WHEN "Customer Id" IN
            (SELECT "Customer Id" FROM ecommerce_logistics_cleaned WHERE "order date (DateOrders)" < '2017-10-03')
            THEN "Customer Id" END) AS also_ordered_before
FROM ecommerce_logistics_cleaned
WHERE "order date (DateOrders)" >= '2017-10-03' AND order_year <= 2017;

--  9: PRODUCT LEVEL - department sales change 2017 vs 2016
-- expect Fan Shop about -1.44M, Golf about -423K, Technology about +1.04M
SELECT "Department Name" AS department,
       ROUND(SUM(CASE WHEN order_year = 2016 THEN "Sales" ELSE 0 END)) AS sales_2016,
       ROUND(SUM(CASE WHEN order_year = 2017 THEN "Sales" ELSE 0 END)) AS sales_2017,
       ROUND(SUM(CASE WHEN order_year = 2017 THEN "Sales" ELSE 0 END)
           - SUM(CASE WHEN order_year = 2016 THEN "Sales" ELSE 0 END)) AS change
FROM ecommerce_logistics_cleaned
GROUP BY "Department Name"
ORDER BY change;

--  10: SOLUTION - size of the gap in Oct-Dec 2017 if order value had held at the Oct-Dec 2016 level
-- expect gap about 1.54M (illustration, not a forecast)
SELECT COUNT(DISTINCT "Order Id") AS orders_q4_2017,
       ROUND(SUM("Sales")) AS actual_sales,
       ROUND(COUNT(DISTINCT "Order Id") * (SELECT SUM("Sales")*1.0/COUNT(DISTINCT "Order Id")
              FROM ecommerce_logistics_cleaned
              WHERE "order date (DateOrders)" >= '2016-10-01' AND "order date (DateOrders)" < '2017-01-01')) AS if_order_value_held,
       ROUND(COUNT(DISTINCT "Order Id") * (SELECT SUM("Sales")*1.0/COUNT(DISTINCT "Order Id")
              FROM ecommerce_logistics_cleaned
              WHERE "order date (DateOrders)" >= '2016-10-01' AND "order date (DateOrders)" < '2017-01-01')) - ROUND(SUM("Sales")) AS gap
FROM ecommerce_logistics_cleaned
WHERE "order date (DateOrders)" >= '2017-10-01' AND "order date (DateOrders)" < '2018-01-01';

--  11: SOLUTION - bundle ideas: products bought together before the break
-- expect top pair 8375 orders (Perfect Rip Deck + CJ Elite 2 cleat)
SELECT a."Product Name" AS item_1, b."Product Name" AS item_2, COUNT(*) AS orders_together
FROM ecommerce_logistics_cleaned a
JOIN ecommerce_logistics_cleaned b
  ON a."Order Id" = b."Order Id" AND a."Product Card Id" < b."Product Card Id"
WHERE a."order date (DateOrders)" < '2017-10-03'
GROUP BY item_1, item_2
ORDER BY orders_together DESC
LIMIT 8;

--  12: SOLUTION - first-time buyers to win back with a second-purchase offer (through Jan 2018)
-- expect 8288
SELECT COUNT(*) AS first_time_buyers_to_target
FROM (SELECT "Customer Id"
      FROM ecommerce_logistics_cleaned
      WHERE "order date (DateOrders)" >= '2017-10-03'
      GROUP BY "Customer Id"
      HAVING COUNT(DISTINCT "Order Id") = 1);
