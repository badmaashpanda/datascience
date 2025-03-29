-- Day 1 Common Reactions
-- Find the most common reaction for day 1 by counting the number of occurrences for each reaction. Output the reaction alongside its number of occurrences.

select reaction, count(*),
rank() over (order by count(*) desc) as rnk
from facebook_reactions 
where date_day=1
group by 1