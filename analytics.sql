-- 4. BUSINESS INSIGHTS & ANALYTICS

-- KPI: High-Level Overview
SELECT 
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Sales)/COUNT(DISTINCT Order_ID), 2) AS Avg_Order_Value,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers
FROM clean_ecommerce;

-- TREND: Monthly Sales Growth
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS Sales_Month,
    ROUND(SUM(Sales), 2) AS Monthly_Revenue
FROM clean_ecommerce
GROUP BY Sales_Month
ORDER BY Sales_Month;

-- SEGMENTATION: Customer Value Analysis
SELECT 
    Customer_ID,
    Customer_Name,
    ROUND(SUM(Sales), 2) AS Total_Spent,
    CASE 
        WHEN SUM(Sales) > 10000 THEN 'VIP'
        WHEN SUM(Sales) BETWEEN 5000 AND 10000 THEN 'Regular'
        ELSE 'Low Value'
    END AS Customer_Segment
FROM clean_ecommerce
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Spent DESC;

-- PRODUCT: Top 10 Performing Products (By Rank)
SELECT * FROM (
    SELECT 
        Product_Name,
        Category,
        SUM(Sales) AS Revenue,
        RANK() OVER (ORDER BY SUM(Sales) DESC) AS sales_rank
    FROM clean_ecommerce
    GROUP BY Product_Name, Category
) t
WHERE sales_rank <= 10;