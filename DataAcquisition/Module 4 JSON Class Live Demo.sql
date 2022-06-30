create database work;

/*What does JSON look like
{"name":"David"}
*/

/*Create an empty table*/
create table work.jsontest (price int);
drop table work.jsontest;

/*Create an empty table with a JSON field*/
create table work.jsontest (mytags json);

/*Insert a JSON "string" into the table*/
insert into work.jsontest
   values('{"name":"David"}'),
		 ('{"name":"Rohan"}'),
         ('{"name":"Ulya"}');
         
select * from work.jsontest;


/*Insert multiple items into a JSON column*/
drop table work.jsontest;
/*Create an empty table with a JSON field*/
create table work.jsontest (mytags json);

/*Insert a JSON "string" into the table*/
insert into work.jsontest
   values('{"name":"David","isfulltime":true}'),
		 ('{"name":"Rohan","isfulltime":false}'),
         ('{"name":"Ulya","isfulltime":null}');
         
select * from work.jsontest;

/*Example of standard SQL extract*/
select current_date(), extract(month from current_date());

/*Extract items for a JSON field*/
select json_extract(mytags,'$.name') as first_name
from work.jsontest;

/*Extract items for a JSON field without quotes*/
select json_unquote(json_extract(mytags,'$.name')) as first_name
from work.jsontest;

/*Extract items for a JSON field*/
select mytags->'$.name' as first_name
from work.jsontest;

/*Extract items for a JSON field without quotes*/
select mytags->>'$.name' as first_name
from work.jsontest;

/*Using a where clause with JSON*/
select * from work.jsontest
   where json_extract(mytags,'$.name')='David'; /*pay attention to case in JSON*/
   
select * from work.jsontest
   where mytags->>'$.name'='David'; /*note how double arrow behaves*/
   
select * from work.jsontest
   where mytags->'$.name'='David'; /*note how single headed arrow behaves*/
   
/*A JSON field can be just one variable in a table that contains other variable types*/

create table work.jsontest2 (id int,
							 day varchar(15),
                             newfield json);
                             
insert into work.jsontest2
   values (1, "Monday",'{"cost":12,"product":"eggs"}'),
   (2, "Tuesday",'{"cost":10,"product":"bread"}'),
   (5, "Friday",'{"cost":null,"product":"milk"}');

select * from work.jsontest2;

/*JSON fields are very flexible.  They don't have to be in the same order*/
create table work.jsontest3 (id int,
							 day varchar(15),
                             newfield json);
                             
insert into work.jsontest3
   values (1, "Monday",'{"cost":12,"product":"eggs"}'),
   (2, "Tuesday",'{"product":"bread","cost":10}'),
   (5, "Friday",'{"cost":null,"product":"milk"}');

select * from work.jsontest3;

/*JSON fields are very flexible.  They don't have to contain all values*/
create table work.jsontest4 (id int,
							 day varchar(15),
                             newfield json);
                             
insert into work.jsontest4
   values (1, "Monday",'{"cost":12,"product":"eggs"}'),
   (2, "Tuesday",'{"product":"bread"}'),
   (5, "Friday",'{"cost":null,"product":"milk"}');

SELECT * FROM work.jsontest4;

/*Now back to the original jsontest2 table we created above*/
select * from work.jsontest2;

/*Use JSON value to select other data*/
select day, newfield->>"$.cost" as cost
from work.jsontest2
where newfield->>"$.product"='bread';

/*How to make the output more readable*/
select mytags from work.jsontest;
select json_pretty(mytags) from work.jsontest;

/*A more complex example*/
/*drop table work.customer_sales;*/
CREATE TABLE work.customer_sales (
    customer_json json
);

insert into work.customer_sales values
('{"email": "ariveles0@stumbleupon.com", "phone": null, "sales": [{"product_id": 7, "product_name": "Bat", "sales_amount": 479.992, "sales_transaction_date": "2017-07-19T08:38:41"}], "last_name": "Riveles", "date_added": "2017-04-23T00:00:00", "first_name": "Arlena", "customer_id": 1}'),
('{"email": "jnussen3@salon.com", "phone": "615-824-2506", "sales": [{"product_id": 12, "product_name": "Lemon Zester", "sales_amount": 314.991, "sales_transaction_date": "2019-02-23T15:50:29"}], "last_name": "Nussen", "date_added": "2017-09-03T00:00:00", "first_name": "Jessika", "customer_id": 4}');

select * from work.customer_sales; 
select json_pretty(customer_json) from work.customer_sales; 

select customer_json->>'$.email' as email
   from work.customer_sales
   where customer_json->>'$.customer_id' = '4';
   
/*in mySQL 8, you can use JSON_table to extract from an array in JSON*/
