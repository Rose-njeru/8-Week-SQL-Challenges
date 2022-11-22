CREATE SCHEMA dannys_dinner;

CREATE TABLE sales(
customer_id VARCHAR (1),
order_date DATE,
product_id INT);

INSERT INTO sales(customer_id,order_date,product_id)
VALUES 
('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');

CREATE TABLE menu(
product_id INT,
product_name VARCHAR(5),
price INT);

INSERT INTO menu(product_id,product_name,price)
VALUES
('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
  CREATE TABLE members(
  customer_id VARCHAR (1),
  join_date DATE);
  
  INSERT INTO members(customer_id,join_date)
  VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
-- sales table  
SELECT *
FROM sales;
 -- menu table
 SELECT *
 FROM menu;
-- members table
SELECT *
FROM members;

-- 1 What is the total amount each customer spent at the restaurant?
SELECT 
s.customer_id ,
 SUM(m.price) AS amount_spent
FROM sales AS s
INNER JOIN menu AS m
ON s.product_id=m.product_id
GROUP BY customer_id;

-- 2 How many days has each customer visited the restaurant?

SELECT customer_id, 
COUNT( DISTINCT order_date) AS num_days
FROM sales
GROUP BY customer_id;

-- 3 What was the first item from the menu purchased by each customer?

SELECT 
s.customer_id ,
s.order_date,
m.product_name,
DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY order_date) AS rank_num
FROM sales AS s
INNER JOIN menu AS m
ON s.product_id=m.product_id;

WITH first_item AS(
SELECT 
s.customer_id ,
s.order_date,
m.product_name,
DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY order_date) AS rank_num
FROM sales AS s
INNER JOIN menu AS m
ON s.product_id=m.product_id)
SELECT
 customer_id,
product_name
FROM first_item
WHERE rank_num=1
GROUP BY customer_id,product_name;

--  4 What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT  m.product_name,
 COUNT(m.product_name) AS purchase_count
FROM sales AS s
 INNER JOIN menu AS m
ON s.product_id=m.product_id
GROUP BY product_name
ORDER BY COUNT(m.product_name) DESC
LIMIT 1;

-- 5 Which item was the most popular for each customer?
SELECT 
 s.customer_id,
 m.product_name,
 COUNT(m.product_name) AS product_count,
 DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(m.product_name) DESC )AS ranking
FROM sales AS s
INNER JOIN menu AS m
ON s.product_id=m.product_id
GROUP BY customer_id,product_name;

WITH purchase AS(SELECT 
 s.customer_id,
 m.product_name,
 COUNT(m.product_name) AS product_count,
 DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(m.product_name) DESC )AS ranking
FROM sales AS s
INNER JOIN menu AS m
ON s.product_id=m.product_id
GROUP BY customer_id,product_name)
SELECT 
customer_id,
product_name
FROM purchase
WHERE ranking=1
GROUP BY customer_id,product_name;

-- 6 Which item was purchased first by the customer after they became a member?

SELECT s.customer_id,
s.order_date,
mb.join_date,
m.product_name,
DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date ) AS ranking
FROM menu AS m
INNER JOIN sales AS s
on m.product_id=s.product_id
INNER JOIN members AS mb
on s.customer_id=mb.customer_id
WHERE s.order_date >= mb.join_date;

WITH purchase AS(
SELECT 
s.customer_id,
s.order_date,
mb.join_date,
m.product_name,
DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date ) AS ranking
FROM menu AS m
INNER JOIN sales AS s
on m.product_id=s.product_id
INNER JOIN members AS mb
on s.customer_id=mb.customer_id
WHERE s.order_date >= mb.join_date)
SELECT 
customer_id,
product_name,
order_date
FROM purchase
WHERE ranking=1
GROUP BY customer_id,product_name;

-- 7  Which item was purchased just before the customer became a member?
SELECT s.customer_id,
s.order_date,
mb.join_date,
m.product_name,
DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date ) AS ranking
FROM menu AS m
INNER JOIN sales AS s
on m.product_id=s.product_id
INNER JOIN members AS mb
on s.customer_id=mb.customer_id
WHERE s.order_date < mb.join_date;

