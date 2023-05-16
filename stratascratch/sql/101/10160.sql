-- Rank guests based on their ages

-- Rank guests based on their ages.
-- Output the guest id along with the corresponding rank.
-- Order records by the age in descending order.

select guest_id,
rank() over (order by age desc) as rank
from airbnb_guests;