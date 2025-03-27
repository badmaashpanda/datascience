-- You have a dataset that records daily active users for each premium account. A premium account appears in the data every day as long as it remains premium. However, some premium accounts may be temporarily discounted, meaning they are not actively paying—this is indicated by a final_price of 0.


-- For each of the first 7 available dates, count the number of premium accounts that were actively paying on that day. Then, track how many of those same accounts remain premium and are still paying exactly 7 days later.


-- Output three columns:
-- •   The date of initial calculation


-- •   The number of premium accounts that were actively paying on that day


-- •   The number of those accounts that remain premium and are still paying after 7 days


with cte as (
select a.account_id, a.entry_date, a.final_price, 
b.account_id as p_account_id,
b.entry_date as p_entry_date,
b.final_price as p_final_price
from premium_accounts_by_day a
left join premium_accounts_by_day b on a.account_id=b.account_id and b.entry_date-a.entry_date=7 
and b.final_price>0)

select entry_date , count(distinct account_id) as premium_paid_accounts,
count(distinct p_account_id) as premium_paid_accounts_after_7d
from cte
where final_price>0
group by 1
order by 1
limit 7