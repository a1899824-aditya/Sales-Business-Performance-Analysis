-- Dashboard Table 1: kpi_summary;

create table kpi_summary AS
SELECT
	SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity,
    SUM(profit)/SUM(sales) AS profit_margin
FROM superstore_final;


-- Dashboard Table 2: Monthly Trend
DROP TABLE IF EXISTS monthly_trend;
create table monthly_trend AS
	select
		date_format(order_date, '%Y-%m') AS month,
        sum(sales) as total_sales,
        sum(profit) as total_profit
from superstore_final
group by month
order by month;
        

-- Dashboard Table 3: Category Performance

Drop table if exists category_performance;

create table category_performance AS
SELECT
	category,
    sum(sales) as total_sales,
    sum(profit) as total_profit
from superstore_final
group by CATEGORY ;

-- Dashboard Table 4: Sub-category Performance

Drop table if exists subcategory_performance;

Create table subcategory_performance AS
select
	sub_category,
    sum(sales) AS total_sales,
    sum(profit) as total_profit,
    sum(profit)/sum(sales) as profit_ratio
from superstore_final
group by sub_category;


-- -----------------------------------------
-- Dashboard Table 6: Shipping Analysis
-- -----------------------------------------
DROP TABLE IF EXISTS shipping_performance;

CREATE TABLE shipping_performance AS
SELECT 
    CASE 
        WHEN shipping_days <= 2 THEN 'Fast'
        WHEN shipping_days <= 5 THEN 'Medium'
        ELSE 'Slow'
    END AS shipping_speed,
    
    COUNT(*) AS total_orders,
    AVG(profit) AS avg_profit

FROM superstore_final
GROUP BY shipping_speed;	


-- -----------------------------------------
-- Dashboard Table 7: Discount Impact
-- -----------------------------------------
DROP TABLE IF EXISTS discount_analysis;

CREATE TABLE discount_analysis AS
SELECT 
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.2 THEN 'Low'
        WHEN discount <= 0.5 THEN 'Medium'
        ELSE 'High'
    END AS discount_level,
    
    COUNT(*) AS total_orders,
    AVG(profit) AS avg_profit

FROM superstore_final
GROUP BY discount_level;

DROP TABLE IF EXISTS kpi_summary;

CREATE TABLE kpi_summary (
    total_sales DECIMAL(15,2),
    total_profit DECIMAL(15,2),
    total_orders INT,
    total_quantity INT,
    profit_margin DECIMAL(10,4)
);

INSERT INTO kpi_summary
SELECT 
    SUM(sales),
    SUM(profit),
    COUNT(DISTINCT order_id),
    SUM(quantity),
    SUM(profit)/SUM(sales)
FROM superstore_final;
