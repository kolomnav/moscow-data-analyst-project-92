   
    
	-- ЗАДАЧА 6
    
 with tab as (   
   select 
   		case  
   			when age > 40 then  '40+'
   			when age >=26 and age <=40 then  '26-40'
   			when age >=16 and age <26 then '16-25'
   		end as  age_category	 
   		from customers 
   		   --group by age_category
   		   --order by age_category 
   )
  select  
   age_category, count(1) as age_count
   from   tab  --  customers
   		group by age_category 
   		order by age_category 
   -- Конец задачи 6/1
   
   
  select 

concat(EXTRACT(year  FROM sale_date),'-', EXTRACT(MONTH FROM sale_date) ) as date ,

count(c.customer_id ) as total_customers ,
Floor (SUM (s.quantity * p.price )) as income
  FROM sales as s 
  left join products p on s.product_id =p.product_id 
  Left join  customers c  ON s.customer_id   = c.customer_id 
  
    group by date   
    order by date 
;
   -- Конец задачи 6/2 
   
  select 
concat(c.first_name,' ', c.last_name) as customer ,  --c.customer_id ,
min(s.sale_date) as sale_date,
concat(e.first_name,' ', e.last_name) as seller  -- s.sales_person_id 

  FROM sales as s 
   join products p on s.product_id =p.product_id 
   join  customers c  ON s.customer_id   = c.customer_id 
   join  employees e   ON s.sales_person_id   = e.employee_id 
   
   where p.price = 0 
    group by c.customer_id   ,seller  
    order by c.customer_id  
;
   
   -- конез задачи 6/3 
