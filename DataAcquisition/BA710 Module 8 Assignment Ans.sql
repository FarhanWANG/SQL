
/*Copy AP database so we don't alter it*/

drop database if exists ap_demo;
create database ap_demo;
# create table ap_demo.balance_due_table as select * from ap.balance_due_table;
create table ap_demo.general_ledger_accounts as select * from ap.general_ledger_accounts;
create table ap_demo.invoice_archive as select * from ap.invoice_archive;
create table ap_demo.invoice_line_items as select * from ap.invoice_line_items;
create table ap_demo.invoices as select * from ap.invoices;
create table ap_demo.terms as select * from ap.terms;
create table ap_demo.vendor_contacts as select * from ap.vendor_contacts;
create table ap_demo.vendors as select * from ap.vendors;

/*Set the default databse to ap_demo*/

USE ap_demo;

/****Question 1****/
DROP PROCEDURE IF EXISTS m8_question_1;

DELIMITER //
CREATE PROCEDURE m8_question_1()
BEGIN
	declare balance_count_param int;
    declare balance_total_param int;

	select count(invoice_id),sum(banlance)
		into balance_count_param,balance_total_param
		from balance_due_table;

	if balance_total_param >= 30000 then
		select balance_count_param,balance_total_param;
	else
		select 'Total balance due is less than $30,000.';
	end if;  

  select concat(customer_id_param, ' has a credit total of ', credit_total_param) 
     as message;
END//
DELIMITER ;

CALL m8_question_1();




/****Question 2****/
DROP PROCEDURE IF EXISTS m8_question_2;

DELIMITER //
CREATE PROCEDURE m8_question_2
(
  account_number_param        INT,
  account_description_param   VARCHAR(50)
)
BEGIN
  INSERT INTO general_ledger_accounts
         (account_number, account_description)
  VALUES (account_number_param, account_description_param);
END//
DELIMITER ;

CALL m8_question_2(1233,"6m");


/****Question 3****/
DROP PROCEDURE IF EXISTS m8_question_3;

DELIMITER //
CREATE PROCEDURE m8_question_3
(
  terms_id_param        INT,
  terms_due_days_param INT,
  terms_description_param   VARCHAR(50)
)
BEGIN
  IF terms_description_param IS NULL THEN
    SET terms_description_param = concat('Net due ', terms_due_days_param,' days') ;
  END IF;
  
  INSERT INTO terms
         (terms_id, terms_description,terms_due_days)
  VALUES (terms_id_param, terms_description_param,terms_due_days_param);
END//
DELIMITER ;

Call m8_question_3(6,120,'Net due 120 days');
Call m8_question_3(7,120,NULL);


/****Question 4****/
DROP Function IF EXISTS m8_question_4;

DELIMITER //
CREATE FUNCTION m8_question_4 (invoice_id_param INT)
RETURNS DECIMAL(9,2) DETERMINISTIC READS SQL DATA
BEGIN
DECLARE number_days DECIMAL(9,2);
SELECT invoice_due_date - payment_date
   INTO number_days
   FROM ap_demo.invoices
   WHERE invoice_id = invoice_id_param;
RETURN number_days;
END//
delimiter ;

select invoice_id,m8_question_4(1) FROM ap_demo.invoices where invoice_id = 1;

/****Question 5****/
DROP Function IF EXISTS m8_question_5;

DELIMITER //
CREATE FUNCTION m8_question_5 (vendor_id_param INT)
RETURNS varchar(50) DETERMINISTIC READS SQL DATA
BEGIN
DECLARE adde varchar(50);
SELECT concat(vendor_city,', ',vendor_state)
   INTO adde
   FROM ap_demo.vendors
   WHERE vendor_id = vendor_id_param;
RETURN adde;
END//
delimiter ;

select vendor_id,m8_question_5(1) FROM ap_demo.vendors where vendor_id = 1;





