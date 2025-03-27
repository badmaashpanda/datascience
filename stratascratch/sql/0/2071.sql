-- The marketing department is aiming its next promotion at customers who have purchased products from two particular brands: Fort West and Golden.


-- You have been asked to prepare a list of customers who purchased products from both brands.

WITH cte AS
  (SELECT customer_id,
          o.product_id,
          brand_name
   FROM online_orders o
   JOIN online_products p ON o.product_id = p.product_id),
     fort_west AS
  (SELECT DISTINCT customer_id
   FROM cte
   WHERE brand_name = 'Fort West'),
     golden AS
  (SELECT DISTINCT customer_id
   FROM cte
   WHERE brand_name = 'Golden')
SELECT f.customer_id
FROM fort_west f
INNER JOIN golden g ON f.customer_id = g.customer_id;