-- Find the top-ranked songs for the past 20 years.
-- Find all the songs that were top-ranked (at first position) at least once in the past 20 years

select distinct song_name
from billboard_top_100_year_end
where year >= date_part('year',current_date)-20
and year_rank = 1