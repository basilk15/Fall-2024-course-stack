--Q1--
select COUNT(*) from Customers where Fax IS NULL

--Q2--
select COUNT(*) from Orders where YEAR(OrderDate) = 1997

--Q3--
select COUNT(*) from Customers where ContactTitle = 'Sales Representative'

--Q4--
select COUNT(*) as TotalProducts from [Order Details] OD where OD.OrderID = 11070

--Q5--
select COUNT(*) as TotalCustomers from Customers C where C.Country = 'UK' OR C.Country = 'USA'

--Q6--
select SUM(P.UnitsInStock) as TotalUnits from Products P

--Q7--
select SUM(P.UnitsInStock*P.UnitPrice) as TotalWorth from Products P

--Q8--
select COUNT(*) as TotalEmployees from Employees E where E.City = 'London'

--Q9--
select COUNT(*) as TotalFemaleEmployees from Employees E where E.TitleOfCourtesy = 'Ms.' OR E.TitleOfCourtesy = 'Mrs.'

--Q10--
select O.OrderID, O.OrderDate, P.ProductName from Orders O INNER JOIN [Order Details] OD on O.OrderID = OD.OrderID INNER JOIN Products P on OD.ProductID = P.ProductID

--Q11--
select o.orderID, o.orderdate, p.productname, c.companyname as customername from orders o inner join [order details] od on o.orderID = od.orderID inner join products p on od.productID = p.productID inner join customers c on o.customerID = c.customerID

--Q12--
select o.orderID, o.orderDate, p.productName, c.categoryName from orders o inner join [order details] od on o.orderID = od.orderID inner join products p on od.productID = p.productID inner join categories c on p.categoryID = c.categoryID where c.categoryname = 'Seafood'

--Q13--
select c.companyname as customername from customers c left outer join orders o on c.customerID =o.customerID where o.orderID is null

--Q14--
select distinct o.orderID from orders o inner join [order details] od on o.orderID = od.orderID inner join products p on od.productID =p.productID inner join categories c on p.categoryID = c.categoryID where c.categoryname = 'Meat/Poultry' or c.categoryname = 'Dairy Products'

--Q15--
select e.firstname + ' ' + e.lastname as employeefullname, c.companyname as customername from employees e cross join customers c



