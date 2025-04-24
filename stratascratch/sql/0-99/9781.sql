-- Processed Ticket Rate By Type
-- Find the processed rate of tickets for each type. The processed rate is defined as the number of processed tickets divided by the total number of tickets for that type. Round this result to two decimal places.

select type,
sum(case when processed = 'TRUE' then 1 else 0 end) as processed,
count(*) as all
from facebook_complaints
group by 1