/*All tables should be created in your WORK schema, unless otherwise noted*/

/*Set Time Zone*/

set time_zone='-4:00';

select now();

/*Preliminary Data Collection
select * to investigate your tables.*/
select * from ba710case.ba710_prod;
select * from ba710case.ba710_sales;
select * from ba710case.ba710_emails;

/*Investigate production dates and prices from the prod table*/
select * from ba710case.ba710_prod
   where product_type='scooter'
   order by base_msrp;

/***PRELIMINARY ANALYSIS***/

/*Create a new table in WORK that is a subset of the prod table
which only contains scooters.
Result should have 7 records.*/
create table work.case_scoot_names as 
   select * from ba710case.ba710_prod
   where product_type = 'scooter';
   
select * from work.case_scoot_names;

/*Use a join to combine the table above with the sales information*/
create table work.case_scoot_sales as
   select a.model, a.product_type, a.product_id,
		  b.customer_id, b.sales_transaction_date, 
          date(b.sales_transaction_date) as sale_date,
          b.sales_amount, b.channel, b.dealership_id
   from work.case_scoot_names a
   inner join ba710case.ba710_sales b
      on a.product_id=b.product_id;
      
select * from work.case_scoot_sales;

/*Create a list partition for the case_scoot_sales table on product_id. (Hint: Alter table)  
Create one partition for each product_type.  
Since there are two release dates for the Lemon model, create a partition for Lemon_2010 and a partition for Lemon_2013. Name each partition as the product's name.*/

/***PART 1: INVESTIGATE BAT SALES TRENDS***/  

/*Select Bat models from your table.*/
select * from work.case_scoot_sales where model = 'Bat';

/*Count the number of Bat sales from your table.*/
select count(*) from work.case_scoot_sales where model = 'Bat';

/*What is the total revenue of Bat sales?*/
select sum(sales_amount) from work.case_scoot_sales where model = 'Bat';

/*When was most recent Bat sale?*/
select max(sale_date) from work.case_scoot_sales where model = 'Bat';

/*Summarize the number of sales (count) and sales total (sum of amount) by date
   for each product.
Create a table in your WORK schema that contains one record for each date & product id 
   combination.
Include model, product_id, sale_date, a column for count of sales, 
   and a column for sum of sales*/
create table work.case_sales_summary as 
	select model,product_id, sale_date, count(product_id) as number_of_sales, sum(sales_amount) as total_sales
	from work.case_scoot_sales group by product_id,sale_date;

/***Bat Sales Analysis*********************************/
/*Now quantify the sales trends. Create columns for cumulative sales, total sales 
   for the past 7 days, and percentage increase in cumulative sales compared to 7 
   days prior using the following steps:*/
   
   
/*CUMULATIVE SALES
   Create a table that is a subset of the table above including all columns, 
   but only include Bat scooters.   Create a new column that contains the 
   cumulative sales amount (one row per date).
Hint: Window Functions, Over*/
create table work.case_Bat_cumulative_sales as 
select *,sum(total_sales) over(partition by model order by sale_date ROWS UNBOUNDED PRECEDING)  as cumulative_sales
from work.case_sales_summary where model = 'Bat';

/*SALES PAST 7 DAYS
   Add a column to the table created above (or create a new table with an additional
   column) that computes a running total of sales for the previous 7 days.
   (i.e., for each record the new column should contain the sum of sales for 
   the current date plus the sales for the preceeding 6 records).*/
#drop table work.case_cumulative_sales;

create table work.case_Bat_running_sales as 
select *,sum(total_sales) OVER(rows between 6 preceding and current row) as running_total_sales 
from work.case_Bat_cumulative_sales;

/*GROWTH IN CUMULATIVE SALES OVER THE PAST WEEK
   Add a column to the table created above (or create a new table with an additional 
   column) that computes the cumulative sales growth in the past week as a percentage change
   of cumulative sales (current record) compared to the cumulative sales from the 
   same day of the previous week (seven records above).  
(Formula: (Current Cumulative Sales - Cumulative Sales 7 Days Ago) / Cumulative Sales 7 Days Ago
(Hint: Use the lag function.)*/
create table work.case_Bat_growth_sales as 
select *, running_total_sales/ (lag(running_total_sales,7)  over()) -1 as growth from work.case_Bat_running_sales;



