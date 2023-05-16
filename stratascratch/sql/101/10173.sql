-- Days At Number One

-- Find the number of days a US track has stayed in the 1st position for both the US and worldwide rankings. Output the track name and the number of days in the 1st position. Order your output alphabetically by track name.

-- If the region 'US' appears in dataset, it should be included in the worldwide ranking.

select us.trackname as trackname, count(us.date) as n_days_on_n1_position 
from spotify_daily_rankings_2017_us us
join spotify_worldwide_daily_song_ranking w
on us.trackname = w.trackname AND us.date = w.date
where us.position = 1 AND w.position = 1
group by us.trackname
order by us.trackname;