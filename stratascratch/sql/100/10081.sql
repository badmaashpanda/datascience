-- Find the number of employees who received the bonus and who didn't

-- Find the number of employees who received the bonus and who didn't. Bonus values in employee table are corrupted so you should use  values from the bonus table. Be aware of the fact that employee can receive more than bonus.
-- Output value inside has_bonus column (1 if they had bonus, 0 if not) along with the corresponding number of employees for each.

with base as (select distinct a.id,
case when bonus_amount>0 then 1 else 0 end as has_bonus
from employee a 
left join bonus b on a.id=b.worker_ref_id)

select has_bonus, count(id) as n_employees
from base
group by 1 

-- Use of left join