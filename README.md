# E-commerce Sales Analysis Hackathon

This project is of hackathon participation that requires analyzing e-commerce sales data through data cleaning in Excel and SQL, performing SQL queries to extract data insights, conducting further analysis using Python, and visualizing the results with Power BI.

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
The dataset contains sales transactions from an e-commerce platform. It includes customer demographics, order details, pricing, shipping status, and order dates.

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

### 1.Total Sales by Product Category
```python
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd

# df is my DataFrame

# Aggregate total sales per category
category_sales = df.groupby('Category')['Total_Price'].sum().sort_values(ascending=False)

# Plot bar chart
plt.figure(figsize=(10, 5))
sns.barplot(x=category_sales.index, y=category_sales.values, hue=category_sales.index, legend=False, palette='viridis')  # Corrected line
plt.xticks(rotation=45)
plt.xlabel("Product Category")
plt.ylabel("Total Sales")
plt.title("Total Sales by Product Category")
plt.show()
```
<img width="934" alt="Total sales by product category" src="https://github.com/user-attachments/assets/269f38eb-6267-49d7-8274-c2672f849cde" />

### 2. Sales Distribution by Region (Pie Chart)
# Insight: Identify which regions contribute the most to sales.
```python
# Most profitable products
df.groupby("Product_Name")["Total_Price"].sum().sort_values(ascending=False).head(5)
```
<img width="936" alt="Sales distribution by region" src="https://github.com/user-attachments/assets/aa0fbe82-5fe5-480f-af5a-34182598788f" />
<img width="932" alt="sales distribution by region1" src="https://github.com/user-attachments/assets/d5d84c6c-fc69-4b70-be9c-167035302631" />

### 3. Relationship Between Unit Price and Quantity Sold (Scatter Plot)
# Insight: Check if higher-priced products sell in larger or smaller quantities.
```python
# Scatter plot
plt.figure(figsize=(8, 5))
sns.scatterplot(data=df, x='Unit_Price', y='Quantity', alpha=0.7)
plt.xlabel("Unit Price")
plt.ylabel("Quantity Sold")
plt.title("Unit Price vs Quantity Sold")
plt.show()
```
<img width="949" alt="Unit price vs Quantity sold " src="https://github.com/user-attachments/assets/823efea3-4945-4fc9-a3c6-f5273deec375" />

### 4. Shipping Status Distribution (Bar Chart)
# Insight: Understand the proportion of orders delivered, returned, or in transit.
```python
import matplotlib.pyplot as plt
import seaborn as sns

# df is my DataFrame

shipping_counts = df['Shipping_Status'].value_counts()

plt.figure(figsize=(8, 5))
sns.barplot(x=shipping_counts.index, y=shipping_counts.values, hue=shipping_counts.index, legend=False, palette='coolwarm')  # Corrected line
plt.xlabel("Shipping Status")
plt.ylabel("Number of Orders")
plt.title("Order Distribution by Shipping Status")
plt.show()
```
<img width="941" alt="Order distribution by shipping status" src="https://github.com/user-attachments/assets/d06f3bf5-b424-4279-ae16-6cf5d8d196fd" />

### 5. Sales Distribution by Gender (Bar Chart)
#Insight: Understand sales performance across different genders.
```python
import seaborn as sns
import matplotlib.pyplot as plt

gender_sales = df.groupby('Gender')['Total_Price'].sum()

plt.figure(figsize=(6, 4))
sns.barplot(x=gender_sales.index, y=gender_sales.values, hue=gender_sales.index, legend=False, palette='pastel')  # Corrected line
plt.xlabel("Gender")
plt.ylabel("Total Sales")
plt.title("Sales Distribution by Gender")
plt.show()
```
<img width="932" alt="Sales distribution by gender" src="https://github.com/user-attachments/assets/910e568e-2b9f-4660-bc96-2a196762777b" />
<img width="945" alt="sales distribution by gender1" src="https://github.com/user-attachments/assets/ceabf3df-8f64-4c9b-beab-f65b649391b7" />

### 6. Quantity Sold by Region (Bar Chart)
# Insight: Identify which regions have the highest sales volume.
```python
import seaborn as sns
import matplotlib.pyplot as plt

region_quantity = df.groupby('Region')['Quantity'].sum().sort_values(ascending=False)

plt.figure(figsize=(8, 5))
sns.barplot(x=region_quantity.index, y=region_quantity.values, hue=region_quantity.index, legend=False, palette='Set2')  # Corrected line
plt.xlabel("Region")
plt.ylabel("Total Quantity Sold")
plt.title("Quantity Sold by Region")
plt.show()
```
<img width="928" alt="Qantity sold by region" src="https://github.com/user-attachments/assets/17a9a662-4428-4308-b719-6a4229786794" />

### 7. Average Unit Price by Category (Bar Chart)
# Insight: Compare the average price of products across different categories.
```python
import seaborn as sns
import matplotlib.pyplot as plt

category_avg_price = df.groupby('Category')['Unit_Price'].mean().sort_values(ascending=False)

plt.figure(figsize=(10, 5))
sns.barplot(x=category_avg_price.index, y=category_avg_price.values, hue=category_avg_price.index, legend=False, palette='plasma')  # Corrected line
plt.xlabel("Category")
plt.ylabel("Average Unit Price")
plt.title("Average Unit Price by Category")
plt.show()
```
<img width="941" alt="Average unit price by category" src="https://github.com/user-attachments/assets/b303f153-d647-4fc9-9655-dfd0c307a64b" />

