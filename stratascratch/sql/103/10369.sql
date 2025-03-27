with base as (select *, 
case when datediff('day',last_active_date,CAST('2024-01-31' AS DATE)) <= 30 
and sessions >= 5 and listening_hours >= 10 then 1 else 0 end as last_active
from penetration_analysis)

select country, round(1.0*sum(last_active)/count(user_id),2) as aupr
from base
group by 1 

