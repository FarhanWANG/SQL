
/*Module 9 Lab Exercises*/
/*Due Sunday April 24th*/
/*Complete the following template:*/

use work;

select * From m9demo_invoice_line_items;
/****Exercise 1****/
/*1. Modify the trigger named invoices_before_update that was shown in Example 2 
     of the demo so it ALSO raises an error whenever the payment total
     plus the credit total becomes larger than the invoice total in a row. 
     Then, test this trigger with appropriate UPDATE statements.*/
    
SELECT * FROM work.m9demo_invoices;

drop trigger if exists work.invoices_before_update;   

DELIMITER //
CREATE TRIGGER invoices_before_update
BEFORE UPDATE ON m9demo_invoices
	FOR EACH ROW
		BEGIN
			IF NEW.payment_total + NEW.credit_total > NEW.invoice_total THEN
				SIGNAL SQLSTATE 'HY000'
				SET MESSAGE_TEXT = 'The payment total plus the credit total becomes larger than the invoice total.';
			END IF;
		END;//



update work.m9demo_invoices
set invoice_total=40.2,payment_total=100
where invoice_id=2;//


/****Exercise 2****/
/*2. Recreate the work.m9demo_invoices_audit table from Example 3 of the demo, if you 
     haven't already.  Create a trigger named invoices_after_update. This trigger 
     should insert the old data about the invoice into the Invoices Audit table 
     after the row is updated. Then, test this trigger with appropriate 
     UPDATE statements.*/
     
drop trigger if exists work.invoices_after_update;   //

CREATE TRIGGER invoices_after_update
BEFORE UPDATE ON m9demo_invoices
FOR EACH ROW
BEGIN
	INSERT INTO m9demo_invoices_audit (vendor_id, invoice_number, invoice_total)
	SELECT vendor_id, invoice_number, invoice_total
	FROM m9demo_invoices where invoice_id = NEW.invoice_id;
END;//

UPDATE m9demo_invoices
SET invoice_total=40.2,payment_total=10
WHERE invoice_id=2;//





