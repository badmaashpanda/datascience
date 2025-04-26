-- Consecutive Days
-- Find all the users who were active for 3 consecutive days or more.
with base as (select user_id, date ,
date - lag(date,1) over (partition by user_id order by date) as prev_date,
date - lag(date,2) over (partition by user_id order by date) as prev_2_date
from sf_events
order by 1,2)

select user_id from base where prev_date=1 and prev_2_date=2

-- method 2

with base as (select 
user_id,
record_date,
lag(record_date,2) over (partition by user_id order by user_id,record_date) as two
from sf_events
order by 1,2)

select 
user_id
from base where record_date-two = 2