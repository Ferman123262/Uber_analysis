CREATE TABLE uber_rides (
  ride_date             DATE,
  ride_time             VARCHAR2(8),
  booking_id            VARCHAR2(20),
  booking_status        VARCHAR2(30),
  customer_id           VARCHAR2(20),
  vehicle_type          VARCHAR2(30),
  pickup_location       VARCHAR2(100),
  drop_location         VARCHAR2(100),
  cancelled_by_customer NUMBER(1),
  cust_cancel_reason    VARCHAR2(100),
  cancelled_by_driver   NUMBER(1),
  driver_cancel_reason  VARCHAR2(100),
  incomplete_ride       NUMBER(1),
  incomplete_reason     VARCHAR2(100),
  booking_value         NUMBER(10,2),
  ride_distance         NUMBER(8,2),
  driver_rating         NUMBER(3,1),
  customer_rating       NUMBER(3,1),
  payment_method        VARCHAR2(30)
);




select * from uber_rides;



-- Q1. How many rows, unique booking IDs and unique customers are in the dataset?


select 
    count(*) as cnt_rows,
    count(distinct booking_id) as unique_booking,
    count(distinct customer_id) as unique_customer
from uber_rıdes;



-- Q2. What is the distribution of bookings by status (count and %)?
select 
    booking_status,
    count(booking_id) as "number of bookings",
    round(100 * ratio_to_report(count(*)) over(),2) ||'%' as pct
from uber_rides 
group by booking_status
order by 1 desc;



-- Q3. What are the completion, cancellation, no-driver-found and incomplete rates?

SELECT ROUND(100 * AVG(CASE WHEN booking_status = 'Completed' THEN 1 ELSE 0 END), 2) AS completion_pct,
       ROUND(100 * AVG(CASE WHEN booking_status IN ('Cancelled by Customer','Cancelled by Driver') THEN 1 ELSE 0 END), 2) AS cancellation_pct,
       ROUND(100 * AVG(CASE WHEN booking_status = 'No Driver Found' THEN 1 ELSE 0 END), 2) AS no_driver_pct,
       ROUND(100 * AVG(CASE WHEN booking_status = 'Incomplete' THEN 1 ELSE 0 END), 2) AS incomplete_pct
FROM   uber_rides;



-- Q4. What are the overall KPIs: total revenue, average fare, average distance and revenue per km?

SELECT 
       SUM(booking_value) AS total_revenue,
       ROUND(AVG(booking_value), 2) AS avg_fare,
       ROUND(AVG(ride_distance), 2)  AS avg_distance_km,
       ROUND(SUM(booking_value) / SUM(ride_distance), 2) AS revenue_per_km
FROM uber_rides
WHERE  booking_status = 'Completed';



-- Q5. How do rides, revenue, average fare and revenue per km compare across vehicle types?
SELECT 
       vehicle_type,
       COUNT(*) AS completed_rides,
       SUM(booking_value) AS revenue,
       ROUND(AVG(booking_value), 1) AS avg_fare,
       ROUND(SUM(booking_value) / SUM(ride_distance), 2) AS revenue_per_km,
       ROUND(100 * RATIO_TO_REPORT(SUM(booking_value)) OVER (), 2) AS revenue_share_pct
FROM uber_rides
WHERE  booking_status = 'Completed'
GROUP  BY vehicle_type
ORDER  BY revenue DESC;


-- Q6. What is the share of each payment method (rides and revenue)?
SELECT 
       payment_method,
       COUNT(*) AS rides,
       ROUND(100 * RATIO_TO_REPORT(COUNT(*)) OVER (), 2) AS pct_of_rides,
       SUM(booking_value) AS revenue
FROM uber_rides
WHERE  booking_status = 'Completed'
GROUP  BY payment_method
ORDER  BY rides DESC;


-- Q7. What is the monthly revenue trend and the month-over-month (MoM) % change?


WITH monthly AS (
  SELECT TRUNC(ride_date, 'MM') AS month_start,
         COUNT(*) AS rides,
         SUM(booking_value) AS revenue
  FROM uber_rides
  WHERE  booking_status = 'Completed'
  GROUP  BY TRUNC(ride_date, 'MM')
)
SELECT TO_CHAR(month_start, 'YYYY-MM') AS month,
       rides,
       revenue,
       LAG(revenue) OVER (ORDER BY month_start) AS prev_month_revenue,
       ROUND(100 * (revenue - LAG(revenue) OVER (ORDER BY month_start))
                 / LAG(revenue) OVER (ORDER BY month_start), 2) AS mom_pct
