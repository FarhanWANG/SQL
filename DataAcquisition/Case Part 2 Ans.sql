/*Set Time Zone*/
set time_zone='-4:00';

use work;
  
/***PART 2: MARKETING ANALYSIS***/

/*General Email & Sales Prep*/

/*Create a table called WORK.CASE_SALES_EMAIL that contains all of the email data
as well as both the sales_transaction_date and the product_id from sales.
Please use the WORK.CASE_SCOOT_SALES table to capture the sales information.*/
create table work.case_sales_email
	select a.product_id,a.sales_transaction_date,b.*
	from work.case_scoot_sales a,ba710case.ba710_emails b where a.customer_id = b.customer_id;

/*Create two separate indexes for product_id and sent_date on the newly created
   WORK.CASE_SALES_EMAIL table.*/
   
alter table work.case_sales_email add index idx_product (product_id);
alter table work.case_sales_email add index idx_sent_date (sent_date);


/***Product email analysis****/
/*Bat emails 30 days prior to purchase
   Create a view of the previous table that:
   - contains only emails for the Bat scooter
   - contains only emails sent 30 days prior to the purchase date*/
CREATE VIEW bat_email AS
	SELECT *  FROM work.case_sales_email where product_id = 7 and (sales_transaction_date - sent_date) > 30;

/*Filter emails*/
/*There appear to be a number of general promotional emails not 
specifically related to the Bat scooter.  Create a new view from the 
view created above that removes emails that have the following text
in their subject.

Remove emails containing:
Black Friday
25% off all EVs
It's a Christmas Miracle!
A New Year, And Some New EVs*/

CREATE VIEW filtered_bat_email AS
select * from bat_email
where not (email_subject like '%Black Friday%' or email_subject like '%25% off all EVs%' or
email_subject like '%It\'s a Christmas Miracle!%' or email_subject like '%A New Year, And Some New EVs%' );

/*Question: How many rows are left in the relevant emails view.*/
/*Code:*/
select count(*) from filtered_bat_email;

/*Answer:       16907     */


/*Question: How many emails were opened (opened='t')?*/
/*Code:*/
select count(*) from filtered_bat_email where opened = 't';


/*Answer:     3369       */


/*Question: What percentage of relevant emails (the view above) are opened?*/
/*Code:*/
select count(*)/(select count(*) from filtered_bat_email) from filtered_bat_email where opened = 't';

 
/*Answer:      19.93%       */ 


/***Purchase email analysis***/
/*Question: How many distinct customers made a purchase (CASE_SCOOT_SALES)?*/
/*Code:*/

select count(distinct(customer_id)) from case_scoot_sales where product_id = 7;

/*Answer:     6659        */


/*Question: What is the percentage of distinct customers made a purchase after 
    receiving an email?*/
/*Code:*/

select count(distinct(customer_id)) / (select count(distinct(customer_id)) from case_scoot_sales where product_id = 7)
from case_sales_email where sales_transaction_date > sent_date and product_id = 7;

/*Answer:    56.49%         */
               
		
/*Question: What is the percentage of distinct customers that made a purchase 
    after opening an email?*/
/*Code:*/
select count(distinct(customer_id)) / (select count(distinct(customer_id)) from case_scoot_sales where product_id = 7)
from case_sales_email where sales_transaction_date > sent_date and opened = 't' and product_id = 7;

                
/*Answer:     35.76%        */

 
/*****LEMON 2013*****/
/*Complete a comparitive analysis for the Lemon 2013 scooter.  
Irrelevant/general subjects are:
25% off all EVs
Like a Bat out of Heaven
Save the Planet
An Electric Car
We cut you a deal
Black Friday. Green Cars.
Zoom 
 
/***Product email analysis****/
/*Lemon emails 30 days prior to purchase
   Create a view that:
   - contains only emails for the Lemon 2013 scooter
   - contains only emails sent 30 days prior to the purchase date*/

CREATE VIEW lemon_email AS
	SELECT *  FROM work.case_sales_email where product_id = 3 and (sales_transaction_date - sent_date) > 30;


/*Filter emails*/
/*There appear to be a number of general promotional emails not 
specifically related to the Lemon scooter.  Create a new view from the 
view created above that removes emails that have the following text
in their subject.

Remove emails containing:
25% off all EVs
Like a Bat out of Heaven
Save the Planet
An Electric Car
We cut you a deal
Black Friday. Green Cars.
Zoom */


CREATE VIEW filtered_lemon_email AS
select * from lemon_email
where not (email_subject like '%Like a Bat out of Heaven%' or email_subject like '%25% off all EVs%' or
email_subject like '%Save the Planet%' or email_subject like '%An Electric Car%' or 
email_subject like '%We cut you a deal%' or email_subject like '%Black Friday. Green Cars.%' or
email_subject like '%Zoom%');


/*Question: How many rows are left in the relevant emails view.*/
/*Code:*/
select count(*) from filtered_lemon_email;


/*Answer:       16036     */


/*Question: How many emails were opened (opened='t')?*/
/*Code:*/
select count(*) from filtered_lemon_email where opened = 't';


/*Answer:     3293       */


/*Question: What percentage of relevant emails (the view above) are opened?*/
/*Code:*/
select count(*)/(select count(*) from filtered_lemon_email) from filtered_lemon_email where opened = 't';

 
/*Answer:    20.54%         */ 


/***Purchase email analysis***/
/*Question: How many distinct customers made a purchase (CASE_SCOOT_SALES)?*/
/*Code:*/

select count(distinct(customer_id)) from case_scoot_sales where product_id = 3;

/*Answer:   13854          */


/*Question: What is the percentage of distinct customers made a purchase after 
    receiving an email?*/
/*Code:*/

select count(distinct(customer_id)) / (select count(distinct(customer_id)) from case_scoot_sales where product_id = 3)
from case_sales_email where sales_transaction_date > sent_date and product_id = 3;

/*Answer:    47.06%         */
               
		
/*Question: What is the percentage of distinct customers that made a purchase 
    after opening an email?*/
/*Code:*/

select count(distinct(customer_id)) / (select count(distinct(customer_id)) from case_scoot_sales where product_id = 3)
from case_sales_email where sales_transaction_date > sent_date and opened = 't' and product_id = 3;
                
/*Answer:       26.81%      */
