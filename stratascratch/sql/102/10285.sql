-- Acceptance Rate By Date
-- What is the overall friend acceptance rate by date? Your output should have the rate of acceptances by the date the request was sent. Order by the earliest date to latest.

-- Assume that each friend request starts by a user sending (i.e., user_id_sender) a friend request to another user (i.e., user_id_receiver) that's logged in the table with action = 'sent'. If the request is accepted, the table logs action = 'accepted'. If the request is not accepted, no record of action = 'accepted' is logged.

with base as (select a.user_id_sender, a.date, a.action as sent, b.action as accepted
from fb_friend_requests a
left join fb_friend_requests b on a.user_id_sender=b.user_id_sender and b.action='accepted'
where a.action = 'sent')

select date, count(accepted)/count(sent)::float as percentage_acceptance
from base 
group by 1
order by 1