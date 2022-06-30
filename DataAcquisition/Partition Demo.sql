
   
/*Set up environment for Module 6 Demo.*/
DROP DATABASE IF EXISTS employees;
CREATE DATABASE IF NOT EXISTS employees;
USE employees;   
   
/*Create a table structure without partitions*/   
   
CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

/*Select a specific range and explain the cost of the query*/
select * from employees;

select * from employees
   where emp_no between 101000 and 125000;
   
explain format=json select * from employees
   where emp_no between 101000 and 125000;

/*Create a range partition*/

alter table employees
   partition by range(emp_no)
   (partition p1 values less than (100000),
	partition p2 values less than (200000),
    partition p3 values less than maxvalue);
   
/*Select from a range where the data is only on partition 2*/   

select * from employees
   where emp_no between 101000 and 125000;
   
/*Explain the cost.  Note that the cost is significantly lower than 
  the select prior to the partition.*/   
   
explain format=json select * from employees
   where emp_no between 101000 and 125000;
   
/*Note how the following explain only references the partitions necessary
  to complete the query*/   
   
explain select * from employees
where emp_no between 51000 and 125000;   
   
/*Remove the partition from the employees table.*/   
   
alter table employees remove partitioning;

describe employees;

alter table employees partition by key();



   
   