-- Distance Per Dollar
-- You’re given a dataset of uber rides with the traveling distance (‘distance_to_travel’) and cost (‘monetary_cost’) for each ride. For each date, find the difference between the distance-per-dollar for that date and the average distance-per-dollar for that year-month. Distance-per-dollar is defined as the distance traveled divided by the cost of the ride.

-- The output should include the year-month (YYYY-MM) and the absolute average difference in distance-per-dollar (Absolute value to be rounded to the 2nd decimal).
-- You should also count both success and failed request_status as the distance and cost values are populated for all ride requests. Also, assume that all dates are unique in the dataset. Order your results by earliest request date first.

with base as (select
    to_char(request_date::Date,'YYYY-MM') As year_month,
    distance_to_travel/monetary_cost As individual_date,
    Avg(distance_to_travel/monetary_cost) Over(Partition By to_char(request_date::Date,'YYYY-MM')) As month_value
From uber_request_logs
order by request_date)

select distinct year_month,
round(abs(individual_date-month_value)::decimal,2)
from base
order by 1