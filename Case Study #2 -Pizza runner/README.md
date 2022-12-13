# 🍕 Case Study #2- Pizza Runner

![This is an Image](https://8weeksqlchallenge.com/images/case-study-designs/2.png)

## 📚 Table of Contents
+ Business Task
+ Entity Relationship Diagram
+ Data Cleaning
+ Case Study Questions
+  SQL solution
  
  
  
  ### Business Task 
  Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!
Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

### Entity Relationship Diagram 
![This is an image](https://user-images.githubusercontent.com/81607668/127271531-0b4da8c7-8b24-4a14-9093-0795c4fa037e.png)

### Data CLeaning and Transformation
[View the solution here](https://github.com/Rose-njeru/8-Week-SQL-Challenges/blob/main/Case%20Study%20%232%20-Pizza%20runner/Data%20Cleaning%20and%20Transformation/Data%20Cleaning%20and%20Transformation.sql)

### Case Study Questions
#### A. Pizza Metrics
1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many successful orders were delivered by each runner?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week

[View solution here[(https://github.com/Rose-njeru/8-Week-SQL-Challenges/blob/main/Case%20Study%20%232%20-Pizza%20runner/Pizza%20Metrics/Pizza%20Metric.sql)

#### B. Runner and Customer Experience
1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

[View solution here](

#### C. Ingredient Optimization
1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
5. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

[View Solution here](https://github.com/Rose-njeru/8-Week-SQL-Challenges/blob/main/Case%20Study%20%232%20-Pizza%20runner/Ingredient%20Optimization/Ingredient%20Optimization.sql)

#### D. Pricing and Rating
1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

[View Solution here](https://github.com/Rose-njeru/8-Week-SQL-Challenges/blob/main/Case%20Study%20%232%20-Pizza%20runner/Pricing%20and%20Ratings/Pricing%20and%20Ratings.sql)

[Case Study Solution Here](https://github.com/Rose-njeru/8-Week-SQL-Challenges/blob/main/Case%20Study%20%232%20-Pizza%20runner/Pizza_Runner.sql)



