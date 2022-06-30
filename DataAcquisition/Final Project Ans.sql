/*Make a copy of the balance due table in your work library.*/

create table work.project_balance_due as select * from ap.balance_due_table;

/*Create a stored procedure called Work.Balance_Due_Insert that inserts a record into 
the work.balance_due_table by passing the five following parameters: 
Vendor Name, Invoice Number, Invoice Amount, Payment Amount, Credit Amount.*/


DROP PROCEDURE IF EXISTS Balance_Due_Insert;

DELIMITER //
CREATE PROCEDURE Balance_Due_Insert
(
  vendor_name_param      VARCHAR(50),
  invoice_number_param   VARCHAR(50),
  invoice_total_param    DECIMAL(9,2),
  payment_total_param    DECIMAL(9,2),
  credit_total_param    DECIMAL(9,2)
)
BEGIN
   DECLARE balance_due_param Decimal(9,2) DEFAULT 0;
   set balance_due_param = invoice_total_param - payment_total_param - credit_total_param;
   INSERT INTO work.project_balance_due
         (vendor_name, invoice_number, invoice_total, payment_total, credit_total,balance_due)
   VALUES (vendor_name_param, invoice_number_param, invoice_total_param, 
          payment_total_param, credit_total_param, balance_due_param);
END//
DELIMITER ;

call work.Balance_Due_Insert('Test',10000,100,10,10);


/*Create a trigger to validate the Vendor Name. The Vendor Name passed by the end user 
should always be inserted as upper case, even if it isn’t entered upper case as a parameter.*/

drop trigger if exists work.balance_due_before_insert;   

DELIMITER //
CREATE TRIGGER balance_due_before_insert
BEFORE insert ON work.project_balance_due
FOR EACH ROW
BEGIN
set NEW.vendor_name = upper(NEW.vendor_name);
END;//


/*Create a trigger to validate the Payment Amount.  The Payment Amount should never be larger than the Invoice Amount, 
so the code should generate an error, if it encounters a payment greater than the invoice.  
(Hint: This would be an error where the data is out of range.)*/

drop trigger if exists work.validate_balance_due_before_insert; //

CREATE TRIGGER validate_balance_due_before_insert
BEFORE insert ON work.project_balance_due
	FOR EACH ROW
		BEGIN
			IF NEW.payment_total > NEW.invoice_total THEN
				SIGNAL SQLSTATE 'HY000'
				SET MESSAGE_TEXT = 'Data is out of range. The payment total becomes larger than the invoice total.';
			END IF;
		END;//

Call work.balance_due_insert('ULTIMATE BACKYARD', 1102125, 600, 50, 50);//
Call work.balance_due_insert ('ORION Ltd', 28682021, 9260.99, 0, 1000);//
Call work.balance_due_insert ('Bat Scooters', 312710, 11100, 42910, 3800);//






















