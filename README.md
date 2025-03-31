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

#### 2. Product Category with Highest Revenue
```sql
SELECT Category, SUM(Total_Price) AS Total_Revenue
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Category
ORDER BY Total_Revenue DESC
LIMIT 1;
```

#### 3. Average Shipping Fee by Region
```sql
SELECT Region, AVG(Shipping_Fee) AS Avg_Shipping_Fee
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Region
ORDER BY Avg_Shipping_Fee DESC;
```

#### 4. Customer Age Impact on Purchasing Behavior
```sql
SELECT Age, COUNT(*) AS Total_Purchases, SUM(Total_Price) AS Total_Spent
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Age
ORDER BY Total_Spent DESC;
```

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

#### 6. Most Popular Product by Gender
```sql
SELECT Gender, Product_Name, COUNT(*) AS Purchase_Count
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Gender, Product_Name
ORDER BY Gender, Purchase_Count DESC;
```

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

#### 7. Order Fulfillment Rate
```sql
SELECT Shipping_Status, COUNT(*) AS Order_Count,
       COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS Percentage
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Shipping_Status;
```

#### 8. Fulfillment vs. Return Rate
```sql
SELECT 
    (COUNT(CASE WHEN Shipping_Status = 'Delivered' THEN 1 END) * 100.0 / COUNT(*)) AS Fulfillment_Rate,
    (COUNT(CASE WHEN Shipping_Status = 'Returned' THEN 1 END) * 100.0 / COUNT(*)) AS Return_Rate
FROM SALES_CUSTOMER_INSIGHT;
```

#### 9. Sorting Customer IDs
```sql
ALTER TABLE SALES_CUSTOMER_INSIGHT  
CHANGE `Customer ID` Customer_id VARCHAR(255);

SELECT * 
FROM SALES_CUSTOMER_INSIGHT
ORDER BY CAST(SUBSTRING(Customer_ID, 6) AS UNSIGNED) ASC;
```

---

## 4. Python Analysis

### (To be added: Exploratory Data Analysis and Visualization using Python.)

---

## 5. Power BI Dashboard

### (To be added: Visual representation of sales insights and key performance indicators.)

---

## 6. Conclusion

### (To be added: Summary of key findings and recommendations.)

---


