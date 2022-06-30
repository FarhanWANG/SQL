/*
BA710 Winter 2022
Module 2: Window Functions
Due: Thursday March 17th 11:59PM (grace period to Sunday March 20th 11:59PM)

Complete the following exercises and upload a screenshot of your Results Grid
and Action Output (in this Word document) as well a completed SQL script template
for the entire exercise.  Please use comments in the SQL script to denote each question.

Please use Window functions for every question in this lab.
*/
select * from ba710.orders;
/*
1. 1. Create row numbers and a first order field for each country.  Include ShipCountry, CustomerID, 
OrderID, and OrderDate.  Your output should also contain a field for the earliest 
order for each country.  Your output should also contain a row number for each 
record within a country.  (e.g., France should start at 1 and count up; Belgium 
should then start at 1 and count up.)
*/

select ShipCountry,CustomerID,OrderID,OrderDate, row_number() over (partition by ShipCountry) as RowNumber, min(OrderDate) over (partition by ShipCountry) as EarliestOrderDate from ba710.orders;

/*
2. Show the number of days between the current order and the previous order.  
Keep CustomerID, OrderID, OrderDate, a column for the previous order’s date and 
a column for the difference in days.
*/

select CustomerID,OrderID,OrderDate,lag(OrderDate,1) OVER() as lag_OrderDate, Date(OrderDate) - Date(lag(OrderDate,1) OVER()) as Difference from ba710.orders;

/*
3. What is the average unit price for each order?  Include all columns from 
the OrderDetails table and a new column for average unit price.
*/

SELECT *,avg(UnitPrice) over(partition by OrderID) as AverageUnitPrice FROM ba710.orderdetails;

/*
4. Using the Customers table, how many customers are in each country?  
Keep CustomerID, CompanyName, Country and a new column for number of customers.
*/

select CustomerID,CompanyName,Country,count(CustomerID) over (partition by Country) as NumberOfCustomers from ba710.customers;

/*
5. What is the maximum freight for each country.  Keep OrderID, CustomerID, 
ShipVia, Freight and a new column for the maximum freight per country.
*/

select OrderID,CustomerID,ShipVia,Freight,max(Freight) over (partition by ShipCountry) from ba710.orders;

/*
6. Calculate a moving average of freight when ordered by descending shipping date 
and ascending order_id.  Keep OrderID, CustomerID, ShipVia, ShippedDate and 
a new column for the moving average.
*/

select OrderID,CustomerID,ShipVia,ShippedDate,avg(Freight) over (rows between 2 preceding and current row) as moving_avg_freight from ba710.orders order by ShippedDate desc, OrderID asc;

/*
7. Now calculate a moving average of freight when ordered by descending shipping date 
and ascending order_id using only the 5 preceding records.  Keep OrderID, CustomerID, 
ShipVia, ShippedDate and a new column for the moving average.
*/

select OrderID,CustomerID,ShipVia,ShippedDate,avg(Freight) over (rows between 5 preceding and 1 preceding) as moving_avg_freight from ba710.orders order by ShippedDate desc, OrderID asc;

/*
8. What is the average unit price for each shipping date?  You will need to 
join two tables.  Keep ShippedDate, OrderID, UnitPrice and a new column for 
the average unit price per date.
*/


select ShippedDate,o.OrderID as OrderID, UnitPrice, avg(UnitPrice) over (partition by (ShippedDate)) from ba710.orders as o
join  ba710.orderdetails as od on o.OrderID=od.OrderID;

