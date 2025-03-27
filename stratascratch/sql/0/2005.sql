-- Output share of US users that are active. Active users are the ones with an "open" status in the table fb_active_users.

select 
count(user_id) filter (where status='open' and country = 'USA') as active,
count(user_id) as tot
from fb_active_users
