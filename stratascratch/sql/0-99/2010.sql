-- Top Streamers
-- List the top 3 users who accumulated the most sessions. Include only the user who had more streaming sessions than viewing. Return the user_id, number of streaming sessions, and number of viewing sessions.


with base as (select user_id,
sum(case when session_type='streamer' then 1 else 0 end) as stream,
sum(case when session_type='viewer' then 1 else 0 end) as view
from twitch_sessions
group by 1)

select user_id,
stream, 
view
from base where stream>view
order by 2 desc
limit 3