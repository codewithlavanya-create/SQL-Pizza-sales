create database SQL_projects;

use SQL_projects;

-- Ques 1: Retrieve the total number of orders placed.

select count(order_id) as total_orders from orders;

-- Ques 2 : Calculate the total revenue generated from pizza sales.

select round(sum(od.quantity * p.price),2) as total_revenue from order_details od
join pizzas p
on p.pizza_id = od.pizza_id;


-- Ques 3: Identify the highest-priced pizza.

select pt.name, p.price
from pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id
order by p.price desc
limit 1;

-- Ques 4: List the top 5 most ordered pizza types along with their quantities.

select  pt.name as pizza_name, sum(quantity) as quantity
from order_details od join pizzas p on od.pizza_id = p.pizza_id
join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
group by  pt.name
order by quantity desc
limit 5;

-- Ques 5: - Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT pt.category, sum(quantity) as quantity
from order_details od join pizzas p on od.pizza_id = p.pizza_id
join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
group by pt.category order by quantity desc;

-- Ques 6: Determine the distribution of orders by hour of the day.

select * from orders;

select hour(time) as Hour, count(order_id)  as count_ID
from orders
group by hour(time) limit 10;

-- Ques 7: Group the orders by date and calculate the average number of pizzas ordered per day.

select round(avg(quantity),3) as average from 
(select date , sum(quantity) as quantity from order_details od
join orders o on od.order_id = o.order_id
group by date) orders;

-- Ques 8 : Determine the top 3 most ordered pizza types based on revenue.

select pt.name, sum(quantity * price) as revenue
from order_details od join Pizzas p on 
od.pizza_id = p.pizza_id
join pizza_types pt on pt.pizza_type_id = p.pizza_type_id
group by pt.name
order by revenue desc
limit 3;

-- Ques 9 : Calculate the percentage contribution of each pizza type to total revenue.

select pt.category,
round(sum(quantity * price)/(select sum(quantity * price)
	from order_details od join pizzas p
    on od.pizza_id = p.pizza_id) * 100,2) as revenue
from order_details od join pizzas p on od.pizza_id = p.pizza_id
join pizza_types pt on pt.pizza_type_id = p.pizza_type_id
group by pt.category order by revenue desc;

-- Ques 10 : Analyze the cumulative revenue generated over time.

with cte as (
select date, round(sum(quantity * price),2) as revenue
from order_details od 
join orders o on od.order_id = o.order_id
join pizzas p on od.pizza_id = p.pizza_id
group by o.date)

select date,
sum(revenue) over(order by date) as cum_revenue
from cte;