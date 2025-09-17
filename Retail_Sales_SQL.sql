-- Create TABLE

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender varchar(10),
		age INT,
		category varchar(15),
		quantity INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
	);

select *
from retail_sales
limit 5

select 
	count(*)
from retail_sales


-- Data Cleaning

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR 
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL 
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	

-- 
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
	age IS NULL
	OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;


-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many unique customers we have ?
SELECT COUNT(DISTINCT customer_id) as unique_customer FROM retail_sales

--How Many Categorts we have?
SELECT DISTINCT category FROM retail_sales


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


select * from retail_sales

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select *
from retail_sales
where sale_date = '2022-11-05'


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022

select * 
from retail_sales
where 
	  category = 'Clothing'
	  AND
	  TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	  AND
	  quantity > 2


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select 
	category,
	sum(total_sale) as net_sale,
	 COUNT(*) as total_orders
from retail_sales
group by 1



-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
		round(avg(age),0) as avg_age
from retail_sales
where category = 'Beauty'



-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select 
	*
from retail_sales
where total_sale > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
	count(*) as  total_trans,
	gender,
	category
from retail_sales
group by 2,3
order by 3


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select 
	year,
	month,
	avg_sale
from
(
select 
	extract(YEAR from sale_date) as year,
	extract(MONTH from sale_date) as month,
	avg(total_sale) as avg_sale,
	rank() over(partition by extract(YEAR from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1,2
) as t1
where rank = 1

select * from retail_sales


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
	group by 1
	order by 2 desc 
	limit  5


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select 
	count(DISTINCT customer_id) as unique_customers,
	category
from retail_sales
group by 2


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
as
(
select *,
	CASE
		WHEN extract(HOUR from sale_time) < 12 THEN 'Morning'
		WHEN extract(HOUR from sale_time) between 12 AND 17 THEN 'Afternoon'
		else 'Evening'
	END as shift
from retail_sales
)
select 
	count(*) total_orders,
	shift
from hourly_sale
group by 2


--Q.11 What is the monthly sales trend?
select * from retail_sales

select  
	TO_CHAR(sale_date,'YYYY-MM') as month,
	sum(total_sale)  as monthly_sales
from retail_sales
group by 1
order by 1


--Q.12 Who are the most loyal customers (customers with more than 5 purchases)?
select 
	customer_id,
	count(*) as total_orders,
	sum(total_sale) as total_spent
from retail_sales
group by 1
having count(*)>5
order by 3 desc


--Q.13 What percentage of total revenue does each category contribute?

select  
	category,
	round((sum(total_sale) * 100/ (select sum(total_sale) from retail_sales))::numeric,2) as revenue_percentage	
from retail_sales
group by 1
order by 2 desc


--Q.14 Which are the top 3 months with the highest total sales?

select 
	TO_CHAR(sale_date, 'YYYY-MM') as month,
	sum(total_sale) as total_sale
from retail_sales
group by 1
order by 2 desc
limit 3












