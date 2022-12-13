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




