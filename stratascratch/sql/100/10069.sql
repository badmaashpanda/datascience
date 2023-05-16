-- Correlation Between E-mails And Activity Time

-- There are two tables with user activities. The google_gmail_emails table contains information about emails being sent to users. Each row in that table represents a message with a unique identifier in the id field. The google_fit_location table contains user activity logs from the Google Fit app.
-- Find the correlation between the number of emails received and the total exercise per day. The total exercise per day is calculated by counting the number of user sessions per day.


with one as (select to_user, day,
count(*) as emails from google_gmail_emails group by 1,2 order by 1)

,two as (
select user_id,day,
count(session_id) as sessions from google_fit_location group by 1,2 order by 1)

,M3 as (
select a.to_user, a.day, a.emails, b.sessions
from one a inner join two b on a.to_user=b.user_id and a.day=b.day
order by a.to_user, a.day)

,M4 as (
Select 
        *
       , sessions   -   (Select AVG(sessions)   From M3)        as X
       , emails     -   (Select AVG(emails)     From M3)        as Y
      , (sessions   -   (Select AVG(sessions)   From M3) )^2    as x_2
      , (emails     -   (Select AVG(emails)     From M3) )^2    as y_2
From M3
)
Select 
    Sum(x*y)/((Sum(x_2)*Sum(y_2))^0.5)
From M4