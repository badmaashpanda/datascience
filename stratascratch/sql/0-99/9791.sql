-- Create a report showing how many views each keyword has. Output the keyword and the total views, and order records with highest view count first.

with base as (select a.post_keywords, b.viewer_id,
case when viewer_id is null then 0 else 1 end as vid
from facebook_posts a left join facebook_post_views b on a.post_id=b.post_id)

select trim(both '[]#"' from unnest(string_to_array(post_keywords, ','))), sum(vid)
from base group by 1 order by 2 desc