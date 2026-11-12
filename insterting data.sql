--inserting data to tables.

insert into  dates (date_id, full_date,year, month,quarter, week,day,month_name)
select distinct 
rowid,
order_date, 
strftime('%Y',order_date),
strftime('%m',order_date),
((cast (strftime('%m',order_date) as integer)-1)/3+1),
strftime('%W',order_date),
strftime('%d',order_date),
CASE strftime('%m', order_date)
        WHEN '01' THEN 'January'
        WHEN '02' THEN 'February'
        WHEN '03' THEN 'March'
        WHEN '04' THEN 'April'
        WHEN '05' THEN 'May'
        WHEN '06' THEN 'June'
        WHEN '07' THEN 'July'
        WHEN '08' THEN 'August'
        WHEN '09' THEN 'September'
        WHEN '10' THEN 'October'
        WHEN '11' THEN 'November'
        WHEN '12' THEN 'December'
    END
from swiggy_data where order_date is not null

delete FROM  mapping 

SELECT  * from dates d 

--inserting into locations
INSERT into mapping (city,state,location)
select DISTINCT 
 city,state,location from swiggy_data sd where order_date is not null 

SELECT  * from mapping 

--inserting into restaurants
insert into restaurants (restaurant_id, restaurant_name )
SELECT distinct rowid, rest_name from swiggy_data sd where order_date is not null 

select * from restaurants r 

insert into categories (category)
SELECT distinct trim(category) from swiggy_data sd where order_date is not null 

update dishes  set dish_id =rowid 

select count(*) from orders

insert into restaurants (restaurant_name)
SELECT distinct trim(rest_name) from swiggy_data sd where order_date is not null 

insert into dishes (dish_name)
SELECT distinct trim(dish_name) from swiggy_data sd where order_date is not null 

insert into orders (date_id,price,rating,rating_count , location_id, restaurant_id,category_id,dish_id)
SELECT dd.date_id,s.price,s.rating,s.rating_count,m.locatio_id,r.restaurant_id,c.category_id,d.dish_id from swiggy_data s join
dates dd on s.order_date=dd.full_date join mapping m on m.state=s.state and m.city=s.city and m.location=s.location
join restaurants r on r.restaurant_name=s.rest_name join categories c on c.category=s.category join dishes d on d.dish_name=s.dish_name



-- 1. Drop the broken table
DROP TABLE IF EXISTS orders;

-- 2. Recreate it with the bulletproof SQLite syntax
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    date_id INTEGER,
    price REAL,
    rating REAL,
    rating_count INTEGER,
    location_id INTEGER,
    restaurant_id INTEGER,
    category_id INTEGER,
    dish_id INTEGER
);

-- 3. (Optional Speed Booster) Add indexes to your dimension lookup columns 
-- so the insert takes seconds instead of minutes:
CREATE INDEX idx_dates_full ON dates(full_date);
CREATE INDEX idx_restaurants_name ON restaurants(restaurant_name);
CREATE INDEX idx_dishes_name ON dishes(dish_name);

-- 4. Re-run your INSERT query
INSERT INTO orders (date_id, price, rating, rating_count, location_id, restaurant_id, category_id, dish_id)
SELECT dd.date_id, s.price, s.rating, s.rating_count, m.locatio_id, r.restaurant_id, c.category_id, d.dish_id 
FROM swiggy_data s 
JOIN dates dd ON s.order_date = dd.full_date 
JOIN mapping m ON m.state = s.state AND m.city = s.city AND m.location = s.location
JOIN restaurants r ON r.restaurant_name = s.rest_name 
JOIN categories c ON c.category = s.category 
JOIN dishes d ON d.dish_name = s.dish_name;

ALTER TABLE table_name 
ADD COLUMN column_name data_type;
