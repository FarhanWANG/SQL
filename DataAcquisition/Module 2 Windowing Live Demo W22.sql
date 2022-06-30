
/*count number of records*/

select count(*) from ba710.orders;

/*count number of records & add the total to each row in orders*/

select *, count(*) OVER() as totalrecords from ba710.orders;

/*count number of records for each employee*/

select employeeid, count(*) as totalorders
from ba710.orders
group by employeeid;

/*count number of records for each employee and add total to existing row*/

select *, count(*) OVER(partition by employeeid) as totalorders
from ba710.orders;

/*create a running total of the count(*) values*/
select *, count(*) OVER(partition by employeeid) as totalorders,
          count(*) OVER(order by employeeid) as runningtotal
from ba710.orders;

/*create a row number for each record*/
select *, count(*) OVER(order by orderid) as totalorders
from ba710.orders;


select *, row_number() OVER() as totalorders
from ba710.orders;

/*calculate the average freight for each customer*/
select customerid, avg(freight) as avg_freight
from ba710.orders
group by customerid
order by customerid;

/*calculate the average freight for each customer adding the avg to each row of the old table*/
select *, avg(freight) OVER(partition by customerid) as avg_freight
from ba710.orders
order by customerid;

/*what is the difference between the current freight and the avg for each customer?*/
select orderid, customerid, freight, 
   avg(freight) OVER(partition by customerid) as avg_freight,
   freight-(avg(freight) OVER(partition by customerid)) as difference
from ba710.orders
order by customerid;

/*calculate the moving average freight across 3 rows*/
select orderid, customerid, freight, 
   avg(freight) OVER(rows between 2 preceding and current row) as moving_avg_freight
from ba710.orders
order by customerid;

/*calculate the moving average freight across 3 previous rows*/
select orderid, customerid, freight, 
   avg(freight) OVER(rows between 3 preceding and 1 preceding) as moving_avg_freight
from ba710.orders
order by customerid;

/*calculate a running total for freight*/
select orderid, customerid, employeeid, shipvia, freight,
   sum(freight) OVER(order by orderid) as running_total
from ba710.orders;

/*calculate a running total for freight for each customer*/
select orderid, customerid, employeeid, shipvia, freight,
   sum(freight) OVER(partition by customerid order by orderid) as running_total
from ba710.orders;

/*What is the freight value of the previous order?*/
select orderid, customerid, employeeid, shipvia, freight,
   lag(freight,1) OVER() as lag_freight
from ba710.orders;

/*What is the freight value of the next order?*/
select orderid, customerid, employeeid, shipvia, freight,
   lead(freight,1) OVER() as lead_freight
from ba710.orders;

/*What is the first freight value for each customer?*/
select orderid, shippeddate, customerid, employeeid, shipvia, freight,
   first_value(freight) OVER(partition by customerid) as first_freight
from ba710.orders;

/*What is the most recent (last) freight value for each customer?*/
select orderid, shippeddate, customerid, employeeid, shipvia, freight,
   last_value(freight) OVER(partition by customerid) as last_freight
from ba710.orders;

/*What is the lowest freight value for each customer?*/
select orderid, shippeddate, customerid, employeeid, shipvia, freight,
   first_value(freight) OVER(partition by customerid) as first_freight,
   min(freight) OVER(partition by customerid) as min_freight
from ba710.orders;

/*rank records by freight. no increment when ranking is tied. gap in ranking when tied.*/
select orderid, customerid, freight, rank() OVER(order by freight)
from ba710.orders;

/*rank records by freight. increment even when there is a tie. no gap in ranking when tied.*/
select orderid, customerid, freight, dense_rank() OVER(order by freight)
from ba710.orders;

/*rank records by freight. instead of assigning ranking, assign a percentile (range).*/
select orderid, customerid, freight, percent_rank() OVER(order by freight)
from ba710.orders;

/*rank records by freight. instead of assigning ranking, assign a decile (nth-ile.*/
select orderid, customerid, freight, ntile(10) OVER(order by freight)
from ba710.orders;