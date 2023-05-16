-- Highest Total Miles
-- You’re given a table of Uber rides that contains the mileage and the purpose for the business expense.  You’re asked to find business purposes that generate the most miles driven for passengers that use Uber for their business transportation. Find the top 3 business purpose categories by total mileage.

select purpose, sum(miles) as miles_sum
from my_uber_drives
where category = 'Business'
group by 1
order by 2 desc
limit 3

