
-- 1. CREATE TABLES


CREATE TABLE Categories (
    CategoryID NUMBER PRIMARY KEY,
    CategoryName VARCHAR2(50)
);

CREATE TABLE Products (
    ProductID NUMBER PRIMARY KEY,
    ProductName VARCHAR2(100),
    CategoryID NUMBER,
    Price NUMBER(10,2),
    StockCount NUMBER,
    ExpiryDate DATE,
    CONSTRAINT fk_category FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);

CREATE TABLE SalesTransactions (
    TransactionID NUMBER PRIMARY KEY,
    ProductID NUMBER,
    Quantity NUMBER,
    TotalAmount NUMBER(10,2),
    TransactionDate DATE,
    CONSTRAINT fk_product FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);


-- 2. INSERT DUMMY DATA

INSERT INTO Categories VALUES (1, 'Dairy');
INSERT INTO Categories VALUES (2, 'Fruits');
INSERT INTO Categories VALUES (3, 'Snacks');



INSERT INTO Products VALUES (101, 'Milk', 1, 50, 60, SYSDATE + 5);
INSERT INTO Products VALUES (102, 'Cheese', 1, 120, 30, SYSDATE + 20);
INSERT INTO Products VALUES (103, 'Apple', 2, 80, 100, SYSDATE + 3);
INSERT INTO Products VALUES (104, 'Banana', 2, 40, 20, SYSDATE + 2);
INSERT INTO Products VALUES (105, 'Chips', 3, 30, 200, SYSDATE + 90);
INSERT INTO Products VALUES (106, 'Biscuits', 3, 25, 150, SYSDATE + 60);

INSERT INTO SalesTransactions VALUES (1, 101, 5, 250, SYSDATE - 10);
INSERT INTO SalesTransactions VALUES (2, 103, 10, 800, SYSDATE - 5);
INSERT INTO SalesTransactions VALUES (3, 105, 20, 600, SYSDATE - 40);
INSERT INTO SalesTransactions VALUES (4, 101, 3, 150, SYSDATE - 20);



-- 3.QUERIES


--  A. Expiring Soon 

SELECT ProductID, ProductName, StockCount, ExpiryDate
FROM Products
WHERE ExpiryDate BETWEEN SYSDATE AND SYSDATE + 7
AND StockCount > 50;



--  B. Dead Stock 

SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN SalesTransactions s
    ON p.ProductID = s.ProductID
    AND s.TransactionDate >= SYSDATE - 60
WHERE s.ProductID IS NULL;



--  C. Revenue by Category 

SELECT c.CategoryName, SUM(s.TotalAmount) AS TotalRevenue
FROM SalesTransactions s
JOIN Products p ON s.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE s.TransactionDate >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1)
AND s.TransactionDate < TRUNC(SYSDATE, 'MM')
GROUP BY c.CategoryName
ORDER BY TotalRevenue DESC;