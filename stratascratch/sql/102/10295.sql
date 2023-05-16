-- Most Active Users On Messenger
-- Meta/Facebook Messenger stores the number of messages between users in a table named 'fb_messages'. In this table 'user1' is the sender, 'user2' is the receiver, and 'msg_count' is the number of messages exchanged between them.
-- Find the top 10 most active users on Meta/Facebook Messenger by counting their total number of messages sent and received. Your solution should output usernames and the count of the total messages they sent or received

with one as (select user1 as us,
sum(msg_count) as messages
from fb_messages group by 1)
, two as (select user2 as us,
sum(msg_count) as messages
from fb_messages group by 1)

,three as (select us, messages from one
union 
select us, messages from two)

select us, sum(messages) as total_msg_count from 
three
group by 1
order by 2 desc
limit 10