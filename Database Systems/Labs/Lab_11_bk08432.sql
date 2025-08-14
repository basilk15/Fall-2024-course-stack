--q1--
insert into Products (ProductName, CategoryID, UnitPrice) 
	values ('Coca Cola', 1, 90);

--q2--
insert into Products (ProductName, CategoryID, UnitPrice) 
	values ('Fish', (select CategoryID from Categories where CategoryName = 'Seafood'), 50);

--q3--
update Products set UnitPrice = UnitPrice * 1.25 
	where CategoryID=(select CategoryID from Categories where CategoryName='Confections');

--q4--
insert into Categories (CategoryName) values ('Drinks');

--q5--
insert into Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
select ProductName, SupplierID, (select CategoryID from Categories where CategoryName = 'Drinks'), QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
from Products
where CategoryID = (select CategoryID from Categories where CategoryName = 'Beverages');

--q6--
update Products set CategoryID=(select CategoryID from Categories where CategoryName = 'Drinks')
	where CategoryID=(select CategoryID from Categories where CategoryName = 'Beverages');

--q7--
--a--
delete from EmployeeTerritories 
	where EmployeeID = (select EmployeeID from Employees where LastName = 'King' AND FirstName = 'Robert');

--b--
insert into EmployeeTerritories (EmployeeID, TerritoryID)
select (select EmployeeID from Employees where LastName = 'King' and FirstName = 'Robert'), TerritoryID
from EmployeeTerritories
where EmployeeID = (select EmployeeID from Employees where LastName = 'Fuller' and FirstName = 'Andrew');


--q8--
delete from Products
	where CategoryID = (select CategoryID from Categories where CategoryName = 'Seafood')
		and UnitsInStock<5;

--q9--
delete from [Order Details]
where OrderID in (select OrderID from Orders where CustomerID = 'CHOPS');
delete from Orders
where CustomerID = 'CHOPS';


--q10--
delete from [Order Details]
where OrderID in (select OrderID from Orders where ShippedDate >= '1998-04-01' and ShippedDate <= '1998-04-30');
delete from Orders
where ShippedDate >= '1998-04-01' and ShippedDate <= '1998-04-30';



