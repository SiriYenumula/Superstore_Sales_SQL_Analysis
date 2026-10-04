-- =====================================================================
-- Superstore Sales Analysis using SQL
-- Dataset : Superstore sample dataset (9,994 rows, 21 columns)
-- Tool    : MySQL (MySQL Workbench)
-- Loading : Data was loaded into MySQL with a Python script (load_data.py)
-- Table   : superstore (columns use underscores, e.g. Order_ID, Sub_Category;
--           Order_Date and Ship_Date are DATE columns)
-- =====================================================================

CREATE DATABASE IF NOT EXISTS projects;
USE projects;


-- ---------------------------------------------------------------------
-- SETUP: check that the data loaded correctly
-- ---------------------------------------------------------------------
SELECT * FROM superstore LIMIT 5;
SHOW COLUMNS FROM superstore;

-- How many columns are in the table? (expected: 21)
SELECT COUNT(*) AS total_columns
FROM information_schema.columns
WHERE table_schema = 'projects'
  AND table_name = 'superstore';

-- How many rows are in the table? (expected: 9994)
SELECT COUNT(*) AS total_rows FROM superstore;

-- What are the total sales and total profit across all regions?
SELECT SUM(Sales) AS total_sales, SUM(Profit) AS total_profit FROM superstore;


-- =====================================================================
-- LEVEL 1: BASICS
-- =====================================================================

-- 1. How many rows are there, and how many unique orders?
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT Order_ID) AS unique_orders
FROM superstore;

-- INSIGHT 1: The data has 9,994 order lines across 5,009 unique orders,
-- so each order has about 2 products on average.


-- 2. What are the total sales and profit for each Region?
SELECT Region,
       SUM(Sales) AS total_sales,
       SUM(Profit) AS total_profit
FROM superstore
GROUP BY Region
ORDER BY total_sales DESC;

-- Supporting query for Insight 2: profit margin (profit / sales) by region
SELECT Region,
       ROUND(SUM(Profit) / SUM(Sales) * 100, 1) AS profit_margin_pct
FROM superstore
GROUP BY Region
ORDER BY profit_margin_pct DESC;

-- INSIGHT 2: The West region leads in sales (about 725K) and profit (about 108K).
-- Central has the lowest profit (about 40K) and the weakest margin (about 8%),
-- compared with about 15% in the West.


-- 3. Which are the top 10 products by sales?
SELECT Product_Name, SUM(Sales) AS total_sales
FROM superstore
GROUP BY Product_Name
ORDER BY total_sales DESC
LIMIT 10;

-- Supporting query for Insight 3: share of total sales from the top 10 products
SELECT ROUND(SUM(product_sales) / (SELECT SUM(Sales) FROM superstore) * 100, 1) AS top10_products_share_pct
FROM (
    SELECT SUM(Sales) AS product_sales
    FROM superstore
    GROUP BY Product_Name
    ORDER BY product_sales DESC
    LIMIT 10
) AS top10;

-- INSIGHT 3: The Canon imageCLASS 2200 Advanced Copier is the top product
-- with about 61.6K in sales, more than double the second product (about 27K).
-- The top 10 products make up about 11% of total sales.


-- 4. What are the sales and profit for each Category and Sub-Category?
SELECT Category,
       Sub_Category,
       SUM(Sales) AS total_sales,
       SUM(Profit) AS total_profit
FROM superstore
GROUP BY Category, Sub_Category
ORDER BY Category, total_sales DESC;

-- INSIGHT 4: Technology (about 145K) and Office Supplies (about 122K) earn far more profit
-- than Furniture (about 18K), even though sales are similar.
-- Phones have the highest sales (about 330K), but Copiers earn the most profit (about 55.6K).


-- =====================================================================
-- LEVEL 2: BUSINESS QUESTIONS
-- =====================================================================

-- 5. What are the sales for each year and month?
SELECT YEAR(Order_Date) AS year,
       MONTH(Order_Date) AS month,
       SUM(Sales) AS total_sales
FROM superstore
GROUP BY year, month
ORDER BY year, month;

-- Supporting query for Insight 5: sales by calendar month (all years combined)
SELECT MONTH(Order_Date) AS month,
       ROUND(SUM(Sales), 0) AS total_sales
