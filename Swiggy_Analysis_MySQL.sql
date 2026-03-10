# 1) Making minor changes in the table 

# Displaying the imported table first


SELECT * 
FROM orders;

# 1.1) Assigning a id column and making it as a Primary Key 

ALTER TABLE orders
ADD id INT AUTO_INCREMENT PRIMARY KEY; # AUTO_INCREMENT automatically assigns the next sequential number to each new row.

# 1.2) Modifying the id coluumn and making it appear before all other columns 

ALTER TABLE orders
MODIFY COLUMN id INT AUTO_INCREMENT FIRST;

# 1.3) The date format is not correct to fix that-

UPDATE swiggy_data
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');

# Then change the column type

ALTER TABLE swiggy_data
MODIFY order_date DATE;

# 1.4) Changing the table name

ALTER TABLE orders
RENAME TO swiggy_data;

# 2) Data Validation & Data Cleaning

# 2.1) Check for Null values

SELECT 
SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS null_state,
SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_city,
SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_state,
SUM(CASE WHEN restaurant_name IS NULL THEN 1 ELSE 0 END) AS null_restaurant,
SUM(CASE WHEN location IS NULL THEN 1 ELSE 0 END) AS null_location,
SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS null_category,
SUM(CASE WHEN dish_name IS NULL THEN 1 ELSE 0 END) AS null_dish,
SUM(CASE WHEN price_inr IS NULL THEN 1 ELSE 0 END) AS null_price,
SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS null_rating,
SUM(CASE WHEN rating_count IS NULL THEN 1 ELSE 0 END) AS null_rating_count
FROM swiggy_data;

# As we can see we have No Null values in our dataset.

# 2.2) Check for Blank or Empty Strings

SELECT * 
FROM swiggy_data
WHERE state = '' OR city = '' OR restaurant_name = '' 
OR location = '' OR category = '' OR dish_name = '';

# None of the Categorical columns contain any blank values.

# 2.2) Checking for Duplicate values

SELECT state, city, order_date, restaurant_name, location, 
category, dish_name, price_inr, rating, rating_count, COUNT(*) AS duplicate_count
FROM swiggy_data
GROUP BY state, city, order_date, restaurant_name, location, 
category, dish_name, price_inr, rating, rating_count
HAVING duplicate_count> 1;

/* 
As we can see, we have 29 rows which are duplicated, 
the 'duplicate_count' column shows the amount of time that record is duplicated.
*/

# 2.3) Delete Duplicate values

DELETE t1
FROM swiggy_data t1
JOIN (SELECT id 
FROM (SELECT id,ROW_NUMBER() OVER (
								PARTITION BY state, city, order_date, restaurant_name,
                                location, category, dish_name,
                                price_inr, rating, rating_count
								ORDER BY id) AS rn
FROM swiggy_data) temp
WHERE rn > 1) t2 
ON t1.id = t2.id;

/*
We used `ROW_NUMBER()` with `PARTITION BY`, a derived table, and a self-join 
on the primary key `id` to safely identify and delete only exact duplicate rows while keeping one original record.
*/



# 3) Creating a Star Schema

/*
To optimize analytics and reporting, building a Star Schema with the following Dimension and Fact tables:

dim_date → Year, Month, Quarter, Week
dim_location → State, City, Location
dim_restaurant → Restaurant_Name
dim_category → Category
dim_dish → Dish_Name

Central fact table:

fact_swiggy_orders → Price_INR, Rating, Rating_Count, foreign keys to all dimensions
*/

# 3.1) Dimension Tables

-- DATE TABLE

CREATE TABLE dim_date 
(
date_id INT AUTO_INCREMENT PRIMARY KEY,
Full_Date DATE,
Year INT NOT NULL,
Month INT NOT NULL,
Month_Name VARCHAR(50),
Quarter INT NOT NULL,
Day INT NOT NULL,
Week INT NOT NULL 
);

-- LOCATION TABLE

CREATE TABLE dim_location 
(
location_id INT AUTO_INCREMENT PRIMARY KEY,
State VARCHAR(50),
City VARCHAR(100),
Location VARCHAR(200) 
);

