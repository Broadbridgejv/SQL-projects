/*Q1 Show the CategoryName, Description, and number of products in each 
category. You will have trouble grouping by Category.Description, because of 
its data type.*/   

SELECT      c.CategoryName,
            (CAST(c.Description AS CHARACTER(32))) AS [Description],
            COUNT(p.ProductID) AS [Products available]
FROM        Categories as c
JOIN        Products AS P ON c.CategoryID=p.CategoryID
GROUP BY    C.CategoryName, CAST(c.Description AS CHARACTER(32))
ORDER BY    c.CategoryName

/*Q2 We want to know the percentage of buffer stock we hold on every product. 
We want to see this as a percentage above/below the reorderLevel. Show the 
ProductID, productname, unitsInstock, reOrderLevel, and the percent above/below
 the reorderlevel. So if unitsInstock is 13 and the reorderLevel level is 10, 
 the percent above/below would be 0.30. Make sure you convert at the 
 appropriate times to ensure no rounding occurs. Check your work carefully.*/

SELECT      p.ProductID,
            p.ProductName,
            p.UnitsInStock,
            p.ReorderLevel,
            (CAST(p.UnitsInStock-p.ReorderLevel AS float(24)) / p.ReorderLevel *100) AS [Percentage of buffer stock]
FROM        Products AS p
WHERE       ReorderLevel !=0
ORDER BY    [Percentage of buffer stock]

/*Q3 Show the orderID, orderdate, and total amount due for each order, 
including freight. Make sure that the amount due is a money data type and that
there is no loss in accuracy as conversions happen. Do not do any unnecessary
conversions. The trickiest part of this is the making sure that freight is NOT
 in the SUM.*/

SELECT      o.OrderID,
            o.OrderDate,
            SUM((od.UnitPrice * CAST(od.Quantity AS MONEY))-O.Freight) AS [Amount due]
FROM        Orders AS o
JOIN        [Order Details] AS od ON o.OrderID=od.OrderID
GROUP BY    O.OrderID,O.OrderDate
ORDER BY    o.OrderID

            

/*Q4 Our company is located in Wilmington NC, the eastern time zone (UTC-5).
We've been mostly local, but are now doing business in other time zones. Right
now all of our dates in the orders table are actually our server time, and the 
server is located in an Amazon data center outside San Francisco, in the 
pacific time zone (UTC-8). For only the orders we ship to France, show the 
orderID, customerID, orderdate in UTC-5, and the shipped date in UTC+1 
(France's time zone.) You might find the TODATETIMEOFFSET() function helpful in
this regard, and also the SWITCHOFFSET() function.. Remember the implied time 
zone (EST) when you do this.*/

SELECT      OrderID,
            CustomerID,
            TODATETIMEOFFSET(orderdate,'+03:00') AS [UTC-5 orderdate],
            SWITCHOFFSET(shippeddate,'+09:00') AS [UTC+1 shippeddate]
FROM Orders
ORDER BY    OrderID

/*Q5 We are realizing that our data is taking up more space than necessary, 
which is making some of our regular data become "big data", in other words, 
difficult to deal with. In preparation for a data migration, we'd like to 
convert many of the fields in the Customers table to smaller data types. We 
anticipate having 1 million customers, and this conversion could save us up to 
58MB on just this table. Do a SELECT statement that shows all fields in the 
table, in their original order, and rows ordered by customerID, with these 
fields converted:

CustomerID converted to CHAR(5) - saves at least 5 bytes per record
PostalCode converted to VARCHAR(10) - saves up to 5 bytes per record
Phone converted to VARCHAR(24) - saves up to 24 bytes per record
Fax converted to VARCHAR(24) - saves up to 24 bytes per record */

SELECT      CAST(CustomerID AS CHAR(5)) AS CustomerID,
            CompanyName,
            ContactName,
            ContactTitle,
            Address,
            city,
            Region,
            CAST(PostalCode AS VARCHAR(10)) AS PostalCode,
            Country,
            CAST(Phone AS VARCHAR(24)) AS Phone,
            CAST(Fax AS VARCHAR(24)) AS Fax
FROM        Customers
ORDER BY    CustomerID         

/*Q6 Show a list of products, their unit price, and their ROW_NUMBER() based 
on price, ASC. Order the records by productname. */

SELECT      ROW_NUMBER() OVER
            (ORDER BY UnitPrice ASC) AS [Row Number],
            ProductID, 
            ProductName, 
            UnitPrice
FROM        Products
ORDER BY    ProductName

/*Q7 Do #6, but show the DENSE_RANK() based on price, ASC, rather than 
ROW_NUMBER().*/

SELECT      DENSE_RANK() OVER
            (ORDER BY UnitPrice ASC) AS [Price Rank],
            ProductID, ProductName, UnitPrice
FROM        Products
ORDER BY    ProductName

/*Q8 Show a list of products ranked by price into three categories based on 
price: 1, 2, 3. The highest 1/3 of the products will be marked with a 1, the 
second 1/3 as 2, the last 1/3 as 3. HINT: this is NTILE(3), order by unitprice 
DESC. */

SELECT      NTILE(3) OVER(ORDER BY UnitPrice DESC) AS [Price Tercile],
            ProductName, UnitPrice
FROM        Products
ORDER BY    ProductName 

/*Q9 Show a list of products from categories 1, 2, 7, 4 and 5. Show their 
RANK() based on value in inventory.*/

SELECT      RANK() OVER(PARTITION BY CategoryID ORDER by SUM(UnitPrice * UnitsInStock)) AS Rank,
            ProductName, 
            CategoryID,
            SUM(UnitPrice * UnitsInStock) AS [Inventory value]
FROM        Products
WHERE       CategoryID IN (1,2,4,5,7)
GROUP BY    CategoryID, ProductName
ORDER BY    CategoryID, Rank

/*Q10 Show a list of orders, ranked based on freight cost, highest to lowest. 
Order the orders by the orderdate.*/

SELECT      RANK() OVER(ORDER BY Freight DESC) [Freight cost rank],
            Freight, OrderID, OrderDate
FROM        Orders
ORDER BY    OrderDate