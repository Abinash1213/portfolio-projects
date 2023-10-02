create database if not exists zomato;
use zomato;
create table goldusers_signup(userid int,gold_signup_date date);
insert into goldusers_signup(userid,gold_signup_date) values (1,'2017-09-22'),
(3,'2017-04-21');
CREATE TABLE users (
    userid INT,
    signup_date DATE
);
insert into users(userid,signup_date) values (1,'2014-09-02'),
(2,'2015-01-15'),
(3,'2014-04-11');

CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'2017-04-19',2),
(3,'2019-12-18',1),
(2,'2020-07-20',3),
(1,'2019-10-23',2),
(1,'2018-03-19',3),
(3,'2016-12-20',2),
(1,'2016-11-09',1),
(1,'2016-05-20',3),
(2,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-11',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);

CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


SELECT 
    s.userid, SUM(p.price) as total_amount
FROM
    sales s
        JOIN
    product p ON s.product_id = p.product_id group by userid;
    
    
    
SELECT 
    userid, COUNT(DISTINCT created_date) AS no_of_days
FROM
    sales
GROUP BY userid; 
    
    
## what was the first product purchased by the customer?

select*from(select *,rank()over(partition by userid order by created_date) rnk from sales) a where rnk=1;

##what is the most purchased item on the menu and how many times was it purchased by customers?

select userid,count(product_id) as cnt from sales where product_id=
(select product_id from sales group by product_id order by count(product_id) desc limit 1 ) group by userid; 

##which item was most popular for each customer?
select * from
(select*,rank() over(partition by userid order by cnt desc) as rnk from
(select userid,product_id,count(product_id) as cnt from sales group by userid, product_id)a)b where rnk=1;

## which item was purchased first by the customer after they became a member?

select*from
(select a.*,rank() over(partition by userid order by created_date) as rnk from
(SELECT 
    g.userid, g.gold_signup_date, s.product_id, s.created_date
FROM
    goldusers_signup g
        JOIN
    sales s ON g.userid = s.userid where s.created_date>=g.gold_signup_date)a )b where rnk=1;
    
    
    
    
## which item was purchased just before the customer became a member?

select*from
(select a.*,rank() over(partition by userid order by created_date desc) as rnk from
(SELECT 
    g.userid, g.gold_signup_date, s.product_id, s.created_date
FROM
    goldusers_signup g
        JOIN
    sales s ON g.userid = s.userid where s.created_date<=g.gold_signup_date)a )b where rnk=1;
    
    
## 8 What is the total orders and amount spent for each member before they became a member?


SELECT 
    userid,
    COUNT(created_date) AS no_of_items,
    SUM(price) AS total_amount
FROM
    (SELECT 
        a.*, p.price
    FROM
        (SELECT 
        g.userid, g.gold_signup_date, s.product_id, s.created_date
    FROM
        goldusers_signup g
    JOIN sales s ON g.userid = s.userid
    WHERE
        s.created_date <= g.gold_signup_date) a
    JOIN product p ON a.product_id = p.product_id) b
GROUP BY userid;


##  9  If buying each product generates points for eg 5rs=2 zomato point each product has different purchasing points for eg for p1 5rs=1 point,for p2 10rs=5 points and p3 5rs=1 points
## Calculate points collected by each customers and for which product most points have been given till now.  


SELECT 
    userid, SUM(total_points) * 2.5 AS total_money_earned
FROM
    (SELECT 
        c.*, total_amt / points AS total_points
    FROM
        (SELECT 
        b.*,
            CASE
                WHEN product_id = 1 THEN 5
                WHEN product_id = 2 THEN 2
                WHEN product_id = 3 THEN 5
                ELSE 0
            END AS points
    FROM
        (SELECT 
        a.userid, a.product_id, SUM(price) AS total_amt
    FROM
        (SELECT 
        s.*, p.price
    FROM
        sales s
    JOIN product p ON s.product_id = p.product_id) a
    GROUP BY userid , product_id) b) c) d
GROUP BY userid;


select*from
(select *, rank() over(order by total_points_earned desc) as rnk from
(SELECT 
    product_id, SUM(total_points) AS total_points_earned
FROM
    (SELECT 
        c.*, total_amt / points AS total_points
    FROM
        (SELECT 
        b.*,
            CASE
                WHEN product_id = 1 THEN 5
                WHEN product_id = 2 THEN 2
                WHEN product_id = 3 THEN 5
                ELSE 0
            END AS points
    FROM
        (SELECT 
        a.userid, a.product_id, SUM(price) AS total_amt
    FROM
        (SELECT 
        s.*, p.price
    FROM
        sales s
    JOIN product p ON s.product_id = p.product_id) a
    GROUP BY userid , product_id) b) c) d
GROUP BY product_id)e)f where rnk=1;



## 10 In first one year after the customer joins the gold program(including their join dates) irrespective of what the customer has purchased they earned 5 zomato points
## for every 10 rs spent who earned more 1 or 3 and what was their points earnings in their first year?



SELECT 
    a.*, p.price * .5 AS total_points_earned
FROM
    (SELECT 
        s.userid, s.created_date, s.product_id, g.gold_signup_date
    FROM
        sales s
    JOIN goldusers_signup g ON s.userid = g.userid
        AND created_date >= gold_signup_date
        AND created_date <= DATE_ADD(gold_signup_date, INTERVAL (1) YEAR)) a
        JOIN
    product p ON a.product_id = p.product_id;



## 11  rnk all the transaction of all the customers


 select*,rank() over(partition by userid order by created_date ) as rnk from sales;
 
 