FROM   monthly
ORDER  BY month_start;


-- Q8. What are the top reasons customers cancel rides?
SELECT cust_cancel_reason,
       COUNT(*) AS cancellations,
       ROUND(100 * RATIO_TO_REPORT(COUNT(*)) OVER (), 2) AS pct
FROM   uber_rides
WHERE  cancelled_by_customer = 1
GROUP  BY cust_cancel_reason
ORDER  BY cancellations DESC;



-- Q9. What are the top reasons drivers cancel rides?
SELECT driver_cancel_reason,
       COUNT(*) AS cancellations,
       ROUND(100 * RATIO_TO_REPORT(COUNT(*)) OVER (), 2) AS pct
FROM   uber_rides
WHERE  cancelled_by_driver = 1
GROUP  BY driver_cancel_reason
ORDER  BY cancellations DESC;



-- Q10. What are the cancellation, no-driver and incomplete rates by vehicle type?
SELECT 
       vehicle_type,
       COUNT(*) AS total_rides,
       ROUND(100 * AVG(CASE WHEN booking_status = 'Cancelled by Customer' THEN 1 ELSE 0 END), 2) AS cust_cancel_pct,
       ROUND(100 * AVG(CASE WHEN booking_status = 'Cancelled by Driver'  THEN 1 ELSE 0 END), 2) AS driver_cancel_pct,
       ROUND(100 * AVG(CASE WHEN booking_status = 'No Driver Found' THEN 1 ELSE 0 END), 2) AS no_driver_pct,
       ROUND(100 * AVG(CASE WHEN booking_status = 'Incomplete' THEN 1 ELSE 0 END), 2) AS incomplete_pct
FROM uber_rides
GROUP  BY vehicle_type
ORDER  BY total_rides DESC;



-- Q11. What are the peak demand hours (rides, revenue and rank by hour)?
SELECT hr, rides, revenue,
       RANK() OVER (ORDER BY rides DESC) AS demand_rank
FROM (
  SELECT TO_NUMBER(SUBSTR(ride_time, 1, 2)) AS hr,
         COUNT(*) AS rides,
         SUM(CASE WHEN booking_status = 'Completed' THEN booking_value END) AS revenue
  FROM   uber_rides
  GROUP  BY TO_NUMBER(SUBSTR(ride_time, 1, 2))
)
ORDER  BY hr;



-- Q12. How do rides and revenue vary by day of the week?
SELECT (ride_date - TRUNC(ride_date, 'IW')) + 1 AS day_no,
       TO_CHAR(ride_date, 'Dy', 'NLS_DATE_LANGUAGE=ENGLISH') AS day_name,
       COUNT(*) AS rides,
       SUM(CASE WHEN booking_status = 'Completed' THEN booking_value END) AS revenue
FROM uber_rides
GROUP  BY (ride_date - TRUNC(ride_date, 'IW')) + 1,
          TO_CHAR(ride_date, 'Dy', 'NLS_DATE_LANGUAGE=ENGLISH')
ORDER  BY day_no;



-- Q13. Which hours have the highest "No Driver Found" rate (supply shortage)?
SELECT TO_NUMBER(SUBSTR(ride_time, 1, 2)) AS hr,
       COUNT(*) AS rides,
       SUM(CASE WHEN booking_status = 'No Driver Found' THEN 1 ELSE 0 END) AS no_driver,
       ROUND(100 * AVG(CASE WHEN booking_status = 'No Driver Found' THEN 1 ELSE 0 END), 2) AS no_driver_pct
FROM uber_rides
GROUP  BY TO_NUMBER(SUBSTR(ride_time, 1, 2))
ORDER  BY no_driver_pct DESC
FETCH FIRST 5 ROWS ONLY;



-- Q14. What are the top 10 pickup locations by rides and revenue?
SELECT pickup_location,
       COUNT(*) AS rides,
       SUM(CASE WHEN booking_status = 'Completed' THEN booking_value END) AS revenue
FROM uber_rides
GROUP  BY pickup_location
ORDER  BY rides DESC
FETCH FIRST 10 ROWS ONLY;


