
USE ap;

/*Slide 2: What is a View*/

CREATE VIEW vendors_min AS
  SELECT vendor_name, vendor_state, vendor_phone
  FROM vendors;

/*Use as a table; e.g., Select, Update*/  
SELECT * FROM vendors_min
WHERE vendor_state = 'CA'
ORDER BY vendor_name;

UPDATE vendors_min
SET vendor_phone = '(800) 555-3941'
WHERE vendor_name = 'Register of Copyrights';

DROP VIEW vendors_min;

/*Slide 4: Illustrating Pros of Views*/

CREATE VIEW vendors_phone_list AS
  SELECT vendor_name, vendor_contact_last_name, 
         vendor_contact_first_name, vendor_phone
  FROM vendors
  WHERE vendor_id IN (SELECT DISTINCT vendor_id FROM invoices);
  
CREATE OR REPLACE VIEW vendor_invoices AS
  SELECT vendor_name, invoice_number, invoice_date, invoice_total 
  FROM vendors 
    JOIN invoices ON vendors.vendor_id = invoices.vendor_id;
    
CREATE OR REPLACE VIEW top5_invoice_totals AS
  SELECT vendor_id, invoice_total
  FROM invoices
  ORDER BY invoice_total DESC
  LIMIT 5;

CREATE OR REPLACE VIEW invoices_outstanding AS
  SELECT invoice_number, invoice_date, invoice_total,
         invoice_total - payment_total - credit_total AS balance_due
  FROM invoices
  /*HAVING balance_due > 0*/
  WHERE (invoice_total - payment_total - credit_total) > 0;

CREATE OR REPLACE VIEW invoices_outstanding
  (invoice_number, invoice_date, invoice_total, balance_due)
AS
  SELECT invoice_number, invoice_date, invoice_total,
         invoice_total - payment_total - credit_total
  FROM invoices
  WHERE invoice_total - payment_total - credit_total > 0;
    
CREATE OR REPLACE VIEW invoice_summary AS
  SELECT vendor_name, 
    COUNT(*) AS invoice_count, 
    SUM(invoice_total) AS invoice_total_sum
  FROM vendors 
    JOIN invoices ON vendors.vendor_id = invoices.vendor_id
  GROUP BY vendor_name;
  
/*Slide 7: Example of a restriction*/

CREATE OR REPLACE VIEW balance_due_view AS 
  SELECT vendor_name, invoice_number, 
         invoice_total, payment_total, credit_total, 
         invoice_total - payment_total - credit_total AS balance_due
  FROM vendors JOIN invoices ON vendors.vendor_id = invoices.vendor_id
  WHERE invoice_total - payment_total - credit_total > 0;
  
select * from balance_due_view;  
  
UPDATE balance_due_view
SET credit_total = 300
WHERE invoice_number = '9982771';

/*Note the error.  Why?*/
UPDATE balance_due_view
SET balance_due = 0
WHERE invoice_number = '9982771';  


/*Further Examples Demo*/


/*Deleting from a View (Insert works the same way)*/

CREATE OR REPLACE VIEW ibm_invoices AS
  SELECT invoice_number, invoice_date, invoice_total
  FROM invoices
  WHERE vendor_id = 34;

DELETE FROM ibm_invoices
WHERE invoice_number = 'Q545443';

/*"Updating" views*/

CREATE VIEW vendors_sw AS
SELECT *
FROM vendors
WHERE vendor_state IN ('CA','AZ','NV','NM');

CREATE OR REPLACE VIEW vendors_sw AS
SELECT *
FROM vendors
WHERE vendor_state IN ('CA','AZ','NV','NM','UT','CO');

DROP VIEW vendors_sw;

