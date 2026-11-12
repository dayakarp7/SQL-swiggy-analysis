select * from swiggy_data sd 

select count(*) from swiggy_data 

select count(*) from orders

select (select count(*) from dates, select count(*) from mapping, select count(*) from location )


SELECT 'mapping', count(*) from mapping  union all
SELECT 'restaurants', COUNT(*) FROM restaurants
UNION ALL
SELECT 'dishes', COUNT(*) FROM dishes
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'dates', COUNT(*) FROM dates;

select restaurant_name, count(*) from restaurants group by restaurant_name having count(*)>1

select dish_name, count(*) from dishes group by dish_name having count(*)>1

select category, count(*) from categories group by category having count(*)>1

select state,city,location, count(*) from mapping group by state,location,city having count(*)>1 

select city, count(*) from mapping group by city having count(*)>1 

SELECT 
    s.state, s.city, s.location, 
    COUNT(m.locatio_id) AS mapping_matches
FROM swiggy_data s
LEFT JOIN mapping m 
    ON m.state = s.state 
   AND m.city = s.city 
   AND m.location = s.location
GROUP BY s.state, s.city, s.location
HAVING COUNT(m.locatio_id) > 1;

SELECT 
    COUNT(*) AS total_source_rows,
    COUNT(DISTINCT order_date, rest_name, dish_name, price) AS unique_source_rows
FROM swiggy_data;

SELECT full_date, COUNT(*) AS count
FROM dates
GROUP BY full_date
HAVING COUNT(*) > 1; 
