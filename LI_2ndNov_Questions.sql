-- 1. Create a worker table with attributes id, name, email, phone, salary, manager_id and department_id
-- the email id and phone number must not contain null values and must be unique, salary must be greater than 1000
-- set id column as the primary key.
use temp;
create table worker (
w_ID int ,
w_Name varchar(60),
email varchar(60) not null ,
phone varchar(15) not null ,
salary int check(salary>1000),
manager_id int,
department_id int ,
constraint uni_email unique(email),
constraint uni_phone unique(phone),
constraint pk_id primary key(w_ID)
);

desc worker;


-- 2. Delete the salary check constraint from the worker table
show create table worker;
worker, CREATE TABLE `worker` (
  `w_ID` int NOT NULL,
  `w_Name` varchar(60) DEFAULT NULL,
  `email` varchar(60) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `salary` int DEFAULT NULL,
  `manager_id` int DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  PRIMARY KEY (`w_ID`),
  UNIQUE KEY `uni_email` (`email`),
  UNIQUE KEY `uni_phone` (`phone`),
  CONSTRAINT `worker_chk_1` CHECK ((`salary` > 1000))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

alter table worker
drop check worker_chk_1; 

desc worker;

select * from worker;
-- 3. Update the product price with an decrease in 5% for product id's 2055. (use product schema)
update product
set product_price=product_price-(product_price*0.05)
where product_category_id=2055;

-- 4. display the country_id and country names of the following 
-- countries: Austria, Brazil and Chad (use Sakila schema)
use sakila;
select country_id,country
from country
where country in ('Austria','Brazil','Chad');

-- 5. Get the product id and description of product whose length is greater than 10 and 
#also height is less than 5 (use product schema)
select product_id,product_desc
from product
where length>10 and height<5;

-- 6. Find the products whose category id is the range of 2060 to 2070 and whose total stock is more than 23. (use product schema)
select product_id,product_desc
from product
where (product_category_id between 2060 and 2070 )
and Quantity_in_stock>23
;

-- 7. For all the products weight, return the smallest integer not less than the weight value (use product schema)
select product_id,weight,ceil(weight)
from product;

-- 8. Get only the first 7 characters from the product description (use product schema)
select left(product_desc,7)
from product;

--  9. Fetch the last but one letter of the product description, name the column as lastbutone_substr (use product schema)
select product_desc,substr(product_desc,(length(product_desc)-1),1) as lastbutone_substr
from product;
select product_desc,substr(product_desc,-2,1) as lastbutone_substr
from product;

-- 10. Get the id, description and price  of products which contain 'TV' in their description (use product schema)
select product_id,product_desc,product_price
from product
where product_desc like '%TV%';

-- 11. Get the employees full name, the first letter in first_name must be in lower case. (use hr schema)
select first_name
from employees;
select first_name, concat(replace(FIRST_NAME, substring(FIRST_NAME, 1,1), 
lower(substring(FIRST_NAME, 1,1))), ' ', last_name) as _full_name
from employees;

select first_name,substring(FIRST_NAME, 1,1)
from employees;

-- 12. Get the position of letter 'S' (first occurence) in the product desc (instring gives the position of the string, it gives only the first occurence) (use product schema)
select product_desc,position('s' in product_desc) 
from product;
select product_desc,instr(product_desc,'s')
from product;

-- 13. For the given string '  Great Lakes ', Check how Ltrim, Rtrim and trim works
select '  Great Lakes ', ltrim('  Great Lakes '),rtrim('  Great Lakes '),trim('  Great Lakes ');
select length('  Great Lakes '), length(ltrim('  Great Lakes ')),length(rtrim('  Great Lakes ')),length(trim('  Great Lakes '));


-- 14. Remove the dollar symbol from $400
select trim(leading '$' from '$400') ;

-- 15. Remove the # present in the end of the string '#Great_Lakes#'
select trim(trailing '#' from '#Great_Lakes#') ;


-- 16. Remove the symbol '*' from the string '**Great_Lakes**'
select trim('*' from '**Great_Lakes**');

-- 17. Create sales table with the below column details,
-- i) order_id - 101, 102, 103, 104, 105 --> Primary key
-- ii) order_date - yesterday's date
-- iii) expected_delivery_date - 7 days from order date (use product schema)
create table sales(
order_id int primary key,
order_date date,
expected_delivery_date date);
 insert into sales
 values(101,subdate(curdate(),1),adddate(curdate(),7)),
 (102,subdate(curdate(),1),adddate(curdate(),7)),
 (103,subdate(curdate(),1),adddate(curdate(),7)),
 (104,subdate(curdate(),1),adddate(curdate(),7)),
 (105,subdate(curdate(),1),adddate(curdate(),7));
 


