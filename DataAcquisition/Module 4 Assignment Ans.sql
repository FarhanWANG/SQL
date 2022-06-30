/*Assignment due Thursday March 17 11:59PM (grace period through Sunday March 20 11:59PM*/
/*Complete the script and upload to the Assignments folder*/

/*Run the code below, if necessary*/
create database work;
drop table work.part1;
drop table work.part2a;
drop table work.part2b;
drop table work.customer_sales;

/*Create a new table work.part1 with one JSON field*/

create table work.part1 (jsontags json);

/*Insert the following into the JSON field in work.part1.
Note: values provided are not in the correct syntax*/

insert into work.part1
   values('{"id":1,"month":"january","profit":1213}'),
		 ('{"id":2,"month":"february","profit":5653}'),
         ('{"id":3,"month":"march","profit":null}'),
         ('{"id":4,"month":"april","profit":46843}'),
		 ('{"id":5,"month":"may","profit":16874}'),
         ('{"id":6,"month":"june","profit":5268}');
       
/*
id:1 , month:january, profit:1213
id:2 , month:february , profit:5653
id:3 , month:march , profit:null
id:4 , month:april , profit:46843
id:5 , month:may , profit:16874
id:6 , month:june , profit:5268
*/



/*Create a new table work.part2a from work.part1 extracting all three fields into 
individual sql columns id, month and profit. 
Use the extract function - not the double headed arrow.
Make sure you remove any quotes.*/

create table work.part2a (id int, month varchar(15),profit varchar(15));
insert into work.part2a (id,month,profit)  
(select json_unquote(json_extract(jsontags,'$.id')),
json_unquote(json_extract(jsontags,'$.month')),
json_unquote(json_extract(jsontags,'$.profit'))
  from work.part1);


/*Create a new table work.part2b from work.part1 extracting all three fields into 
individual sql columns id, month and profit.  
Use the double headed arrow.
Make sure you remove any quotes.*/

create table work.part2b (id int, month varchar(15),profit varchar(15));
insert into work.part2b (id,month,profit)  
(select jsontags->>'$.id', jsontags->>'$.month', jsontags->>'$.profit' from work.part1);

/*Using a where clause on work.part1 to extract the month where the id is either 3 or 6*/  

select jsontags->>'$.month' as month from work.part1 where jsontags->>'$.id' in (3,6);

/*Using a where clause on work.part1 to extract the id where the profit is null*/   

select jsontags->>'$.id' as id from work.part1 where jsontags->>'$.profit' ='null';


