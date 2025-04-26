--Recent Refinance Submissions

--Write a query to return the total loan balance for each user based on their most recent "Refinance" submission. The submissions table joins to the loans table using loan_id from submissions and id from loans.

with cte as (select user_id, id,
row_number() over (partition by user_id order by created_at desc) as rnk
from loans 
where type = 'Refinance')

select a.user_id,
b.balance from 
cte a 
join submissions b on a.id = b.loan_id and rnk=1
 