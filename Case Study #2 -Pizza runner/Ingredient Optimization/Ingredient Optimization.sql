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

 