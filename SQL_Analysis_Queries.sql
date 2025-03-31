CREATE DATABASE E_COMMERCE_SALES;
USE E_COMMERCE_SALES;

SHOW tables;

SELECT * FROM SALES_CUSTOMER_INSIGHT;

SELECT * FROM SALES_CUSTOMER_INSIGHT;

UPDATE SALES_CUSTOMER_INSIGHT_2
SET Shipping_Fee = ROUND(Shipping_Fee, 2);


ALTER TABLE SALES_CUSTOMER_INSIGHT_2
CHANGE `Shipping Fee` Shipping_Fee DECIMAL(10,2);

ALTER TABLE SALES_CUSTOMER_INSIGHT
CHANGE `Product Name` Product_Name VARCHAR(255),
CHANGE `Unit Price` Unit_Price DECIMAL(10,2),
CHANGE `Total Price` Total_Price DECIMAL(10,2),
CHANGE `Shipping status` Shipping_Status VARCHAR(50);


SELECT * FROM SALES_CUSTOMER_INSIGHT;

SELECT COUNT(*) AS total_records FROM SALES_CUSTOMER_INSIGHT;
use E_COMMERCE_SALES;
SELECT * FROM SALES_CUSTOMER_INSIGHT;
 -- total sales by region
SELECT region, SUM(total_price) AS total_sales
FROM SALES_CUSTOMER_INSIGHT
GROUP BY region
ORDER BY total_sales DESC;

SELECT * FROM SALES_CUSTOMER_INSIGHT;
-- product category that generates the highest revenue
SELECT Category, SUM(Total_Price) AS Total_Revenue
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Category
ORDER BY Total_Revenue DESC
LIMIT 1;
-- average shipping fee by region
SELECT Region, AVG(Shipping_Fee) AS Avg_Shipping_Fee
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Region
ORDER BY Avg_Shipping_Fee DESC;
--  how customer age impacts purchasing behavior

SELECT Age, COUNT(*) AS Total_Purchases, SUM(Total_Price) AS Total_Spent
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Age
ORDER BY Total_Spent DESC;
--  how customer age impacts purchasing behavior
--  Grouping Ages into Ranges

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

-- most popular products by gender
SELECT Gender, Product_Name, COUNT(*) AS Purchase_Count
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Gender, Product_Name
ORDER BY Gender, Purchase_Count DESC;

SELECT Gender, Product_Name, Purchase_Count 
FROM (
    SELECT Gender, Product_Name, COUNT(*) AS Purchase_Count,
           RANK() OVER (PARTITION BY Gender ORDER BY COUNT(*) DESC) AS ranking
    FROM SALES_CUSTOMER_INSIGHT
    GROUP BY Gender, Product_Name
) ranked 
WHERE ranking = 1;
-- order fulfillment rate
-- Order Fulfillment Rate
SELECT Shipping_Status, COUNT(*) AS Order_Count,
       COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS Percentage
FROM SALES_CUSTOMER_INSIGHT
GROUP BY Shipping_Status;

-- Fulfillment Rate Calculation
SELECT 
    (COUNT(CASE WHEN Shipping_Status = 'Delivered' THEN 1 END) * 100.0 / COUNT(*)) AS Fulfillment_Rate,
    (COUNT(CASE WHEN Shipping_Status = 'Returned' THEN 1 END) * 100.0 / COUNT(*)) AS Return_Rate
FROM SALES_CUSTOMER_INSIGHT;

SELECT * FROM SALES_CUSTOMER_INSIGHT;
SELECT * 
FROM SALES_CUSTOMER_INSIGHT
ORDER BY CAST(SUBSTRING(Customer_ID, 6) AS UNSIGNED) ASC;


ALTER TABLE SALES_CUSTOMER_INSIGHT  
CHANGE `Customer ID` Customer_id VARCHAR(255);

SELECT * FROM SALES_CUSTOMER_INSIGHT;
-- sort the Customer ID in ascending order based on the numeric part while keeping the "CUSTO" prefix
SELECT * 
FROM SALES_CUSTOMER_INSIGHT
ORDER BY CAST(SUBSTRING(Customer_ID, 6) AS UNSIGNED) ASC;