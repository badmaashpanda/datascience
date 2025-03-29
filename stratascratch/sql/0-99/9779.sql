-- Daily Interactions By Users Count
-- Find the number of interactions along with the number of people involved with them on a given day. Be aware that user1 and user2 columns represent user ids. Output the date along with the number of interactions and people. Order results based on the date in ascending order and the number of people in descending order.

--expected output: date | no_interactions | no_people
--order by date, no_people DESC
--group by date
--union all two tables (1) initiated (2) received 
--count distinct users for no_people 
with t1 as
(select day, count(*) as num_interactions
from facebook_user_interactions
group by day),

t2 as (
select day, count(distinct user1) as num_users
from
(select day, user1  
from facebook_user_interactions f
union all 
select day, user2 
from facebook_user_interactions f1
) t4
group by day) 


select t1.day, t1.num_interactions, t2.num_users
from t1
join t2 on t1.day = t2.day
order by num_interactions, num_users DESC