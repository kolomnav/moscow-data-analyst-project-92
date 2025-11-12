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

--Первая задача

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

-- конец второй задачи

select 
concat(e.first_name,' ', e.last_name) as seller ,
--to_char(s.sale_date, 'day'),
to_char(s.sale_date, 'Day') as day_of_week,
Floor (SUM (s.quantity * p.price )) as income
  FROM sales as s 
  left join products p on s.product_id =p.product_id 
  Left join  employees e ON s.sales_person_id  = e.employee_id
    group by  sale_date , seller 
    order by extract(isodow from s.sale_date), seller 
   
    ;
