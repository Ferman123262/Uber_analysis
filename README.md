# 🚗 Uber Ride Analytics — End-to-End Data Analysis Project

## 📌 Project Overview

This project is an end-to-end **Uber Ride Analytics** project designed to analyze ride-booking data from operational, financial, customer, and supply-side perspectives.

The project combines **Oracle SQL, Python, Pandas, and Power BI** to transform raw ride-level data into meaningful business insights.

The analysis focuses on key business areas such as:

* Ride completion and cancellation performance
* Revenue and fare analysis
* Vehicle-type performance
* Customer behavior and segmentation
* Peak demand periods
* Driver supply shortages
* Pickup locations and popular routes
* Payment methods
* Ratings and service quality
* Monthly revenue trends

The overall workflow follows:

**Raw Data → SQL Analysis → Python EDA → Business Insights → Power BI Dashboard**

---

## 🎯 Business Objectives

The main objective is to understand how the ride-booking platform performs and identify opportunities for improving:

* Revenue generation
* Ride completion rate
* Customer retention
* Driver availability
* Operational efficiency
* Vehicle utilization
* Cancellation management
* Customer experience

The project was structured around **24 business questions**, allowing the analysis to move beyond basic descriptive statistics toward actionable business insights.

---

## 📊 Dataset

The dataset contains approximately **150,000 ride-booking records** and **104,000+ unique customers**.

### Main Variables

| Category     | Variables                                                |
| ------------ | -------------------------------------------------------- |
| Booking      | `booking_id`, `booking_status`, `ride_date`, `ride_time` |
| Customer     | `customer_id`                                            |
| Vehicle      | `vehicle_type`                                           |
| Location     | `pickup_location`, `drop_location`                       |
| Cancellation | Customer/driver cancellation flags and reasons           |
| Financial    | `booking_value`                                          |
| Distance     | `ride_distance`                                          |
| Ratings      | `driver_rating`, `customer_rating`                       |
| Payment      | `payment_method`                                         |

---

# 🛠️ Tools & Technologies

### SQL

* Oracle SQL
* Aggregations
* `CASE WHEN`
* CTEs
* Window Functions
* `LAG()`
* `RANK()`
* `RATIO_TO_REPORT()`
* Date and time functions
* Conditional aggregation

### Python

* Python
* Pandas
* Jupyter Notebook
* Data cleaning
* Exploratory Data Analysis
* Feature engineering
* Business-oriented analysis

### Visualization

* Power BI
* KPI analysis
* Trend analysis
* Business dashboarding

---

# 🗄️ SQL Analysis

The SQL analysis was designed around business questions rather than isolated SQL exercises.

### Key SQL Analysis Areas

#### 1. Dataset Overview

* Total number of records
* Unique booking IDs
* Unique customers
* Booking-status distribution

#### 2. Operational KPIs

Calculated:

* Completion rate
* Cancellation rate
* No-driver-found rate
* Incomplete ride rate

#### 3. Revenue Performance

Analyzed:

* Total revenue
* Average fare
* Average ride distance
* Revenue per kilometer

#### 4. Vehicle Performance

Compared vehicle types based on:

* Completed rides
* Revenue
* Average fare
* Revenue per kilometer
* Revenue share

#### 5. Payment Analysis

Analyzed each payment method by:

* Number of rides
* Ride share
* Revenue

#### 6. Monthly Revenue & MoM Growth

Created a monthly revenue analysis using:

* `TRUNC()`
* `LAG()`
* Month-over-month revenue change

This makes it possible to identify revenue growth and decline periods.

#### 7. Cancellation Analysis

Analyzed:

* Main customer cancellation reasons
* Main driver cancellation reasons
* Cancellation rates by vehicle type
* High-cancellation pickup locations

#### 8. Demand & Supply Analysis

Analyzed:

* Peak demand hours
* Revenue by hour
* Demand ranking
* Hours with the highest `No Driver Found` rate

