-- Risky Projects
-- Identify projects that are at risk for going overbudget. A project is considered to be overbudget if the cost of all employees assigned to the project is greater than the budget of the project.

-- You'll need to prorate the cost of the employees to the duration of the project. For example, if the budget for a project that takes half a year to complete is $10K, then the total half-year salary of all employees assigned to the project should not exceed $10K. Salary is defined on a yearly basis, so be careful how to calculate salaries for the projects that last less or more than one year.

-- Output a list of projects that are overbudget with their project name, project budget, and prorated total employee expense (rounded to the next dollar amount).

with base as (select id, title,
budget,
(end_date-start_date)/365::float as duration
from linkedin_projects)

, annual as (
select a.project_id, sum(b.salary) as total_annual_cost
from linkedin_emp_projects a
inner join linkedin_employees b 
on a.emp_id=b.id
group by 1)

select a.title, a.budget, ceiling(b.total_annual_cost*a.duration) as prorated_employee_expense
from base a 
inner join annual b on a.id=b.project_id
where round(b.total_annual_cost*a.duration) > a.budget
order by title