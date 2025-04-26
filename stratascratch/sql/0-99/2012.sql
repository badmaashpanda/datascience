-- Viewers Turned Streamers
-- Return the number of streamer sessions for each user whose very first session was as a viewer.
-- Include only those users whose earliest session (by session_start) was of type 'viewer'. Return the user ID and the number of streamer sessions they had, ordered by number of sessions descending, then user ID ascending.

with base as (select *,
rank() over (partition by user_id order by session_start) as rnk
from twitch_sessions
order by user_id, session_start)

, users as (
select user_id from base where rnk=1 and session_type='viewer')

select a.user_id,
count(a.session_id) from
twitch_sessions a 
join users b on a.user_id=b.user_id and a.session_type = 'streamer'
group by 1
order by 2 desc

