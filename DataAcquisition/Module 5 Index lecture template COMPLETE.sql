/*Drop if necessary*/
/*drop table work.products_demo;*/

show databases;

show tables from work;

show columns from ba710.OrderDetails;

describe ba710.OrderDetails;

/*Create table review*/
create table work.products_demo (
	product_id int unsigned not null,
    product_name varchar(100) not null,
    product_category varchar(50),
    product_price decimal(10,2) not null,
    product_sku char(10) not null,
    short_description varchar(500)
);

describe work.products_demo;

/*Primary key review*/

drop table work.products_demo;

create table work.products_demo (
	product_id int unsigned not null,
    product_name varchar(100) not null,
    product_category varchar(50),
    product_price decimal(10,2) not null,
    product_sku char(10) not null,
    short_description varchar(500),
    primary key (product_id)
);

describe work.products_demo;

/*Add an index*/

drop table work.products_demo;

create table work.products_demo (
	product_id int unsigned not null,
    product_name varchar(100) not null,
    product_category varchar(50),
    product_price decimal(10,2) not null,
    product_sku char(10) not null,
    short_description varchar(500),
    primary key (product_id),
    index prod_name_index (product_name)
);

describe work.products_demo;

/*Add a complex index*/

drop table work.products_demo;

create table work.products_demo (
	product_id int unsigned not null,
    product_name varchar(100) not null,
    product_category varchar(50),
    product_price decimal(10,2) not null,
    product_sku char(10) not null,
    short_description varchar(500),
    primary key (product_id),
    index idx_prod_name (product_name),
    index idx_names (product_name, product_category)
);

describe work.products_demo;

/*Add an index using alter table*/

alter table work.products_demo
add index idx_sku (product_sku);

/*Add an index using create index*/

create index idx_text on work.products_demo (short_description);

describe work.products_demo;

/*create an index on first 10 characters*/

create index idx_text10 on work.products_demo (short_description(10));

/*Explain a select*/

explain select * from ba710.OrderDetails;

explain select * from ba710.OrderDetails
where productid=14;

select * from ba710.OrderDetails
where productid=14;

/*How long will this run?*/

explain format=json select * from ba710.OrderDetails
where productid=14;

/*Format with JSON tab delimited*/
/***********
{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "217.50"
    },
    "table": {
      "table_name": "OrderDetails",
      "access_type": "ALL",
      "rows_examined_per_scan": 2155,
      "rows_produced_per_join": 215,
      "filtered": "10.00",
      "cost_info": {
        "read_cost": "195.95",
        "eval_cost": "21.55",
        "prefix_cost": "217.50",
        "data_read_per_join": "6K"
      },
      "used_columns": [
        "OrderID",
        "ProductID",
        "UnitPrice",
        "Quantity",
        "Discount"
      ],
      "attached_condition": "(`ba710`.`orderdetails`.`ProductID` = 14)"
    }
  }
}
*********/

/*How much does this cost with an index?*/
/*Drop index if it exists*/
/*drop index idx_prodid on ba710.orderdetails;*/

create index idx_prodid on ba710.orderdetails (productid);

explain format=json select * from ba710.OrderDetails
where productid=14;

/*Paste JSON*/
/*********
{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "7.70"
    },
    "table": {
      "table_name": "OrderDetails",
      "access_type": "ref",
      "possible_keys": [
        "idx_prodid"
      ],
      "key": "idx_prodid",
      "used_key_parts": [
        "ProductID"
      ],
      "key_length": "4",
      "ref": [
        "const"
      ],
      "rows_examined_per_scan": 22,
      "rows_produced_per_join": 22,
      "filtered": "100.00",
      "cost_info": {
        "read_cost": "5.50",
        "eval_cost": "2.20",
        "prefix_cost": "7.70",
        "data_read_per_join": "704"
      },
      "used_columns": [
        "OrderID",
        "ProductID",
        "UnitPrice",
        "Quantity",
        "Discount"
      ]
    }
  }
}
******/

/*Check real time durations*/
drop index idx_prodid on BA710.orderdetails;

