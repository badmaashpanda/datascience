-- Users By Average Session Time

-- Calculate each user's average session time. A session is defined as the time difference between a page_load and page_exit. For simplicity, assume a user has only 1 session per day and if there are multiple of the same events on that day, consider only the latest page_load and earliest page_exit. Output the user_id and their average session time.

-- ssah
with load as (select user_id, timestamp::date as day,
      max(timestamp)
from facebook_web_log
where action = 'page_load'
group by 1,2)

, exit as (select user_id, timestamp::date as day,
      min(timestamp)
from facebook_web_log
where action = 'page_exit'
group by 1,2)

select a.user_id, avg( b.min - a.max)
from load a inner join exit b on a.user_id=b.user_id and a.day=b.day
group by 1




