---Business requiremnts 
--data validation
--checking null values
SELECT 
	sum(case when state is null then 1 else 0 end ) as null_states ,
		sum(case when city is null then 1 else 0 end ) as null_cities ,
			Sum(case when rest_name is null then 1 else 0 end ) as rest_name , 
			sum(case when location is null then 1 else 0 end ) as null_location ,
			sum(case when category is null then 1 else 0 end ) as null_category ,
			sum(case when dish_name is null then 1 else 0 end ) as null_dish_name ,
			sum(case when price is null then 1 else 0 end ) as null_price ,
			sum(case when rating is null then 1 else 0 end ) as null_rating ,
			sum(case when rating_count is null then 1 else 0 end ) as null_rating_count ,
			sum(case when order_date is null then 1 else 0 end ) as null_orderdate 
			from swiggy_data
			
--checking empty strings or blanks
select * from swiggy_data where state = ' ' or rest_name='' or location='' or category='' or dish_name='' or price='' 
or rating ='' or rating_count='' or order_date=''

-- checking duplicates
SELECT state, city,rest_name,location,category,dish_name,price,rating,rating_count,order_date, count(*) as cnt from swiggy_data sd 
group by state, city,rest_name,location,category,dish_name,price,rating,rating_count,order_date 
having count(*)>1

SELECT *, count(*) as cnt from swiggy_data sd 
group by state, city,rest_name,location,category,dish_name,price,rating,rating_count,order_date 
having count(*)>1

--- deleting duplications
with cte1 as (
SELECT *, row_number() over(partition by state,city,rest_name,location,category,dish_name,price,rating,rating_count,order_date order by (select null))as rnn
from swiggy_data )
delete from cte1 where rnn>1
-- the above code didn't work cause sqlite do not delete data with CTEs or temporary tables. if we need to delete data we can write like this.
with cte1 as (
SELECT rowid,*, row_number() over(partition by state,city,rest_name,location,category,dish_name,price,rating,rating_count,order_date order by (select null))as rnn
from swiggy_data )
delete from swiggy_data where rowid in (select rowid from cte1 where rnn>1)