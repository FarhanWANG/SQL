
/*Copy AP database so we don't alter it*/

drop database if exists ap_demo;
create database ap_demo;
-- create table ap_demo.balance_due_table as select * from ap.balance_due_table;
create table ap_demo.general_ledger_accounts as select * from ap.general_ledger_accounts;
-- create table ap_demo.invoice_archive as select * from ap.invoice_archive;
-- create table ap_demo.invoice_line_items as select * from ap.invoice_line_items;
-- create table ap_demo.invoices as select * from ap.invoices;
create table ap_demo.terms as select * from ap.terms;
create table ap_demo.vendor_contacts as select * from ap.vendor_contacts;
-- create table ap_demo.vendors as select * from ap.vendors;

/*Set the default databse to ap_demo*/

USE ap_demo;

/****Demonstration of basic stored procedure syntax****/

delimiter //

create procedure name(varname1 char(20),
                      varname2 int)
begin



end //

delimiter;



/****Simple stored procedure that insterts****/

DROP PROCEDURE IF EXISTS insert_invoice;

DELIMITER //

CREATE PROCEDURE insert_invoice
(
  vendor_id_param        INT,
  invoice_number_param   VARCHAR(50),
  invoice_date_param     DATE,
  invoice_total_param    DECIMAL(9,2),
  terms_id_param         INT,
  invoice_due_date_param DATE
)
BEGIN
  INSERT INTO invoices
         (vendor_id, invoice_number, invoice_date, 
          invoice_total, terms_id, invoice_due_date)
  VALUES (vendor_id_param, invoice_number_param, invoice_date_param, 
          invoice_total_param, terms_id_param, invoice_due_date_param);
END//

DELIMITER ;

-- test; this statement does not raise an error; note the null for the due date column.
CALL insert_invoice(34, 'ZXA-080', '2018-01-18', 14092.59, 3, '2018-03-18');

select * from ap_demo.invoices;

-- this statement raises an error because NULL values in not NULL fields
CALL insert_invoice(35, 'ZXA-082', '2018-01-18', 14092.59, NULL, NULL);

/* Side note: this statement does not raise an error, but we would like it 
   to raise an error, since the invoice amount is negative.  This can be handled
   with stored procedures (this class) or triggers (next class).*/
CALL insert_invoice(36, 'ZXA-083', '2018-01-18', -14092.59, 3, '2018-03-18');

-- clean up
DELETE FROM invoices WHERE invoice_id in (34,35,36);



/****Set default value****/

DROP PROCEDURE IF EXISTS show_customer_credit_total;

DELIMITER //

CREATE PROCEDURE show_customer_credit_total
(
  customer_id_param     INT
)
BEGIN
   DECLARE credit_total_param Decimal(9,2) DEFAULT 0;
    
   select concat(customer_id_param, ' has a credit total of ', credit_total_param) 
      as message;
  
END//

DELIMITER ;

-- call with param
CALL show_customer_credit_total(56);


/****Set conditional default values****/

DROP PROCEDURE IF EXISTS show_customer_credit_total;

DELIMITER //

CREATE PROCEDURE show_customer_credit_total
(
  customer_id_param    INT,
  credit_total_param   DECIMAL(9,2)
)
BEGIN
 -- DECLARE credit_total_param Decimal(9,2) DEFAULT 0;
    
  -- Set default values for NULL values
  IF credit_total_param IS NULL THEN
    SET credit_total_param = 100;
  END IF;
  
  select concat(customer_id_param, ' has a credit total of ', credit_total_param) 
     as message;
  
END//

DELIMITER ;


-- call with param
CALL show_customer_credit_total(56, 200);

-- call without param
CALL show_customer_credit_total(56, NULL);

-- note, you must use the word NULL and not leave blank
CALL show_customer_credit_total(56);
CALL show_customer_credit_total(56,);

/*An example using declare and if with a SQL table*/
/*Write a script that creates and calls a stored procedure named m8_example_1. 
This stored procedure should declare a variable and set it to the count of all 
rows in the Invoices table that have a balance due that's greater than or equal 
to $5,000. Then, the stored procedure should display a result set that displays 
the variable in a message like this:

3 invoices exceed $5,000.*/

drop procedure if exists m8_example_1;  

delimiter //

create procedure m8_example_1()
begin
	declare invoice_count_param int;

	select count(invoice_id) 
	into invoice_count_param
	from invoices
	where Invoice_total - payment_total - credit_total >= 5000;

	if invoice_count_param > 0 then
		select concat(invoice_count_param,' invoice(s) exceed $5000') as message;
	else
		select 'No invoices exceed $5000' as message;
	end if;
