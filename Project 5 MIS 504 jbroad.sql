/*Q1 Show the Supplier companyname and the count of how many products we get 
from that supplier. Make sure to count the primary key of the products table.
 Order by companyname.*/

SELECT      s.CompanyName,
            COUNT(p.ProductID) AS [PRODUCTS SUPPLIED]
FROM        Suppliers AS s
JOIN        Products AS p ON s.SupplierID=p.SupplierID
GROUP BY    s.CompanyName
ORDER BY    s.CompanyName

/*Q2 Do number 1 again, but only include products that are not discontinued*/

SELECT      s.CompanyName,
            COUNT(p.ProductID) AS [PRODUCTS SUPPLIED]
FROM        Suppliers AS s
JOIN        Products AS p ON s.SupplierID=p.SupplierID
WHERE       p.Discontinued = 0
GROUP BY    s.CompanyName
ORDER BY    s.CompanyName

/*Q3 Show the Supplier companyname and the average unitprice of products 
from that supplier. Only include products that are not discontinued. */

SELECT      s.CompanyName,
            AVG(p.UnitPrice) AS [Average unit price]
FROM        Suppliers AS s
JOIN        Products AS P ON s.SupplierID=p.SupplierID
WHERE       p.Discontinued = 0
GROUP BY    S.CompanyName
ORDER BY    [Average unit price] DESC

/*Q4 Show the Supplier companyname and the total inventory value of all 
products from that supplier. This will involve the SUM() function with 
some calculations inside the functions.*/

SELECT      s.CompanyName,
            SUM(p.UnitPrice * p.UnitsInStock) AS [Total Inventory Value]  
FROM        Suppliers AS s
JOIN        Products AS p ON s.SupplierID=p.SupplierID
GROUP BY    s.CompanyName
ORDER BY    s.CompanyName

/*Q5 Show the Category name and a count of how many products are in each 
category.*/

SELECT      ca.CategoryName,
            COUNT(ProductID) AS [Count of Products]
FROM        Categories AS ca
JOIN        Products AS p ON ca.CategoryID=p.CategoryID
GROUP BY    ca.CategoryName
ORDER BY    ca.CategoryName

/*Q6 Show the Category name and a count of how many products in each 
category that are packaged in jars (have the word 'jars' in the 
QuantityPerUnit.)*/

SELECT      ca.CategoryName,
            COUNT(ProductID) AS [Products in jars]
FROM        Categories AS ca
JOIN        Products AS p ON ca.CategoryID=p.CategoryID
WHERE       p.QuantityPerUnit  LIKE  '%jar%'
GROUP BY    ca.CategoryName
ORDER BY    ca.CategoryName

/*Q7 Show the Category name, and the minimum, average, and maximum price of 
products in each category.*/

SELECT      ca.CategoryName,
            MIN(p.UnitPrice) AS [Minimun price],
            AVG(p.UnitPrice) AS [Average Price],
            MAX(p.UnitPrice) AS [Maximum Price]
FROM        Categories AS ca
JOIN        Products AS p ON ca.CategoryID=p.CategoryID
GROUP BY    ca.CategoryName
ORDER BY    ca.CategoryName

/*Q8 Show each order ID, its orderdate, the customer ID, and a count of how
 many items are on each order*/

SELECT      o.OrderId,
            o.OrderDate,
            c.CustomerId,
            COUNT([Order Details].Quantity) AS [Quantity ordered]
FROM        Orders AS o
JOIN        Customers AS c ON o.CustomerID=c.CustomerID
JOIN        [Order Details] ON [Order Details].OrderID=o.OrderID
GROUP BY    o.OrderID, o.OrderDate, c.CustomerID
ORDER BY    O.OrderDate

/*Q9 Show each productID, its productname, and a count of how many orders it 
has appeared on.*/

SELECT      p.ProductID,
            p.ProductName,
            COUNT([Order Details].OrderID) AS [Number of Order Appearances]
FROM        Products AS p
JOIN        [Order Details] ON P.ProductID=[Order Details].ProductID
GROUP BY    p.ProductID, p.ProductName
ORDER BY    [Number of Order Appearances] DESC, p.ProductID