This provides an indication of potential supply shortages during high-demand periods.

#### 9. Geographic & Route Analysis

Identified:

* Top pickup locations
* Most popular routes
* Pickup locations with high cancellation rates

#### 10. Customer Analytics

Analyzed:

* Top customers by total spending
* Completed rides per customer
* Average fare per customer
* Customer booking behavior
* Customer segmentation

Customers were segmented into:

* **1 ride**
* **2 rides**
* **3+ rides**

The analysis also compares each segment's customer share with its revenue contribution.

#### 11. Rating Analysis

Compared:

* Average driver ratings
* Average customer ratings
* High-rated driver percentage

across different vehicle types.

#### 12. Monthly Vehicle Ranking

Used window functions to determine which vehicle type generated the highest revenue in each month.

---

# 🐍 Python Data Analysis

Python was used to perform exploratory analysis and answer the same business questions from a data-analysis perspective.

### Data Preparation

The workflow included:

* Data loading
* Data quality inspection
* Missing-value analysis
* Duplicate analysis
* Date/time processing
* Feature engineering
* Creation of analytical variables

Additional analytical features included metrics such as:

* Fare per kilometer
* Hour
* Weekday
* Month
* High-fare indicators

---

# 🔎 Exploratory Data Analysis

The Python analysis explored several dimensions of the business.

### Booking Performance

The project evaluates the distribution of:

* Completed bookings
* Customer cancellations
* Driver cancellations
* No-driver-found bookings
* Incomplete rides

The notebook calculates an overall **completion rate of approximately 62%** and a **cancellation rate of approximately 25%**.

---

## 💰 Revenue Analysis

Completed rides generated approximately **$491.5K in booking value** in the analyzed dataset.

Revenue was examined by:

* Month
* Vehicle type
* Hour
* Weekday
* Pickup location
* Customer
* Payment method

The analysis also calculates revenue-per-kilometer and average fare metrics.

---

# ⏰ Demand & Supply Analysis

Hourly ride demand shows clear differences throughout the day.

The analysis identifies **18:00 as the highest-demand hour**, with approximately **12,397 rides**.

The project also examines the `No Driver Found` rate by hour to identify potential supply-demand mismatches.

This provides a useful operational perspective:

> High demand does not automatically mean high successful completion.

Supply availability must also be considered.

---

# 👥 Customer Analytics

Customer behavior was analyzed using completed rides and booking history.

The project identifies:

* Top customers by total spending
* Number of completed rides
* Average fare
* Customer booking frequency
* Cancellation behavior

A customer segmentation analysis divides customers into:

| Segment  | Customer Share | Revenue Share |
| -------- | -------------: | ------------: |
| 1 ride   |         73.68% |        51.30% |
| 2 rides  |          8.75% |        12.04% |
| 3+ rides |         17.57% |        36.65% |

This indicates that the smaller group of customers completing **3+ rides** contributes a disproportionately large share of revenue.

---

# 📍 Location & Route Analysis

The project identifies high-volume pickup locations and popular routes.

It also investigates pickup locations with elevated cancellation rates, using a minimum ride-volume threshold to avoid misleading results from locations with very few observations.

This can help identify locations where operational improvements may have the greatest impact.

---

# ⭐ Service Quality

Driver and customer ratings were analyzed by vehicle type.

The project compares:

* Average driver rating
* Average customer rating
* Percentage of rides with high driver ratings

This provides an additional perspective on service quality alongside operational and financial KPIs.

---

# 📈 Power BI Dashboard

<img width="1327" height="747" alt="image" src="https://github.com/user-attachments/assets/a1787ec1-8036-4d82-b555-4628d77a8958" />

The Power BI component transforms the analytical results into an interactive business-reporting environment.

The dashboard is designed to help users quickly understand:

* Overall ride performance
* Revenue performance
* Booking-status distribution
* Vehicle performance
* Customer behavior
* Demand patterns
* Cancellation trends
* Geographic performance

