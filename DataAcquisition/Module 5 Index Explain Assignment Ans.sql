


/*Query 1: 
Select customer id from the orders table*/
select CustomerID from ba710.orders;

/*Write code to calculate the cost of Query 1*/

explain format=json select CustomerID from ba710.orders;


/*What is the cost:       */
/*
The cost is 85.25

'{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "85.25"
    },
    "table": {
      "table_name": "orders",
      "access_type": "ALL",
      "rows_examined_per_scan": 830,
      "rows_produced_per_join": 830,
      "filtered": "100.00",
      "cost_info": {
        "read_cost": "2.25",
        "eval_cost": "83.00",
        "prefix_cost": "85.25",
        "data_read_per_join": "551K"
      },
      "used_columns": [
        "CustomerID"
      ]
    }
  }
}'
*/

/*Add an index to the orders table for customer id*/

create index idx_CustomerID on ba710.orders (CustomerID);


/*Write code to calculate the new cost of Query 1*/

explain format=json select CustomerID from ba710.orders;

/*What is the cost:       */

/*

The cost is still 85.25

'{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "85.25"
    },
    "table": {
      "table_name": "orders",
      "access_type": "index",
      "key": "idx_CustomerID",
      "used_key_parts": [
        "CustomerID"
      ],
      "key_length": "15",
      "rows_examined_per_scan": 830,
      "rows_produced_per_join": 830,
      "filtered": "100.00",
      "using_index": true,
      "cost_info": {
        "read_cost": "2.25",
        "eval_cost": "83.00",
        "prefix_cost": "85.25",
        "data_read_per_join": "551K"
      },
      "used_columns": [
        "CustomerID"
      ]
    }
  }
}'
*/

/*Was there a benefit for creating this index:       */

/* No, there was no benefit */

/*Why:          */

describe ba710.orders;
/*
The cost of indexing using primary key is same as newly created index (both of the two methods need to index all elements)

*/

/*Drop the customer id index that you created above*/

drop index idx_CustomerID on ba710.orders;

/*Query 2:
Select * from the orders table where the customer id starts 
with a letter less than M in the alphabet*/

select * from ba710.orders where customerid < "M";


/*Write code to calculate the cost Query 2*/

 explain format=json select * from ba710.orders
where customerid < "M";

/*What is the cost:       */

/*
The cost is 85.25

'{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "85.25"
    },
    "table": {
      "table_name": "orders",
      "access_type": "ALL",
      "rows_examined_per_scan": 830,
      "rows_produced_per_join": 276,
      "filtered": "33.33",
      "cost_info": {
        "read_cost": "57.59",
        "eval_cost": "27.66",
        "prefix_cost": "85.25",
        "data_read_per_join": "183K"
      },
      "used_columns": [
        "OrderID",
        "CustomerID",
        "EmployeeID",
        "OrderDate",
        "RequiredDate",
        "ShippedDate",
        "ShipVia",
        "Freight",
        "ShipName",
        "ShipAddress",
        "ShipCity",
        "ShipRegion",
        "ShipPostalCode",
        "ShipCountry"
      ],
      "attached_condition": "(`ba710`.`orders`.`CustomerID` < ''M'')"
    }
  }
}'
*/

/*Add an index to the orders table for customer id*/

create index cust_index on ba710.orders (customerid(1));

/*Write code to calculate the new cost of Query 2*/

 explain format=json select * from ba710.orders
where customerid < "M";

/*What is the cost:       */
/*
The cost is 92 

'{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "92.00"
    },
    "table": {
      "table_name": "orders",
      "access_type": "ALL",
      "possible_keys": [
        "cust_index"
      ],
      "rows_examined_per_scan": 830,
      "rows_produced_per_join": 471,
      "filtered": "56.87",
      "cost_info": {
        "read_cost": "44.80",
        "eval_cost": "47.20",
        "prefix_cost": "92.00",
        "data_read_per_join": "313K"
      },
      "used_columns": [
        "OrderID",
        "CustomerID",
        "EmployeeID",
        "OrderDate",
        "RequiredDate",
        "ShippedDate",
        "ShipVia",
        "Freight",
        "ShipName",
        "ShipAddress",
        "ShipCity",
        "ShipRegion",
        "ShipPostalCode",
        "ShipCountry"
      ],
      "attached_condition": "(`ba710`.`orders`.`CustomerID` < ''M'')"
    }
  }
}'
*/

/*Was there a benefit for creating this index:       */

/* No, there was no benefit*/

/*Why:          */
/* indexing of customer ID has no benefit since they need to index all the elements*/
describe ba710.orders;

/*Drop the customer id index that you created above*/
drop index cust_index on ba710.orders;



/*Query 3:
Write a query that joins the customers table and the orders table*/

select * from ba710.customers c inner join ba710.orders o on c.CustomerID = o.CustomerID;

/*Write an explain to determine the cost of Query 3*/

explain format=JSON select * from ba710.customers c inner join ba710.orders o on c.CustomerID = o.CustomerID;

/*What is the cost:      */

