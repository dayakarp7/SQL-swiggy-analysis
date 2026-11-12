--Operational and sales performance analysis.
SELECT * from dates d 

-- select sum(pnt) from (
SELECT d.month_name  ,count(*) cnt, round(count(*)*100.0/(sum(count(*)) over()),2) as pnt
from orders o
join dates d on o.date_id=d.date_id 
group by d.month_name order by  pnt desc
--SELECT * from dates d limit 10

SELECT d.quarter  ,count(*) cnt, round((count(*)*100.0)/(sum(count(*)) over()),2) as pnt
from orders o
join dates d on o.date_id=d.date_id 
group by d.quarter order by  pnt desc

SELECT case STRFTIME('%w',d.full_date) 
when '0' then 'sunday'
when '1' then 'monday'
when '2' then 'tuesday'
when '3' then 'wedsnesday'
when '4' then 'thursday'
when '5' then 'friday'
when '6' then 'saturday'
 end 
as dayweek  ,count(*) cnt 
--, printf('%2f',round((count(*)*100.0)/sum(count(*)) over(),2) as pnt
from orders o
join dates d on o.date_id=d.date_id 
--group by dayweek 
group by STRFTIME('%w', d.full_date)
order by STRFTIME('%w', d.full_date) asc

--top performing restaurants
SELECT * from orders limit 10

select r.restaurant_name , count(*) from orders o join restaurants r on o.restaurant_id =r.restaurant_id 
group by r.restaurant_name order by count(*) desc

--aggregate sales, average value per order

select r.restaurant_name , count(*) cnt,sum(o.price) reve from orders o join restaurants r on o.restaurant_id =r.restaurant_id 
group by r.restaurant_name order by reve desc, cnt desc

select r.restaurant_name , count(*) cnt,sum(o.price) reve, printf('%.2f' ,round(AVG(o.price),2)) avgreve 
from orders o join restaurants r on o.restaurant_id =r.restaurant_id 
group by r.restaurant_name order by avg(price)  desc -- ,reve desc, cnt desc

SELECT * from dishes d 

SELECT  count(*) cnt, d.dish_name, r.restaurant_name  from orders o join dishes d on o.dish_id =d.dish_id join restaurants r on o.restaurant_id =r.restaurant_id 
group by r.restaurant_name , d.dish_name order by cnt desc

with cte1 as (
SELECT   sum(o.price) as smprce, o.price,count(*) cnt,SUBSTR(r.restaurant_name,1,40), d.dish_name, row_number() over(partition by r.restaurant_name order by count(*) desc) rnk
from orders o join dishes d on o.dish_id =d.dish_id join restaurants r on o.restaurant_id =r.restaurant_id 
group by r.restaurant_name , d.dish_name ,o.price
)
SELECT * from cte1 where rnk=1 order by cnt desc


SELECT  count(*), d.dish_name, r.restaurant_name, row_number() over(partition by r.restaurant_name order by count(*) desc) rnk
from orders o join dishes d on o.dish_id =d.dish_id join restaurants r on o.restaurant_id =r.restaurant_id 
group by r.restaurant_name , d.dish_name

--menu item popularity
SELECT count(*) cnt, d.dish_name    from orders o  join dishes d on o.dish_id =d.dish_id  join mapping m on o.location_id =m.locatio_id 
group by  d.dish_name order by cnt asc

SELECT count(*) cnt, c.category  from orders o  join dishes d on o.dish_id =d.dish_id  join categories c   on o.category_id  =c.category_id 
group by  c.category  order by cnt desc

SELECT count(*),o.dish_id  from orders o join restaurants r on o.restaurant_id =r.restaurant_id  where   r.restaurant_name='175 C' group by o.dish_id 

with cte1 as (
SELECT   sum(o.price) as smprce, o.price,count(*), d.dish_name, r.restaurant_name, row_number() over(partition by r.restaurant_name order by count(*) desc) rnk
from orders o join dishes d on o.dish_id =d.dish_id join restaurants r on o.restaurant_id =r.restaurant_id 
where /* d.dish_name='Banana milk boba   [350 ml]' and */ r.restaurant_name='175 C'
group by r.restaurant_name , d.dish_name ,o.price
)
SELECT * from cte1 where rnk=1

---category performance on count percentage
--with cte2 as (
SELECT substr(c.category,1,20) as nme ,count(*) cnt, round((count(*)*100.0/sum(count(*)) over()),2) as perce  ,sum(o.price ) sme, round(avg(o.price ),2) 
from orders o  join categories c on o.category_id =c.category_id group by c.category
order by round((count(*)*100.0/sum(count(*)) over()),2) desc
--) select sum(perce) from cte2


---category performance revenue generated percentage code is incorrect with o.price column in select and groupby clause.
with cte3 as (
SELECT substr(c.category,1,20) as nme ,count(*) cnt, round((sum(o.price)*100.0)/(sum(o.price) over()),2) as perce  ,sum(o.price ) sme, round(avg(o.price ),2) 
from orders o  join categories c on o.category_id =c.category_id group by c.category --,o.price 
order by  perce desc 
) SELECT sum(perce) from cte3
-- round(sum(o.price)*100.0/sum(o.price) over(),2) desc

SELECT distinct category from orders o join categories c on o.category_id = c.category_id 

-- this is correct for category wise price percentage
with cte1 as (
SELECT distinct category, sum(o.price) pr, ((sum(o.price )*100.0)/(select sum(o.price) from orders o)) as perc from orders o join categories c on o.category_id = c.category_id 
group by c.category 
order by pr desc
) select sum(perc) from cte1

select 298.3*24097 math

select * from mapping m  

--location wise revenue performance
with cte1 as (
SELECT m.city, sum(o.price) pr, ((sum(o.price )*100.0)/(select sum(o.price) from orders o)) as perc, count(o.order_id )
from orders o join mapping m on o.location_id  = m.locatio_id 
group by m.city  
order by pr desc
) select sum(perc) from cte1

--location wise top ordered category
with cte2 as (
with cte1 as (
SELECT  c.category_id cid, c.category ct , count(o.order_id) cnt
from orders o join categories c on o.category_id =c.category_id group by c.category , c.category_id order by cnt desc
) select cid,ct, max(cnt) from cte1 group by ct order by max(cnt) desc )
SELECT m.city, cte2.ct from cte2 join orders o on o.category_id =cte2.cid join mapping m on o.location_id =m.locatio_id 
group by m.city 

--this is correct. with this as base model we can replace category with dish names also.
with cte1 as (
SELECT  m.city cty,c.category_id cid, c.category ct , count(o.order_id) cnt,row_number() over(partition by m.city order by count(o.order_id) DESC  )as rnk
from orders o join categories c on o.category_id =c.category_id join mapping m on o.location_id =m.locatio_id 
group by c.category , c.category_id,m.city order by cnt desc
) select cte1.cty,cid,ct,cte1.cnt from cte1 where  rnk=1


with cte1 as (
SELECT  m.city cty, d.dish_name dh , count(o.order_id) cnt,row_number() over(partition by m.city order by count(o.order_id) desc )as rnk
from orders o join dishes d  on o.dish_id  =d.dish_id  join mapping m on o.location_id =m.locatio_id 
group by d.dish_name ,m.city order by cnt desc
) select cte1.cty,dh from cte1 where  rnk=1

with cte1 as (
SELECT  m.city cty, d.dish_name dh , count(o.order_id) cnt,row_number() over(partition by m.city order by count(o.order_id) desc )as rnk
from orders o join dishes d  on o.dish_id  =d.dish_id  join mapping m on o.location_id =m.locatio_id 
group by d.dish_name ,m.city --order by cnt desc
) select cte1.cty,dh,cnt from cte1 where  rnk=1 or rnk=2 order by cte1.cty

with cte1 as (
SELECT  m.city cty, r.restaurant_name  dh , count(o.order_id) cnt,row_number() over(partition by m.city order by count(o.order_id) desc )as rnk
from orders o join restaurants r   on o.dish_id  =r.restaurant_id  join mapping m on o.location_id =m.locatio_id 
group by dh ,m.city order by cnt desc
) select cte1.cty,dh,cnt,rnk from cte1 where rnk=1 or rnk=2 order by cty

SELECT * FROM categories c 

--Customer Preference & Product Mix Analysis
--count vs revenue of categories
SELECT c.category, sum(o.price) rve,count(*) cnt from categories c join orders o on o.category_id =c.category_id 
group by c.category order by rve desc

SELECT * from  swiggy_data sd 

create table salaries (
	empid integer primanry key,
	name varchar(20) ,
	salary integer )
	
	SELECT * from salaries

alter table salaries
add COLUMN year integer
	
insert into salaries ( empid, name, salary,year)
 values (101,'james', 60000,2023),
 (101,'james',72000,2025),
 (102,'sarah',55000,2023),
 (102,'sarah',60000,2025),
 (103,'michael',62000,2023),
 (103,'michael',75000,2025),
 (104,'emma',58000,2023),
 (104,'emma',66000,2025);

with cte1 as (
select s1.empid eid,s1.salary s1e from salaries s1 where year=2023),
cte2 as (
select s2.empid,s2.salary s2e from salaries s2 where year=2025)
select cte1.eid, round(((cte2.s2e*1.0)/(cte1.s1e*1.0))-1,2)*100.0 as perc from cte1 join cte2 on cte1.eid=cte2.empid

with cte1 as (select *, rank() over(partition by empid order by year) rnk from salaries),
cte2 as (select cte1.empid c2emp,cte1.salary c2s from cte1 where cte1.year=(select min(year) from salaries)),
cte3 as (select cte1.empid c3emp,cte1.year, cte1.salary c3s from cte1 where cte1.year=(select max(year) from salaries))
select c2emp, round(((c3s*1.0/c2s)-1)*100,2) perc from cte2 join cte3 on cte2.c2emp=cte3.c3emp

SELECT * from swiggy_data sd limit 10

--finding average price of dish in each category
--Calculate the average price of dishes ordered within each category to see where customers spend the most money per item.

SELECT SUBSTRING(c.category,1,20) nme, count(*) cnt, round(avg(o.price),2) avgprc, max(o.price), min(o.price) from orders o join categories c on o.category_id =c.category_id 
group by c.category ,c.category_id order by avgprc desc

SELECT SUBSTRING(c.category,1,20) nme, o.price /*count(*) cnt, round(avg(o.price),2) avgprc, max(o.price), min(o.price) */ from orders o join categories c on o.category_id =c.category_id 
where nme='PARTY SPECIALS' /* group by c.category ,c.category_id  order by o.price desc */

SELECT * from mapping m 

with cte1 as (
select m.city,location lt, count(o.order_id  ) cntl, row_number() over(partition by m.city order by count(o.order_id) desc) as rnk
from mapping m join orders o on o.location_id =m.locatio_id group by location,m.city order by count(*) desc
)
select * from  cte1  where rnk=1 /*group by m2.city,cte1.lt */order by cntl desc

select city,location from mapping m where city='Lucknow' 

--finding top categories on categories
with cte1 as (
select m.city,r.restaurant_name lt, count(o.order_id  ) cntl,sum(o.price) rve, row_number() over(partition by m.city order by sum(o.price ) desc) as rnk
from mapping m join orders o on o.location_id =m.locatio_id join restaurants r on o.restaurant_id =r.restaurant_id
group by lt,m.city order by count(*) desc
)
select * from  cte1  where rnk=1 /*group by m2.city,cte1.lt */order by rve desc


--rating analysis. 
SELECT * from dates d 


SELECT distinct dish_name from dishes 

SELECT Substring(dish_name,1,20) as nme, avg(rating) rr from orders o join dishes d on o.dish_id =d.dish_id group by d.dish_id order by rr

--moving averages and growth rates
with cte1 as (
SELECT  sum(o.price) rve, case  when strftime('%w',d.full_date) in ('1','2','3','4','5') 
then 'weekday'  else 'weekends'  end as days from dates d join orders o on o.date_id =d.date_id group by  days
)
select case when cte1.days='weekday' then cte1.rve end weekday_revenue ,
case when cte1.days='weekends' then cte1.rve end weekend_revenue
from cte1

WITH labeled_dates AS (
    SELECT 
        d.full_date,
        CASE 
            WHEN strftime('%w', d.full_date) IN ('1', '2', '3', '4', '5') THEN 'weekday' 
            ELSE 'weekends' 
        END AS day_type
    FROM dates d
)
SELECT 
    SUM(CASE WHEN day_type = 'weekday' THEN 1 ELSE 0 END) AS total_weekdays,
    SUM(CASE WHEN day_type = 'weekends' THEN 1 ELSE 0 END) AS total_weekends
FROM labeled_dates;

select * from orders o 

--finding out the top performing dishes over the years
WITH cte1 as (
	select y.month_name ,substr(dish_name,1,20) nme , count(d.dish_name ) cnt FROM  orders o join dishes d on o.dish_id =d.dish_id join dates y on o.date_id =y.date_id 
	group by y.month_name , d.dish_name order by cnt desc
)
select cte1.month_name, count(cte1.dish_name) dshn from cte1 group by cte1.month_name order by dshn desc

--category over categories
with cte1 as(
	select y.month_name ,substr(dish_name,1,20) nme , count(d.dish_id ) cnt FROM  orders o join dishes d on o.dish_id =d.dish_id join dates y on o.date_id =y.date_id 
	group by y.month_name , d.dish_name order by cnt desc  ), cte2 AS (
	select month_name, nme, cnt, row_number() over(partition by month_name order by cnt desc) rnk from cte1 )
	select * from cte2
	
--category over categories 2nd
with cte1 as(
	select y.month_name ,  count(d.dish_id) cnt , d.dish_name ,
	row_number() over(partition by month_name order by count(d.dish_id) desc) rnk
	FROM orders o join dishes d on o.dish_id = d.dish_id join dates y on o.date_id = y.date_id
	group by y.month_name , d.dish_name order by cnt desc ) ,  cte2 as (
	select * from cte1 where rnk=1 ) --select * from cte2
	select d.dish_name, sum(o.price ) from orders o join dishes d on o.dish_id =d.dish_id
where d.dish_name in (select cte2.dish_name  from cte2)
group by d.dish_name 

--faulty code when rnk is write within main query and not in cte mode.
select d.month_name, sum(o.price) pri, sum(o.price) over( order by month_name) rnk
from orders o join dates d on o.date_id =d.date_id group by d.month_name 

--for the same desired code, proper query writing rnk in cte setup 
with cte1 as (
select d.month_name, (o.price) pri 
from orders o join dates d on o.date_id =d.date_id group by d.month_name )
 select *,sum(pri) over( order by month_name) rnk --,sum(pri)/lag(sum(pri),
 from cte1

 
 
 select 6560087.0+6761477.22+6247063.67