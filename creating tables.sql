--normalization process.
--dimension table

---date table
create table dates (
 date_id int identity(1,1) PRIMARY key,
 full_date DATE ,
 year int,
 month int, month_name varchar(20), quarter int, week int, day int )
 
 select * from dates
---location table
 create table mapping (
  locatio_id int identity(1,1) primary key,
  state varchar(100),
  city varchar(100),
  location varchar(100) )

 --restaurant table
  create table restaurants (
   restaurant_id int identity(1,1) primary key,
   restaurant_name varchar(200) )
   
 -- categories table
   create table categories (
   category_id int identity(1,1) primary key,
   category varchar(200) )
   
   -- categories table
   create table dishes (
   dish_id int identity(1,1) primary key,
   dish_name varchar(200) )
   
 -------all above tables are dimension tables.
   ----below one is FACT table.
   create table orders (
    order_id int rowid primary key,
    date_id int, price decimal(10,2), rating decimal(10,2), rating_count int,
    location_id int, restaurant_id int, category_id int, dish_id int,
    foreign key (date_id) references dates(date_id),
    foreign key (location_id) references mapping (locatio_id),
    foreign key (restaurant_id) references restaurants (restaurant_id),
    foreign key (category_id) references categories (category_id),
    foreign key (dish_id) references dishes(dish_id) )
    
  drop table orders
    
    
    
    
    
    
    
   
   
