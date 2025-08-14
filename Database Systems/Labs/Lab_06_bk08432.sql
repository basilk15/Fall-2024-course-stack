 --Q1--
 SELECT * FROM Customers

 --Q2--
 SELECT OrderID, OrderDate, ShipCity, ShipCountry FROM Orders

 --Q3--
 SELECT OrderID, OrderDate, CustomerID FROM Orders WHERE ShipCountry='France'

 --Q4--
SELECT OrderID,OrderDate,CustomerID FROM Orders WHERE ShipCountry='France' OR ShipCountry='Brazil' 

 --Q5--
SELECT OrderID,OrderDate,Freight,ShipCountry FROM Orders WHERE (ShipCountry='France' OR ShipCountry= 'Sweden') AND Freight>40

--Q6--
SELECT TitleOfCourtesy+ ' ' +FirstName + ' ' + LastName AS EmployeeFullName, Title FROM Employees 

 --Q7--
SELECT OrderID,OrderDate,ShipName,ShipAddress,ShipCity,ShipCountry FROM Orders WHERE ShipAddress LIKE '%box%'

--Q8--
SELECT OrderID,CustomerID FROM Orders WHERE CustomerID LIKE 'C%S' 

 --Q9--
SELECT FirstName + ' ' + LastName AS EmployeeName FROM Employees WHERE DATEDIFF(year,HireDate,GETDATE())>10

--Q10--
SELECT OrderID, DATEDIFF(day, OrderDate, ShippedDate) AS ProcessingTimeInDays FROM Orders 

 --Q11--
 SELECT * FROM Customers WHERE Fax IS NULL

--Q12--
SELECT *FROM Products WHERE QuantityPerUnit LIKE '%box%' 