-- RESTAURANT TABLE

CREATE TABLE dim_restaurant 
(
restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
Restaurant_Name VARCHAR(200) 
);

-- CATEGORY TABLE

CREATE TABLE dim_category
(
category_id INT AUTO_INCREMENT PRIMARY KEY,
Category VARCHAR(200) 
);

-- DISH TABLE

CREATE TABLE dim_dish
(
dish_id INT AUTO_INCREMENT PRIMARY KEY,
Dish_Name VARCHAR(200) 
);

# 3.2) Creating the Fact Table

CREATE TABLE IF NOT EXISTS fact_swiggy_orders
(
order_id INT AUTO_INCREMENT PRIMARY KEY,

date_id INT,
Price_INR DECIMAL(10,2),
Rating DECIMAL(4,2),
Rating_Count INT,

location_id INT,
restaurant_id INT,
category_id INT,
dish_id INT,

FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
FOREIGN KEY (location_id) REFERENCES dim_location(location_id),
FOREIGN KEY (restaurant_id) REFERENCES dim_restaurant(restaurant_id),
FOREIGN KEY (category_id) REFERENCES dim_category(category_id),
FOREIGN KEY (dish_id) REFERENCES dim_dish(dish_id)
);

SELECT * FROM fact_swiggy_orders;

# 4) The structure of the table is created, now we insert values into our table

# 4.1] dim_date table

INSERT INTO dim_date (Full_Date, Year, Month, Month_Name, Quarter, Day, Week )

SELECT DISTINCT order_date,
YEAR(order_date),
MONTH(order_date),
MONTHNAME(order_date),
QUARTER(order_date),
DAY(order_date),
DAYOFWEEK(order_date)

FROM swiggy_data
WHERE order_date IS NOT NULL;

# Checking the table 
SELECT * FROM dim_date;

# 4.2] dim_location table

INSERT INTO dim_location (State, City, Location)
SELECT DISTINCT State, City, Location
FROM swiggy_data;

# Checking the table 
SELECT * FROM dim_location;

# 4.3] dim_restaurant

INSERT INTO dim_restaurant (restaurant_name)
SELECT DISTINCT restaurant_name
FROM swiggy_data;

# Checking the table 
SELECT * FROM dim_restaurant;

# 4.4] dim_category

INSERT INTO dim_category (Category)
SELECT DISTINCT Category
FROM swiggy_data;

# Checking the table 
SELECT * FROM dim_category;

# 4.5] dim_dish

INSERT INTO dim_dish (dish_name)
SELECT DISTINCT dish_name
FROM swiggy_data;

# Checking the table 
SELECT * FROM dim_dish;

# 4.6) Fact table

INSERT INTO fact_swiggy_orders
(
date_id,
Price_INR,
Rating, 
Rating_Count, 
location_id, 
restaurant_id, 
category_id, 
dish_id
)
SELECT
dd. date_id,
s. Price_INR,
s. Rating, 
s. Rating_Count, 

dl. location_id, 
dr. restaurant_id, 
dc. category_id, 
dsh. dish_id

FROM swiggy_data s

JOIN dim_date dd
ON dd.Full_Date = s.order_date

JOIN dim_location dl
ON dl. State = s. State
AND dl. City = s. City
AND dl. Location = s. Location

JOIN dim_restaurant dr
ON dr. Restaurant_Name = s. Restaurant_Name

JOIN dim_category dc
ON dc. Category= s. Category

JOIN dim_dish dsh
ON dsh. Dish_Name = s. Dish_Name;

# Checking the table 
SELECT * FROM fact_swiggy_orders;

# Now joining all the tables

SELECT * FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
JOIN dim_location l ON f.location_id = l.location_id
JOIN dim_restaurant r ON f.restaurant_id = r.restaurant_id
JOIN dim_category c ON f.category_id = c.category_id
JOIN dim_dish di ON f.dish_id = di.dish_id;


# 5) Key Performance Indicators (KPI's) Development

-- Total Orders

