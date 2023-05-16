-- New Products
-- You are given a table of product launches by company by year. Write a query to count the net difference between the number of products companies launched in 2020 with the number of products companies launched in the previous year. Output the name of the companies and a net difference of net products released for 2020 compared to the previous year.

with base as (select year, company_name, count(*)
from car_launches
group by 1,2
order by 2,1)

select a.company_name,
a.count-b.count
from base a
inner join base b on a.company_name=b.company_name and 
a.year!=b.year
and a.year='2020'

-- solution 2
select company_name,
count(case when year=2020 then 1 else null end) - count(case when year=2019 then 1 else null end)
from car_launches
group by 1