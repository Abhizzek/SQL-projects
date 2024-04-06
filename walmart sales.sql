CREATE DATABASE IF NOT EXISTS salesDataWalmart

use salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
      invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
      branch VARCHAR(5) NOT NULL,
      city VARCHAR(30) NOT NULL,
      customer_type VARCHAR(30) NOT NULL, 
      gender VARCHAR(10) NOT NULL,
      product_line VARCHAR(100) NOT NULL,
      unit_price DECIMAL(10,2) NOT NULL,
      quantity INT NOT NULL,
      VAT DECIMAL(6,4) NOT NULL,
      total DECIMAL(12,4) NOT NULL,
      date DATETIME NOT NULL,
      time TIME NOT NULL,
      payment_method VARCHAR(15) NOT NULL,
      cogs DECIMAL(10,2) NOT NULL,
      gross_margin_pct DECIMAL(11,9),
      gross_income DECIMAL(12,4) NOT NULL,
      rating DECIMAL(2,1)
      );
      
      -- ------------------------------Feature engineering----------------------------------------------------------------------------
      
      -- time_of_day
      
SELECT 
    time,
    CASE 
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_date
FROM sales;

Alter TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
CASE 
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
END 
);


-- day_name column

SELECT 
   date
FROM sales ;

SELECT 
  date,
  DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales 
SET day_name= DAYNAME(date);

-- month_name --- 

SELECT 
  date,
  MONTHNAME(date) AS month_name

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales 
SET month_name= MONTHNAME(date);


-- EDA ------------------------------------------------------------------------------- GENERIC -------------------------------------

-- how many unique cities does the data have?
SELECT DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT DISTINCT branch
FROM sales;

SELECT DISTINCT city,branch 
FROM SALES;

-- how many unique product line does the data have?
SELECT COUNT(DISTINCT product_line)
FROM sales; 

-- what is the most common payment method?
SELECT payment_method,
COUNT(payment_method) AS cnt
FROM sales 
GROUP BY payment_method
ORDER BY cnt DESC;

-- What is the most selling product line?
SELECT product_line,
COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- What is the total revenue by month?
SELECT month_name AS monthname,
SUM(total) AS revenue 
FROM sales
GROUP BY month_name
ORDER BY revenue DESC;

-- What month has the largest COGS?(COST OF GOODS SOLD)
SELECT month_name AS monthname,
SUM(cogs) AS cogs 
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;

-- What  product line had the largest revenue?
SELECT product_line AS product_line,
SUM(total) AS TotalRevenue 
FROM sales
GROUP BY product_line
ORDER BY TotalRevenue DESC;

-- What is the city with the largest revenue?
SELECT branch, city,
SUM(total) AS TotalRevenue 
FROM sales
GROUP BY branch,city
ORDER BY TotalRevenue DESC;

-- What product line had the largest VAT?
SELECT product_line AS productline,
AVG(VAT) AS avgtax 
FROM sales
GROUP BY productline
ORDER BY avgtax DESC;

-- FETCH each product line and add a column to those product line showing 'Good', "Bad". Good if geater than average sales



-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS QTY
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT gender,product_line,
COUNT(gender) AS total_cnt
FROM sales
GROUP BY GENDER, product_line
ORDER BY total_cnt DESC; 

-- What is average rating of each product?
SELECT product_line AS productline,
ROUND(AVG(rating),2) AS avgrating 
FROM sales
GROUP BY productline
ORDER BY avgrating DESC;

-- Number of sales made in each time of the day per weekday
SELECT time_of_day,COUNT(*) AS total_sales
FROM sales
WHERE day_name="Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT 
     customer_type,
     SUM(total) AS total_rev
FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- 