-- First Day Retention Rate
-- Calculate the first-day retention rate of a group of video game players. The first-day retention occurs when a player logs in 1 day after their first-ever log-in.
-- Return the proportion of players who meet this definition divided by the total number of players.

with first_login as (select player_id,
min(login_date) as first_login
from players_logins
group by 1 
order by 1)

,base as (
select a.*,
b.first_login,
datediff('day', b.first_login,login_date) as repeat_login
from players_logins a
left join 
first_login b on a.player_id=b.player_id)

select
count(distinct player_id) filter (where repeat_login = 1) / count(distinct player_id)::float 
as retention_rate
from base
