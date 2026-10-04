# Superstore Sales Analysis using SQL

A SQL project that analyses retail sales data from the Superstore sample dataset to answer 10 business questions about sales, profit, discounts, customers and trends.

**Author:** Siri Yenumula

## Project Overview

This project uses MySQL to explore where a retail store makes and loses money. The analysis covers sales and profit by region, category and customer segment, the effect of discounts on profit, yearly and monthly sales trends, and the top products and customers.

## Dataset

- **Source:** Superstore sample dataset (a public sample dataset, available on Kaggle). It is sample data, not real company data.
- **Size:** 9,994 rows, 21 columns, 5,009 unique orders
- **Period:** Orders from 2011 to 2014
- **Key columns:** Order_ID, Order_Date, Ship_Mode, Customer_Name, Segment, Region, State, Category, Sub_Category, Product_Name, Sales, Quantity, Discount, Profit

## Tools Used

- MySQL and MySQL Workbench (queries and analysis)
- Python with pandas, SQLAlchemy and PyMySQL (loading the CSV into MySQL)

## SQL Concepts Used

Aggregate functions (SUM, AVG, COUNT, COUNT DISTINCT), GROUP BY, HAVING, ORDER BY with LIMIT, CASE WHEN, subqueries, and date functions (YEAR, MONTH).

## Business Questions

1. How many rows and unique orders are there?
2. What are the total sales and profit for each region?
3. Which are the top 10 products by sales?
4. What are the sales and profit for each category and sub-category?
5. What are the sales for each year and month?
6. Which sub-categories have a negative total profit?
7. Which customer segment is the most profitable?
8. Who are the top 10 customers by total sales?
9. How does the average profit change across discount bands (no discount, up to 20%, above 20%)?
10. What percentage of total sales does each category contribute?

## Key Insights

**1. Large discounts lose money.** Average profit per order line falls from 66.90 (no discount) to 26.50 (up to 20% discount) and turns negative at -97.18 for discounts above 20%.

| Discount band | Order lines | Average profit |
|---|---|---|
| No discount | 4,798 | 66.90 |
| Up to 20% | 3,803 | 26.50 |
| Above 20% | 1,393 | -97.18 |

**2. Three sub-categories make a net loss.** Tables (about -17.7K), Bookcases (about -3.5K) and Supplies (about -1.2K) have negative total profit.

**3. Technology and Office Supplies earn far more profit than Furniture.** Sales are similar across the three categories, but Furniture has a profit margin of only about 2.5%, compared with about 17% for the other two.

| Category | Share of sales | Total profit | Profit margin |
|---|---|---|---|
| Technology | 36.4% | about 145K | 17.4% |
| Furniture | 32.3% | about 18K | 2.5% |
| Office Supplies | 31.3% | about 122K | 17.0% |

**4. The Central region has the weakest margin.** The West leads in sales (about 725K) and profit (about 108K), while Central earns only about 40K in profit, a margin of about 8% compared with about 15% in the West.

**5. Sales grew over time and peak at year end.** Yearly sales grew from about 484K in 2011 to about 734K in 2014, with a small dip in 2012. November and December together bring about 30% of all sales.

All 10 insights are written as comments under each query in `superstore_analysis.sql`.

## Repository Files

| File | Description |
|---|---|
| `superstore_analysis.sql` | All queries, supporting queries and insights |
| `load_data.py` | Python script that loads the CSV into a MySQL table |
| `README.md` | Project description |

## How to Run

1. Install MySQL and Python.
2. Download the Superstore CSV file.
3. Install the libraries: `pip install pandas sqlalchemy pymysql`
4. Open `load_data.py` and set the CSV file path, your MySQL password and your database name, then run `python load_data.py`. This creates a table called `superstore`.
5. Open `superstore_analysis.sql` in MySQL Workbench and run the queries.

## Notes and Limitations

- The data is a sample dataset, so the findings illustrate the analysis and do not describe a real business.
- The data is in a single table, so this project does not use joins.
- The results show that discounts and lower profit go together. They do not prove that discounts alone cause the losses.
