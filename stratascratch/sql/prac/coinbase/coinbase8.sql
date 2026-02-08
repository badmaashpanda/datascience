-- Problem

-- For each payment_method_type and each week, find the single day in that week with the highest total loss, and also compute what share of that week’s loss occurred on that top-loss day.

-- Table

-- fact.transfers

-- Relevant columns:

-- transfer_created_ts

-- payment_method_type

-- transfer_loss_usd

-- Output (one row per payment_method_type per week)

-- week_start (use DATE_TRUNC('week', transfer_created_ts)::date)

-- payment_method_type

-- top_loss_day (date)

-- top_day_loss_usd

-- weekly_loss_usd

-- top_day_share_of_week_loss = top_day_loss_usd / weekly_loss_usd

-- Notes / Constraints

-- Loss is SUM(transfer_loss_usd) (including zeros is fine; they don’t change sums).

-- If there’s a tie for top day, break ties by choosing the earliest date.

-- Use Postgres/Redshift-style SQL.

with cte as (
select 
payment_method_type,
transfer_created_ts,
transfer_loss_usd,
date_trunc('week',transfer_created_ts)::date as week_start,
transfer_created_ts::date as transfer_created_dt
from fact.transfers
)

, agg as (
select 
payment_method_type,
week_start,
transfer_created_dt,
sum(transfer_loss_usd) over (partition by payment_method_type, week_start, transfer_created_dt) as daily_sum,
sum(transfer_loss_usd) over (partition by payment_method_type, week_start) as weekly_sum
as daily_transfer_loss_usd
from cte
)

, top1 as (
select payment_method_type,
week_start,
transfer_created_dt,
daily_sum,
weekly_sum,
row_number() over (partition by payment_method_type, week_start order by daily_sum desc) as rn
from agg
)

select 
payment_method_type,
week_start,
transfer_created_dt as top_loss_day,
daily_sum as top_day_loss_usd,
weekly_sum,
daily_sum/weekly_sum as top_day_share_of_week_loss
from top1
