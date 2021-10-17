SELECT    ProductID,
          ProductName,
          UnitsInStock
FROM      Products
WHERE     UnitsInStock < 5
ORDER BY  ProductID

SELECT    ProductID,
          ProductName,
          UnitsInStock
FROM      Products
WHERE     UnitPrice > 8.0
ORDER BY  ProductID

SELECT    ProductName, 
          Unitprice,
          UnitsInStock * UnitPrice AS [Total Inventory]
FROM      Products
ORDER BY  ProductName

SELECT    ProductName, 
          CategoryId, 
          UnitPrice
FROM      Products
WHERE     CategoryID = 2 AND UnitPrice < 4.0
ORDER BY  ProductName

SELECT    ProductName, 
          CategoryId, 
          UnitPrice
FROM      Products
WHERE     CategoryID = 7 AND UnitPrice > 8.0
ORDER BY  ProductName

SELECT    ProductName, 
          CategoryId, 
          UnitPrice
FROM      Products
WHERE     (CategoryID = 2 AND UnitPrice < 4.0) OR (CategoryID = 7 AND UnitPrice > 8.0)
ORDER BY  ProductName

SELECT    ProductName,
          UnitPrice
FROM      Products
WHERE     QuantityPerUnit LIKE '%bottle%'
ORDER BY  ProductName

SELECT    ProductName
FROM      Products 
WHERE     ProductName LIKE '%lager' 
ORDER BY  ProductName

SELECT    ProductName, 
          UnitPrice
FROM      Products
WHERE     CategoryID IN (2,4,5,7)
ORDER BY  CategoryID

SELECT    ProductID,
          ProductName,
          SupplierID
FROM      Products
WHERE     ProductName LIKE '% ale %' OR 
          ProductName LIKE 'ale %' OR 
          ProductName LIKE '% ale' OR
          ProductName LIKE '% lager %' OR 
          ProductName LIKE 'lager %' OR 
          ProductName LIKE '% lager'
ORDER BY ProductID

SELECT    ProductName,
          UnitPrice,
          UnitsInStock
FROM      Products
WHERE     UnitsInStock < ReorderLevel / 2
ORDER BY  UnitsInStock 

SELECT    ProductName
FROM      Products
WHERE     (UnitsInStock * UnitPrice) < 200.0 
ORDER BY  (UnitsInStock * UnitPrice) DESC

SELECT    ProductName, 
          (UnitsInStock * UnitPrice) AS [Inventory Value]
FROM      Products
WHERE     (UnitsInStock * UnitPrice) > 500.0 AND Discontinued = 1
ORDER BY  [Inventory Value] DESC

SELECT    ProductName
FROM      Products
WHERE     Discontinued = 0 AND UnitsInStock + UnitsOnOrder <= ReorderLevel
ORDER BY  ProductName

SELECT    CategoryID, 
          ProductID, 
          ProductName, 
          UnitPrice
FROM      Products
ORDER BY  CategoryID, UnitPrice DESC, ProductID