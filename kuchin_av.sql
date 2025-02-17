CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    gender TEXT,
    DOB DATE,
    job_title TEXT,
    job_industry TEXT,
    wealth_segment TEXT,
    deceased_indicator TEXT,
    owns_cars TEXT,
    address TEXT,
    postcode INT,
    state TEXT,
    country TEXT,
    property_valuation INT
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    transaction_date DATE,
    online_order TEXT,
    order_status TEXT,
    brand TEXT,
    product_line TEXT,
    product_class TEXT,
    product_size TEXT,
    price FLOAT,
    standard_cost FLOAT
);


select * from transactions t 

drop table products;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    brand TEXT,
    product_line TEXT,
    product_class TEXT,
    product_size TEXT,
    price FLOAT,
    standard_cost FLOAT
);


CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    address TEXT,
    postcode INT,
    state TEXT,
    country TEXT
);

INSERT INTO locations (address, postcode, state, country)
SELECT DISTINCT address, postcode, state, country
FROM customers;

INSERT INTO products (product_id, brand, product_line, product_class, product_size, price, standard_cost)
SELECT DISTINCT product_id, brand, product_line, product_class, product_size, price, standard_cost
FROM transactions t
on conflict (product_id) do nothing;

drop table customers;
select * from products t;
select * from transactions t;

drop table transactions;
select * from customers;

drop table jobs_and_wealth;
create table jobs_and_wealth (
	jaw_id SERIAL primary key,
	job_title text,
	job_industry text,
	wealth_segment text,
	deceased_indicator text,
	own_cars text
);
ALTER TABLE customers
ADD COLUMN job_wealth_id INT;


INSERT INTO jobs_and_wealth (job_title, job_industry, wealth_segment, deceased_indicator, own_cars)
SELECT DISTINCT job_title, job_industry, wealth_segment, deceased_indicator, owns_cars
FROM customers
WHERE job_title IS NOT NULL 
  OR job_industry IS NOT NULL
  OR wealth_segment IS NOT NULL;

UPDATE customers c
SET job_wealth_id = j.jaw_id
FROM jobs_and_wealth j
WHERE c.job_title = j.job_title
  AND c.job_industry = j.job_industry
  AND c.wealth_segment = j.wealth_segment
  and c.deceased_indicator = j.deceased_indicator
  and c.owns_cars = j.own_cars;


alter table customers 
add CONSTRAINT fk_customer_job_wealth
      FOREIGN KEY (job_wealth_id)
      REFERENCES jobs_and_wealth (jaw_id);


ALTER TABLE customers
ADD COLUMN location_id INT;

ALTER TABLE customers
ADD CONSTRAINT fk_customers_locations
    FOREIGN KEY (location_id)
    REFERENCES locations (location_id);

ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_customers
    FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id);



