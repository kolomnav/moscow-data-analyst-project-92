--Задача 4
select count(customer_id) as customers_count
from customers;
-- конец 4
-- Задача 5
 select 
concat(e.first_name,' ', e.last_name) as seller ,
count(s.sales_person_id) as operations ,
Floor (SUM (s.quantity * p.price )) as income
  FROM sales as s 
  left join products p on s.product_id =p.product_id 
  Left join  employees e ON s.sales_person_id  = e.employee_id
    group by  seller 
    order by income desc
    limit 10
    ;

--конец  задачи 5/1


with  avg_check as 
( select AVG(sales.quantity * products.price) from sales   join  products    on  sales.product_id = products.product_id  )

select 
CONCAT_WS(' ',employees.first_name, employees.last_name) as seller ,
floor (AVG(sales.quantity * products.price )) as average_income

from
sales 
 join  products    on  sales.product_id = products.product_id 
 join  employees ON sales.sales_person_id  = employees.employee_id 
   group by  seller
   having AVG(sales.quantity * products.price) <(select * from avg_check)
   order by average_income 
;

-- конец второй задачи 5/2

with weekday_income as
(
select
	s.sales_person_id as sale_id,
	to_char(s.sale_date, 'day') as weekday,
	extract(isodow from s.sale_date) as number_wd,
	sum(p.price * s.quantity) as income
from sales s 
join products p 
  on s.product_id = p.product_id
group by s.sales_person_id, weekday, number_wd -- группировка в запросе 
)
select 
  (e.first_name || ' ' || e.last_name) as name,
  wd.weekday as day_of_week,
  round(wd.income) as income /* округляет выручку до целого числа*/
from weekday_income as wd
join employees e
  on wd.sale_id = e.employee_id
order by number_wd,day_of_week, name
;

-- конец задачи 5/3
   
	-- ЗАДАЧА 6
  select  
   
   case 
   			when age > 40 then  '40+'
   			when age >=26 and age <=40 then  '26-40'
   			when age >=16 and age <26 then '16-25'
   		end 	as   age_category,
	count(1) as age_count
   from   customers
    
   	group by age_category 
   	order by age_category 
	;   
	
   -- Конец задачи 6/1
select 
	TO_CHAR(s.sale_date, 'YYYY-MM') as selling_month,
	count(DISTINCT(	c.customer_id ))	as total_customers ,
	Floor (SUM (s.quantity * p.price )) as income
FROM sales as s 
  left join products p on s.product_id =p.product_id 
  Left join  customers c  ON s.customer_id   = c.customer_id 
  
    group by selling_month   
    order by selling_month 
;
   -- Конец задачи 6/2 

with tab as
(
select
	concat(c.first_name,' ', c.last_name) as customer ,
	s.customer_id,
	first_value (s.sale_date) over (partition by s.customer_id) as sale_date, --   первое значение s.sale_date в разрезе id продавца
	first_value (p.price) over (partition by s.customer_id order by s.sale_date, p.price) as first_p, -- первое значение p.price в разрезе id продавца и отсортированному по s.sale_date, p.price 
	first_value (concat(e.first_name,' ', e.last_name))  over (partition by s.customer_id order by s.sale_date, p.price) as seller -- первое значение имя продавца в разрезе id продавца и отсортированному по s.sale_date, p.price
from sales s 
join customers c 
	on s.customer_id = c.customer_id 
join employees e 
	on e.employee_id = s.sales_person_id 
join products p
	on p.product_id = s.product_id
)
select 
	customer,
	sale_date,
	seller
from tab
where first_p = '0' --где прайс  0
group by customer, customer_id,  sale_date, seller
order by customer_id, sale_date
; 
   
   -- конез задачи 6/3  предыдущее решение имело идентичный результат
