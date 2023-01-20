-- In these sets of queries, you can see that the JOIN functions were heavily used as we are dealing with multiple data sets to find the given answer.
-- Subqueries were also heavily used since we needed to perform a task before perform the final query. The use of subquery is complex however is very useful when you want to isolate parts. 
-- Tip when writing the subquery, write down the inside query first (inside the parenthesis) since this is going to be performed first. Then create your outer query (outside of the parenthesis) based on the results of the first query. 
-- QUESTION #1: What is the total amount each customer spent at the restaurant?
SELECT
	s.customer_id, 
	SUM(price) AS total_amount
FROM sales AS s 
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_amount DESC; 

-- QUESTION #2: How many days has each customer visited the restaurant?
SELECT 
	s.customer_id, 
	COUNT(order_date) AS visits
FROM sales AS s
GROUP BY s.customer_id
ORDER BY s.customer_id; 

-- QUESTION#3: WHAT WAS THE FIRST ITEM FROM THE MENU PURCHASED BY EACH CUSTOMER
SELECT 
	customer_id, 
	product_name
FROM
(
SELECT
	s.customer_id,
	m.product_name, 
	order_date, 
	DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name, order_date
) AS first
WHERE rank=1

-- QUESTION #4: WHAT IS THE MOST PURCHASED ITEM ON THE MENU AND HOW MANY TIMES WAS IT PURCHASED?
SELECT 
	s.product_id, 
	m.product_name, 
	COUNT (s.product_id) AS most_purchased
FROM sales AS s
JOIN menu AS m 
ON s.product_id = m.product_id
GROUP BY s.product_id, m.product_name
ORDER BY most_purchased DESC
LIMIT 1;

-- QUESTION #5: WHICH ITEM WAS THE MOST POPULAR?
SELECT 
	m.product_name, 
	COUNT(m.product_name) AS most_purchased
FROM sales AS s
JOIN menu AS m 
ON s.product_id = m.product_id
GROUP BY m.product_name
LIMIT 1;

-- QUESTION #6: WHICH ITEM WAS PURCHASED FIRST BY THE CUSTOMER AFTER THEY BECAME A MEMBER?
SELECT 
	a.customer_id, 
	a.order_date, 
	menu.product_name
FROM (
	SELECT
		s.customer_id,
		m.join_date, 
		s.order_date, 
		s.product_id, 
		DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank
	FROM sales AS s
	JOIN members AS m 
		ON s.customer_id = m.customer_id 
	WHERE s.order_date >= m.join_date 
) AS a
JOIN menu 
	ON a.product_id = menu.product_id
WHERE rank = 1;

-- #QUESTION #7: WHICH ITEM WAS PURCHASED JUST BEFORE THE CUSTOMER BECAME A MEMBER?
SELECT 
	b.customer_id, 
	b.order_date, 
	menu.product_name
FROM (
	SELECT 
		s.customer_id, 
		m.join_date, 
		s.order_date, 
		s.product_id, 
		DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank
	FROM sales AS s
	JOIN members AS m
		ON s.customer_id = m.customer_id
	WHERE s.order_date < m.join_date
) AS b
JOIN menu 
	ON b.product_id = menu.product_id
WHERE rank = 1;

-- QUESTION #8: WHAT IS THE TOTAL ITEMS AND AMOUNT SPENT FOR EACH MEMBERS BEFORE THEY BECAME A MEMBER?
SELECT 
	s.customer_id, 
	SUM(price) AS total_amount,
	COUNT( s.product_id) AS total_items
FROM sales AS s
JOIN menu as m
ON s.product_id = m.product_id
JOIN members 
ON s.customer_id = members.customer_id
WHERE s.order_date < members.join_date
GROUP BY s.customer_id;

-- BONUS QUESTIONS
SELECT 
	s.customer_id,
	s.order_date, 
	m.product_name,
	m.price,
CASE 
	WHEN s.order_date < mem.join_date THEN 'N'
	WHEN s.order_date >= mem.join_date THEN 'Y'
	ELSE 'N'
	END AS member
FROM sales AS s
LEFT JOIN menu AS m 
ON s.product_id = m.product_id
LEFT JOIN members AS mem 
ON s.customer_id = mem.customer_id
ORDER BY s.customer_id, s.order_date;

WITH member AS 
(
	SELECT 
	s.customer_id,
	s.order_date, 
	m.product_name,
	m.price,
CASE 
	WHEN s.order_date < mem.join_date THEN 'N'
	WHEN s.order_date >= mem.join_date THEN 'Y'
	ELSE 'N'
	END AS member
FROM sales AS s
LEFT JOIN menu AS m 
ON s.product_id = m.product_id
LEFT JOIN members AS mem 
ON s.customer_id = mem.customer_id
ORDER BY s.customer_id, s.order_date
)

SELECT *, 
CASE
	WHEN member = 'N' THEN null
	ELSE
	RANK() OVER(PARTITION BY customer_id, member
	ORDER BY order_date) 
	END AS ranking
FROM member;



