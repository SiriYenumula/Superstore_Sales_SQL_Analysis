import pandas as pd
from sqlalchemy import create_engine

# 1) Change this to the real location of your original Superstore.csv (use forward slashes)
file_path = r"C:\Users\Admin\Downloads\Superstore.csv\Superstore_Sales.csv"

df = pd.read_csv(file_path, encoding="latin-1")

# Make column names MySQL-friendly: "Order ID" -> "Order_ID", "Sub-Category" -> "Sub_Category"
df.columns = [c.replace(" ", "_").replace("-", "_") for c in df.columns]

# Dates in this file are day-month-year
df["Order_Date"] = pd.to_datetime(df["Order_Date"], format="%d-%m-%Y")
df["Ship_Date"] = pd.to_datetime(df["Ship_Date"], format="%d-%m-%Y")

# 2) Change YOUR_PASSWORD and your_database_name
engine = create_engine("mysql+pymysql://root:siri135@localhost:3306/projects")

df.to_sql("superstore", engine, if_exists="replace", index=False)
print("Rows loaded:", len(df))