/*Run the following code:*/
CREATE TABLE work.customer_sales (customer_json json);
insert into work.customer_sales values
('{"email": "ariveles0@stumbleupon.com", "phone": null, "sales": [{"product_id": 7, "product_name": "Bat", "sales_amount": 479.992, "sales_transaction_date": "2017-07-19T08:38:41"}], "last_name": "Riveles", "date_added": "2017-04-23T00:00:00", "first_name": "Arlena", "customer_id": 1}'),
('{"email": "jnussen3@salon.com", "phone": "615-824-2506", "sales": [{"product_id": 12, "product_name": "Lemon Zester", "sales_amount": 314.991, "sales_transaction_date": "2019-02-23T15:50:29"}], "last_name": "Nussen", "date_added": "2017-09-03T00:00:00", "first_name": "Jessika", "customer_id": 4}'),
('{"email": "umiddlehursta@prnewswire.com", "phone": "918-339-5890", "sales": [{"product_id": 1, "product_name": "Lemon", "sales_amount": 319.992, "sales_transaction_date": "2011-11-15T03:47:26"}], "last_name": "Middlehurst", "date_added": "2011-10-22T00:00:00", "first_name": "Urbano", "customer_id": 11}'),
('{"email": "nespinaye@51.la", "phone": "818-658-6748", "sales": [{"product_id": 5, "product_name": "Blade", "sales_amount": 559.992, "sales_transaction_date": "2014-07-19T06:33:44"}], "last_name": "Espinay", "date_added": "2014-07-05T00:00:00", "first_name": "Nichols", "customer_id": 15}'),
('{"email": "pgeistk@nasa.gov", "phone": "801-275-7520", "sales": [{"product_id": 3, "product_name": "Lemon", "sales_amount": 499.99, "sales_transaction_date": "2014-11-21T15:58:08"}], "last_name": "Geist", "date_added": "2014-10-04T00:00:00", "first_name": "Pryce", "customer_id": 21}'),
('{"email": "fheatheringtonm@accuweather.com", "phone": null, "sales": [{"product_id": 3, "product_name": "Lemon", "sales_amount": 499.99, "sales_transaction_date": "2016-01-19T15:44:16"}], "last_name": "Heatherington", "date_added": "2016-01-05T00:00:00", "first_name": "Fara", "customer_id": 23}'),
('{"email": "blanegrann@123-reg.co.uk", "phone": "318-557-4463", "sales": [{"product_id": 12, "product_name": "Lemon Zester", "sales_amount": 349.99, "sales_transaction_date": "2019-04-20T06:58:36"}], "last_name": "Lanegran", "date_added": "2015-10-28T00:00:00", "first_name": "Barbi", "customer_id": 24}'),
('{"email": "ggarratr@bbb.org", "phone": "515-439-0780", "sales": [{"product_id": 7, "product_name": "Bat", "sales_amount": 599.99, "sales_transaction_date": "2018-08-24T14:05:15"}], "last_name": "Garrat", "date_added": "2018-03-26T00:00:00", "first_name": "Gradey", "customer_id": 28}'),
('{"email": "krivelt@kickstarter.com", "phone": "512-942-0905", "sales": [{"product_id": 2, "product_name": "Lemon Limited Edition", "sales_amount": 799.99, "sales_transaction_date": "2011-01-19T10:57:07"}], "last_name": "Rivel", "date_added": "2010-08-05T00:00:00", "first_name": "Kath", "customer_id": 30}'),
('{"email": "rvaskinu@washingtonpost.com", "phone": "202-366-1344", "sales": [{"product_id": 3, "product_name": "Lemon", "sales_amount": 499.99, "sales_transaction_date": "2016-08-23T23:16:03"}], "last_name": "Vaskin", "date_added": "2016-05-08T00:00:00", "first_name": "Rhody", "customer_id": 31}'),
('{"email": "hpurselowev@oaic.gov.au", "phone": "239-462-4672", "sales": [{"product_id": 8, "product_name": "Bat Limited Edition", "sales_amount": 559.992, "sales_transaction_date": "2019-03-29T10:13:23"}, {"product_id": 7, "product_name": "Bat", "sales_amount": 599.99, "sales_transaction_date": "2019-02-18T15:17:44"}], "last_name": "Purselowe", "date_added": "2019-02-07T00:00:00", "first_name": "Hamnet", "customer_id": 32}'),
('{"email": "clagneaux11@fda.gov", "phone": "404-221-7224", "sales": [{"product_id": 3, "product_name": "Lemon", "sales_amount": 499.99, "sales_transaction_date": "2018-11-20T18:25:40"}, {"product_id": 8, "product_name": "Bat Limited Edition", "sales_amount": 699.99, "sales_transaction_date": "2018-06-30T07:41:02"}], "last_name": "Lagneaux", "date_added": "2018-04-05T00:00:00", "first_name": "Carter", "customer_id": 38}'),
('{"email": "gpoyser12@admin.ch", "phone": "785-885-9323", "sales": [{"product_id": 7, "product_name": "Bat", "sales_amount": 479.992, "sales_transaction_date": "2018-11-01T11:45:34"}, {"product_id": 3, "product_name": "Lemon", "sales_amount": 499.99, "sales_transaction_date": "2018-09-14T02:33:09"}], "last_name": "Poyser", "date_added": "2018-09-17T00:00:00", "first_name": "Gena", "customer_id": 39}'),
('{"email": "mbatting16@jiathis.com", "phone": "763-806-4636", "sales": [{"product_id": 3, "product_name": "Lemon", "sales_amount": 499.99, "sales_transaction_date": "2018-08-14T17:05:18"}], "last_name": "Batting", "date_added": "2016-10-08T00:00:00", "first_name": "Mufi", "customer_id": 43}'),
('{"email": "bjordan2@geocities.com", "phone": null, "sales": [], "last_name": "Jordan", "date_added": "2018-10-27T00:00:00", "first_name": "Braden", "customer_id": 3}'),
('{"email": "wparoni17@telegraph.co.uk", "phone": null, "sales": [{"product_id": 3, "product_name": "Lemon", "sales_amount": 499.99, "sales_transaction_date": "2018-07-20T22:18:55"}], "last_name": "Paroni", "date_added": "2018-06-10T00:00:00", "first_name": "Waldemar", "customer_id": 44}'),
('{"email": "tkirimaa18@illinois.edu", "phone": null, "sales": [{"product_id": 3, "product_name": "Lemon", "sales_amount": 499.99, "sales_transaction_date": "2017-08-08T08:56:05"}], "last_name": "Kirimaa", "date_added": "2017-08-15T00:00:00", "first_name": "Tomasina", "customer_id": 45}'),
('{"email": "hdelaperrelle19@uol.com.br", "phone": null, "sales": [{"product_id": 7, "product_name": "Bat", "sales_amount": 539.991, "sales_transaction_date": "2017-09-26T23:57:34"}, {"product_id": 3, "product_name": "Lemon", "sales_amount": 499.99, "sales_transaction_date": "2017-10-07T04:18:03"}], "last_name": "De la Perrelle", "date_added": "2017-08-19T00:00:00", "first_name": "Hadley", "customer_id": 46}');
   

/*select the json field and make it look "pretty"*/
select customer_json->>'$.last_name' as last_name,customer_json->>'$.first_name' as first_name,customer_json->>'$.email' as email,
customer_json->>'$.phone' as phone,customer_json->>'$.sales' as sales, customer_json->>'$.date_added' as date_added,
customer_json->>'$.customer_id' as customer_id
from work.customer_sales;

/*Create a list of emails where the id is greater than 20*/
select customer_json->>'$.email' as email
from work.customer_sales
where customer_json->>'$.customer_id' >20;

/*Create a list of names and emails for people who do not have a phone number*/
select customer_json->>'$.last_name' as last_name,customer_json->>'$.first_name' as first_name,customer_json->>'$.email' as email
from work.customer_sales
where customer_json->>'$.phone' = "null";

/*When was the customer with the first name carter added?*/
select customer_json->>'$.date_added' as date_added
from work.customer_sales
where customer_json->>'$.first_name' = "Carter";
