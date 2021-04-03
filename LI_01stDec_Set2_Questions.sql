-- 1. Display the top 3 most frequently rented movies in descending order.
-- Get the movie name and times rented (sakila schema)
with tab(title,times_rented,rankk) as (select title,count(rental_id) as times_rented,
dense_rank() over(order by count(rental_id) desc ) as rankk
from film f join inventory i 
on f.film_id=i.film_id
join rental r on i.inventory_id=r.inventory_id
group by title)
select title,times_rented,rankk
from tab
where rankk<=3;


-- 2. Find the total payment received every year and display the same for the respective records 
#( for all the payment id's) (sakila schema)
select payment_id,year(payment_date),sum(amount) over(partition by year(payment_date)) as total_payment
from payment
group by payment_id;


-- 3. Find the overall payment received so far and the amount received for a month of a year, find the proportion and 
-- sort the result based on the highest proportion coming first. Display the calculated results for all the payment id's (sakila schema)
select payment_id,sum(amount) over() as total_amt,sum(amount) over(partition by month(payment_date)) as month_total,
sum(amount) over(partition by month(payment_date)) /sum(amount) over() as proportion
from payment
order by proportion desc;





-- 4. For department id 80 and commission percentage more than 30% collect the below details:
-- employee id's of each department, their name, department id and the number of employees 
-- in each department (hr schema)
select employee_id,first_name,department_id,count(employee_id) over(partition by department_id) as number_of_emp
from employees
where department_id=80 and commission_pct>0.30;


-- 5. Show the employee id's , employee name, manager id, salary, average salary
-- of employees reporting under each manager and the difference between them (hr schema)
select employee_id,first_name,manager_id,salary,avg(salary) over(partition by manager_id) as average,salary-avg(salary) over(partition by manager_id) as diff
from employees;


-- 6. Get the order date, order id, product id, product quantity and Quantity ordered 
-- in a single day for each record (order schema)
select ORDER_DATE,h.ORDER_ID,PRODUCT_ID,ORDERED_QTY,sum(ORDERED_QTY) over(partition by ORDER_DATE) as Quantity_ordered
from order_header h join order_items i
where h.ORDER_ID=i.ORDER_ID;

select ORDER_DATE,h.ORDER_ID,PRODUCT_ID,ORDERED_QTY,sum(ORDERED_QTY) over(partition by day(ORDER_DATE)) as Quantity_ordered
from order_header h join order_items i
where h.ORDER_ID=i.ORDER_ID;
select oh.order_id,oh.order_date,oi.product_id,oi.ordered_qty,
sum(ORDERED_QTY)over(partition by ORDER_DATE) Ouantity_ordered 
from order_header oh
join order_items oi on oh.order_id = oi.order_id;

-- 7. Divide the employees into 10 groups with highest paid employees coming first.
-- For each employee fetch the emp id, department id salary and the group they belong to (hr schema)
select employee_id,first_name,salary,department_id,
ntile(10) over(order by salary desc) as groupps
from employees;




-- 8. create a view to get all the product details of cheapest product in each product category 
create view cheap1 as select * from product where (PROD_CAT_ID,PRODUCT_PRICE) in 
(select PROD_CAT_ID,min(PRODUCT_PRICE) from product group by PROD_CAT_ID);
select * from cheap1;

                 
-- 9. create a view high_end_product with product_id, product_desc, product_price, product_category_id, product_category_description 
-- having product price greater than the minimum price of the category 2055 
create view high_end_product as select PRODUCT_ID,PRODUCT_DESC,PRODUCT_PRICE,p.PROD_CAT_ID,PROD_CAT_DESC
from product p join product_category c
on p.PROD_CAT_ID=c.PROD_CAT_ID
where PRODUCT_PRICE> (select min(PRODUCT_PRICE) from product group by PROD_CAT_ID having PROD_CAT_ID=2055);
select * from high_end_product;



-- 10. Make a copy of the product table with name prod_copy and Update the product price of categories with description containing
--  promotion-medium with 10% increase in price
create table prod_copy as ( update table product
set PRODUCT_PRICE=PRODUCT_PRICE+(PRODUCT_PRICE*0.10)
where PROD_CAT_ID in (select PROD_CAT_ID from product_category where PROD_CAT_DESC like '%promotion-medium%');




select employee_id,first_name,manager_id,salary, 
avg(salary) over(partition by manager_id)  as average,
(salary-avg(salary) over(partition by manager_id)) as diff
from employees;

select employee_id,first_name,department_id,count(employee_id) over(partition by department_id) as number_of_emp 
from employees where department_id=80 and commission_pct>0.30;