/*Q10 Do #9 again, but limit to only orders that were place in January of 
1997.*/

SELECT      p.ProductID,
            p.ProductName,
            COUNT([Order Details].OrderID) AS [Number of January 1997 Appearances]
FROM        Products AS p
JOIN        [Order Details] ON P.ProductID=[Order Details].ProductID
JOIN        Orders ON [Order Details].OrderID=Orders.OrderId
WHERE       YEAR(Orders.OrderDate)=1997 AND MONTH(Orders.OrderDate)=1
GROUP BY    p.ProductID, p.ProductName
ORDER BY    [Number of January 1997 Appearances] DESC, p.ProductID

/*Q11 Show each OrderID, its orderdate, the customerID, and the total amount 
due, not including freight. Sum the amounts due from each product on the 
order. The amount due is the quantity times the unitprice, times one minus the
 discount. Order by amount due, descending, so the biggest dollar amount due 
 is at the top.*/

SELECT      o.OrderId,
            o.Orderdate,
            o.CustomerID,
            SUM((od.UnitPrice*od.Quantity)*(1-od.Discount)) AS [Total Amount due]
FROM        Orders AS o
JOIN        [Order Details] AS od ON o.OrderID=od.OrderID
GROUP BY    O.OrderID,o.Orderdate,O.CustomerID
ORDER BY    o.OrderDate

/*Q12 We want to know, for the year 1997, the total revenues by category. Show 
the CategoryID, categoryname, and the total revenue from products in that 
category. This is very much like #11. Don't include freight.*/

SELECT      c.CategoryId,
            c.CategoryName,
            SUM((od.UnitPrice*od.Quantity)*(1-od.Discount)) AS [Total revenue 1997]
FROM        Orders AS o
JOIN        [Order Details] AS od ON o.OrderID=od.OrderID
JOIN        Products ON od.ProductID=Products.ProductID
JOIN        Categories AS c ON Products.CategoryID=c.CategoryID
WHERE       YEAR(O.OrderDate)=1997      
GROUP BY    c.CategoryID,c.CategoryName
ORDER BY    c.CategoryID

/*Q13 We want to know, for the year 1997, total revenues by month. Show the 
month number, and the total revenue for that month. Don't include freight.*/

SELECT      MONTH(o.orderDate) AS [Month],
            SUM((od.UnitPrice*od.Quantity)*(1-od.Discount)) AS [Total monthly revenue 1997]
FROM        Orders AS o
JOIN        [Order Details] AS od ON o.OrderID=od.OrderID
WHERE       YEAR(O.OrderDate)= 1997
GROUP BY    MONTH(o.OrderDate)
ORDER BY    MONTH(o.OrderDate)
            

/*Q14 We want to know, for the year 1997, total revenues by employee. Show the
 EmployeeID, lastname, title, then their total revenues. Don't include freight. 
*/

SELECT      e.EmployeeID,
            e.LastName,
            e.Title,
            SUM((od.UnitPrice*od.Quantity)*(1-od.Discount)) AS [Total employee revenue 1997]
FROM        Orders AS o
JOIN        [Order Details] AS od ON o.OrderID=od.OrderID
JOIN        Employees AS e ON o.EmployeeID=e.EmployeeID
WHERE       YEAR(O.OrderDate)= 1997
GROUP BY    e.EmployeeID,e.LastName, e.Title
ORDER BY    [Total employee revenue 1997] DESC

/*Q15 We want to know, for the year 1997, a breakdown of revenues by month and 
category. Show the month number, the categoryname, and the total revenue for 
that month in that category. Order the records by month then category.*/

SELECT      MONTH(o.orderDate) AS [Month],
            c.CategoryName,    
            SUM((od.UnitPrice*od.Quantity)*(1-od.Discount)) AS [Total monthly revenue 1997]
FROM        Orders AS o
JOIN        [Order Details] AS od ON o.OrderID=od.OrderID
JOIN        products AS P ON od.ProductID=p.ProductID
JOIN        Categories AS c ON p.CategoryID=c.CategoryID
WHERE       YEAR(O.OrderDate)= 1997
GROUP BY    MONTH(o.OrderDate),C.CategoryName
ORDER BY    MONTH(o.OrderDate),C.CategoryName 