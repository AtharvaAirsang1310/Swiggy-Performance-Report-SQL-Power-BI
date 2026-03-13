# 🍔 Swiggy Food Delivery Data Analysis | SQL + Power BI Project

End-to-end analytics project on a **Swiggy-style food delivery dataset** — from raw order data modeling in SQL → KPI development → interactive Power BI dashboard with actionable business insights.

Goal: Uncover customer ordering behavior, restaurant performance, category & dish popularity, geographic revenue patterns, and key trends to support data-driven decisions for food delivery platforms.

---

## 🛠 Tools & Technologies

- **SQL** (MySQL) – Data cleaning, transformation, modeling & KPI calculations
- **Power BI** – Interactive dashboards, visuals & storytelling
- **DAX** – Custom measures, calculated columns & KPI logic
- **Star Schema** – Efficient dimensional modeling (Fact + Dimension tables)

---

## 🗂 Data Model (Star Schema)

### Fact Table
`fact_swiggy_orders`

| Column         | Description                  |
|----------------|------------------------------|
| order_id       | Unique order identifier      |
| date_id        | Order date reference         |
| price_inr      | Order value (₹)              |
| rating         | Customer rating (out of 5)   |
| rating_count   | Number of ratings received   |
| location_id    | Location reference           |
| restaurant_id  | Restaurant reference         |
| category_id    | Food category reference      |
| dish_id        | Ordered dish reference       |

### Dimension Tables
- `dim_date`
- `dim_location`
- `dim_restaurant`
- `dim_category`
- `dim_dish`

---

## 📊 Dashboard Features

### Revenue Analysis
- Revenue distribution by **day of the week**
- **Monthly** order & revenue trends

### Category Performance
- Orders vs Revenue comparison
- Bubble chart: Category performance by ratings & order volume

### Dish Analysis
- **Top 5** most ordered dishes

### Restaurant Performance
- **Top 10** restaurants by revenue
- **Highest rated** restaurants
- **Lowest rated** food categories

### Geographic Insights
- Revenue distribution across **Indian states**
- **Top cities** by total orders
- Locations with **highest average dish prices**

---

## 📈 Key KPIs

### KPI Calculations (SQL Examples)

```sql
-- Total Orders
SELECT COUNT(order_id) AS Total_Orders
FROM fact_swiggy_orders;

-- Total Revenue (formatted in INR Million)
SELECT CONCAT(FORMAT(SUM(price_inr) / 1000000, 2), ' INR Million') AS Total_Revenue
FROM fact_swiggy_orders;

-- Average Dish Price
SELECT CONCAT(FORMAT(AVG(price_inr), 2), ' INR') AS Average_Dish_Price
FROM fact_swiggy_orders;

-- Average Customer Rating
SELECT ROUND(AVG(rating), 1) AS Average_Rating
FROM fact_swiggy_orders;
```

---

## KPI Overview

| KPI                  | Value     |
|----------------------|-----------|
| Total Orders         | 173K      |
| Total Revenue        | ₹45.81M   |
| Average Dish Price   | ₹264.36   |
| Average Rating       | 4.34      |

## 🔄 Complete Data Analysis Workflow
