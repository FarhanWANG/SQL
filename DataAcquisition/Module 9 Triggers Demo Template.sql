
drop table if exists work.m9demo_invoices;
drop table if exists work.m9demo_vendors;
drop table if exists work.m9demo_invoice_line_items;

create table work.m9demo_invoices as
select * from ap.invoices;
create table work.m9demo_vendors as
select * from ap.vendors;
create table work.m9demo_invoice_line_items as
select * from ap.invoice_line_items;


/****Basic Syntax****/


/****Example 1****/
/****Trigger to Correct Mixed Case US State Names****/

/*Investigate Vendors*/
select * from work.m9demo_vendors
where vendor_id=1;

/*Code Trigger*/

drop trigger if exists work.vendor_state_before_update;



/*Execute Update - Change state for vendor 1 from Wisconsin to California*/
update work.m9demo_vendors
set vendor_state='ca'
where vendor_id=1;

select * from work.m9demo_vendors
where vendor_id=1;
   
   
/****Example 2****/   
/****Trigger to Validate Data Constraints****/
   
/*Investigate invoice table*/   
select * from work.m9demo_invoices
where invoice_id=100;   

select * from ap.invoice_line_items
where invoice_id=100;   

/*Code to sum line item amounts for each invoice*/
    SELECT invoice_id, SUM(line_item_amount)
    as sum_line_item_amount FROM work.m9demo_invoice_line_items
    group by invoice_id;
   
/*Code trigger that adds up the line items and checks that the 
  invoice total entered (updated) does not exceed the sum*/
drop trigger if exists work.invoices_before_update;   
   
   
   
/*Test Trigger With Update*/   
update work.m9demo_invoices
set invoice_total=679.2
where invoice_id=100;

/****Example 3****/
/****Trigger to "Audit" Data Changes Part 1: Insert****/

/*Create an audit table to keep track of changes when inserting*/

DROP TABLE IF EXISTS work.m9demo_invoices_audit;

CREATE TABLE work.m9demo_invoices_audit
(
  vendor_id           INT             NOT NULL,
  invoice_number      VARCHAR(50)     NOT NULL,
  invoice_total       DECIMAL(9,2)    NOT NULL,
  action_type         VARCHAR(50)     NOT NULL,
  action_date         DATETIME        NOT NULL
);

/*Code Trigger*/
DROP TRIGGER IF EXISTS work.invoices_after_insert;



/*Test with an insert*/
INSERT INTO work.m9demo_invoices VALUES 
(115, 34, 'ZXA-080', '2018-08-30', 14092.59, 0, 0, 3, '2018-09-30', NULL);

SELECT * FROM work.m9demo_invoices_audit;


/****Example 4****/
/****Trigger to Audit Data Changes Part 2: Delete****/

DROP TRIGGER IF EXISTS work.invoices_after_delete;

/*Note: We created the work.m9demo_invoices_audit above in Part 1*/

    
/*Test with a delete*/
DELETE FROM work.m9demo_invoices WHERE invoice_id = 115;

SELECT * FROM work.m9demo_invoices_audit;

/****SHOW TRIGGERS****/

