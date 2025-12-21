-- We want to understand fraud performance by signup cohort.

-- Define:

-- Signup cohort = the month the user signed up
-- signup_month = DATE_TRUNC('month', user_created_ts)

-- Cohort measurement window = transfers in the user’s first 60 days after signup:

-- 0 <= DATEDIFF('day', user_created_ts, transfer_created_ts) <= 60

-- For each pair of:

-- signup_month

-- payment_method_type

-- compute, over the first 60 days of user lifetime:

-- total_volume_usd

-- total_loss_usd

-- loss_rate = total_loss_usd / total_volume_usd

-- num_users_with_transfers in that cohort and payment method (only users who had at least one transfer in first 60 days)

-- We are only interested in transfers within that 60-day window.

-- Output Columns

-- Your final query should return:

-- signup_month

-- payment_method_type

-- num_users_with_transfers

-- total_volume_usd

-- total_loss_usd

-- loss_rate

-- Order by:

-- signup_month

-- payment_method_type

-- Assume Redshift/Postgres-like SQL and DATEDIFF('day', user_created_ts, transfer_created_ts) is available.



with cte as (
  select 
  a.payment_method_type,
  a.transfer_loss_usd,
  a.transfer_volume_usd,
  a.user_id,
  date_trunc('month', b.user_created_ts)  as signup_month,
  datediff('day', b.user_created_ts, a.transfer_created_ts) as transfer_tenure
FROM fact.transfers a 
 join dim.users b on a.user_id=b.user_id
 where datediff('day', b.user_created_ts, a.transfer_created_ts) between 0 and 60
 )

 , agg as (
 select 
 signup_month,
 payment_method_type,
 count (distinct user_id) as num_users_with_transfers,
 sum(transfer_volume_usd) as total_volume_usd,
 sum(transfer_loss_usd) as total_loss_usd
 from cte
 group by 1,2
 )

select 
signup_month,
payment_method_type,
num_users_with_transfers,
total_volume_usd,
total_loss_usd,
case when total_volume_usd = 0 then null else total_loss_usd/total_volume_usd end as loss_rate
from agg
order by 1,2