select * from ba710.OrderDetails
where productid=14;

create index idx_prodid on ba710.orderdetails (productid);

select * from ba710.OrderDetails
where productid=14;

/*Explain using join and order*/
drop index idx_prodid on BA710.orderdetails;

/*Without an index*/
explain format=JSON select a.* , b.customerid from ba710.orderdetails a
inner join ba710.orders b
on a.orderid=b.orderid
where a.productid=14
order by a.orderid;

/*Paste JSON*/
/*********
{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "333.33"
    },
    "ordering_operation": {
      "using_filesort": false,
      "nested_loop": [
        {
          "table": {
            "table_name": "a",
            "access_type": "index",
            "possible_keys": [
              "PRIMARY"
            ],
            "key": "PRIMARY",
            "used_key_parts": [
              "OrderID",
              "ProductID"
            ],
            "key_length": "8",
            "rows_examined_per_scan": 2155,
            "rows_produced_per_join": 215,
            "filtered": "10.00",
            "cost_info": {
              "read_cost": "195.95",
              "eval_cost": "21.55",
              "prefix_cost": "217.50",
              "data_read_per_join": "6K"
            },
            "used_columns": [
              "OrderID",
              "ProductID",
              "UnitPrice",
              "Quantity",
              "Discount"
            ],
            "attached_condition": "(`ba710`.`a`.`ProductID` = 14)"
          }
        },
        {
          "table": {
            "table_name": "b",
            "access_type": "eq_ref",
            "possible_keys": [
              "PRIMARY"
            ],
            "key": "PRIMARY",
            "used_key_parts": [
              "OrderID"
            ],
            "key_length": "4",
            "ref": [
              "ba710.a.OrderID"
            ],
            "rows_examined_per_scan": 1,
            "rows_produced_per_join": 215,
            "filtered": "100.00",
            "cost_info": {
              "read_cost": "94.28",
              "eval_cost": "21.55",
              "prefix_cost": "333.33",
              "data_read_per_join": "143K"
            },
            "used_columns": [
              "OrderID",
              "CustomerID"
            ]
          }
        }
      ]
    }
  }
}
*******/

/*Now with an index*/
create index idx_prodid on ba710.orderdetails (productid);

explain format=JSON select a.* , b.customerid from ba710.orderdetails a
inner join ba710.orders b
on a.orderid=b.orderid
where a.productid=14
order by a.orderid;

/*Paste JSON*/
/*********
{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "19.52"
    },
    "ordering_operation": {
      "using_filesort": false,
      "nested_loop": [
        {
          "table": {
            "table_name": "a",
            "access_type": "ref",
            "possible_keys": [
              "PRIMARY",
              "idx_prodid"
            ],
            "key": "idx_prodid",
            "used_key_parts": [
              "ProductID"
            ],
            "key_length": "4",
            "ref": [
              "const"
            ],
            "rows_examined_per_scan": 22,
            "rows_produced_per_join": 22,
            "filtered": "100.00",
            "cost_info": {
              "read_cost": "5.50",
              "eval_cost": "2.20",
              "prefix_cost": "7.70",
              "data_read_per_join": "704"
            },
            "used_columns": [
              "OrderID",
              "ProductID",
              "UnitPrice",
              "Quantity",
              "Discount"
            ]
          }
        },
        {
          "table": {
            "table_name": "b",
            "access_type": "eq_ref",
            "possible_keys": [
              "PRIMARY"
            ],
            "key": "PRIMARY",
            "used_key_parts": [
              "OrderID"
            ],
            "key_length": "4",
            "ref": [
              "ba710.a.OrderID"
            ],
            "rows_examined_per_scan": 1,
            "rows_produced_per_join": 22,
            "filtered": "100.00",
            "cost_info": {
              "read_cost": "9.62",
              "eval_cost": "2.20",
              "prefix_cost": "19.52",
              "data_read_per_join": "14K"
            },
            "used_columns": [
              "OrderID",
              "CustomerID"
            ]
          }
        }
      ]
    }
  }
}
*********/