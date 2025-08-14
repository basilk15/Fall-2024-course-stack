--q1--
create view projectview as
select 
    products.productname,
    suppliers.companyname as suppliername,
    categories.categoryname as category,
    products.unitprice as price,
    count([order details].orderid) as nooforders,
    sum([order details].quantity) as totalqtysold
from products
inner join suppliers on products.supplierid = suppliers.supplierid
		inner join 
			categories on products.categoryid = categories.categoryid
		left join 
			[order details] on products.productid = [order details].productid
			group by 
		products.productname, suppliers.companyname, categories.categoryname, products.unitprice;
go

--q2--
create view employee_sum as
select 
    concat(employees.firstname, ' ', employees.lastname) as employeename,
    (select concat(e2.firstname, ' ', e2.lastname)
     from employees e2
     where e2.employeeid = employees.reportsto) as managername,
    datediff(year, employees.birthdate, getdate()) as age,
    datediff(year, employees.hiredate, getdate()) as noofyearswithcompany,
    count(orders.orderid) as noofordersprocessed
from 
    employees
left join 
    orders on employees.employeeid = orders.employeeid
group by 
    employees.firstname, employees.lastname, employees.birthdate, employees.hiredate, employees.reportsto, employees.employeeid;


--q3--
create procedure offerdiscount
    @productid int,
    @discountfactor float
as begin
    update products
    set unitprice = unitprice * (1 - @discountfactor)
    where productid = @productid;
		update [order details]
			set unitprice = unitprice * (1 - @discountfactor)
				where productid = @productid and exists (select 1 from orders where orders.orderid = [order details].orderid and orders.shippeddate is null
      );
end

exec  offerdiscount @ProductID=1, @DiscountFactor=0.5;


--q4--
create procedure deleteemployee
    @employee_to_delete int
as begin
    if not exists (
        select 1
        from employees
        where employeeid = @employee_to_delete
          and reportsto is not null
    )
    begin
        print 'this is top manager so wont be deleted';
        return;
    end
    if exists(
        select 1
        from orders
        where employeeid = @employee_to_delete
    )
    begin
        print 'this has worked on orders and wont be deleted.';
        return;
    end
    update employees
    set reportsto = (
        select reportsto
        from employees
        where employeeid = @employee_to_delete
    )
    where reportsto = @employee_to_delete;
    delete from employeeterritories
    where employeeid = @employee_to_delete;
    delete from employees
    where employeeid = @employee_to_delete;

    print 'deleted';
end;


--q5--
create procedure copyorder
    @original_order_id int,
    @new_customer_id nvarchar(5)
as
begin
    insert into orders (customerid, employeeid, orderdate, requireddate, shippeddate, shipvia, freight, shipname, shipaddress, shipcity, shipregion, shippostalcode, shipcountry)
    select 
        @new_customer_id, 
        employeeid, 
        getdate() as orderdate, 
        requireddate, shippeddate, shipvia, freight, shipname, shipaddress, shipcity, shipregion, shippostalcode, shipcountry
    from orders
		where orderid = @original_order_id;
    declare @new_order_id int;
    select @new_order_id = scope_identity();
    insert into [order details] (orderid, productid, unitprice, quantity, discount)
    select 
        @new_order_id, productid, unitprice, quantity, discount
    from [order details]
		where orderid = @original_order_id;
    print 'order has been successfully copied.';
end;
