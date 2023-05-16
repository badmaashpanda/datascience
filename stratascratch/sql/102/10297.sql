-- Comments Distribution
-- Write a query to calculate the distribution of comments by the count of users that joined Meta/Facebook between 2018 and 2020, for the month of January 2020.

-- The output should contain a count of comments and the corresponding number of users that made that number of comments in Jan-2020. For example, you'll be counting how many users made 1 comment, 2 comments, 3 comments, 4 comments, etc in Jan-2020. Your left column in the output will be the number of comments while your right column in the output will be the number of users. Sort the output from the least number of comments to highest.

-- To add some complexity, there might be a bug where an user post is dated before the user join date. You'll want to remove these posts from the result.

with base as (select a.id, a.joined_at, b.created_at from fb_users a
left join fb_comments b on a.id=b.user_id
where joined_at between '2018-01-01' and '2020-12-31' 
and to_char(created_at,'YYYY-MM') = '2020-01'
and b.created_at>=a.joined_at
order by a.id)

, com as (
select id, count(*) as num_comments
from base group by 1)

select num_comments, count(*) from com
group by 1
order by 1