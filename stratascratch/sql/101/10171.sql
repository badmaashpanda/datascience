-- Find the genre of the person with the most number of oscar winnings

-- Find the genre of the person with the most number of oscar winnings.
-- If there are more than one person with the same number of oscar wins, return the first one in alphabetic order based on their name. Use the names as keys when joining the tables.

with base as (select b.top_genre, count(*)
from oscar_nominees a
inner join nominee_information b on a.nominee=b.name
where a.winner = 'TRUE'
group by 1
order by 2 desc)

select top_genre from base limit 1