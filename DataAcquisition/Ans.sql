/* Q1 */
select * from ba710.shippers;

/* Q2 */
select FirstName,LastName,HireDate from ba710.employees where Title='Sales Representative';

/* Q3 */
select ProductID,ProductName from ba710.products where ProductName like '%queso%';

/* Q4 */
select OrderId,CustomerID,ShipCountry from ba710.orders where ShipCountry in ('France','Belgium');

/* Q5 */
select FirstName,LastName,Title,BirthDate from ba710.employees order by BirthDate;

/* Q6 */
select FirstName,LastName,Title,Date(BirthDate) as DateOnlyBirthDate from ba710.employees order by BirthDate;

/* Q7 */
select OrderID,ProductID,UnitPrice*Quantity as TotalPrice from ba710.orderdetails order by OrderID,ProductID;

/* Q8 */
select count(distinct(CustomerID)) as TotalCustomers from ba710.customers;

/* Q9 */
select min(OrderDate) as FirstOrder from ba710.orders;

/* Q10 */
select ContactTitle,count(ContactTitle) as TotalContact from ba710.customers group by ContactTitle order by TotalContact desc;

/* Q11 */
select ProductID,p.ProductName,s.CompanyName from ba710.products as p,ba710.suppliers as s where p.SupplierID=s.SupplierID;

/* Q12 */
SELECT ProductID,ProductName,UnitsInStock,ReorderLevel FROM ba710.products where UnitsInStock<=ReorderLevel;

/* Q13 */
select ShipCountry,avg(Freight) as AverageFreight from ba710.orders group by ShipCountry order by AverageFreight desc limit 3;
