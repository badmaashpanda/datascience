-- We want to compare fraud performance early in a user’s lifetime vs later.

-- For each payment_method_type, compute:

-- First_30d window: transfers where
-- transfer_created_ts is within 0–30 days (inclusive) of user_created_ts.

-- After_30d window: transfers where
-- transfer_created_ts is > 30 days after user_created_ts.

-- For each payment_method_type and each window (first_30d, after_30d), compute:

-- total_volume_usd

-- total_loss_usd

-- loss_rate = total_loss_usd / total_volume_usd

-- Return columns:

-- payment_method_type

-- lifetime_bucket (values: 'first_30d' or 'after_30d')

-- total_volume_usd

-- total_loss_usd

-- loss_rate

-- You can ignore users with no transfers.

-- Assume Redshift/Postgres-style SQL; use DATEDIFF('day', user_created_ts, transfer_created_ts) to compute age in days.

-- Order results by:

-- payment_method_type

-- lifetime_bucket (with first_30d before after_30d)





with cte as (
  select 
  date_trunc('day', a.transfer_created_ts) as created_date,
  a.payment_method_type,
  a.transfer_loss_usd,
  a.transfer_volume_usd,
  a.user_id,
  b.user_created_ts,
  datediff('day', b.user_created_ts,a.transfer_created_ts) as transfer_tenure,
  case when datediff('day', b.user_created_ts,a.transfer_created_ts) between 0 and 30 then '1. first_30d'
  when datediff('day', b.user_created_ts,a.transfer_created_ts) > 30 then '2. after_30d'
  else 'NA' end as lifetime_bucket
FROM fact.transfers a 
 join dim.users b on a.user_id=b.user_id
 )

, agg as (
select 
payment_method_type,
lifetime_bucket,
sum(transfer_volume_usd) as total_volume,
sum(transfer_loss_usd) as total_loss
from cte
group by 1,2
)

select payment_method_type,
lifetime_bucket,
case when total_volume = 0 then null else total_loss/total_volume end as loss_rate
from agg
order by 1,2