select *  from sale;


--  18. Find the customers who have taken rentals for more than a week (use Sakila schema)
select distinct customer_id
from rental
where datediff(return_date,rental_date)>7;

-- 19. Find rental id, rental date and day as rental_date_day in which the customers rented the inventory (use Sakila schema)
select rental_id,date(rental_date),dayname(rental_date) as rental_date_day
from rental;

select rental_id, concat(rental_date,', ', dayname(rental_date)) as rental_date_day
from rental;

-- 20. Get the film id and title of the film in upper case (use Sakila schema)
select ucase(film_id),ucase(title)
from film;

-- 21. Delivery cost for the goods is 10% of the total weight. Calculate the same. 
-- Note: If a product does not have weight detail, the delivery cost is 0.1$ (use product schema)
select weight, case when 
weight>0 then ifnull((weight*1.1),0.1) end as delivery_cost
from product;

--  22. Find the full name of actors whose last name ends with YD. Sort the records based on the full name 
-- in descending order (use Sakila schema)
select concat(first_name,' ',last_name) as full_name
from actor
where last_name like '%YD'
order by full_name desc;

-- 23. Find the highest amount for rental id's (use Sakila schema)
select amount 
from payment
order by amount desc 
limit 1,1;

-- 24. Find top three highest amount for rentals (use Sakila schema)
select distinct amount
from payment
order by amount desc
limit 3;

-- 25. Find the fifth highest amount for rentals (use Sakila schema)
select distinct amount
from payment
order by amount desc
limit 4,1;

-- 26. Find out the id's of actor who have performed in more than 40 films (use Sakila schema)
select actor_id,film_id
from film_actor
group by actor_id
having count(film_id)>40;


-- 27.  For every product category find the total quantity in stock (use product schema)
select product_category_id,sum(Quantity_in_stock) as total
from product
group by product_category_id;

-- 28. Find the max price, min price and the difference between the maximum and minimum price for a category  (use product schema)
select max(product_price),min(product_price), max(product_price)-min(product_price)
from product;

-- 29. List last names of actors and the number of actors who have that last name, but only for names 
-- that are shared by at least two actors (use Sakila schema)
select last_name,count(first_name)
from actor
group by last_name
having count(last_name)>=2;

-- 30. How many copies of the film 'DADDY PITTSBURGH' exist in the inventory system? (use Sakila schema)
select title,count(f.film_id) as countt
from film f join  inventory i
on f.film_id=i.film_id 
where title='DADDY PITTSBURGH';

-- 31. List the total paid by each customer. List the customers alphabetically by last name (use Sakila schema)
     select first_name,c.customer_id,sum(amount)
     from customer c join payment p
     on c.customer_id=p.customer_id
     group by c.customer_id
     order by last_name;

-- 32.  The titles of movies starting with the letters K and Q whose language is English. (use Sakila schema)
select title,f.language_id,name
from film f join language l
on f.language_id=l.language_id
where (f.title like 'k%' or f.title like 'q%') and l.name='English'
group by title;

-- 33. Display the 3 most frequently rented movies in descending order.
-- Get the movie name and times rented (use Sakila schema)
select i.film_id,title,count(i.film_id) as times_rented
from film f join inventory i 
on f.film_id=i.film_id 
join rental r on i.inventory_id=r.inventory_id
group by f.film_id
order by times_rented desc 
limit 7
;



-- 34. Find out how much business, each store has brought in. Along with store id get the city, country too
 select s.store_id,c.city,co.country,sum(amount)
 from payment p 
 join staff s on p.staff_id=s.staff_id 
 join store st on s.store_id=st.store_id
 join address a on st.address_id=a.address_id
 join city c on a.city_id=c.city_id
 join country co on c.country_id=co.country_id
 group by store_id;
 

-- 35. Get the employee's and manager's id and department id's for employees whose manager is working in a different department. (use hr schema)
select employee_id,first_name,d.manager_id,d.department_id
from employees e join 
on e.employee_id=d.manager_id ;



select employee_id,department_id,manager_id
from employees m
where department_id not in 
 ( select department_id from employees e where  m.employee_id=e.manager_id);
