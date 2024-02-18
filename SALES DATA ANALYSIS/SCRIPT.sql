SELECT * from customers;
SELECT * from markets;
SELECT * from products;
SELECT * from date;
SELECT * from transactions;

-- GOAL: i will explore all tables one by one. my aim is to make 1 Big tables out of these 5 tables that contain all relevant data that i can use in tableau to do some intresting visulaization.

-- TABLE 1 Customers: 
 SELECT * from customers;
 Select count(DISTINCT customer_type) AS distinct_customer_type from customers;
 Select count(*) As Numbers_of_rows from customers;
 -- I will keep all the data from the Table "customers" as all these columns in this table are important.
 
 -- TABLE 2 MARKETS:
 
 SELECT * from markets;
 
 Select count(DISTINCT markets_name) AS distinct_markets_type from markets;
 
 Select count(*) As Numbers_of_rows from markets;
 
 select distinct zone from markets;
 
 SELECT DISTINCT(markets_name) FROM markets;
 
 SELECT COUNT(DISTINCT(markets_name)) FROM markets;
 
 
 -- Query to seperate markets with respect to Zones. 
 
 SELECT
    zone,
    GROUP_CONCAT(markets_name) AS market_list
FROM
    markets
GROUP BY
    zone;
    
-- Same query to seperate markets with respect to Zones.    

SELECT
    zone,
    markets_name
FROM
    markets
ORDER BY
    zone, markets_name;
 
 
 -- I will keep all the data from the Table "markets" as all these columns in this table are important.
 
 
 -- TABLE 3 PRODUCTS:
 
 SELECT * from products;
 
 Select distinct product_type from products;
 
 Select count(*) As Numbers_of_rows from products;
 
 SELECT DISTINCT(product_type) FROM products;
 
 SELECT COUNT(DISTINCT(product_type)) FROM products;
 
 SELECT DISTINCT(product_type) FROM products;
 
 SELECT DISTINCT(product_code) FROM products;
 
 SELECT COUNT(DISTINCT(product_code)) FROM products;
 
 -- i will also keep all columns in this table too.
 
 -- TABLE 4 DATE:
 
 SELECT * from date;
 
 Select count(*) As Numbers_of_rows from date;
 
 
 -- i will only take one column from here which is date. 
 
 -- TABLE 5 TRANSACTIONS:
 
 SELECT * from transactions;
 
 Select count(*) As Numbers_of_rows from transactions;
 
 SELECT Sum(sales_amount) FROM transactions;
 
 SELECT ROUND(AVG(sales_qty),2) FROM transactions;
 
 SELECT DISTINCT(currency) FROM transactions;
 
 SELECT DISTINCT(market_code) FROM transactions;
 
 SELECT COUNT(DISTINCT(market_code)) FROM transactions;
 

-- Just checking what is sum sales amount and sum sales quantity as per zone with its markets

SELECT zone, markets_name, zone,
SUM(sales_amount),
SUM(sales_qty)

from transactions

join

markets ON transactions.market_code = markets.markets_code

GROUP BY zone, markets_name

order by zone, markets_name;
 
 
 -- I will keep all data from this table Because on the basis of this table i will join all the data from other tables.
 
 
-- Just for my own practice i am joining all data column by column. i can also join all data within one query but i want to join it one by one just to do some practice.



-- I am joining Transactions with products table and naming it A1. 
CREATE TABLE A1 AS
SELECT
	transactions.*,
	products.product_type
    
FROM
    transactions
JOIN
    products ON products.product_code = transactions.product_code;
    
Select * from A1; 



-- Now i am creating Table 2 by combining A1 and Markets.  
  
CREATE TABLE A2 AS
SELECT
	A1.*,
	markets_name,
    markets.zone
    
FROM
    A1
JOIN
    markets ON markets.markets_code = A1.market_code;

SELECT * from A2;

-- Now i am creating A3 by combining A2 and customers. 

CREATE TABLE A3 AS
SELECT
	customers.*,
	A2.product_code,
    A2.market_code,
    A2.order_date,
    A2.sales_qty,
    A2.sales_amount,
    A2.currency,
    A2.product_type,
    A2.markets_name,
    A2.zone
    
FROM
    customers
JOIN
    A2 ON A2.customer_code = customers.customer_code; 
    
SELECT * FROM A3;


-- Now finally i am creating A4 by joining A3 and date table.

CREATE TABLE A4 AS
SELECT
	A3.*
FROM
    A3

    date ON A3.order_date = date.date;

Select * FROM A4;
Select count(*) From A4;

-- Now i have created a BIG table containing 12 columns now i can take this table into Tableau and analyze it.