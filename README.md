# E-commerce Sales Data Analysis

This project involves analyzing e-commerce sales data through data cleaning in Excel and SQL, performing SQL queries to extract insights, conducting further analysis using Python, and visualizing the results with Power BI.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Excel Data Cleaning Process](#excel-data-cleaning-process)
3. [SQL Analysis](#sql-analysis)
4. [Python Analysis](#python-analysis)
5. [Power BI Dashboard](#power-bi-dashboard)
6. [Conclusion](#conclusion)

---

## 1. Introduction

### Overview
This dataset contains sales transactions from an e-commerce platform. It includes customer demographics, order details, pricing, shipping status, and order dates.

### Purpose of the Analysis
- Analyze total sales by region.
- Identify the product category generating the highest revenue.
- Calculate the average shipping fee by region.
- Examine how customer age impacts purchasing behavior.
- Determine the most popular product by gender.
- Assess the order fulfillment rate (delivered vs. returned).

---

## 2. Excel Data Cleaning Process

### Handling Missing Values
- Identified missing values using Excel’s `COUNTBLANK()` function.
- Filled missing values for `Age` and `Region` using:
  ```excel
  =IF(A2="", "Unknown", A2)
  ```
  where `A2` represents the column with missing values.

### Standardizing Formats
- Converted all date values to `YYYY-MM-DD` using Excel’s `TEXT()` function:
  ```excel
  =TEXT(A2, "YYYY-MM-DD")
  ```
- Standardized product categories and pricing formats.

---

## 3. SQL Analysis

After cleaning the dataset, SQL queries were used to extract insights.

### Data Cleaning in SQL
```sql
ALTER TABLE SALES_CUSTOMER_INSIGHT
CHANGE `Product Name` Product_Name VARCHAR(255),
CHANGE `Unit Price` Unit_Price DECIMAL(10,2),
CHANGE `Total Price` Total_Price DECIMAL(10,2),
CHANGE `Shipping status` Shipping_Status VARCHAR(50);
```

### SQL Query Analysis

#### 1. Total Sales by Region
```sql
SELECT region, SUM(total_price) AS total_sales
FROM SALES_CUSTOMER_INSIGHT
GROUP BY region
ORDER BY total_sales DESC;
```
<img width="950" alt="total_sales results by region" src="https://github.com/user-attachments/assets/c61dc104-156d-4bed-8d37-4151d7d23d69" />


#### 2. Product Category with Highest Revenue
```sql
SELECT Category, SUM(Total_Price) AS Total_Revenue
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Category
ORDER BY Total_Revenue DESC
LIMIT 1;
```
<img width="950" alt="product category that generates the highest revenue" src="https://github.com/user-attachments/assets/345f3378-4e71-4fa2-a23f-9c9efd43f75c" />

#### 3. Average Shipping Fee by Region
```sql
SELECT Region, AVG(Shipping_Fee) AS Avg_Shipping_Fee
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Region
ORDER BY Avg_Shipping_Fee DESC;
```
<img width="950" alt="average shipping fee by region" src="https://github.com/user-attachments/assets/de0e047a-2565-4363-bd9e-b9bb178638a5" />

#### 4. Customer Age Impact on Purchasing Behavior
```sql
SELECT Age, COUNT(*) AS Total_Purchases, SUM(Total_Price) AS Total_Spent
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Age
ORDER BY Total_Spent DESC;
```
<img width="953" alt="how customer age impact purchasing power" src="https://github.com/user-attachments/assets/9c7fb61b-e67f-44e3-a269-a4ed1fa245c0" />
<img width="953" alt="how customer age impact purchasing power1" src="https://github.com/user-attachments/assets/337188d0-e8e2-4e3b-a279-d3958546e768" />
<img width="955" alt="how customer age impact purchasing power2" src="https://github.com/user-attachments/assets/d6e548cb-ebda-4387-8113-1a5769f71ac7" />
<img width="950" alt="how customer age impact purchasing power3" src="https://github.com/user-attachments/assets/acc59f9a-bb24-4770-a42b-0bbb73848f6b" />

#### 5. Grouping Ages into Ranges
```sql
SELECT 
  CASE 
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 50 THEN '36-50'
    ELSE '50+'
  END AS Age_Group,
  COUNT(*) AS Total_Purchases,
  SUM(Total_Price) AS Total_Spent
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Age_Group
ORDER BY Total_Spent DESC;
```
<img width="955" alt="Grouping Ages into Ranges" src="https://github.com/user-attachments/assets/d9530f7c-fece-4303-beb8-29224037d2d6" />

#### 6. Most Popular Product by Gender
```sql
SELECT Gender, Product_Name, COUNT(*) AS Purchase_Count
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Gender, Product_Name
ORDER BY Gender, Purchase_Count DESC;
```
<img width="950" alt="most popular product by gender" src="https://github.com/user-attachments/assets/6582e5a5-54c6-4667-a0f0-3b34c2b0b5c9" />

**Alternative with Ranking:**
```sql
SELECT Gender, Product_Name, Purchase_Count 
FROM (
    SELECT Gender, Product_Name, COUNT(*) AS Purchase_Count,
           RANK() OVER (PARTITION BY Gender ORDER BY COUNT(*) DESC) AS ranking
    FROM SALES_CUSTOMER_INSIGHT
    GROUP BY Gender, Product_Name
) ranked 
WHERE ranking = 1;
```
<img width="956" alt="most popular product by gender1" src="https://github.com/user-attachments/assets/18e97899-f45e-47d5-8c5d-7747807a25ad" />

#### 7. Order Fulfillment Rate
```sql
SELECT Shipping_Status, COUNT(*) AS Order_Count,
       COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS Percentage
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Shipping_Status;
```
<img width="950" alt="order fulfilment rate1" src="https://github.com/user-attachments/assets/ab0349e0-6c46-460b-9119-9e58b3e13cdc" />

#### 8. Fulfillment vs. Return Rate
```sql
SELECT 
    (COUNT(CASE WHEN Shipping_Status = 'Delivered' THEN 1 END) * 100.0 / COUNT(*)) AS Fulfillment_Rate,
    (COUNT(CASE WHEN Shipping_Status = 'Returned' THEN 1 END) * 100.0 / COUNT(*)) AS Return_Rate
FROM SALES_CUSTOMER_INSIGHT;
```
<img width="950" alt="order fulfillment rate calculation" src="https://github.com/user-attachments/assets/35462aae-e184-41f9-8a93-676b80c2a71b" />

#### 9. Sorting Customer IDs
```sql
ALTER TABLE SALES_CUSTOMER_INSIGHT  
CHANGE `Customer ID` Customer_id VARCHAR(255);

SELECT * 
FROM SALES_CUSTOMER_INSIGHT
ORDER BY CAST(SUBSTRING(Customer_ID, 6) AS UNSIGNED) ASC;
```
<img width="932" alt="sort customer id in ascending order" src="https://github.com/user-attachments/assets/1506c2dc-4e79-4f79-842c-a9e140dc605c" />
<img width="953" alt="sort customer id in ascending order1" src="https://github.com/user-attachments/assets/60496f15-61d6-4d82-8360-7105e82e5790" />

---

---

## 4. Python Analysis

# Sales Data Analysis Project

## Overview
Analysis of a 1000-record sales dataset to identify key trends and patterns in customer purchasing behavior.

## Installation
```python
# Install required packages
pip install pandas numpy matplotlib seaborn
```

## Loading and Exploring Data
```python
# Import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load dataset
df = pd.read_csv("sales_cleaneddata_from_msql.csv")

# Check data basics
df.head()
df.isnull().sum()  # No missing values
df.duplicated().sum()  # No duplicates
```

## Dataset Highlights
- 1000 sales records with customer info, product details, and shipping data
- Three product categories: Electronics (47.7%), Accessories (40.1%), Wearables (12.2%)
- Customer demographics: 52.4% Male, 47.6% Female; Ages 18-69 (avg: 46.9)
- Shipping statuses: In Transit (32.9%), Delivered (31.3%), Returned (30.8%)

## Key Visualizations

### 1. Sales by Product Category
```python
# Aggregate total sales per category
category_sales = df.groupby('Category')['Total_Price'].sum().sort_values(ascending=False)

# Plot bar chart
plt.figure(figsize=(10, 5))
sns.barplot(x=category_sales.index, y=category_sales.values, palette='viridis')
plt.xlabel("Product Category")
plt.ylabel("Total Sales")
plt.title("Total Sales by Product Category")
plt.show()
```

### 2. Top Products by Revenue
```python
# Most profitable products
df.groupby("Product_Name")["Total_Price"].sum().sort_values(ascending=False).head(5)
```

### 3. Shipping Status Distribution
```python
# Plot shipping status counts
shipping_counts = df['Shipping_Status'].value_counts()
plt.figure(figsize=(8, 5))
sns.barplot(x=shipping_counts.index, y=shipping_counts.values, palette='coolwarm')
plt.xlabel("Shipping Status")
plt.ylabel("Number of Orders")
plt.title("Order Distribution by Shipping Status")
plt.show()
```

### 4. Monthly Sales Trend
```python
# Convert date and plot trend
df['Order Date'] = pd.to_datetime(df['Order Date'], errors='coerce')
df.set_index('Order Date', inplace=True)
df.resample('ME')['Total_Price'].sum().plot(
    title='Monthly Sales Trend', 
    figsize=(10, 5), 
    marker='o', 
    color='b'
)
plt.ylabel("Total Sales")
plt.show()
```

## Key Findings

### Product Insights
- Electronics generate highest revenue despite fewer units sold
- Laptops are most profitable ($696,000 total sales)
- Monitors are top-selling by quantity (503 units)

### Customer & Regional Insights
```python
# Check age-spending correlation
correlation = df['Age'].corr(df['Total_Price'])
print(f"Correlation between Age and Total Price: {correlation}")  # 0.039

# Regional distribution
region_quantity = df.groupby('Region')['Quantity'].sum().sort_values(ascending=False)
```
- Minimal correlation between age and spending
- Sales evenly distributed across regions (West, South, East, North)
- West region leads slightly in quantity sold

### Business Metrics
- High return rate (30.8%) warrants investigation
- Higher-priced items purchased in smaller quantities
- No strong seasonal trends identified in monthly sales


---

## 5. Power BI Dashboard

### Overview
Using Power BI, we built an interactive dashboard that aggregates key metrics from our e-commerce sales data. The dashboard includes insights on total sales, revenue by product category, shipping status, and more. It is designed to be user-friendly and visually appealing, with various visualizations such as maps, bar charts, and pie charts. The dashboard has been published to Power BI Service, and a link to the live dashboard is provided below.

**Dashboard Link:** [View Live Power BI Dashboard](https://app.powerbi.com/your-dashboard-link)

---

### 5.1 Customer Sales Report

**Description:**  
This page provides an overall view of customer sales performance. It includes:
- **Key Metrics:** Total sales, total orders, and average order value.
- **Visualizations:** A combination of KPI cards and a bar chart displaying total sales by region.
- **Insight:** Quickly identifies regions with the highest sales, enabling targeted strategies.

**Screenshot:**  
![Customer Sales](https://github.com/user-attachments/assets/e8a38f1b-db29-496c-b98b-975b714f0dd1)

---

### 5.2 Customer Insights

**Description:**  
This page focuses on customer demographics and purchasing behavior. It includes:
- **Visualizations:**  
  - Sales by age group using a clustered bar chart.
  - Sales by gender using a pie chart.
- **Insight:** Highlights how different customer segments contribute to overall revenue, allowing for more targeted marketing efforts.

**Screenshot:**  
![Customer Insights](https://github.com/user-attachments/assets/643f73d7-fba5-4b11-917f-c34ba4536ea5)

---

### 5.3 Product Performance

**Description:**  
This page analyzes product-related metrics. It features:
- **Visualizations:**  
  - A bar chart displaying total sales by product category and region.
  - A detailed view of top-performing products.
- **Insight:** Helps identify which product categories are driving revenue and how regional performance varies.

**Screenshot:**  
![Product Performance](https://github.com/user-attachments/assets/fac436f7-93be-4361-8dba-01c02354de0f)

---

### 5.4 Shipping Analysis

**Description:**  
This page evaluates the shipping performance and operational efficiency. It includes:
- **Visualizations:**  
  - A line chart showing delivery date trends.
  - A bar chart depicting delivery status by region.
  - A pie chart representing shipping fees by region.
- **Insight:** Provides a comprehensive view of order fulfillment and shipping cost distribution, highlighting potential areas for logistics improvement.

**Screenshot:**  
![Shipping insights](https://github.com/user-attachments/assets/fd2268b5-ab71-41ac-a41e-ebfa0b7b96d3)




---

## 6. Conclusion

### (To be added: Summary of key findings and recommendations.)

---


