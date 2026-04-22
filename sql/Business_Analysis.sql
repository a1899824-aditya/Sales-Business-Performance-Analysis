SELECT 
	SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity
FROM superstore_final;

-- Checking Profitability

Select
	profit_type,
    COUNT(*) AS total_orders,
    SUM(profit) AS total_profit
FROM superstore_final
GROUP BY profit_type;

-- Time Analysis

Select
	YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore_final
GROUP BY year, month
ORDER BY year, month;

-- Viewing the top categories

SELECT
	category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore_final
GROUP BY category
ORDER BY total_sales DESC;

-- Viewing Regional Performance
Select 
	region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore_final
GROUP BY region;

-- Looking which categories are causing losses

SELECT
	category,
    SUM(profit) AS total_profit
FROM superstore_final
GROUP BY category
ORDER BY total_profit ASC;


SELECT 
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore_final
GROUP BY sub_category
ORDER BY total_profit ASC;

-- Discount Impact Analysis
Select
	discount,
    COUNT(*) AS orders,
    AVG(profit) AS avg_profit
From superstore_final
group by discount
order by discount;

-- Analyzing Discounts
Select 
	CASE
    when discount = 0 then 'No Discount'
    when discount <= 0.2 then 'Low Discount'
    when discount <= 0.5 then 'Medium Discount'
    ELSE 'High Discount'
END AS discount_level,
count(*) as orders,
avg(profit) as avg_profit

FROM superstore_final
GROUP BY discount_level;

-- Customer Behavior Analysis
SELECT
	customer_id,
    SUM(sales) AS total_spent
FROM superstore_final
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Repeat vs one-time customers
select
	count(*) as total_customers,
    sum(case when order_count = 1 then 1 else 0 end) as one_time_customers,
    sum(case when order_count > 1 then 1 else 0 end) as repeat_customers
    FROM (
		SELECT customer_id , count(order_id) as order_count
		from superstore_final
        group by customer_id
	) t;
    
-- Does slow shipping affect profit?
select
	case
		when shipping_days <=2 then 'Fast'
        when shipping_days <=5 then 'Medium'
        else 'Slow'
	END AS shipping_speed,
    
    COUNT(*) as orders,
    AVG(profit) AS avg_profit
FROM superstore_final
group by shipping_speed;

-- Regional + Category Combination

SELECT 
    region,
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore_final
GROUP BY region, category
ORDER BY region, total_sales DESC;

-- Time-Based Trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore_final
GROUP BY month
ORDER BY month;


SELECT 
    MONTH(order_date) AS month,
    AVG(sales) AS avg_sales
FROM superstore_final
GROUP BY month
ORDER BY month;

-- Profit Margin
SELECT 
    SUM(profit) / SUM(sales) AS profit_margin
FROM superstore_final;

-- Loss Rate 

SELECT 
    SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS loss_percentage
FROM superstore_final;

-- Top vs Worst Subcategories

SELECT 
    sub_category,
    SUM(profit) AS total_profit
FROM superstore_final
GROUP BY sub_category
ORDER BY total_profit DESC
LIMIT 5;

SELECT 
    sub_category,
    SUM(profit) AS total_profit
FROM superstore_final
GROUP BY sub_category
ORDER BY total_profit ASC
LIMIT 5;

-- Sales vs Profit Efficiency

SELECT 
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit)/SUM(sales) AS profit_ratio
FROM superstore_final
GROUP BY sub_category
ORDER BY profit_ratio ASC;


ALTER USER 'root'@'localhost'
IDENTIFIED WITH mysql_native_password BY 'adminmca23';

FLUSH PRIVILEGES;