/*When Part 2 is released tomorrow, please include a screenshot of your results grid
   for your final Bat Sales Analysis Table*/

/*Question: On what date does the cumulative weekly sales growth drop below 10%?
Answer:  */   
select sale_date from work.case_Bat_growth_sales where growth < 0.1;

/*Question: How many days since the launch date did it take for cumulative sales growth
to drop below 10%?
Answer:                                */
select min(sale_date) from work.case_Bat_growth_sales;
select min(sale_date) from work.case_Bat_growth_sales where growth < 0.1;
/* 13 days */

/***Bat Limited Edition Sales Analysis*********************************/
/*Is the launch timing (October) a potential cause for the drop?
Replicate the Bat Sales Analysis for the Bat Limited Edition.
As above, complete the steps to calculate CUMULATIVE SALES, SALES PAST 7 DAYS,
and CUMULATIVE SALES GROWTH IN PAST WEEK*/

create table work.case_BLE_cumulative_sales as 
select *,sum(total_sales) over(partition by model order by sale_date ROWS UNBOUNDED PRECEDING)  as cumulative_sales
from work.case_sales_summary where model = 'Bat Limited Edition';

create table work.case_BLE_running_sales as 
select *,sum(total_sales) OVER(rows between 6 preceding and current row) as running_total_sales 
from work.case_BLE_cumulative_sales;

create table work.case_BLE_growth_sales as 
select *, running_total_sales/ (lag(running_total_sales,7)  over()) -1 as growth from work.case_BLE_running_sales;
select * from work.case_sales_summary;

/*When Part 2 is released tomorrow, please include a screenshot of your results grid
   for your final Bat Limited Edition Sales Analysis Table*/

/*Question: On what date does the cumulative weekly sales growth drop below 10%?
Answer:     */       
select sale_date from work.case_BLE_growth_sales where growth < 0.1;

/*Question: How many days since the launch date did it take for cumulative sales growth
to drop below 10%?
Answer:             */                   
select min(sale_date) from work.case_BLE_growth_sales;
select min(sale_date) from work.case_BLE_growth_sales where growth < 0.1;
/* 2 days */

/*Question: Is there a difference in the behavior in cumulative sales growth 
between the Bat edition and either the Bat Limited edition? (Make a statement comparing
the growth statistics.)
Answer:                       */
/* Yes. Bat Limited edition is worse than Bat edition. Bucause It takes shorter duration for Bat Limited edition to drop below 10% */

/***Lemon 2013 Sales Analysis*********************************/
/*The Bat Limited was at a higher price point than the Bat.
Let's take a look at the 2013 Lemon model, since it's also a similar price point.  
Replicate the Bat Sales Analysis for the 2013 Lemon scooter.
As above, complete the steps to calculate CUMULATIVE SALES, SALES PAST 7 DAYS,
and CUMULATIVE SALES GROWTH IN PAST WEEK*/
select * from work.case_sales_summary;

create table work.case_Lemon_cumulative_sales as 
select *,sum(total_sales) over(partition by model order by sale_date ROWS UNBOUNDED PRECEDING)  as cumulative_sales
from work.case_sales_summary where product_id = 3;

create table work.case_Lemon_running_sales as 
select *,sum(total_sales) OVER(rows between 6 preceding and current row) as running_total_sales 
from work.case_Lemon_cumulative_sales;

create table work.case_Lemon_growth_sales as 
select *, running_total_sales/ (lag(running_total_sales,7)  over()) -1 as growth from work.case_Lemon_running_sales;

/*When Part 2 is released tomorrow, please include a screenshot of your results grid
   for your final 2013 Lemon Sales Analysis Table*/

/*Question: On what date does the cumulative weekly sales growth drop below 10%?
Answer:          */  
select sale_date from work.case_Lemon_growth_sales where growth < 0.1;

/*Question: How many days since the launch date did it take for cumulative sales growth
to drop below 10%?
Answer:                   */             
select min(sale_date) from work.case_Lemon_growth_sales;
select min(sale_date) from work.case_Lemon_growth_sales where growth < 0.1;
/* 12 days */

/*Question: Is there a difference in the behavior in cumulative sales growth 
between the Bat edition and the 2013 Lemon edition?  (Make a statement comparing
the growth statistics.)
Answer:                            */

/* Yes. 2013 Lemon edition is worse than Bat edition. Bucause It takes shorter duration for Bat Limited edition to drop below 10% */

  