-- Q15. What are the top 10 most popular routes (pickup to drop)?
SELECT pickup_location || ' -> ' || drop_location AS route,
       COUNT(*) AS rides
FROM   uber_rides
GROUP  BY pickup_location, drop_location
ORDER  BY rides DESC
FETCH FIRST 10 ROWS ONLY;


-- Q16. Which pickup locations have the highest cancellation rate (min. 100 rides)?
SELECT pickup_location,
       COUNT(*) AS rides,
       ROUND(100 * AVG(CASE WHEN booking_status IN ('Cancelled by Customer','Cancelled by Driver') THEN 1 ELSE 0 END), 2) AS cancel_pct
FROM uber_rides
GROUP  BY pickup_location
HAVING COUNT(*) >= 100
ORDER  BY cancel_pct DESC
FETCH FIRST 10 ROWS ONLY;



-- Q17. Who are the top 10 customers by total spending?
SELECT customer_id,
       COUNT(*) AS completed_rides,
       SUM(booking_value) AS total_spent,
       ROUND(AVG(booking_value), 1) AS avg_fare
FROM uber_rides
WHERE  booking_status = 'Completed'
GROUP  BY customer_id
ORDER  BY total_spent DESC
FETCH FIRST 10 ROWS ONLY;




-- Q18. How are customers segmented by number of completed rides (1, 2, 3+), and what is each segment's revenue share?
WITH cust AS (
  SELECT customer_id, COUNT(*) AS rides, SUM(booking_value) AS spent
  FROM uber_rides
  WHERE booking_status = 'Completed'
  GROUP BY customer_id
)
SELECT CASE WHEN rides = 1 THEN '1 ride'
            WHEN rides = 2 THEN '2 rides'
            ELSE '3+ rides' END AS segment,
       COUNT(*) AS customers,
       ROUND(100 * RATIO_TO_REPORT(COUNT(*)) OVER (), 2) AS pct_customers,
       SUM(spent) AS revenue,
       ROUND(100 * RATIO_TO_REPORT(SUM(spent)) OVER (), 2) AS pct_revenue
FROM cust
GROUP BY CASE WHEN rides = 1 THEN '1 ride'
               WHEN rides = 2 THEN '2 rides'
               ELSE '3+ rides' END
ORDER  BY segment;


-- Q19. What are the average driver and customer ratings by vehicle type?
SELECT vehicle_type,
       COUNT(*) AS rated_rides,
       ROUND(AVG(driver_rating), 2) AS avg_driver_rating,
       ROUND(AVG(customer_rating), 2) AS avg_customer_rating,
       ROUND(100 * AVG(CASE WHEN driver_rating >= 45 THEN 1 ELSE 0 END), 2) AS driver_4_5_plus_pct
FROM uber_rides
WHERE booking_status = 'Completed'
GROUP BY vehicle_type
ORDER BY avg_driver_rating DESC;


-- Q20. Which vehicle type ranks first in revenue each month?
WITH m AS (
  SELECT TRUNC(ride_date, 'MM') AS month_start,
         vehicle_type,
         SUM(booking_value) AS revenue
  FROM uber_rides
  WHERE booking_status = 'Completed'
  GROUP BY TRUNC(ride_date, 'MM'), vehicle_type
),
r AS (
  SELECT m.*,
         RANK() OVER (PARTITION BY month_start ORDER BY revenue DESC) AS rnk
  FROM   m
)
SELECT TO_CHAR(month_start, 'YYYY-MM') AS month, vehicle_type, revenue
FROM r
WHERE rnk = 1
ORDER BY month_start;


    
    
-- Q21. How many bookings, completed rides and cancellations (by customer / by driver) does each customer have?
SELECT customer_id,
       COUNT(*) AS total_bookings,
       SUM(CASE WHEN booking_status = 'Completed' THEN 1 ELSE 0 END) AS completed,
       SUM(CASE WHEN booking_status = 'Cancelled by Customer' THEN 1 ELSE 0 END) AS cancelled_by_customer,
       SUM(CASE WHEN booking_status = 'Cancelled by Driver' THEN 1 ELSE 0 END) AS cancelled_by_driver
FROM uber_rides
GROUP BY customer_id
ORDER BY total_bookings DESC
FETCH FIRST 20 ROWS ONLY;
