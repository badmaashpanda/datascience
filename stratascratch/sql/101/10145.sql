-- Make a pivot table to find the highest payment in each year for each employee

-- Make a pivot table to find the highest payment in each year for each employee.
-- Find payment details for 2011, 2012, 2013, and 2014.
-- Output payment details along with the corresponding employee name.
-- Order records by the employee name in ascending order

with base as (
select employeename,
case when year=2011 then totalpay else 0 end as pay_2011,
case when year=2012 then totalpay else 0 end as pay_2012,
case when year=2013 then totalpay else 0 end as pay_2013,
case when year=2014 then totalpay else 0 end as pay_2014
from sf_public_salaries
order by employeename)

select employeename,
max(pay_2011) as pay_2011,
max(pay_2012) as pay_2012,
max(pay_2013) as pay_2013,
max(pay_2014) as pay_2014
from base
group by 1
order by 1
