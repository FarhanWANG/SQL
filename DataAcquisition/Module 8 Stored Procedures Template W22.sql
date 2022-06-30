
/*Create copy of ba710case.ba710_prod in work schema*/

drop table if exists work.ba710_prod;

create table work.ba710_prod as
select * from ba710case.ba710_prod;

select * from work.ba710_prod limit 5;

select max(product_id) from work.ba710_prod;

/*****STANDARD SQL*****/

/*Insert new product into work.ba710_prod and select all of the same product types*/

insert into work.ba710_prod (product_id, model, year, product_type, 
                             base_msrp, production_start_date)
value (13, "Lemon 2.0", 2022, "scooter", 549.00, now());

select * from work.ba710_prod
where product_type="scooter";

/*How to change delimiters*/


/*****STORED PROCEDURE*****/

/*Create a stored procedure that inserts new product into 
work.ba710_prod and select all of the same product types*/

drop procedure if exists work.prod_insert;

DELIMITER //

/*Create procedure with name and parameters*/
CREATE PROCEDURE 

BEGIN

END //

DELIMITER ;

/*CALL procedure with parameters*/
CALL 



/****CASE Review****/

/*Simple case expression*/
/*Return a report of products including a new column denoting 2022 scooters as "NEW"*/



/*Subquery within a case statement*/

/*How many customers are there for each scooter except Lemon?
  When Lemon, return a zero*/



/****IF SYNTAX****/

/*Note, these are not complete statements and will not execute.
  We will cover usage of IF in a Stored Procedure next class.*/
  
/*Simple IF*/  
IF first_invoice_due_date < NOW() THEN
SELECT 'Outstanding invoices are overdue!';
END IF;

/*IF with ELSE*/ 
IF first_invoice_due_date < NOW() THEN
SELECT 'Outstanding invoices are overdue!';
ELSE
SELECT 'No invoices are overdue.'; 
END IF;

/*Nested IF*/
IF first_invoice_due_date <= NOW() THEN 
SELECT 'Outstanding invoices are overdue!';
   IF first_invoice_due_date = NOW() THEN 
   SELECT 'TODAY!';
   END IF; 
ELSE
SELECT 'No invoices are overdue.'; 
END IF;

/****LOOPS****/

/*WHILE LOOP*/

/****
   s='My i output: ';
   WHILE i < 4 DO
      SET s = CONCAT(s, 'i=', i, ' ~ ');
	SET i = i + 1;
   END WHILE;
****/

drop procedure if exists work.while_demo;



call work.while_demo;

/*REPEAT LOOP*/

drop procedure if exists work.repeat_demo;



call work.repeat_demo;
