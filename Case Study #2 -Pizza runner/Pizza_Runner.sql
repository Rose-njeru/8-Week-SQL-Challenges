CREATE 
SCHEMA Pizza_Runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners
(runner_id INT UNSIGNED NOT NULL,
registration_date DATE,
PRIMARY KEY(runner_id)) 
ENGINE InnoDB;
INSERT INTO runners(
runner_id,registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');
  
  DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders(
order_id INTEGER,
customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP);
  
  INSERT INTO customer_orders(
  order_id,customer_id,pizza_id,exclusions,extras,order_time)
  VALUES
    ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
  
  DROP TABLE IF EXISTS runner_orders;
  CREATE TABLE runner_orders(
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23));
  
  INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');
  
  DROP TABLE IF EXISTS pizza_names;
  CREATE TABLE pizza_names(
  pizza_id INTEGER,
  pizza_name TEXT);
  
  INSERT INTO pizza_names(
  pizza_id,pizza_name)
  VALUES 
   (1, 'Meatlovers'),
  (2, 'Vegetarian');
  
  DROP TABLE IF EXISTS pizza_recipes;
  CREATE TABLE pizza_recipes(
  pizza_id INTEGER,
  toppings TEXT);
  
  INSERT INTO pizza_recipes(
  pizza_id,toppings)
  VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');
  
  DROP TABLE IF EXISTS pizza_toppings;
  CREATE TABLE pizza_toppings(
  topping_id INTEGER,
  topping_name TEXT);
  
  INSERT INTO pizza_toppings(
  topping_id,topping_name)
  VALUES
   (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
  -- Data  CLeaning and Transformation
/* Cleaning the customer_orders table replace the null values with blanks in both exclusions and extras column
Cleaning runner_orders table
1.remove the 'minutes/mins/minute' in the duration column and replace null with blanks ' '
2.remove 'km' in the distance column and replace null with blank space ' '
3.remove null in the pickup_time column and replace with blank space ' '
4.remove null in cancellation  column and replace with blank space ' '
creating a temp TABLE to store the data instead of altering the whole TABLE 
*/
DROP TEMPORARY TABLE  IF EXISTS   customer_orders_temp;  

CREATE TEMPORARY TABLE customer_orders_temp AS 
SELECT 
order_id,
customer_id,
pizza_id,
CASE
 WHEN exclusions is null OR exclusions LIKE 'null' THEN ''
 ELSE exclusions
 END AS exclusions,
 CASE
 WHEN extras is null or extras LIKE 'null'  THEN ''
 ELSE extras
 END as extras,
 order_time
 FROM `pizza_runner`.`customer_orders`;
 SELECT *
 FROM customer_orders_temp;
 
 DROP TEMPORARY TABLE IF EXISTS runner_orders_temp;
 CREATE TEMPORARY TABLE runner_orders_temp AS
 SELECT 
 order_id,
 runner_id,
 CASE 
 WHEN pickup_time is null OR pickup_time LIKE 'null' then ' '
 ELSE pickup_time
 END AS pickup_time,
 CASE
 WHEN distance is null OR distance LIKE 'null' THEN ' '
 WHEN distance  lIKE '%km' THEN TRIM('km' FROM distance)
 ELSE distance 
 END AS distance,
 CASE 
 WHEN duration is null OR duration LIKE 'null' THEN ' '
 WHEN duration LIKE '%mins' THEN trim('mins' FROM duration)
 WHEN duration LIKE '%minute' THEN trim('minute' FROM duration)
 WHEN duration LIKE '%minutes' THEN trim('minutes' FROM duration)
 ELSE duration
 END AS duration,
 CASE
 WHEN cancellation is null OR cancellation LIKE 'null' THEN ' '
 ELSE cancellation
 END AS cancellation
 FROM `pizza_runner`.`runner_orders`;
 SELECT *
 from runner_orders_temp;
 ALTER TABLE runner_orders_temp
MODIFY COLUMN pickup_time TIMESTAMP,
MODIFY COLUMN distance FLOAT,
MODIFY  COLUMN duration INT;
 
 
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

-- B Runner and Customer Experience
-- 1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT 
COUNT(runner_id) AS runners_signed,
extract(week FROM registration_date) AS week_period
FROM pizza_runner.runners
GROUP BY extract(week FROM registration_date);
-- 2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT 
ct.order_time,
ot.pickup_time,
timestampdiff(minute,ct.order_time,ot.pickup_time) AS minute_diff
FROM customer_orders_temp AS ct
JOIN runner_orders_temp AS  ot
ON ct.order_id=ot.order_id
GROUP BY ct.order_time,ot.pickup_time;
WITH time_taken AS (
 SELECT 
ct.order_time,
ot.pickup_time,
timestampdiff(minute,ct.order_time,ot.pickup_time) AS minute_diff
FROM customer_orders_temp AS ct
JOIN runner_orders_temp AS  ot
ON ct.order_id=ot.order_id
GROUP BY ct.order_time,ot.pickup_time)
SELECT 
AVG(minute_diff) AS average_time
FROM time_taken
WHERE minute_diff >1;
-- 3.Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT 
ct.order_time,
COUNT(ct.order_id) AS pizza_number,
ot.pickup_time,
timestampdiff(minute,ct.order_time,ot.pickup_time)
FROM customer_orders_temp AS ct
JOIN runner_orders_temp AS ot
ON ct.order_id=ot.order_id
WHERE ot.distance !=0
GROUP BY ct.order_time,ot.pickup_time;
WITH total_pizza AS(
SELECT 
ct.order_time,
COUNT(ct.order_id) AS pizza_number,
ot.pickup_time,
timestampdiff(minute,ct.order_time,ot.pickup_time) AS minute_diff
FROM customer_orders_temp AS ct
JOIN runner_orders_temp AS ot
ON ct.order_id=ot.order_id
WHERE ot.distance !=0
GROUP BY ct.order_time,ot.pickup_time)
SELECT 
pizza_number,
ROUND( AVG(minute_diff),2)
FROM total_pizza
WHERE minute_diff >1
GROUP BY pizza_number;
--  4.What was the average distance travelled for each customer?
 SELECT 
DISTINCT ct.customer_id,
 ot.distance AS distance
 FROM customer_orders_temp AS ct
INNER JOIN runner_orders_temp AS ot
 ON ct.order_id=ot.order_id
 WHERE ot.distance !=0
 GROUP BY ct.customer_id;
 -- 5.What was the difference between the longest and shortest delivery times for all orders?
 SELECT 
 order_id,
 CAST(duration AS UNSIGNED) AS duration
 FROM runner_orders_temp
 WHERE duration not like ''
 AND duration >0
 GROUP BY order_id;
 WITH time_taken AS(
 SELECT 
 order_id,
 CAST(duration AS UNSIGNED) AS duration
 FROM runner_orders_temp
 WHERE duration not like ''
 AND duration > 0
 GROUP BY order_id)
 SELECT
 MAX(duration)- MIN(duration) AS time_difference
 FROM time_taken
 WHERE duration not like ''
 AND duration > 0;
 -- 6.What was the average speed for each runner for each delivery and do you notice any trend for these values?
 SELECT 
 ot.runner_id,
 ct.order_id,
 COUNT(ct.order_id) AS pizza_count,
 ot.distance,
 CAST(ot.duration AS UNSIGNED  ) /60 AS duration_hr,
 round( ot.distance/CAST(ot.duration AS UNSIGNED  ) ,2) *60 AS speedKm_per_Hr
 FROM runner_orders_temp AS ot 
 JOIN customer_orders_temp AS ct
 ON ot.order_id=ct.order_id
 WHERE ot.distance !=0
 AND ot.duration >0
 GROUP BY ot.runner_id,ct.order_id,ot.distance;
 -- 7.What is the successful delivery percentage for each runner?
 SELECT 
 runner_id,
 round( 100* SUM(
 CASE WHEN distance =0 THEN 0
 ELSE 1 
 END) / COUNT(*),0) AS percentage_delivery
 FROM runner_orders_temp
 GROUP BY runner_id;
 
-- C.Ingredient Optimisation
-- 1.What are the standard ingredients for each pizza?
 -- CREATE a new table  pizza_recipe1 to separate the toppings
DROP TABLE IF EXISTS pizza_recipe1;
CREATE TABLE pizza_recipe1
(pizza_id INTEGER,
toppings INTEGER);
INSERT INTO pizza_recipe1
(pizza_id,toppings)
VALUES
(1,1),
(1,2),
(1,3),
(1,4),
(1,5),
(1,6),
(1,8),
(1,10),
(2,4),
(2,6),
(2,7),
(2,9),
(2,11),
(2,12);
SELECT *
FROM pizza_recipe1;
SELECT 
pn.pizza_id,
pn.pizza_name,
pr.toppings,
pt.topping_name
FROM pizza_runner.pizza_names AS pn
JOIN pizza_recipe1 AS pr
ON pn.pizza_id=pr.pizza_id
JOIN pizza_runner.pizza_toppings AS pt
ON pr.toppings=pt.topping_id
GROUP BY pn.pizza_id,
pn.pizza_name,
pr.toppings,
pt.topping_name;
WITH ingredients AS (
SELECT 
pn.pizza_id,
pn.pizza_name,
pr.toppings,
pt.topping_name
FROM pizza_runner.pizza_names AS pn
JOIN pizza_recipe1 AS pr
ON pn.pizza_id=pr.pizza_id
JOIN pizza_runner.pizza_toppings AS pt
ON pr.toppings=pt.topping_id
GROUP BY pn.pizza_id,
pn.pizza_name,
pr.toppings,
pt.topping_name)
SELECT 
pizza_name,
GROUP_CONCAT(topping_name) AS topping_name
FROM ingredients 
GROUP BY pizza_name;

-- 2.What was the most commonly added extra?
-- create table numbers 
-- https://stackoverflow.com/questions/26215324/mysql-php-select-count-of-distinct-values-from-comma-separated-data-tags
DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers(
num INTEGER);
INSERT INTO numbers(num)
VALUES 
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16);
WITH most_added_extra AS(
SELECT 
n.num,
substring_index( substring_index(all_tags,",",num),",",-1) AS one_tag
FROM 
(SELECT
    GROUP_CONCAT(extras separator ',') AS all_tags,
    LENGTH(GROUP_CONCAT(extras SEPARATOR ',')) - LENGTH(REPLACE(GROUP_CONCAT(extras SEPARATOR ','), ',', '')) + 1 AS count_tags
FROM customer_orders_temp)m
JOIN numbers as n
ON n.num<=m.count_tags)
SELECT 
one_tag AS extras,
pt.topping_name AS  extra_topping_name,
Count(one_tag) AS extras_count
FROM most_added_extra AS me
JOIN pizza_runner.pizza_toppings AS pt
ON pt.topping_id=me.one_tag
WHERE one_tag !=0
GROUP BY one_tag
LIMIT 1;