SELECT COUNT(order_id) as Total_Orders
FROM fact_swiggy_orders;

-- Total Revenue (INR Million)

SELECT CONCAT(FORMAT(SUM(Price_INR) / 1000000, 2), ' INR Million') AS Total_Revenue
FROM fact_swiggy_orders;

-- Average Dish Price

SELECT CONCAT(FORMAT(AVG(Price_INR), 2), ' INR') AS Average_Dish_Price
FROM fact_swiggy_orders;

-- Average Rating

SELECT round(AVG(Rating), 1) AS Average_Rating # Rounding to one decimal
FROM fact_swiggy_orders;


# 5.1) Date-Dased Analysis

-- Monthly Order Trends

SELECT Year, Month, Month_Name, COUNT(*) As Total_Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY Year, Month, Month_Name;

-- Quarterly Order Trends

SELECT Year, Quarter, COUNT(*) As Total_Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY Year, Quarter;

-- Quarterly Order Trends

SELECT Year, COUNT(*) As Total_Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY Year;

-- Day-of-Week Patterns

SELECT DAYNAME(Full_Date) AS Day, COUNT(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY DAYOFWEEK(Full_Date), DAYNAME(Full_Date)
ORDER BY DAYOFWEEK(Full_Date);


# 5.2) Location-Based Analysis

-- Top 10 Cities by Order Volume

SELECT City, COUNT(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_location l ON f.location_id = l.location_id
GROUP BY City
ORDER BY Total_Orders DESC
LIMIT 10;

-- Revenue Contribution by States

SELECT State, CONCAT(FORMAT(SUM(Price_INR), 2), ' INR') AS Total_Revenue
FROM fact_swiggy_orders f
JOIN dim_location l ON f.location_id = l.location_id
GROUP BY State
ORDER BY SUM(Price_INR) DESC;


# 5.3) Food-Based Analysis

-- Top 10 Restaurants by Orders

SELECT Restaurant_Name , FORMAT(COUNT(*), 0) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_restaurant r ON f.restaurant_id = r.restaurant_id
GROUP BY Restaurant_Name
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Top 5 Most Popular Categories

SELECT Category , FORMAT(COUNT(*), 0) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_category c ON f.category_id = c.category_id
GROUP BY Category
ORDER BY COUNT(*) DESC
LIMIT 5;

-- Top 10 Most Ordered Dishes

SELECT Dish_Name, FORMAT(COUNT(*), 0) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_dish dsh ON f.dish_id = dsh.dish_id
GROUP BY Dish_Name
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Top 5 Highest Revenue Generating Dishes

SELECT Dish_Name, FORMAT(SUM(Price_INR), 2) AS Total_Revenue
FROM fact_swiggy_orders f
JOIN dim_dish dsh ON f.dish_id = dsh.dish_id
GROUP BY Dish_Name
ORDER BY SUM(Price_INR) DESC
LIMIT 10;

-- Category Performance (Orders + Avg Rating)

SELECT Category, COUNT(*) AS Total_Orders, ROUND(AVG(Rating), 1) As Avg_rating
FROM fact_swiggy_orders f
JOIN dim_category c ON f.category_id = c.category_id
GROUP BY Category
ORDER BY Total_Orders DESC;


# 5.4) Customer Spending Insights

-- Total Orders by Price Range

SELECT
    CASE
        WHEN Price_INR < 100 THEN 'Under 100'
        WHEN Price_INR BETWEEN 100 AND 199 THEN '100 - 199'
        WHEN Price_INR BETWEEN 200 AND 299 THEN '200 - 299'
        WHEN Price_INR BETWEEN 300 AND 499 THEN '300 - 499'
        ELSE '500+'
    END AS Price_Range, COUNT(*) AS Total_Orders
FROM fact_swiggy_orders
GROUP BY Price_Range
ORDER BY Total_Orders DESC;


# 5.5) Ratings Analysis

SELECT rating, COUNT(*) AS Rating_Count
FROM fact_swiggy_orders
GROUP BY Rating
ORDER BY Rating_Count DESC;














