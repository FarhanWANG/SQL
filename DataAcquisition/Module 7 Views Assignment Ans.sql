
/*Complete the template below with code that uses views*/
use ap;
/*Question 1:
Create a view named open_items that shows the invoices that haven't been paid.

This view should return four columns from the Vendors and Invoices tables:
vendor_name, invoice_number, invoice_total, 
and balance_due (invoice_total - payment_total - credit_total).

A row should only be returned when the balance due is greater than zero, 
and the rows should be in sequence by vendor_name.
*/
CREATE OR REPLACE VIEW open_items AS 
  SELECT vendor_name, invoice_number, 
         invoice_total, invoice_total - payment_total - credit_total AS balance_due
  FROM vendors JOIN invoices ON vendors.vendor_id = invoices.vendor_id
  WHERE invoice_total - payment_total - credit_total > 0;


/*Question 2:
Create a view named open_items_summary that returns one summary row for 
each vendor that has invoices that haven't been paid.
Each row should include vendor_name, open_item_count 
(the number of invoices with a balance due), 
and open_item_total (the total of the balance due amounts)
The rows should be sorted by the open item totals in descending sequence.
*/
CREATE OR REPLACE VIEW open_items_summary AS 
	select vendor_name, count(vendor_name) as open_item_count, sum(balance_due) as open_item_total 
	from open_items 
	group by vendor_name 
	order by open_item_total desc;



/*Question 3:
Write a SELECT statement that returns just the first 5 rows from 
the open_items_summary view that you created in question 2.
*/

select * from open_items_summary limit 5;

/*Question 4:
Create an updatable view named vendor_address that returns the 
vendor_id column and all of the address columns for each vendor.
*/
CREATE OR REPLACE VIEW vendor_address AS 
select vendor_id, vendor_address1, vendor_address2, vendor_city, vendor_state, vendor_zip_code
from vendors;
    
/*Question 5:
Write an UPDATE statement that changes the address for the 
row with a vendor ID of 4 so the suite number (Ste 260) is 
stored in the vendor_address2 column instead of the vendor address1 column.
*/


UPDATE vendor_address
SET vendor_address2 = 'Ste 260',vendor_address1 = replace(vendor_address1,'Ste 260','')
WHERE vendor_id = 4;
