/*
The cost is 375.75
'{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "375.75"
    },
    "nested_loop": [
      {
        "table": {
          "table_name": "o",
          "access_type": "ALL",
          "rows_examined_per_scan": 830,
          "rows_produced_per_join": 830,
          "filtered": "100.00",
          "cost_info": {
            "read_cost": "2.25",
            "eval_cost": "83.00",
            "prefix_cost": "85.25",
            "data_read_per_join": "551K"
          },
          "used_columns": [
            "OrderID",
            "CustomerID",
            "EmployeeID",
            "OrderDate",
            "RequiredDate",
            "ShippedDate",
            "ShipVia",
            "Freight",
            "ShipName",
            "ShipAddress",
            "ShipCity",
            "ShipRegion",
            "ShipPostalCode",
            "ShipCountry"
          ]
        }
      },
      {
        "table": {
          "table_name": "c",
          "access_type": "eq_ref",
          "possible_keys": [
            "PRIMARY"
          ],
          "key": "PRIMARY",
          "used_key_parts": [
            "CustomerID"
          ],
          "key_length": "15",
          "ref": [
            "ba710.o.CustomerID"
          ],
          "rows_examined_per_scan": 1,
          "rows_produced_per_join": 830,
          "filtered": "100.00",
          "cost_info": {
            "read_cost": "207.50",
            "eval_cost": "83.00",
            "prefix_cost": "375.75",
            "data_read_per_join": "875K"
          },
          "used_columns": [
            "CustomerID",
            "CompanyName",
            "ContactName",
            "ContactTitle",
            "Address",
            "City",
            "Region",
            "PostalCode",
            "Country",
            "Phone",
            "Fax"
          ]
        }
      }
    ]
  }
}'
*/

/*Create an index on the orders table for the variable customer id*/

create index idx_CustomerID on ba710.orders (CustomerID);


/*Write an explain to determine the new cost Query 3*/

explain format=JSON select * from ba710.customers c inner join ba710.orders o on c.CustomerID = o.CustomerID;

/*What is the cost:      */

/*
The cost is 943.62
'{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "943.62"
    },
    "nested_loop": [
      {
        "table": {
          "table_name": "c",
          "access_type": "ALL",
          "possible_keys": [
            "PRIMARY"
          ],
          "rows_examined_per_scan": 91,
          "rows_produced_per_join": 91,
          "filtered": "100.00",
          "cost_info": {
            "read_cost": "1.00",
            "eval_cost": "9.10",
            "prefix_cost": "10.10",
            "data_read_per_join": "95K"
          },
          "used_columns": [
            "CustomerID",
            "CompanyName",
            "ContactName",
            "ContactTitle",
            "Address",
            "City",
            "Region",
            "PostalCode",
            "Country",
            "Phone",
            "Fax"
          ]
        }
      },
      {
        "table": {
          "table_name": "o",
          "access_type": "ref",
          "possible_keys": [
            "idx_CustomerID"
          ],
          "key": "idx_CustomerID",
          "used_key_parts": [
            "CustomerID"
          ],
          "key_length": "15",
          "ref": [
            "ba710.c.CustomerID"
          ],
          "rows_examined_per_scan": 9,
          "rows_produced_per_join": 848,
          "filtered": "100.00",
          "cost_info": {
            "read_cost": "848.65",
            "eval_cost": "84.87",
            "prefix_cost": "943.62",
            "data_read_per_join": "563K"
          },
          "used_columns": [
            "OrderID",
            "CustomerID",
            "EmployeeID",
            "OrderDate",
            "RequiredDate",
            "ShippedDate",
            "ShipVia",
            "Freight",
            "ShipName",
            "ShipAddress",
            "ShipCity",
            "ShipRegion",
            "ShipPostalCode",
            "ShipCountry"
          ]
        }
      }
    ]
  }
}'
*/

/*Create an index on the customers table for the variable customer id*/

create index idx_CustomerID on ba710.customers (CustomerID);


/*Write an explain to determine the new cost of Query 3*/

explain format=JSON select * from ba710.customers c inner join ba710.orders o on c.CustomerID = o.CustomerID;

/*What is the cost:      */

/* 
The cost is 382.50
'{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "382.50"
    },
    "nested_loop": [
      {
        "table": {
          "table_name": "o",
          "access_type": "ALL",
          "possible_keys": [
            "idx_CustomerID"
          ],
          "rows_examined_per_scan": 830,
          "rows_produced_per_join": 830,
          "filtered": "100.00",
          "cost_info": {
            "read_cost": "9.00",
            "eval_cost": "83.00",
            "prefix_cost": "92.00",
            "data_read_per_join": "551K"
          },
          "used_columns": [
            "OrderID",
            "CustomerID",
            "EmployeeID",
            "OrderDate",
            "RequiredDate",
            "ShippedDate",
            "ShipVia",
            "Freight",
            "ShipName",
            "ShipAddress",
            "ShipCity",
            "ShipRegion",
            "ShipPostalCode",
            "ShipCountry"
          ]
        }
      },
      {
        "table": {
          "table_name": "c",
          "access_type": "eq_ref",
          "possible_keys": [
            "PRIMARY",
            "idx_CustomerID"
          ],
          "key": "PRIMARY",
          "used_key_parts": [
            "CustomerID"
          ],
          "key_length": "15",
          "ref": [
            "ba710.o.CustomerID"
          ],
          "rows_examined_per_scan": 1,
          "rows_produced_per_join": 830,
          "filtered": "100.00",
          "cost_info": {
            "read_cost": "207.50",
            "eval_cost": "83.00",
            "prefix_cost": "382.50",
            "data_read_per_join": "875K"
          },
          "used_columns": [
            "CustomerID",
            "CompanyName",
            "ContactName",
            "ContactTitle",
            "Address",
            "City",
            "Region",
            "PostalCode",
            "Country",
            "Phone",
            "Fax"
          ]
        }
      }
    ]
  }
}'
*/

/*Was there a benefit to creating both indexes?:        */

/*
No
*/

/*Drop all indexes created in this assignment*/


drop index idx_CustomerID on ba710.orders;
drop index idx_CustomerID on ba710.customers;

