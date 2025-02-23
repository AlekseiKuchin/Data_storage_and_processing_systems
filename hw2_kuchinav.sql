CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name text,
    last_name TEXT,
    gender TEXT,
    DOB date,
    job_title TEXT,
    job_industry_category TEXT,
    wealth_segment TEXT,
    deceased_indicator TEXT,
    owns_car TEXT,
    address TEXT,
    postcode TEXT,
    state TEXT,
    country TEXT,
    property_valuation INT
)

drop Table transaction;

CREATE TABLE transaction (
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
    list_price DECIMAL,
    standard_cost DECIMAL
);

select * from customer;

--Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов.
select DISTINCT brand from transaction
where standard_cost > 1500;

--Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно.
select * from transaction
where transaction_date BETWEEN '2017-04-01' AND '2017-04-09'
AND order_status = 'Approved';

--Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'.
select DISTINCT job_title from customer
where job_industry_category IN ('IT', 'Financial Services')
AND job_title LIKE 'Senior%';

--Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services
select DISTINCT t.brand from transaction t
join customer c on t.customer_id = c.customer_id
where c.job_industry_category = 'Financial Services';

--Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'.
select DISTINCT c.customer_id, c.first_name, c.last_name from customer c
join transaction t on c.customer_id = t.customer_id
where t.online_order = 'True'
and brand in ('Giant Bicycles', 'Norco Bicycles', 'Tkek Bicycles')
LIMIT 10;

--Вывести всех клиентов, у которых нет транзакций.
select c.customer_id, c.first_name, c.last_name from customer c
LEFT join transaction t on c.customer_id = t.customer_id
where t.transaction_id IS NULL;

-- Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.
select c.customer_id, c.first_name, c.last_name from customer c
join transaction t on c.customer_id = t.customer_id
where c.job_industry_category = 'IT'
and t.standard_cost = (select MAX(standard_cost) from transaction);

-- Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'.
select c.customer_id, c.first_name, c.last_name from customer c
join transaction t on c.customer_id = t.customer_id
where c.job_industry_category IN ('IT', 'Health')
and t.order_status = 'Approved'
and t.transaction_date BETWEEN '2017-07-07' AND '2017-07-17';