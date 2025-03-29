-- Successfully Sent Messages
-- Find the ratio of successfully received messages to sent messages.

select count(receiver)/count(sender)::float
from facebook_messages_sent s
left join facebook_messages_received r on s.message_id=r.message_id
;