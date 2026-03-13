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

---

## 🔄 Complete Data Analysis Workflow

1. Raw Dataset  
2. SQL – Data Cleaning & Transformation  
3. Star Schema Modeling (Fact + Dimensions)  
4. KPI Development (SQL)  
5. Power BI – Import & Data Model  
6. DAX Measures & Calculated Columns  
7. Interactive Dashboard Creation  
8. Business Insights & Recommendations

---

## 💡 Skills Demonstrated

- Advanced SQL querying & data modeling
- Star schema design for analytics
- KPI definition and calculation
- Power BI dashboard design & visual storytelling
- DAX for business logic & dynamic measures
- Turning raw data into actionable business insights

---

## 🚀 Business Value & Impact

This type of analysis helps food delivery platforms like **Swiggy / Zomato** to:

- Understand **customer ordering patterns** (time-based, category, geography)
- Identify **top-performing restaurants** and underperformers
- Optimize **menu offerings** (popular dishes & high-margin categories)
- Analyze **geographic demand** for city/region-specific expansion & marketing
- Improve **customer satisfaction** through rating trends and feedback insights

---

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

## 📸 Dashboard Screenshots

Here are some key views from the interactive Power BI dashboard:

<img width="1334" height="856" alt="Screenshot 2026-03-12 195657" src="https://github.com/user-attachments/assets/6f3c6b85-3748-4251-8ef2-c768a2b9eac9" />

<img width="1334" height="857" alt="Screenshot 2026-03-12 195722" src="https://github.com/user-attachments/assets/67ce1b0c-1f79-40ff-ac0e-aacc3c0c74e1" />

<img width="1333" height="857" alt="Screenshot 2026-03-12 195741" src="https://github.com/user-attachments/assets/ba46870a-2359-4e98-91a3-2123e3817044" />

---

## 📌 Conclusion

This project showcases a complete **data analytics pipeline** — from raw transactional data → clean & structured modeling → SQL-powered KPIs → visually compelling Power BI dashboard.

By transforming ₹45.81M+ worth of orders into clear patterns and recommendations, the analysis empowers stakeholders to make faster, smarter, **data-driven decisions** in a highly competitive food delivery market.
