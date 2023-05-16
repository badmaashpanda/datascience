-- Workers With The Highest Salaries
-- Find the titles of workers that earn the highest salary. Output the highest-paid title or multiple titles that share the highest salary.

-- Solution 1
with base as (select a.worker_id,
a.salary,
b.worker_title,
rank() over (order by a.salary desc) as rnk
from worker a
left join title b on a.worker_id=b.worker_ref_id)

select worker_title from base 
where rnk=1