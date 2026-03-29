-- Standardizing Column Names to Snake_Case
ALTER TABLE ecommerce_table RENAME COLUMN `Row ID` TO Row_ID;
ALTER TABLE ecommerce_table RENAME COLUMN `Order ID` TO Order_ID;
ALTER TABLE ecommerce_table RENAME COLUMN `Order Date` TO Order_Date;
ALTER TABLE ecommerce_table RENAME COLUMN `Ship Date` TO Ship_Date;
ALTER TABLE ecommerce_table RENAME COLUMN `Ship Mode` TO Ship_Mode;
ALTER TABLE ecommerce_table RENAME COLUMN `Customer ID` TO Customer_ID;
ALTER TABLE ecommerce_table RENAME COLUMN `Customer Name` TO Customer_Name;
ALTER TABLE ecommerce_table RENAME COLUMN `Postal Code` TO Postal_Code;
ALTER TABLE ecommerce_table RENAME COLUMN `Sub-Category` TO Sub_Category;
ALTER TABLE ecommerce_table RENAME COLUMN `Product Name` TO Product_Name;

-- 2. DATA CLEANING & STANDARDIZATION

-- Disable safe updates for bulk cleaning
SET SQL_SAFE_UPDATES = 0;

-- A. Handle NULLs and Trim Strings
UPDATE ecommerce_table
SET 
    Sales = IFNULL(Sales, 0),
    Profit = IFNULL(Profit, 0),
    Quantity = IFNULL(Quantity, 1), -- Default quantity to 1 if null
    Discount = IFNULL(Discount, 0),
    Customer_Name = TRIM(Customer_Name),
    City = TRIM(City),
    Product_Name = TRIM(Product_Name);

-- B. Standardize Mixed Date Formats
-- Converts both MM/DD/YYYY and DD-MM-YYYY to standard YYYY-MM-DD
UPDATE ecommerce_table
SET Order_Date = CASE 
    WHEN Order_Date LIKE '%/%' THEN STR_TO_DATE(Order_Date, '%m/%d/%Y')
    WHEN Order_Date LIKE '%-%' THEN STR_TO_DATE(Order_Date, '%d-%m-%Y')
    ELSE Order_Date 
END;

-- C. Final Datatype Alignment (Optional but recommended)
ALTER TABLE ecommerce_table MODIFY COLUMN Order_Date DATE;

SET SQL_SAFE_UPDATES = 1;