SET SQL_SAFE_UPDATES = 0;
-- Convert data columns to proper format 
UPDATE superstore 
SET order_date = STR_TO_DATE(order_date, '%m/%d/%Y'),
ship_date = STR_TO_DATE(ship_date, '%m/%d/%Y');
ALTER TABLE superstore 
MODIFY order_date DATE,
MODIFY ship_date DATE;
-- Validating Numeric Columns 
SELECT sales , quantity , discount, profit 
From superstore 
LIMIT 20;

-- Checking Null Values

SELECT SUM(order_id IS NULL) AS order_id_nulls,
SUM(customer_id IS NULL ) AS customer_nulls,
SUM(sales IS NULL) AS sales_nulls,
SUM(profit IS NULL) AS profit_nulls
FROM superstore;

-- Checking for duplicates

Select row_id , count(*)
FROM superstore
GROUP BY row_id
HAVING COUNT(*) > 1;

-- Checking date range 
SELECT
MIN(order_date) AS earliest_order,
MAX(order_date) AS latest_order
FROM superstore;

-- Creating a clean table to keep raw data safe and only work on clean table

CREATE TABLE superstore_Clean AS
SELECT * FROM superstore;

-- Checking for negative or weird values
-- Business Review: Loss-making transactions
-- Negative profit is possible and not treated as a data error

SELECT *
FROM superstore_clean
where sales <0 OR profit <0;

-- Data Quality Check: Negative sales values
-- Negative sales are suspicious and should be reviewed
SELECT *
FROM superstore_clean
WHERE sales < 0;

-- Checking discount range
SELECT MIN(discount) , MAX(discount)
FROM superstore;

-- Checking quantity issues
SELECT *
FROM superstore_clean
WHERE quantity <=0;

-- Checking missing important fields
SELECT *
FROM superstore_clean
WHERE customer_id IS NULL
OR product_id IS NULL;

-- Feature Enginerring

-- Extracting Year, Month
SELECT 
order_date,
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month
From superstore_Clean
LIMIT 10;

-- Extracting Month Name
Select 
order_date,
MONTHNAME(order_date) AS month_name
FROM superstore
LIMIT 10;

-- Creating profit category

SELECT 
	profit, 
	CASE
		WHEN profit < 0 THEN 'LOSS'
		WHEN profit = 0 THEN 'Break-even'
		ELSE 'PROFIT'
	END AS profit_type
FROM superstore;

-- Shipping Delay
SELECT
	order_date,
    ship_date,
    DATEDIFF(ship_date, order_date) AS shipping_days
FROM superstore_clean;

-- Checkinh shipping logic

SELECT *
FROM superstore_clean
WHERE ship_date < order_date;

-- CREATING FINAL ANALYTICAL TABLE 

-- Now we build a clean + enriched dataset
CREATE TABLE superstore_final AS
SELECT 
    *,
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    MONTHNAME(order_date) AS month_name,
    DATEDIFF(ship_date, order_date) AS shipping_days,
    CASE 
        WHEN profit < 0 THEN 'Loss'
        WHEN profit = 0 THEN 'Break-even'
        ELSE 'Profit'
    END AS profit_type
FROM superstore;