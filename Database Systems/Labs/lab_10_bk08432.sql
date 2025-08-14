--q1--
SELECT TOP 1 EmployeeID FROM Orders WHERE YEAR(OrderDate) = 1998 ORDER BY OrderDate ASC

--q2--
SELECT EmployeeID FROM Employees WHERE ReportsTo = (SELECT EmployeeID FROM Employees WHERE ReportsTo IS NULL)

--q3--
select distinct employeeid 
from employeeterritories et 
join territories t on et.territoryid = t.territoryid 
where t.regionid in (select regionid from region where regiondescription in ('western', 'eastern'))


--q4--
select ContactName from Customers where Country = 'Germany' and ContactName in (select ContactName from Customers)
union select ContactName from Suppliers where Country = 'Germany' AND ContactName IN (select ContactName from Suppliers)

--q5--
select ProductName from Products where UnitPrice = (select MIN(UnitPrice) from ( select distinct top 3 UnitPrice from Products order by UnitPrice desc) as TopPrices)

--q6--
select employeeid, 
    case 
        when (select datediff(year, hiredate, getdate())) > 5 then 3
        when (select datediff(year, hiredate, getdate())) between 3 and 5 then 2
        else 1 
    end as senioritylevel
from employees


--q7--
select productname, 
    case 
        when unitprice > (select max(unitprice) from products where unitprice <= 80) then 'costly'
        when unitprice between (select min(unitprice) from products where unitprice >= 30) and 80 then 'economical'
        else 'cheap' 
    end as types
from products


--q8--
select p.productname, 
    case 
        when (select count(o.orderid) from orders o join [order details] od on p.productid = od.productid where year(o.orderdate) = 1997) >= 50 then 'customer favourite'
        when (select count(o.orderid) from orders o join [order details] od on p.productid = od.productid where year(o.orderdate) = 1997) between 30 and 49 then 'trending'
        when (select count(o.orderid) from orders o join [order details] od on p.productid = od.productid where year(o.orderdate) = 1997) between 10 and 29 then 'on the rise'
        else 'not popular' 
    end as trend
from products p


--q9--
select c.customerid, 
    (select count(orderid) from orders o where c.customerid = o.customerid) as ordercount 
from customers c

--q10--
select distinct O.CustomerID from Orders O join [Order Details] OD on O.OrderID = OD.OrderID JOIN Products P on OD.ProductID = P.ProductID where P.UnitPrice > ( select avg(UnitPrice) from Products)

--q11--
select distinct C.ContactName
from Customers C
join Orders O on C.CustomerID = O.CustomerID
join [Order Details] OD on O.OrderID = OD.OrderID
join Products P on OD.ProductID = P.ProductID
where P.CategoryID = (
    select CategoryID
    from Products
    where ProductName = 'Chai'
)

--q12--
select top 1 c.contactname, ordercount
from customers c
join (
    select customerid, count(orderid) as ordercount
    from orders
    group by customerid
) as ordercounts on c.customerid = ordercounts.customerid
order by ordercount desc


--q13--
select distinct contactname
from customers
where customerid in (
    select customerid
    from orders
    where orderid in (
        select orderid
        from [order details]
        where productid = (
            select productid
            from products
            where unitprice = (
                select max(unitprice)
                from products
            )
        )
    )
)



--q14--
select avg(productcount) as averageproductsperorder
from (
    select count(od.productid) as productcount
    from [order details] od
    group by od.orderid
) as orderproductcounts;

--q15--
select categoryname
from categories c
join products p on c.categoryid = p.categoryid
group by c.categoryname
having avg(p.unitprice) > (
    select avg(unitprice) from products
)

--q16--
select top 1 productname, unitprice
from products
where unitprice < (select max(unitprice) from products)
order by unitprice desc

--q17--
select avg(ordertotal) as averageorderamount
from (
    select o.orderid, sum(od.quantity * od.unitprice) as ordertotal
    from orders o
    join [order details] od on o.orderid = od.orderid
    join customers c on o.customerid = c.customerid
    where c.country = 'france'
    group by o.orderid
) as ordertotals