The purpose of the dashboard is not only visualization, but also **business decision support**.

---

# 💡 Key Business Insights

Based on the analysis, several important patterns emerge:

### 1. Completion Rate Needs Attention

With approximately **62% of bookings completed**, a significant share of demand does not result in a completed ride.

Improving the conversion of bookings into completed rides could create a meaningful revenue opportunity.

### 2. Cancellations Are a Major Operational Issue

Approximately **25% of bookings fall into cancellation categories**.

Understanding whether cancellations are primarily customer-driven or driver-driven is therefore important for operational strategy.

### 3. Peak Demand Creates Supply Pressure

Demand reaches its highest level during the evening, particularly around **18:00**.

Driver allocation and supply planning should therefore consider hourly demand patterns rather than relying only on daily averages.

### 4. Repeat Customers Are Highly Valuable

Customers with **3+ completed rides represent only 17.57% of customers but generate approximately 36.65% of revenue**.

This highlights the potential value of customer retention and repeat-ride strategies.

### 5. Geographic Performance Is Uneven

Some pickup locations generate substantially more rides than others, while certain locations also exhibit higher cancellation rates.

Location-level operational strategies could therefore improve overall platform performance.

---

# 📌 Business Recommendations

Based on the analysis, potential business actions include:

### 🚘 Improve Driver Supply During Peak Hours

Increase driver availability around high-demand periods, particularly evening peak hours.

### 📍 Optimize Driver Allocation by Location

Use historical demand and cancellation patterns to position drivers closer to high-demand and high-cancellation locations.

### 👥 Focus on Customer Retention

Since frequent customers contribute a relatively large share of revenue, retention strategies could focus on converting one-time users into repeat customers.

### ❌ Investigate Cancellation Drivers

Separate customer-driven and driver-driven cancellation problems and address their underlying causes independently.

### 📊 Monitor Vehicle-Level Performance

Compare vehicle categories using both revenue and operational KPIs rather than revenue alone.

### 📈 Use Monthly KPI Monitoring

Track revenue, rides, completion rate, cancellation rate, and supply shortage indicators over time to identify deteriorating performance early.

---

# 🧠 Skills Demonstrated

This project demonstrates practical experience with:

* SQL querying
* Oracle SQL
* Data aggregation
* Window functions
* CTEs
* KPI development
* Business analysis
* Data cleaning
* Exploratory Data Analysis
* Feature engineering
* Customer segmentation
* Revenue analysis
* Operational analysis
* Supply-demand analysis
* Data visualization
* Power BI reporting
* Business recommendations

---

# 📂 Project Structure

```text
Uber-Ride-Analytics/
│
├── data/
│   └── uber_rides.csv
│
├── sql/
│   └── uber_rides_analysis.sql
│
├── python/
│   └── uber_rides_analysis.ipynb
│
├── powerbi/
│   └── uber_rides_dashboard.pbix
│
├── README.md
└── screenshots/
    └── dashboard.png
```

---

# 🚀 Project Workflow

```text
                 RAW RIDE DATA
                       │
                       ▼
                DATA VALIDATION
                       │
             ┌─────────┴─────────┐
             ▼                   ▼
        ORACLE SQL             PYTHON
             │                   │
       Business Queries      Data Cleaning
       KPI Analysis          EDA
       Window Functions      Feature Engineering
             │                   │
             └─────────┬─────────┘
                       ▼
                BUSINESS INSIGHTS
                       │
                       ▼
                  POWER BI
                       │
                       ▼
              BUSINESS DECISIONS
```

---

# 📊 Project Outcome

This project demonstrates how raw ride-booking data can be transformed into a structured analytical solution using multiple data-analysis technologies.

Instead of focusing only on technical queries, the project connects:

**Data → Metrics → Patterns → Business Insights → Recommendations**

The final solution provides a multi-dimensional view of ride operations, revenue performance, customer behavior, demand, supply, and service quality.