-- 3.What was the most common exclusion?
-- follow same procedure as for the extras
DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers
(num INTEGER );
INSERT INTO numbers (num)
VALUES 
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16);
WITH most_common_exclusion AS
( SELECT
  n.num,
  substring_index( substring_index(all_tags,",",num),",",-1) AS one_tag
  FROM  (SELECT     GROUP_CONCAT(exclusions separator ',') AS all_tags, 
  LENGTH(GROUP_CONCAT(exclusions SEPARATOR ',')) - LENGTH(REPLACE(GROUP_CONCAT(exclusions SEPARATOR ','), ',', '')) + 1 AS count_tags
  FROM customer_orders_temp)m 
  JOIN numbers AS n
  ON n.num<=m.count_tags)
  SELECT  one_tag AS exclusion,
  pt.topping_name AS  exclusion_topping_name, 
  Count(one_tag) AS exclusion_count
  FROM most_common_exclusion AS me
  JOIN pizza_runner.pizza_toppings AS pt
  ON pt.topping_id=me.one_tag
  WHERE one_tag !=0 
  GROUP BY one_tag
 ORDER BY  Count(one_tag) DESC
 LIMIT 1;

/* 4.Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lover
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers*/
SELECT
ct.pizza_id,
ct.order_id,
CASE 
WHEN ct.pizza_id=1 AND(exclusions ='') AND ( extras ='')
THEN 'Meat Lovers'
WHEN ct.pizza_id=2 AND( exclusions='') AND ( extras ='')
THEN 'vegeterian'
WHEN ct.pizza_id=1 AND (exclusions =4) AND ( extras ='')
THEN 'Meat Lovers-Exclude Cheese'
WHEN ct.pizza_id=2 AND (exclusions=4) AND ( extras ='')
THEN 'Vegeterian-Exclude Cheese'
WHEN ct.pizza_id =1 AND(exclusions=3) AND ( extras ='')
THEN 'Meat Lovers -Exclude Beef'
WHEN ct.pizza_id = 1 AND(exclusions ='') AND (extras=1)
THEN 'Meat Lovers -Extra Bacon'
WHEN ct.pizza_id=2 AND (exclusions='') AND (extras=1)
THEN 'Vegeterian-Extra Bacon'
WHEN ct.pizza_id =1 AND (exclusions LIKE '2, 6') AND (extras LIKE'1, 4')
THEN ' Meat Lovers - Exclude BBQ Sauce,Mushroom-Extra Bacon,Cheese'
WHEN ct.pizza_id =1 AND (exclusions =4 ) AND (extras LIKE'1, 5') 
THEN ' Meat Lovers -Exclude Cheese-Extra Bacon,Chicken'
WHEN ct.pizza_id =1 AND(exclusions LIKE'1, 4') AND (extras LIKE'6, 9')
THEN ' Meat Lovers -Exclude Cheese,Bacon-Extra Mushroom,pepper'
END AS Order_item
FROM customer_orders_temp as ct
INNER JOIN pizza_runner.pizza_names AS pn
ON ot.pizza_id=pn.pizza_id;
/* 5.Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"*/
SELECT 
ct.order_id,
CASE 
WHEN pizza_id=1 AND ct.order_id=1  THEN 'Meat Lovers:Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami'
WHEN pizza_id =1 AND ct.order_id=2  THEN 'Meat Lovers:Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami'
WHEN pizza_id =1 AND ct.order_id =3  THEN 'Meat Lovers:Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami'
WHEN pizza_id = 2 AND ct.order_id =3 THEN 'Vegetable Lovers:Cheese,Mushrooms,Onions,Peppers,Tomatoes,Tomato Sauce'
WHEN pizza_id =1 AND ct.order_id =4 THEN 'Meat Lovers:Bacon,BBQ Sauce,Beef,Chicken,Mushrooms,Pepperoni,Salami'
WHEN pizza_id =1 AND ct.order_id =4 THEN 'Meat Lovers:Bacon,BBQ Sauce,Beef,Chicken,Mushrooms,Pepperoni,Salami'
WHEN pizza_id =2 AND ct.order_id =4 THEN 'Vegetable Lovers:Mushrooms,Onions,Peppers,Tomatoes,Tomato Sauce'
WHEN pizza_id =1 AND ct.order_id =5 THEN 'Meat Lovers:2xBacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami'
WHEN pizza_id =2 AND ct.order_id =6 THEN 'Vegetable Lovers:Cheese,Mushrooms,Onions,Peppers,Tomatoes,Tomato Sauce'
WHEN pizza_id=2 AND ct.order_id =7 THEN 'Vegetable Lovers:2x Bacon,Cheese,Mushrooms,Onions,Peppers,Tomatoes,Tomato Sauce'
WHEN pizza_id=1 AND ct.order_id =8 THEN 'Meat Lovers:Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami'
WHEN pizza_id =1 AND ct.order_id= 9 THEN 'Meat Lovers:2xBacon,Chicken,BBQ Sauce,Beef,Mushrooms,Pepperoni,Salami'
WHEN pizza_id =1 AND ct.order_id = 10 THEN 'Meat Lovers:Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami'
WHEN pizza_id =1 AND ct.order_id = 10  THEN 'Meat Lovers:2xBacon,2xCheese,Beef,Chicken,Pepperoni,Salami'
END AS all_ingredients
FROM  customer_orders_temp AS ct
INNER JOIN  runner_orders_temp AS ot
ON ct.order_id=ot.order_id;

 
-- D.Pricing and Ratings
-- 1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
SELECT
SUM(
CASE
WHEN pizza_id = 1 THEN 12
ELSE 10 
END )AS Total_Amount
FROM runner_orders_temp AS ot
 INNER JOIN customer_orders_temp AS ct
 ON ot.order_id=ct.order_id
 WHERE ot.distance !=0;
 
