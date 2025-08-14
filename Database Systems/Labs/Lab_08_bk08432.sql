
--Q1--
select s.CompanyName, count(p.ProductID) as NoOfProducts from Suppliers s join Products p on s.SupplierID = p.SupplierID group by s.CompanyName order by NoOfProducts desc

--Q2--
select s.CompanyName, c.CategoryName, count(p.ProductID) as NoOfProducts, avg(p.UnitPrice) as AveragePrice, sum(p.UnitsInStock) as TotalUnitsInStock from Suppliers s join Products p on s.SupplierID=p.SupplierID join Categories c on p.CategoryID = c.CategoryID group by s.CompanyName, c.CategoryName order by s.CompanyName, c.CategoryName

--Q3-- 
select s.CompanyName from Suppliers s join Products p on s.SupplierID=p.SupplierID group by s.CompanyName having count(p.ProductID)>4

--Q4--
select r.RegionDescription, count(e.EmployeeID) as NoOfEmployees from Region r join Territories t on r.RegionID=t.RegionID JOIN EmployeeTerritories et on t.TerritoryID=et.TerritoryID join Employees e on et.EmployeeID=e.EmployeeID where r.RegionDescription in('Southern', 'Western', 'Northern', 'Eastern') group by r.RegionDescription order by r.RegionDescription asc

--Q5- 
select OrderID, sum((UnitPrice*Quantity)-Discount) as TotalAmount from [Order Details] group by OrderID order by OrderID;

--Q6--
select c.CategoryName, count(p.ProductID) as NoOfProducts from Categories c join Products p on c.CategoryID=p.CategoryID group by c.CategoryName order by c.CategoryName;

--Q7--
select c.ContactName, s.CompanyName, count(distinct o.OrderID) as NoOfOrders from Customers c join Orders o on c.CustomerID=o.CustomerID join [Order Details] od on o.OrderID=od.OrderID join Products p on od.ProductID=p.ProductID join Suppliers s on p.SupplierID=s.SupplierID group by c.ContactName, s.CompanyName order by c.ContactName, s.CompanyName;

--Q8--
select e.FirstName as EmployeeFirstName, e.LastName as EmployeeLastName, year(o.OrderDate) as y, count(o.OrderID) as NoOfOrders from Employees e join Orders o on e.EmployeeID=o.EmployeeID group by e.FirstName, e.LastName, year(o.OrderDate) order by e.FirstName, e.LastName, y;

--Q9--
select m.FirstName as managerfirstname, m.LastName as managerlastname, e.FirstName as employeefirstname, e.LastName as employeelastname, count(o.OrderID) as No_orders from Employees e join Orders o on e.EmployeeID = o.EmployeeID join Employees m on e.ReportsTo=m.EmployeeID group by m.FirstName, m.LastName, e.FirstName, e.LastName order by No_orders desc;

--Q10--
select r.RegionDescription as regionname, count(e.EmployeeID) as no_employees from Region r left join Territories t on r.RegionID= t.RegionID left join EmployeeTerritories et on t.TerritoryID=et.TerritoryID left join Employees e on et.EmployeeID = e.EmployeeID group by r.RegionDescription order by r.RegionDescription;

--Q11--
select e.FirstName + ' ' + e.LastName as fullname, c.ContactName as customername from Employees e cross join Customers c order by e.EmployeeID

--Q12--
select CustomerID, contactname from Customers order by Country, contactname;

--Q13--
select e.City, count(distinct e.EmployeeID) as no_of_emp, count(distinct c.CustomerID) as no_of_c from Employees e left join Customers c on e.City=c.City where e.City is not null group by e.City order by e.City;

--Q14--
select city, (select count(*) from employees e where e.city = c.city) as no_of_e, (select count(*) from customers cust where cust.city = c.city) as no_of_c  from  (select distinct city from employees  union  select distinct city from customers) c 
order by 
    city;

--Q15--
select o.orderid, (e.firstname + ' ' + e.lastname) as employee_full_name 
from 
    orders o 
join 
    employees e on o.employeeid = e.employeeid 
where 
    o.shippeddate>o.requireddate;

--Q16--
select od.productid, sum(od.quantity) as totalquantity 
from 
    [Order Details]od 
group by 
    od.productid 
having 
    sum(od.quantity) < 200;

--Q17--
select o.customerid, count(o.orderid) as total_no_of_orders 
from orders o 
where o.orderdate>'1996-12-31' 
group by 
    o.customerid 
having 
    count(o.orderid)>15;