FROM superstore
GROUP BY month
ORDER BY total_sales DESC;

-- Supporting query for Insight 5: share of sales in November and December
SELECT ROUND(SUM(CASE WHEN MONTH(Order_Date) IN (11, 12) THEN Sales ELSE 0 END)
             / SUM(Sales) * 100, 1) AS nov_dec_share_pct
FROM superstore;

-- INSIGHT 5: Yearly sales grew from about 484K in 2011 to about 734K in 2014 (a small dip in 2012).
-- November and December together bring about 30% of all sales, with November 2014
-- the best month (about 112K). Sales are lowest in January and February.


-- 6. Which Sub-Categories have a negative total profit?
SELECT Sub_Category, SUM(Profit) AS total_profit
FROM superstore
GROUP BY Sub_Category
HAVING total_profit < 0
ORDER BY total_profit;

-- INSIGHT 6: Tables, Bookcases and Supplies make a net loss.
-- Tables lose the most (about 17.7K), followed by Bookcases (about 3.5K) and Supplies (about 1.2K).


-- 7. Which Segment is the most profitable?
SELECT Segment, SUM(Profit) AS total_profit
FROM superstore
GROUP BY Segment
ORDER BY total_profit DESC;

-- Supporting query for Insight 7: profit margin by segment
SELECT Segment,
       ROUND(SUM(Profit) / SUM(Sales) * 100, 1) AS profit_margin_pct
FROM superstore
GROUP BY Segment
ORDER BY profit_margin_pct DESC;

-- INSIGHT 7: The Consumer segment earns the most profit (about 134K) and has the most sales.
-- Home Office is the smallest segment, but has the best margin (about 14%).


-- 8. Who are the top 10 customers by total sales?
SELECT Customer_Name, SUM(Sales) AS total_sales
FROM superstore
GROUP BY Customer_Name
ORDER BY total_sales DESC
LIMIT 10;

-- Supporting query for Insight 8: share of total sales from the top 10 customers
SELECT ROUND(SUM(customer_sales) / (SELECT SUM(Sales) FROM superstore) * 100, 1) AS top10_customers_share_pct
FROM (
    SELECT SUM(Sales) AS customer_sales
    FROM superstore
    GROUP BY Customer_Name
    ORDER BY customer_sales DESC
    LIMIT 10
) AS top10;

-- INSIGHT 8: The top customer is Sean Miller (about 25K in sales).
-- The top 10 customers together bring only about 7% of total sales,
-- so the business does not depend on a few customers.


-- =====================================================================
-- LEVEL 3: ANALYSIS
-- =====================================================================

-- 9. Put Discount into bands (0, up to 20%, above 20%) and compare the average profit
--    in each band. Does a higher discount reduce profit?
--    (Discount is stored as a fraction: 0.2 means 20%.)
SELECT CASE
           WHEN Discount = 0 THEN 'No discount'
           WHEN Discount <= 0.2 THEN 'Up to 20%'
           ELSE 'Above 20%'
       END AS discount_band,
       COUNT(*) AS order_lines,
       ROUND(AVG(Profit), 2) AS avg_profit
FROM superstore
GROUP BY discount_band;

-- INSIGHT 9: Average profit falls from 66.90 (no discount) to 26.50 (up to 20%)
-- and turns negative at -97.18 above 20%, so large discounts lose money.


-- 10. What percentage of total sales does each Category contribute?
SELECT Category,
       SUM(Sales) AS category_sales,
       ROUND(SUM(Sales) / (SELECT SUM(Sales) FROM superstore) * 100, 2) AS sales_percentage
FROM superstore
GROUP BY Category
ORDER BY sales_percentage DESC;

-- Supporting query for Insight 10: profit margin by category
SELECT Category,
       ROUND(SUM(Profit) / SUM(Sales) * 100, 1) AS profit_margin_pct
FROM superstore
GROUP BY Category
ORDER BY profit_margin_pct DESC;

-- INSIGHT 10: Technology contributes the most to sales (about 36%),
-- followed by Furniture (about 32%) and Office Supplies (about 31%).
-- Sales are spread fairly evenly, but Furniture earns a much lower profit (margin about 2.5%).
