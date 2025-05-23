
-- Monthly Churn Rate

-- Calculate the churn rate of September 2021 in percentages. The churn rate is the difference between the number of customers on the first day of the month and on the last day of the month, divided by the number of customers on the first day of a month.
-- Assume that if customer's contract_end is NULL, their contract is still active. Additionally, if a customer started or finished their contract on a certain day, they should still be counted as a customer on that day.

with base as (
select 
case when contract_start <= '2021-09-01' then 1 else 0 end as first,
case when contract_end >= '2021-09-30' or contract_end is null then 1 else 0 end as last
from natera_subscriptions)

select 
100*(sum(first) - sum(last)) / sum(first)::float
from base