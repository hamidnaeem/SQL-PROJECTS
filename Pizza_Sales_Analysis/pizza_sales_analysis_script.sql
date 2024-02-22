
-- First i will create a Data Base.
CREATE DATABASE pizza_sales;

-- Now i am using the data base that i have just created
USE pizza_sales;

SELECT * FROM pizza_sales_analysis;

-- 1) TOTAL REVENUE:

SELECT ROUND(SUM(total_price),2) AS TOTAL_REVENUE FROM pizza_sales_analysis;

-- 2) Average order Value

SELECT ROUND(SUM(total_price)/ COUNT(DISTINCT order_id),2) AS AVG_ORDER_VALUE FROM pizza_sales_analysis;

-- 3) TOTAL PIZZA SOLD

SELECT SUM( quantity) AS TOTAL_PIZZA_SOLD FROM pizza_sales_analysis;

-- 4)TOTAL ORDERS PLACED:

SELECT COUNT( DISTINCT order_id) AS TOTAL_ORDERS FROM pizza_sales_analysis;


-- 5) AVERAGE PIZZA PER ORDER:

SELECT SUM(quantity) / COUNT(DISTINCT order_id) AS AVG_PIZZAS_PER_ORDER FROM pizza_sales_analysis;


-- 6) Number of orders per Hour
SELECT
  DATE_FORMAT(order_time, '%Y-%m-%d %H:00:00') AS hour_of_day,
  SUM(quantity) AS pizzas_sold_in_hour
FROM
  pizza_sales_analysis
GROUP BY
  hour_of_day
ORDER BY
  hour_of_day;
  
-- 7) REVENEU PER MONTH:
  
SELECT DISTINCT MONTH(STR_TO_DATE(order_date, '%m-%d-%Y')) AS distinct_month,  ROUND(SUM(total_price),2)
FROM pizza_sales_analysis
GROUP BY distinct_month
ORDER BY SUM(total_price) DESC;
  
-- 8) QUANTITY per month:
  
  SELECT DISTINCT MONTH(STR_TO_DATE(order_date, '%m-%d-%Y')) AS distinct_month,  COUNT(DISTINCT order_id)
FROM pizza_sales_analysis
GROUP BY distinct_month
ORDER BY COUNT(DISTINCT order_id) DESC;
  
  
-- 9) Orders per month:
  SELECT DISTINCT MONTH(STR_TO_DATE(order_date, '%m-%d-%Y')) AS distinct_month,  ROUND(SUM(quantity),2)
FROM pizza_sales_analysis
GROUP BY distinct_month
ORDER BY SUM(quantity) DESC;
  
  
-- 10) SALES AND PERCENT SALES PER CATEGORY: 
  
  SELECT 
  pizza_category, 
  ROUND(SUM(total_price), 2) AS Total_sales,
  ROUND((SUM(total_price) / (SELECT SUM(total_price) FROM pizza_sales_analysis)) * 100, 2) AS PERCENT_SALES_CATEGORY
FROM 
  pizza_sales_analysis
GROUP BY 
  pizza_category;


-- 11) SALES AND PERCENTAGE PER SIZE:

SELECT 
  pizza_size, 
  ROUND(SUM(total_price), 2) AS Total_sales,
  ROUND((SUM(total_price) / (SELECT SUM(total_price) FROM pizza_sales_analysis)) * 100, 2) AS PERCENT_SALES_PER_NAME
FROM 
  pizza_sales_analysis
GROUP BY 
  pizza_size;

-- 12) SALES AND PERCENTAGE PER SIZE:

SELECT 
  pizza_name, 
  ROUND(SUM(total_price), 2) AS Total_sales,
  ROUND((SUM(total_price) / (SELECT SUM(total_price) FROM pizza_sales_analysis)) * 100, 2) AS PERCENT_SALES_PER_SIZE
FROM 
  pizza_sales_analysis
GROUP BY 
  pizza_name;

SELECT * FROM pizza_sales_analysis;

-- 13) Orders with the Highest Quantity:

SELECT * 
FROM pizza_sales_analysis
ORDER BY quantity DESC
LIMIT 1;


-- 14) Total Sales for a Specific Order:

SELECT order_id, SUM(total_price) AS total_sales
FROM pizza_sales_analysis
WHERE order_id = '195'
GROUP BY order_id;

-- 15) Total Sales for a Specific Pizza Name

SELECT pizza_name, SUM(total_price) AS total_sales
FROM pizza_sales_analysis
WHERE pizza_name = 'The Thai Chicken Pizza'
GROUP BY pizza_name;


-- 16) Orders with Quantity Greater Than 5:

SELECT *
FROM pizza_sales_analysis
WHERE quantity > 3;

-- 17) Top 5 Highest Total Sales:

SELECT order_id, total_price
FROM pizza_sales_analysis
ORDER BY total_price DESC
LIMIT 5;

-- 18) Orders on a Specific Date:

SELECT *
FROM pizza_sales_analysis
WHERE order_date = '01-01-2015';

-- 19) Busiest Order Date:

SELECT order_date, COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales_analysis
GROUP BY order_date
ORDER BY total_orders DESC
LIMIT 1;

-- 20) MOST IMPORTANT KPI OF ALL (Most Ordered Pizza):

SELECT pizza_name, SUM(quantity) AS total_quantity_ordered
FROM pizza_sales_analysis
GROUP BY pizza_name
ORDER BY total_quantity_ordered DESC
LIMIT 1;







