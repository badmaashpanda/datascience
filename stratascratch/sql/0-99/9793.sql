-- Facebook wants to understand the average time users take to perform certain activities in a feature. User activity is captured in the column step_reached.


-- Calculate the average time it takes for users to progress through the steps of each feature. Your approach should first calculate the average time it takes for each user to progress through their steps within the feature. Then, calculate the feature's average progression time by taking the average of these user-level averages. Ignore features where no user has more than one step.


-- Output the feature ID and the average progression time in seconds.


with base as (select feature_id, user_id,timestamp,
lag(timestamp,1) over (partition by feature_id,user_id order by step_reached) as prev_time
from facebook_product_features_realizations)

, base1 as (
select *, datediff('seconds',prev_time,timestamp) as duration
from base)

--select * from base1
select feature_id, user_id, avg(duration) from base1 where duration is not null group by 1,2