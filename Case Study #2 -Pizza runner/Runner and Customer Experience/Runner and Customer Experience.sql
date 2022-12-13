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
