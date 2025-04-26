--Daily Active Users
--Find the average daily active users for January 2021 for each account. Your output should have account_id and the average daily count for that account.

select 
account_id,
count(user_id)/31.0
from sf_events
where record_date between '2021-01-01' and  '2021-01-31' 
group by 1
