-- Business Name Lengths

-- Find the number of words in each business name. Avoid counting special symbols as words (e.g. &). Output the business name and its count of words.

WITH a AS (
SELECT business_name,
          regexp_replace(business_name, '[^a-zA-Z0-9 ]', '', 'g') AS b_name
   FROM sf_restaurant_health_violations)
   
SELECT DISTINCT business_name,
       array_length(regexp_split_to_array(b_name, '\s+'), 1) AS word_count
FROM a;