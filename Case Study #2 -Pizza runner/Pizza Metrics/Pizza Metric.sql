
 -- A Pizza Metrics
 -- 1.How many pizzas were ordered?
 SELECT  
 COUNT(pizza_id) AS pizza_ordered
 FROM customer_orders_temp;
 -- 2.How many unique customer orders were made?
 SELECT
 COUNT(DISTINCT order_id) AS unique_orders
 FROM customer_orders_temp;
-- 3. How many successful orders were delivered by each runner?
SELECT 
runner_id,
COUNT(order_id) AS successful_orders
FROM runner_orders_temp
WHERE distance !=0
GROUP BY runner_id;
-- 4.How many of each type of pizza was delivered?
SELECT 
pn.pizza_name,
COUNT(ct.pizza_id) AS number_of_each_type_delivered
FROM customer_orders_temp AS ct
  INNER JOIN pizza_runner.pizza_names AS pn
ON ct.pizza_id=pn.pizza_id
INNER JOIN runner_orders_temp as ot
ON ct.order_id=ot.order_id
WHERE ot.distance!=0
GROUP BY pn.pizza_name;
-- 5.How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
ct.customer_id,
pn.pizza_name,
COUNT(pn.pizza_name) As ordered_number
FROM customer_orders_temp AS ct
INNER JOIN pizza_runner.pizza_names AS pn
ON ct.pizza_id=pn.pizza_id
GROUP BY ct.customer_id,pn.pizza_name
ORDER BY ct.customer_id;
-- 6.What was the maximum number of pizzas delivered in a single order?
SELECT 
ct.order_id,
COUNT(ct.pizza_id) AS max_pizza_delivered
FROM customer_orders_temp AS ct
INNER JOIN runner_orders_temp As ot
on ct.order_id=ot.order_id
WHERE distance != 0
GROUP BY ct.order_id;
WITH max_pizzas AS(
SELECT 
ct.order_id,
COUNT(ct.pizza_id) AS max_pizza_delivered
FROM customer_orders_temp AS ct
 INNER JOIN runner_orders_temp As ot
on ct.order_id=ot.order_id
WHERE distance != 0
GROUP BY ct.order_id)
SELECT 
order_id,
MAX(max_pizza_delivered)
FROM max_pizzas
GROUP BY order_id;
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
ct.customer_id,
SUM( CASE
WHEN ct.exclusions <> '' OR ct.extras <> '' THEN 1
ELSE 0 
END) AS made_change,
SUM(CASE
WHEN ct.exclusions='' AND ct.extras ='' THEN 1
ELSE 0 
END ) AS no_change
FROM customer_orders_temp AS ct
JOIN runner_orders_temp AS ot
ON ct.order_id=ot.order_id
WHERE distance !=0
GROUP BY ct.customer_id
ORDER BY ct.customer_id;
-- 8.How many pizzas were delivered that had both exclusions and extras?
SELECT 
SUM( CASE 
WHEN ct.exclusions is NOT NULL AND ct.extras is NOT NULL THEN 1
ELSE 0
END )AS pizza_with_exclusions_extras
FROM  customer_orders_temp AS ct
JOIN runner_orders_temp AS ot
ON ct.order_id=ot.order_id
WHERE ot.distance>=1
AND ct.exclusions <> ''
AND ct.extras <> '';
-- 9.What was the total volume of pizzas ordered for each hour of the day?
SELECT 
COUNT(order_id) AS pizza_count_ordered,
hour(order_time) AS hour_of_day
FROM customer_orders_temp
GROUP BY hour(order_time) 
ORDER BY hour(order_time) ;
-- 10.What was the volume of orders for each day of the week?
SELECT 
COUNT(order_id) AS pizza_count,
dayname(order_time) AS day_of_week
FROM customer_orders_temp
GROUP BY dayname(order_time)
ORDER BY COUNT(order_id);