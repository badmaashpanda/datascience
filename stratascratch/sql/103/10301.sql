-- Expensive Projects
-- Given a list of projects and employees mapped to each project, calculate by the amount of project budget allocated to each employee . The output should include the project title and the calculated per employee project budget rounded to the closest integer. Order your list by projects with the highest budget per employee first.

-- with base as (select project_id,
-- count(distinct emp_id) as num_emp
-- from ms_emp_projects 
-- group by 1)

-- select title,
-- round(budget/num_emp,0)
-- from ms_projects a
-- inner join base b on a.id=b.project_id
-- order by 2 desc

select proj.title, budget,
      round(proj.budget/count(distinct emp_id)::decimal, 0) as budget_per_emp
from ms_projects proj
join ms_emp_projects emp
on proj.id = emp.project_id
group by proj.title, proj.budget
order by budget_per_emp desc