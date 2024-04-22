# 1. View the menu_items table and write a query to find the number of items on the menu

select * from menu_items;
select count(distinct(item_name)) as count_of_items from menu_items;

# 2. What are the least and most expensive items on the menu?

select * from menu_items
where price = (select max(price) from menu_items);

select * from menu_items
where price= (select min(price) from menu_items);

# 3. How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?

select count(distinct(item_name)) as no_of_italian_dishes from menu_items
where category="Italian";

select menu_item_id, item_name, category, price as most_expensive
from menu_items
where category="Italian"
order by price desc
limit 1;

select menu_item_id, item_name, category, price as least_expensive
from menu_items
where category="Italian"
order by price asc
limit 1;

# 4. How many dishes are in each category? What is the average dish price within each category?

select category,count(distinct(item_name)) as no_of_dishes,round(avg(price),2) as avg_price
from menu_items
group by category;

# 5. View the order_details table. What is the date range of the table?

select * from order_details;

select min(order_date) as min_date,max(order_date) as max_date
from order_details;

# 6. How many orders were made within this date range? 

select count(distinct order_id) as no_of_orders
from order_details;

# 7. How many items were ordered within this date range?

select count(*) from order_details;

# 8. Which orders had the most number of items?

select order_id,
       count(item_id) as no_of_items 
from order_details
group by order_id
order by count(item_id) desc;

# 9. How many orders had more than 12 items?

with cte as(
select 
     order_id,
     count(item_id) as no_of_items 
from order_details
group by order_id
having no_of_items>12
order by count(item_id) desc)

select count(*) as no_of_orders from cte;

# 10. Combine the menu_items and order_details tables into a single table

select * from order_details o
left join menu_items m
on o.item_id=m.menu_item_id;

# 11. What were the least and most ordered items? What categories were they in?

with cte as(
select 
    item_name,
    count(order_details_id) as num_purchases,
    category
from menu_order_details
group by item_name,category
order by num_purchases desc)

select * from cte
where num_purchases in (
select max(num_purchases) from cte) or num_purchases in (
select min(num_purchases) from cte);


# 12. What were the top 5 orders that spent the most money?

select * from(
select order_id,
       sum(price) as price_of_orders,
       rank() over(order by sum(price) desc) as rnk
from menu_order_details
group by order_id) cte
where rnk<=5;

# 13. View the details of the highest spend order. Which specific items were purchased?

select order_id,
       category,
       count(item_id) as no_of_items
from menu_order_details
where order_id=440
group by category
;

# 14. View the details of the top 5 highest spend orders


select order_id,
       category,
       count(item_id) as no_of_items
from menu_order_details
where order_id in (440, 2075, 1957, 330, 2675)
group by category,order_id
;
# Highest spending customers like Italian a lot hence it shoukd be kept in the menu.