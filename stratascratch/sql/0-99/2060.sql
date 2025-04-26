-- Manager of the Largest Department
-- Given a list of a company's employees, find the name of the manager from the largest department. Manager is each employee that contains word "manager" under their position.  Output their first and last name.

with base as (select department_id,
rank() over (order by count(id) desc) as rnk
from az_employees
group by 1)

select a.department_id,a.first_name, a.last_name, position from 
az_employees a
join base b on a.department_id=b.department_id and b.rnk = 1
where position ilike '%manager%'
