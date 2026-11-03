
USE ecommerce_analysis;

-- 1. Total Sales
SELECT
    SUM(o.Quantity * p.UnitPrice_Clean * (1 - o.Discount)) AS Total_Sales
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
WHERE o.OrderStatus = 'Delivered';


-- 2. Total Profit
SELECT
    SUM(
        o.Quantity *
        (p.UnitPrice_Clean * (1 - o.Discount)
        - CAST(REGEXP_REPLACE(p.UnitCost, '[^0-9.]', '') AS DECIMAL(10,2)))
    ) AS Total_Profit
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
WHERE o.OrderStatus = 'Delivered';


-- 3. Monthly Sales
SELECT
    MONTH(STR_TO_DATE(o.OrderDate, '%d-%b-%y')) AS Month_Number,
    SUM(o.Quantity * p.UnitPrice_Clean * (1 - o.Discount)) AS Monthly_Sales
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
WHERE o.OrderStatus = 'Delivered'
GROUP BY MONTH(STR_TO_DATE(o.OrderDate, '%d-%b-%y'))
ORDER BY Month_Number;


-- 4. Top 5 Products by Sales
SELECT
    p.ProductName,
    SUM(o.Quantity * p.UnitPrice_Clean * (1 - o.Discount)) AS Total_Sales
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.ProductName
ORDER BY Total_Sales DESC
LIMIT 5;


-- 5. Category-wise Sales
SELECT
    p.Category,
    SUM(o.Quantity * p.UnitPrice_Clean * (1 - o.Discount)) AS Category_Sales
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Category
ORDER BY Category_Sales DESC;


-- 6. Payment Mode Analysis
SELECT
    o.PaymentMode,
    COUNT(*) AS Total_Orders,
    SUM(o.Quantity * p.UnitPrice_Clean * (1 - o.Discount)) AS Total_Sales
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
WHERE o.OrderStatus = 'Delivered'
GROUP BY o.PaymentMode
ORDER BY Total_Sales DESC;


-- 7. City-wise Sales
SELECT
    c.City,
    SUM(o.Quantity * p.UnitPrice_Clean * (1 - o.Discount)) AS Total_Sales
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderStatus = 'Delivered'
GROUP BY c.City
ORDER BY Total_Sales DESC;


-- 8. Top 10 Customers
SELECT
    c.CustomerName,
    COUNT(DISTINCT o.OrderID) AS Total_Orders,
    SUM(o.Quantity * p.UnitPrice_Clean * (1 - o.Discount)) AS Total_Sales
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID
WHERE o.OrderStatus = 'Delivered'
GROUP BY c.CustomerID, c.CustomerName
ORDER BY Total_Sales DESC
LIMIT 10;


-- 9. Order Status Analysis
SELECT
    OrderStatus,
    COUNT(*) AS Total_Orders
FROM Orders
GROUP BY OrderStatus
ORDER BY Total_Orders DESC;
