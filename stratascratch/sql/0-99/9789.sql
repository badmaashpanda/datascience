-- Find the total number of approved friendship requests in January and February

select * from facebook_friendship_requests
where 
to_char(date_approved, 'YYYY-MM') in ('2019-01','2019-02')