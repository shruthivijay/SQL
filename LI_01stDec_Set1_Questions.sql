-- Constriant names
SHOW CREATE TABLE employees;

SHOW KEYS FROM employees WHERE Key_name = 'PRIMARY';

select *
from information_schema.key_column_usage
where table_name='order_items';
-- 'employees', 'CREATE TABLE `employees` (\n  `employee_id` int unsigned NOT NULL,\n  `first_name` varchar(20) DEFAULT NULL,\n  `last_name` varchar(25) NOT NULL,\n  `email` varchar(25) NOT NULL,\n  `phone_number` varchar(20) DEFAULT NULL,\n  `hire_date` date NOT NULL,\n  `job_id` varchar(10) NOT NULL,\n  `salary` decimal(8,2) NOT NULL,\n  `commission_pct` decimal(2,2) DEFAULT NULL,\n  `manager_id` int unsigned DEFAULT NULL,\n  `department_id` int unsigned DEFAULT NULL,\n  PRIMARY KEY (`employee_id`),\n  KEY `job_id` (`job_id`),\n  KEY `department_id` (`department_id`),\n  KEY `manager_id` (`manager_id`),\n  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`),\n  CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`),\n  CONSTRAINT `employees_ibfk_3` FOREIGN KEY (`manager_id`) REFERENCES `employees` (`employee_id`)\n) ENGINE=InnoDB DEFAULT CHARSET=utf8'


select *
from information_schema.table_constraints
where table_name='order_items';


-- 1. Find out those employees whose managers are working in different department (hr schema)
select employee_id,e.department_id,first_name,manager_id,department_id
from employees e
where manager_id in (select employee_id from employees where e.department_id<>department_id);


-- 2. Identify the quiz scores that took place on  ‘2020-09-16’ (Student schema)
/*
Student: studentid, studentname and gender
exam: examid, examdate, category
score: studentid, examid and score
*/
select * from score 
where examid= (select examid
from exam
where examdate='2020-09-16' and category ='quiz');



-- 3. WAQ to select the above-average scores from a given exam_id say 5 (Student schema)
select score from score where examid=5 and  score >
(select avg(score) from score where examid=5);


-- 4. Gather employee name and salary data of employees who receive salary greater than their manager's salary. (hr schema)
select first_name,salary 
from employees e
where salary>any(select salary from employees where e.manager_id=employee_id);

                            
-- 5. Get the employee details for those who have the word 'MANAGER' in their job title. (HR schema)
          select * from jobs;
select * from employees
where job_id in (select job_id from jobs where job_title like '%manager%');

-- 6. Find the employees who are not assigned to any department (HR schema)
select * from employees
where department_id not in (select department_id from departments ) or department_id is null;
select * from departments;
select * from employees where department_id is null;

-- 7. Display the order id's which have the maximum quantity ordered greater than 20 (hr schema)
select ORDER_ID,ORDER_DATE 
from order_header 
where ORDER_ID in (select ORDER_ID
from order_items 
group by ORDER_ID
having max(ORDERED_QTY)>20);


-- 8. Display the state province of employees who get commission_pct greater than 0.25 (hr schema)

select state_province from locations where location_id in
 (select location_id from departments where department_id in
 (select department_id
from employees 
where commission_pct>0.25));

-- 9. Display the manager details who have more than 5 employees reporting to them (hr schema)
select * from employees where employee_id in
(select manager_id from employees group by manager_id having count(employee_id)>5);
                    
-- 10. Collect only the duplicate employee records (hr schema)
select * from employees 
where email in (select email from employees group by email having count(*)>1);


-- 11. List the products with quantity in stock greater than 10 and price greater than the average price of any of the
# product categories (order schema)
select PRODUCT_ID,PRODUCT_DESC,QTY_IN_STOCK,PRODUCT_PRICE
from product
where QTY_IN_STOCK>10 and PRODUCT_PRICE >any (select avg(PRODUCT_PRICE) from product group by PROD_CAT_ID );

    
-- 12. Get the employee id and email id of all the managers (HR schema)
select employee_id,email,first_name
from employees
where employee_id in (select manager_id from employees );


-- 13. Find the employees whose difference between the salary and average salary is greater than 10,000 (HR schema)
select employee_id,first_name,salary
from employees
where salary-(select avg(salary) from employees)>10000;


-- 14. Find all the department id’s, their respective average salary, the groups High, Medium and Low based on
# the average salary (HR schema)
select department_id,salary,
ntile(3) over(order by salary) as groupps
from employees;


-- 15. Get the category id and average price of the product categories whose average price is 
#greater than the average price of product id 250 (HR schema)
with tab(PROD_CAT_ID,average) as (select PROD_CAT_ID,avg(PRODUCT_PRICE) as average
from product
group by PROD_CAT_ID)
select tab.PROD_CAT_ID,average
from tab
where average>(select avg(PRODUCT_PRICE) from product where PRODUCT_ID=250);

                            
-- 16. Select those departments where the average salary of job_id working in that department 
#is greater than the overall average salary of that respective job_id (HR schema)
select department_id,avg(salary)
from employees e
group by department_id,job_id
having avg(salary) > (select avg(salary) from employees where e.job_id=job_id);



-- 17. Fetch the department average salary along with the other columns present in department table. (HR schema)
select d.department_id,department_name,d.manager_id,location_id,round(avg(salary),2) as average
from departments d join employees e 
on d.department_id=e.department_id
group by e.department_id;

select d.*, dept_avg_sal
from
(select department_id, avg(salary) as dept_avg_sal
from employees 
group by department_id) dt
join departments d
on dt.department_id= d.department_id;
 
-- 18. Filter out the customer ids, the number of orders made and map them to customer types
-- 	number of orders  = 1 --> 'One-time Customer'
-- 	number of orders  = 2 --> 'Repeated Customer'
-- 	number of orders  = 3 --> 'Frequent Customer'
-- 	number of orders  > 2 --> 'Loyal Customer'
select CUSTOMER_ID , case 
when count( CUSTOMER_ID)=1 then 'One-time Customer'
when count( CUSTOMER_ID)=2 then  'Repeated Customer'
when count( CUSTOMER_ID)=3 then  'Frequent Customer'
else  'Loyal Customer'
end as type_of_customers
from order_header
group by CUSTOMER_ID;




-- 19. Get the total orders as well as the break up for the total shipped, in-process and cancelled order status
# in a single row. (order schema)
select count(ORDER_ID) as total_orders,sum(if(ORDER_STATUS='Shipped',1,0)) as shipped,sum(if(ORDER_STATUS='In process',1,0)) as in_process,sum(if(ORDER_STATUS='cancelled',1,0)) as cancelled
from order_header;
    

-- 20. 4. Display the employee name along with their department name. Show all the employee name 
-- even those without department and show all the department names even if it doesnt have an employee  (hr schema)
select e.department_id,d.department_name,employee_id,first_name
from employees e left join departments d
on e.department_id=d.department_id 
union 
select e.department_id,d.department_name,employee_id,first_name
from employees e right join departments d
on e.department_id=d.department_id ;


