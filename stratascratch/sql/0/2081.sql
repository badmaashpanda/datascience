-- You are given the list of Facebook friends and the list of Facebook pages that users follow. Your task is to create a new recommendation system for Facebook. For each Facebook user, find pages that this user doesn't follow but at least one of their friends does. Output the user ID and the ID of the page that should be recommended to this user.


SELECT DISTINCT f.user_id,
                p.page_id
FROM users_friends f
JOIN users_pages p ON f.friend_id = p.user_id
WHERE NOT EXISTS
    (SELECT *
     FROM users_pages pg
     WHERE pg.user_id = f.user_id
       AND pg.page_id = p.page_id)