WITH purchases AS(SELECT s.customer_id,
s.order_date,
mb.join_date,
m.product_name,
DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date  ) AS ranking
FROM menu AS m
INNER JOIN sales AS s
on m.product_id=s.product_id
INNER JOIN members AS mb
on s.customer_id=mb.customer_id
WHERE s.order_date < mb.join_date)
SELECT 
customer_id,
product_name,
order_date
FROM purchases
WHERE ranking =1
GROUP BY customer_id,product_name;

-- 8  What is the total items and amount spent for each member before they became a member?
SELECT 
s.customer_id,
COUNT(m.product_name)AS items_purchased,
sum(m.price) AS amount_spent
FROM menu AS m
INNER JOIN sales AS s
on m.product_id=s.product_id
INNER JOIN members AS mb
on s.customer_id=mb.customer_id
WHERE s.order_date<mb.join_date
GROUP BY s.customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?
SELECT 
product_name,
CASE WHEN product_id=1 THEN  price *20 
ELSE  price *10 
END AS points
FROM menu;
WITH purchase AS(
SELECT 
product_name,
product_id,
CASE WHEN product_id=1 THEN  price *20 
ELSE  price *10 
END AS points
FROM menu)
SELECT 
s.customer_id,
SUM(points) AS total_points
FROM purchase AS p
INNER JOIN sales AS s
on p.product_id=s.product_id
GROUP BY s.customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi — how many points do customer A and B have at the end of January?

SELECT *,
date_add(join_date,interval 6 day) AS valid_date,
last_day("2021-01-31") AS last_day
FROM members;
WITH purchase AS (
SELECT *,
date_add(join_date,interval 6 day) AS valid_date,
last_day("2021-01-31") AS last_day
FROM members)
SELECT 
s.customer_id,
SUM(
CASE 
WHEN m.product_id=1 THEN m.price*20
WHEN s.order_date BETWEEN p.join_date AND p.valid_date THEN m.price*20
ELSE m.price*10
END) AS points
FROM purchase AS p
INNER JOIN sales AS s
ON p.customer_id=s.customer_id
INNER JOIN menu AS m
ON s.product_id=m.product_Id
WHERE s.order_date< p.last_day
GROUP By s.customer_id
ORDER BY points DESC;

-- Bonus Questions
 SELECT
 s.customer_id,
 s.order_date,
 m.product_name,
 m.price,
 CASE WHEN s.order_date>=mb.join_date THEN 'Y'
 ELSE 'N'
 END AS member
 FROM sales AS s
 INNER JOIN menu AS m 
 ON s.product_id=m.product_id
 INNER JOIN members AS  mb
 ON s.customer_id=mb.customer_id;

WITH purchase AS(
 SELECT
 s.customer_id,
 s.order_date,
 m.product_name,
 m.price,
 CASE WHEN s.order_date>=mb.join_date THEN 'Y'
 ELSE 'N'
 END AS member
 FROM sales AS s
LEFT JOIN menu AS m 
 ON s.product_id=m.product_id
LEFT JOIN members AS  mb
 ON s.customer_id=mb.customer_id)
 SELECT 
 customer_id,
 order_date,
 product_name,
 price,
 member
 FROM purchase
 ORDER BY customer_id,order_date,price DESC;
 

 SELECT
 s.customer_id,
 s.order_date,
 m.product_name,
 m.price,
 CASE WHEN s.order_date>=mb.join_date THEN 'Y'
 ELSE 'N'
 END AS member
 FROM sales AS s
LEFT JOIN menu AS m 
 ON s.product_id=m.product_id
LEFT JOIN members AS  mb
 ON s.customer_id=mb.customer_id;

WITH purchase AS(
 SELECT
 s.customer_id,
 s.order_date,
 m.product_name,
 m.price,
 CASE WHEN s.order_date>=mb.join_date THEN 'Y'
 ELSE 'N'
 END AS member
 FROM sales AS s
LEFT JOIN menu AS m 
 ON s.product_id=m.product_id
LEFT JOIN members AS  mb
 ON s.customer_id=mb.customer_id)
 SELECT *,
 CASE WHEN member ='N' THEN 'null'
 ELSE RANK() OVER(PARTITION BY customer_id,member ORDER BY order_date)  END AS ranking
 FROM purchase
 ORDER BY customer_id,order_date,price DESC;

 