/* 2.What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra*/
SET @intial_amount=138;
SELECT
 LENGTH(GROUP_CONCAT(extras)) - LENGTH(REPLACE(GROUP_CONCAT(extras), ',', ''))+1 +@intial_amount AS Amount_extras_included
FROM runner_orders_temp AS ot
 INNER JOIN customer_orders_temp AS ct
 ON ot.order_id=ct.order_id
 WHERE ot.distance !=0
 AND ct.extras !='';
/* 3.he Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner,
 how would you design an additional table for this new dataset -
 generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5*/
DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings(
order_id INTEGER,
rating INTEGER);
INSERT INTO ratings(order_id,rating)
VALUES
(1,4),
(2,3),
(3,2),
(4,5),
(5,1),
(7,3),
(8,2),
(10,1);
/* 4.Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas*/

SELECT 
ct.customer_id,
ct.order_id,
ot.runner_id,
ratings.rating,
ct.order_time,
ot.pickup_time,
timestampdiff(minute,ct.order_time,ot.pickup_time) AS time_difference_minutes,
 round( ot.distance/CAST(ot.duration AS UNSIGNED  ) ,2) *60 AS  avg_speedKm_per_Hr,
 ot.duration,
 COUNT(ct.pizza_id) AS pizza_count
 FROM customer_orders_temp AS ct
 INNER JOIN  runner_orders_temp AS ot
 ON ct.order_id=ot.order_id
 INNER JOIN ratings AS ratings
 ON ot.order_id=ratings.order_id
WHERE ot.distance !=0
AND ot.duration >0
GROUP BY ct.customer_id,
ct.order_id,
ot.runner_id,
ratings.rating,
ct.order_time,
ot.pickup_time;
/*5.If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - 
how much money does Pizza Runner have left over after these deliveries?*/
SET @intial_amount=138;
SELECT
@intial_amount-SUM(distance)*0.30 AS remaining_amount
FROM  runner_orders_temp;










 
 
 
 
 
 



  
  