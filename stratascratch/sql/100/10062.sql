-- Fans vs Opposition
-- Meta/Facebook is quite keen on pushing their new programming language Hack to all their offices. They ran a survey to quantify the popularity of the language and send it to their employees. To promote Hack they have decided to pair developers which love Hack with the ones who hate it so the fans can convert the opposition. Their pair criteria is to match the biggest fan with biggest opposition, second biggest fan with second biggest opposition, and so on. Write a query which returns this pairing. Output employee ids of paired employees. Sort users with the same popularity value by id in ascending order.

-- Duplicates in pairings can be left in the solution. For example, (2, 3) and (3, 2) should both be in the solution.

with base as (select employee_id, 
row_number() over (order by popularity, employee_id) from facebook_hack_survey
)

, base1 as (select employee_id, 
row_number() over (order by popularity desc, employee_id) from facebook_hack_survey
)

select a.employee_id as employee_fan,
b.employee_id as employee_opp
from base a inner join base1 b on a.row_number=b.row_number