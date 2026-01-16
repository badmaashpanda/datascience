-- loss rate 28 day rolling

with cte as (
  select 
  date_trunc('day', transfer_created_ts) as created_date,
  payment_method_type,
  sum(transfer_loss_usd) as daily_loss,
  sum(transfer_volume_usd) as daily_volume
FROM fact.transfers
GROUP BY 1, 2
)

, spl as (
    select generate_series(min(date_trunc('day', transfer_created_ts)), max(date_trunc('day', transfer_created_ts)), interval '1 day') as dt from fact.transfers
)

,pm as (
    select distinct payment_method_type from fact.transfers
)

, final as (
    select 
    a.dt,
    b.payment_method_type,
    coalese(c.daily_loss,0) as daily_loss,
    coalease(c.daily_volume,0) as daily_volume
    from 
    spl a cross join pm b 
    left join cte c on a.dt = c.created_date and b.payment_method_type = c.payment_method_type
    ORDER BY created_date
)

select 
payment_method_type,
dt,
case when sum(daily_volume) over (partition by payment_method_type order by dt ROWS BETWEEN 27 PRECEDING AND CURRENT ROW) = 0 then null 
else 
(
    sum(daily_loss) over (partition by payment_method_type order by dt ROWS BETWEEN 27 PRECEDING AND CURRENT ROW) 
    /    
    sum(daily_volume) over (partition by payment_method_type order by dt ROWS BETWEEN 27 PRECEDING AND CURRENT ROW)
) end as rolling_28d_loss_rate
from final
order by dt, payment_method_type