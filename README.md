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

### Overview
This section describes how we used Python (via Jupyter Notebook) to perform additional Exploratory Data Analysis (EDA) and create visualizations to answer our project questions.

### Steps in the Python Analysis Process

1. **Connect to the MySQL Database and Load Data:**
   - **Goal:** Retrieve the cleaned dataset from MySQL into a Pandas DataFrame.
   

2. **Perform Additional EDA:**
   - **Goal:** Explore the dataset by checking for missing values, summary statistics, and distributions.
   - **Code:**
     ```python
     # Check for missing values
     missing_values = df.isnull().sum()
     print("Missing Values:\n", missing_values)

     # Summary statistics of the dataset
     print(df.describe())

     # Grouping sales by region to understand distribution
     sales_by_region = df.groupby("Region")["Total_Sales"].sum()
     print("Sales by Region:\n", sales_by_region)
     ```
   - **Screenshot:**  
     
     *Screenshot showing missing values and summary statistics.*

3. **Create Visualizations to Showcase Insights:**
   - **Visualization 1: Sales Trends Over Time**
     - **Goal:** Display how sales have changed over time using a line chart.
     - **Code:**
       ```python
       import matplotlib.pyplot as plt

       # Convert Order Date to datetime
       df['Order_Date'] = pd.to_datetime(df['Order_Date'])

       # Create a time series plot for sales trends
       plt.figure(figsize=(12, 6))
       df.set_index('Order_Date')['Total_Sales'].resample('M').sum().plot()
       plt.title("Sales Trends Over Time")
       plt.xlabel("Month")
       plt.ylabel("Total Sales ($)")
       plt.show()
       ```
     - **Screenshot:**  
        
       *Screenshot of the line chart showing sales trends.*

   - **Visualization 2: Distribution of Sales by Product Category**
     - **Goal:** Visualize the total sales for each product category using a bar chart.
     - **Code:**
       ```python
       # Group data by product category and sum total sales
       category_sales = df.groupby("Category")["Total_Sales"].sum().sort_values(ascending=False)

       plt.figure(figsize=(10, 6))
       category_sales.plot(kind='bar', color='teal')
       plt.title("Sales by Product Category")
       plt.xlabel("Product Category")
       plt.ylabel("Total Sales ($)")
       plt.xticks(rotation=45)
       plt.show()
       ```
     - **Screenshot:**  
       
       *Screenshot of the bar chart for product category sales.*

   - **Visualization 3: Correlation Between Age and Total Price**
     - **Goal:** Analyze the relationship between customer age and total purchase amount with a scatter plot.
     - **Code:**
       ```python
       import seaborn as sns

       plt.figure(figsize=(8, 6))
       sns.scatterplot(x='Age', y='Total_Sales', data=df, alpha=0.6)
       plt.title("Correlation Between Age and Total Sales")
       plt.xlabel("Age")
       plt.ylabel("Total Sales ($)")
       plt.show()
       ```
     - **Screenshot:**  
      
       *Screenshot of the scatter plot showing the correlation between age and total sales.*

4. **Save Your Python Scripts:**
   - **File:** The complete Python analysis is saved in `Python_Analysis_Scripts.ipynb`.
   - **Note:** This notebook includes all the steps above, along with additional exploration as needed.

---

---

## 5. Power BI Dashboard

### (To be added: Visual representation of sales insights and key performance indicators.)

---

## 6. Conclusion

### (To be added: Summary of key findings and recommendations.)

---


