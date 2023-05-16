-- Algorithm Performance

-- Meta/Facebook is developing a search algorithm that will allow users to search through their post history. You have been assigned to evaluate the performance of this algorithm.

-- We have a table with the user's search term, search result positions, and whether or not the user clicked on the search result.

-- Write a query that assigns ratings to the searches in the following way:
-- •	If the search was not clicked for any term, assign the search with rating=1
-- •	If the search was clicked but the top position of clicked terms was outside the top 3 positions, assign the search a rating=2
-- •	If the search was clicked and the top position of a clicked term was in the top 3 positions, assign the search a rating=3

-- As a search ID can contain more than one search term, select the highest rating for that search ID. Output the search ID and it's highest rating.

-- Example: The search_id 1 was clicked (clicked = 1) and it's position is outside of the top 3 positions (search_results_position = 5), therefore it's rating is 2.


with base as (
select search_id, search_term,
       case when clicked=0 then 1
       when  clicked = 1 and search_results_position > 3 then 2
       else 3 end as rating
from fb_search_events 
order by search_id)

select search_id, max(rating) from base
group by 1