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
 