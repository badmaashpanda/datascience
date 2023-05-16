-- Popularity Percentage
-- Find the popularity percentage for each user on Meta/Facebook. The popularity percentage is defined as the total number of friends the user has divided by the total number of users on the platform, then converted into a percentage by multiplying by 100.
-- Output each user along with their popularity percentage. Order records in ascending order by user id.
-- The 'user1' and 'user2' column are pairs of friends.

With all_users as 
(
    select user1, user2
    from facebook_friends
    union 
    select user2, user1
    from facebook_friends
)
select user1 as user_id, (count(distinct user2) / count(user1) over ()::float) * 100 as total_users
from all_users
group by 1