-- Finding User Purchases

-- Write a query that'll identify returning active users. A returning active user is a user that has made a second purchase within 7 days of any other of their purchases. Output a list of user_ids of these returning active users.


-- --Method 1 using lead
-- with base as (select user_id,
-- created_at,
-- lead(created_at,1) over (partition by user_id order by created_at),
-- lead(created_at,1) over (partition by user_id order by created_at) - created_at as diff
-- from amazon_transactions)

-- select distinct user_id from base where diff<=7 order by user_id

-- --Method 2 using self-join
select distinct a.user_id
from 
amazon_transactions a
inner join amazon_transactions b on a.user_id=b.user_id and a.id!=b.id
where (b.created_at - a.created_at) <= 7 and (b.created_at - a.created_at) >= 0
order by a.user_id