end//

delimiter ;

call m8_example_1();

/****Using ERRORS****/
/*https://dev.mysql.com/doc/mysql-errors/8.0/en/server-error-reference.html*/

/*Build on the procedure above but stop the script and generate an error
  if the credit is negative or if the credit is greater than or equal to 1000*/
DROP PROCEDURE IF EXISTS show_customer_credit_total;

DELIMITER //

CREATE PROCEDURE show_customer_credit_total
(
  customer_id_param    INT,
  credit_total_param   DECIMAL(9,2)
)
BEGIN
-- Validate paramater values
  IF credit_total_param < 0 THEN
	SIGNAL SQLSTATE '22003'
	SET MESSAGE_TEXT =
       'The credit_total column must be greater than or equal to 0.',
       MYSQL_ERRNO = 1264;
  ELSEIF credit_total_param >= 1000 THEN
	SIGNAL SQLSTATE '22003'
	SET MESSAGE_TEXT = 
        'The credit_total column must be less than 1000.', 
        MYSQL_ERRNO = 1264;
  END IF;
    
  -- Set default values for NULL values
  IF credit_total_param IS NULL THEN
    SET credit_total_param = 100;
  END IF;
  
  select concat(customer_id_param, ' has a credit total of ', credit_total_param) 
     as message;
  
END//

DELIMITER ;


-- call with param
CALL show_customer_credit_total(56, 200);

CALL show_customer_credit_total(56, -200);

CALL show_customer_credit_total(56, 1200);


/****User Variables****/
/*The variables above are only available inside the stored procedure.
  For instance, customer_id_param in the above procedure is not available elsewhere.*/
 
select customer_id_param; 
select @customer_id_param;

/*What variables are available to the system?*/

show variables;

/*Declare a User Variable for the session*/
set @customer_id_param=10;
select @customer_id_param;

/*How to create a user variable for the session with a stored procedure*/
DROP PROCEDURE IF EXISTS show_customer_credit_total;

DELIMITER //

CREATE PROCEDURE show_customer_credit_total
(
  customer_id_param     INT,
  out update_count      INT
)
BEGIN
   DECLARE credit_total_param Decimal(9,2) DEFAULT 0;
    
   select concat(customer_id_param, ' has a credit total of ', credit_total_param) 
      as message;
      
   set update_count = customer_id_param + 1;   
  
END//

DELIMITER ;

-- call with param
CALL show_customer_credit_total(56,@next_cust);

select @next_cust;
/*The following could be used in a select statement*/
/*select customer_id=@next_cust;*/

select concat('The next customer should be ', @next_cust) as message;


/********************FUNCTIONS*********************/

/****Basic Function Syntax****/

CREATE FUNCTION function_name (var1 char(20),
                               var2 decimal(9,2))
RETURNS /*decimal(11,2)*/ char(55)
RETURN do something here...;

/****Example Function #1 DETERMINISTIC No SQL****/

select * from ap_demo.vendor_contacts;

drop function if exists full_name;

create function full_name (first_param char(20),
                           last_param char(30))
RETURNS CHAR(51) DETERMINISTIC NO SQL
RETURN concat(first_param, ' ', last_param);

select *, full_name(first_name, last_name) as full_name from vendor_contacts limit 5;

/****Example Function #2 DETERMINISTIC****/

drop function if exists get_balance_due;

DELIMITER //

CREATE FUNCTION get_balance_due (
invoice_id_param INT
)
RETURNS DECIMAL(9,2) DETERMINISTIC READS SQL DATA
BEGIN
DECLARE balance_due_var DECIMAL(9,2);
SELECT invoice_total - payment_total - credit_total 
   INTO balance_due_var
   FROM ap_demo.invoices
   WHERE invoice_id = invoice_id_param;
RETURN balance_due_var;
END//

delimiter ;

select invoice_id/*, invoice_total, payment_total, credit_total*/, get_balance_due(10) as balance_due
from invoices
where invoice_id=10;

select invoice_id/*, invoice_total, payment_total, credit_total*/, get_balance_due(105) as balance_due
from invoices
where invoice_id=105;



/****Example Function #3 NOT DETERMINISTIC****/

select round(rand()*1000) as random_num;

drop function if exists rand_int;

create function rand_int()
returns int NOT DETERMINISTIC NO SQL
return round(rand() * 1000);

select rand_int();
