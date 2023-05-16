-- Points Rating Of Wines Over Time

-- Find the average points difference between each and previous years starting from the year 2000. Output the year, average points, previous average points, and the difference between them.
-- If you're unable to calculate the average points rating for a specific year, use an 87 average points rating for that year (which is the average of all wines starting from 2000).

-- extracting year from title, running avg on year. 
-- use lag to get prior year, if null use 87, find difference 

WITH avgs AS
(
    SELECT substring(title, '[0-9]{4}')::INT as year,
        AVG(points) as avg_points
    FROM winemag_p2
    WHERE substring(title, '[0-9]{4}') IS NOT NULL AND points IS NOT NULL
    GROUP BY 1
    ORDER BY 1 ASC
)
SELECT year,
    avg_points,
    COALESCE(LAG(avg_points, 1) OVER(ORDER BY year ASC), 87) as prev_avg_points,
    avg_points - COALESCE(LAG(avg_points, 1) OVER(ORDER BY year ASC),87) as difference
FROM avgs
WHERE year >= 2000