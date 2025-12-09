--Задача 4
SELECT count(customer_id) AS customers_count
FROM customers;
-- конец 4
-- Задача 5
SELECT
    concat(e.first_name, ' ', e.last_name) AS seller,
    count(s.sales_person_id) AS operations,
    floor(sum(s.quantity * p.price)) AS income
FROM sales AS s
LEFT JOIN products AS p ON s.product_id = p.product_id
LEFT JOIN employees AS e ON s.sales_person_id = e.employee_id
GROUP BY seller
ORDER BY income DESC
LIMIT 10;
--конец  задачи 5/1
WITH avg_check AS (
    SELECT avg(sales.quantity * products.price)
    FROM sales
    INNER JOIN products ON sales.product_id = products.product_id
)

SELECT
    concat_ws(' ', employees.first_name, employees.last_name) AS seller,
    floor(avg(sales.quantity * products.price)) AS average_income
FROM sales
INNER JOIN products ON sales.product_id = products.product_id
INNER JOIN employees ON sales.sales_person_id = employees.employee_id
GROUP BY seller
HAVING
    avg(sales.quantity * products.price)
    < (
        SELECT *
        FROM avg_check
    )
ORDER BY average_income;
-- конец второй задачи 5/2
WITH weekday_income AS (
    SELECT
        s.sales_person_id AS sale_id,
        to_char(s.sale_date, 'day') AS weekday,
        extract(
            ISODOW
            FROM s.sale_date
        ) AS number_wd,
        sum(p.price * s.quantity) AS income
    FROM sales AS s
    INNER JOIN products AS p ON s.product_id = p.product_id
    GROUP BY
        s.sales_person_id,
        weekday,
        number_wd
) -- группировка в запросе

SELECT
    (e.first_name || ' ' || e.last_name) AS seller,
    trim(wd.weekday) AS day_of_week,
    floor(wd.income) AS income /* округляет выручку до целого числа*/
FROM weekday_income AS wd
INNER JOIN employees AS e ON wd.sale_id = e.employee_id
ORDER BY
    number_wd,
    day_of_week,
    seller;

-- конец задачи 5/3
-- ЗАДАЧА 6
SELECT
    CASE
        WHEN age > 40 THEN '40+'
        WHEN
            age >= 26
            AND age <= 40 THEN '26-40'
        WHEN
            age >= 16
            AND age < 26 THEN '16-25'
    END AS age_category,
    count(*) AS age_count
FROM customers
GROUP BY age_category
ORDER BY age_category;
-- Конец задачи 6/1
SELECT
    to_char(s.sale_date, 'YYYY-MM') AS selling_month,
    count(DISTINCT c.customer_id) AS total_customers,
    floor(sum(s.quantity * p.price)) AS income
FROM sales AS s
LEFT JOIN products AS p ON s.product_id = p.product_id
LEFT JOIN customers AS c ON s.customer_id = c.customer_id
GROUP BY selling_month
ORDER BY selling_month;
-- Конец задачи 6/2
WITH tab AS (
    SELECT
        concat(c.first_name, ' ', c.last_name) AS customer,
        s.customer_id,
        first_value(s.sale_date) OVER (PARTITION BY s.customer_id) AS sale_date,
        -- первое значение s.sale_date в разрезе id продавца
        first_value(p.price) OVER (
            PARTITION BY s.customer_id
            ORDER BY
                s.sale_date,
                p.price
        ) AS first_p, -- первое значение p.price в разрезе id продавца 
        first_value(concat(e.first_name, ' ', e.last_name)) OVER (
            PARTITION BY s.customer_id
            ORDER BY
                s.sale_date,
                p.price
        ) AS seller -- первое значение имя продавца в разрезе id продавца 
    FROM
        sales s
    INNER JOIN customers c ON s.customer_id = c.customer_id
    INNER JOIN employees e ON s.sales_person_id = e.employee_id 
    INNER JOIN products p ON s.product_id = p.product_id
)

SELECT
    customer,
    sale_date,
    seller
FROM
    tab
WHERE
    first_p = '0' --где прайс  0
GROUP BY
    customer,
    customer_id,
    sale_date,
    seller
ORDER BY
    customer_id,
    sale_date;




