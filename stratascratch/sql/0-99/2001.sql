--Share of Loan Balance

with cte as (
select rate_type,
sum(balance) as total_bal
from submissions
group by 1
)

select a.loan_id,
a.rate_type,
a.balance,
100*a.balance/b.total_bal::float as balance_share
from submissions a
left join cte b on a.rate_type=b.rate_type


-- using Window function
select a.loan_id,
a.rate_type,
a.balance
sum(balance) over (partition by rate_type) as total_bal
from submissions a
