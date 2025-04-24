-- You are given the list of Facebook friends and the list of Facebook pages that users follow. Your task is to create a new recommendation system for Facebook. For each Facebook user, find pages that this user doesn't follow but at least one of their friends does. Output the user ID and the ID of the page that should be recommended to this user.

select distinct a.user_id , 
page_id
from 
users_friends a
join users_pages b on a.friend_id=b.user_id 
where (a.user_id, b.page_id)
not in (SELECT user_id, page_id FROM users_pages)
order by 1,2