### 8.  Total Price Distribution (Histogram)
# Insight: Visualize the distribution of total prices to identify common price ranges.
```python
import matplotlib.pyplot as plt

plt.figure(figsize=(8, 5))
plt.hist(df['Total_Price'], bins=20, color='skyblue', edgecolor='black')
plt.xlabel("Total Price")
plt.ylabel("Frequency")
plt.title("Total Price Distribution")
plt.show()
```
<img width="937" alt="Total price distribution" src="https://github.com/user-attachments/assets/d100e5f6-f49e-4764-8fa3-274c1ddbbb40" />

### 9. Sales Trend Over Time (Line Chart)
# Insight: Identify sales performance trends over months.
```python
import pandas as pd
import matplotlib.pyplot as plt

# 'df' is my DataFrame with 'Order Date' and 'Total_Price' columns

# Making 'Order Date' to be  in datetime format
df['Order Date'] = pd.to_datetime(df['Order Date'], errors='coerce')

# Set 'Order Date' as index
df.set_index('Order Date', inplace=True)

# Resample data monthly and plot sales trend
df.resample('M')['Total_Price'].sum().plot(title='Monthly Sales Trend', figsize=(10, 5), marker='o', color='b')

plt.ylabel("Total Sales")
plt.show()
```
<img width="937" alt="monthly sales trend" src="https://github.com/user-attachments/assets/5c3a373f-3d0d-493f-9461-8c9d56ba6482" />

#### 10. Shipping Fee Distribution (Box Plot)
# Insight: Understand the spread and outliers in shipping fees.
```python
import seaborn as sns
import matplotlib.pyplot as plt

plt.figure(figsize=(6, 4))
sns.boxplot(y=df['Shipping_Fee'], color='lightgreen')
plt.ylabel("Shipping Fee")
plt.title("Shipping Fee Distribution")
plt.show()
```
<img width="926" alt="shipping fee distribution" src="https://github.com/user-attachments/assets/e8dfa53a-085a-474d-9eba-66270d5866bc" />

### 11.  Correlation between age and total price. 
```python
import seaborn as sns
import matplotlib.pyplot as plt
#using seaborn to see the correlation 
plt.figure(figsize=(8, 5))
sns.scatterplot(data=df, x='Age', y='Total_Price', alpha=0.7)
plt.xlabel("Age")
plt.ylabel("Total Price")
plt.title("Correlation between Age and Total Price")
plt.show()
```
<img width="944" alt="correlation between age and total price" src="https://github.com/user-attachments/assets/89ea7823-a41e-409a-b0ea-c3a5296d6b99" />

### 12  correlation matrix
```python
import seaborn as sns
import matplotlib.pyplot as plt

# Select only numeric columns
numeric_df = df.select_dtypes(include=['number'])

# Compute correlation matrix
corr_matrix = numeric_df.corr()

# Plot heatmap
plt.figure(figsize=(8, 6))
sns.heatmap(corr_matrix, annot=True, cmap="coolwarm", fmt=".2f")
plt.title("Correlation Matrix")
plt.show()
```
<img width="955" alt="correlation matrix" src="https://github.com/user-attachments/assets/048b5f79-4b44-4bb9-8651-2a55e78cf943" />

### 13.  Box plot for numerical variables
```python
import seaborn as sns
import matplotlib.pyplot as plt
# Boxplot for outlier detection
numerical_cols = ['Unit_Price', 'Quantity', 'Total_Price', 'Shipping_Fee']
plt.figure(figsize=(12, 6))
sns.boxplot(data=df[numerical_cols])
plt.title("Boxplot of Numerical Variables")
plt.show()
```
<img width="941" alt="box plot for numerical variables" src="https://github.com/user-attachments/assets/c37911d0-7fe0-46f7-a76e-37abad9f9966" />

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

### Summary of Findings  
From our comprehensive analysis of the e-commerce sales data, we identified key trends and insights:  

- **Sales Trends Over Time:** January recorded the highest sales revenue, indicating strong demand at the beginning of the year.  
- **Top-Selling Product Category:** Electronics emerged as the most sold product category, contributing significantly to overall revenue.  
- **Sales by Region:** Certain regions generated higher sales, highlighting potential markets for expansion and targeted marketing.  
- **Customer Behavior:**  
  - Younger age groups (26-35) demonstrated higher purchasing activity.  
  - Product preferences varied between genders, influencing sales trends.  
- **Shipping and Order Fulfillment:**  
  - Most orders were successfully delivered. 
  - Shipping fees varied across regions, affecting purchase decisions.  

### Recommendations  
Based on these insights, we propose the following strategies for business growth:  

1. **Leverage Seasonal Trends**  
   - Prepare for high demand in January by optimizing inventory and marketing campaigns.  
   - Offer promotional discounts in off-peak months to boost sales.  

2. **Product Strategy Enhancement**  
   - Focus on Electronics as a key product category and expand offerings based on customer demand.  
   - Optimize inventory levels to ensure availability of top-selling products.  

3. **Targeted Marketing and Customer Engagement**  
   - Use customer age and gender preferences to personalize recommendations.  
   - Implement loyalty programs and targeted ads in high-performing regions.  

4. **Shipping and Logistics Optimization**  
   - Improve delivery efficiency in regions with higher return rates.  
   - Adjust pricing strategies for shipping fees to enhance affordability and customer satisfaction.  

--- 
Compiled by: Allan Cheruiyot - SALLCH2311
            Romars Marigi   -  SMARRO2211
---



