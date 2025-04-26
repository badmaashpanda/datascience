-- Rank Variance Per Country
-- Which countries have risen in the rankings based on the number of comments between Dec 2019 vs Jan 2020? Hint: Avoid gaps between ranks when ranking countries.

with dec as (
select country,
sum(number_of_comments) as total_comments,
dense_rank() over (order by sum(number_of_comments) desc) as rnk_dec
from fb_comments_count a 
join fb_active_users b on a.user_id = b.user_id
where created_at between '2019-12-01' and '2019-12-31'
group by 1
)

,jan as (
select country,
sum(number_of_comments) as total_comments,
dense_rank() over (order by sum(number_of_comments) desc) as rnk_jan
from fb_comments_count a 
join fb_active_users b on a.user_id = b.user_id
where created_at between '2020-01-01' and '2020-01-31'
group by 1
)

select a.country,
a.rnk_dec,
b.rnk_jan
from dec a join jan b on a.country=b.country
where rnk_jan<rnk_dec