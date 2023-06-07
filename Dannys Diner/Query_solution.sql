/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it p- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


**Query #1**

    SELECT
      	product_id,
        product_name,
        price
    FROM dannys_diner.menu
    ORDER BY price DESC
    LIMIT 5;

| product_id | product_name | price |
| ---------- | ------------ | ----- |
| 2          | curry        | 15    |
| 3          | ramen        | 12    |
| 1          | sushi        | 10    |

---
**Query #2**

    select s.customer_id,sum(me.price) as total_amount
    from dannys_diner.sales s
    join dannys_diner.menu me on s.product_id = me.product_id
    join dannys_diner.members m on s.customer_id = m.customer_id
    group by s.customer_id;

| customer_id | total_amount |
| ----------- | ------------ |
| A           | 76           |
| B           | 74           |

---
**Query #3**

    select a.customer_id,count(a.distinct_dates)
    from
    (select distinct customer_id,order_date as distinct_dates
    from dannys_diner.sales
    order by customer_id) a
    group by a.customer_id;

| customer_id | count |
| ----------- | ----- |
| A           | 4     |
| B           | 6     |
| C           | 2     |

---
**Query #4**

    with first_purchase as
    ( select s.*,m.product_name,row_number() over (partition by s.customer_id order by s.order_date,s.product_id) as rn
     from dannys_diner.sales s 
     join dannys_diner.menu m
     on s.product_id = m.product_id
     )
     select product_name from 
     first_purchase
     where rn = 1;

| product_name |
| ------------ |
| sushi        |
| curry        |
| ramen        |

---
**Query #5**

    select m.product_name,count(s.product_id)
     from dannys_diner.sales s
     join dannys_diner.menu m
     on s.product_id = m.product_id
     group by m.product_name
     order by count(s.product_id) desc
     limit 1;

| product_name | count |
| ------------ | ----- |
| ramen        | 8     |

---
**Query #6**

    select a.customer_id,a.product_name,a.count
     from
     (
     select s.customer_id,m.product_name,count(s.product_id) as count,rank() over( partition by s.customer_id order by count(s.product_id) desc) as rn
     from dannys_diner.sales s
     join dannys_diner.menu m
     on s.product_id = m.product_id
     group by s.customer_id,m.product_name
     order by count(s.product_id) desc
     ) a
    where rn = 1;

| customer_id | product_name | count |
| ----------- | ------------ | ----- |
| A           | ramen        | 3     |
| C           | ramen        | 3     |
| B           | ramen        | 2     |
| B           | curry        | 2     |
| B           | sushi        | 2     |

---
**Query #7**

    with first_purchase as
    ( select s.*,m.product_name,row_number() over (partition by s.customer_id order by s.order_date,s.product_id) as rn
     from dannys_diner.sales s 
     join dannys_diner.menu m on s.product_id = m.product_id
     join dannys_diner.members me on s.customer_id = me.customer_id
     where me.join_date >= s.order_date
     )
     select customer_id,product_name from 
     first_purchase
     where rn = 1;

| customer_id | product_name |
| ----------- | ------------ |
| A           | sushi        |
| B           | curry        |

---
**Query #8**

    with first_purchase as
    ( select s.*,m.product_name,row_number() over (partition by s.customer_id order by s.order_date,s.product_id desc) as rn
     from dannys_diner.sales s 
     join dannys_diner.menu m on s.product_id = m.product_id
     join dannys_diner.members me on s.customer_id = me.customer_id
     where s.order_date < me.join_date
     )
     select customer_id,product_name from 
     first_purchase
     where rn = 1;

| customer_id | product_name |
| ----------- | ------------ |
| A           | curry        |
| B           | curry        |

---
**Query #9**

    select s.customer_id,count(s.product_id),sum(m.price)
     from dannys_diner.sales s 
     join dannys_diner.menu m on s.product_id = m.product_id
     join dannys_diner.members me on s.customer_id = me.customer_id
     where s.order_date < me.join_date
     group by s.customer_id
     order by s.customer_id;

| customer_id | count | sum |
| ----------- | ----- | --- |
| A           | 2     | 25  |
| B           | 3     | 40  |

---
**Query #10**

    select 
     	a.customer_id,
     	sum(case
            	when a.product_id = 1 then a.price * 20
            	else a.price * 10
            	end
            ) as points
     from
     	( select s.customer_id,s.product_id,m.price
          from dannys_diner.sales s 
          join dannys_diner.menu m on s.product_id = m.product_id
         ) a
     group by a.customer_id
     order by a.customer_id;

| customer_id | points |
| ----------- | ------ |
| A           | 860    |
| B           | 940    |
| C           | 360    |

---
**Query #11**

    with before_membership as
     (
     select 
     	a.customer_id,
     	sum(case
            	when a.product_id = 1 then a.price * 20
            	else a.price * 10
            	end
            ) as points1
      from
     	( select s.customer_id,s.order_date,me.join_date,s.product_id,m.price
          from dannys_diner.sales s 
          join dannys_diner.menu m on s.product_id = m.product_id
          left join dannys_diner.members me on s.customer_id = me.customer_id
        ) a
    where a.order_date < a.join_date
    group by a.customer_id
    order by a.customer_id
    ),
    after_membership as
    (
     select 
     	a.customer_id, sum(a.price) * 20 as points2
     from
     	( select s.customer_id,s.order_date,me.join_date,s.product_id,m.price
          from dannys_diner.sales s 
          join dannys_diner.menu m on s.product_id = m.product_id
          left join dannys_diner.members me on s.customer_id = me.customer_id
        ) a
    where a.order_date >= a.join_date
    group by a.customer_id
    order by a.customer_id
    ),
    members_points as
    (
    select x.cust, x.points1+x.points2 as total_points
    from
    (select bm.customer_id as cust,bm.points1,am.customer_id,am.points2
    from before_membership bm
    join after_membership am on am.customer_id = bm.customer_id
    ) x
    group by x.cust,x.points1,x.points2
    order by x.cust
    ),
    non_member as
    (
      select 
     	a.customer_id as cust,
     	sum(case
            	when a.product_id = 1 then a.price * 20
            	else a.price * 10
            	end
            ) as total_points
     from
     	( select s.customer_id,s.product_id,m.price
          from dannys_diner.sales s 
          join dannys_diner.menu m on s.product_id = m.product_id
         ) a
     where a.customer_id = 'C'
     group by a.customer_id
     order by a.customer_id
     )
     (
       select * from members_points
       order by cust
      )
     union all
     (
       select * from non_member
       order by cust
      );

| cust | total_points |
| ---- | ------------ |
| A    | 1370         |
| B    | 1180         |
| C    | 360          |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/sEXvtxGqXZr8vcUpnDm46F/0)