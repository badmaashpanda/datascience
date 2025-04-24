-- Day 1 Common Reactions
-- Find the most common reaction for day 1 by counting the number of occurrences for each reaction. Output the reaction alongside its number of occurrences.

with cte as (select reaction,
count(*) as n_occurences,
rank() over (order by count(*) desc) as rnk
from facebook_reactions
where date_day = 1
group by 1)

select reaction,n_occurences from cte where rnk = 1