drop table customers;
drop table transactions;

create table customers (
    customer_id int primary key,
    first_name TEXT,
    last_name TEXT,
    gender TEXT,
    DOB DATE,
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
);

CREATE Table transactions (
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
    list_price FLOAT,
    standard_cost FLOAT
    );

--Вывести распределение (количество) клиентов по сферам деятельности, отсортировав результат по убыванию количества. — (2 балл)
SELECT job_industry_category, COUNT(*) as cnt
FROM customers
GROUP BY job_industry_category
ORDER BY cnt DESC;
--Найти сумму транзакций за каждый месяц по сферам деятельности, отсортировав по месяцам и по сфере деятельности. — (1 балл)
SELECT job_industry_category, EXTRACT(MONTH FROM transaction_date) as month, SUM(list_price) as sum
FROM transactions
JOIN customers ON transactions.customer_id = customers.customer_id
GROUP BY job_industry_category, month
ORDER BY month, job_industry_category;
--Вывести количество онлайн-заказов для всех брендов в рамках подтвержденных заказов клиентов из сферы IT. — (1 балл)

SELECT brand, COUNT(*) as cnt
FROM transactions
JOIN customers ON transactions.customer_id = customers.customer_id
WHERE job_industry_category = 'IT' AND order_status = 'Approved'
GROUP BY brand;

--Найти по всем клиентам сумму всех транзакций (list_price), максимум, минимум и количество транзакций, отсортировав результат по убыванию суммы транзакций и количества клиентов. Выполните двумя способами: используя только group by и используя только оконные функции. Сравните результат. — (2 балла)

SELECT customers.customer_id, first_name, last_name, SUM(list_price) as sum, MAX(list_price) as max, MIN(list_price) as min, COUNT(*) as cnt
FROM transactions
JOIN customers ON transactions.customer_id = customers.customer_id
GROUP BY customers.customer_id, first_name, last_name
ORDER BY sum DESC, cnt DESC;

--Найти имена и фамилии клиентов с минимальной/максимальной суммой транзакций за весь период (сумма транзакций не может быть null). Напишите отдельные запросы для минимальной и максимальной суммы. — (2 балла)

SELECT first_name, last_name, SUM(list_price) as sum
FROM transactions
JOIN customers ON transactions.customer_id = customers.customer_id
GROUP BY customers.customer_id, first_name, last_name
HAVING SUM(list_price) = (SELECT MIN(sum) FROM (SELECT SUM(list_price) as sum FROM transactions GROUP BY customer_id) as t);
--Вывести только самые первые транзакции клиентов. Решить с помощью оконных функций. — (1 балл)

SELECT *
FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY transaction_date) as rn
FROM transactions) as t
WHERE rn = 1;
--Вывести имена, фамилии и профессии клиентов, между транзакциями которых был максимальный интервал (интервал вычисляется в днях) — (2 балла).

SELECT first_name, last_name, job_title
FROM (SELECT *, transaction_date - LAG(transaction_date) OVER (PARTITION BY customer_id ORDER BY transaction_date) as diff
FROM transactions) as t
JOIN customers ON t.customer_id = customers.customer_id
ORDER BY diff DESC
LIMIT 1;