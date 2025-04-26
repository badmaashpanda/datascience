
-- Average Customers Per City
-- Write a query that will return all cities with more customers than the average number of  customers of all cities that have at least one customer. For each such city, return the country name,  the city name, and the number of customers
with base as (select 
city_id,
count(id) as total_customer
from linkedin_customers
group by 1)

select city_name, country_name,total_customer
from base a
join linkedin_city b on a.city_id=b.id
join linkedin_country c on b.country_id=c.id
where total_customer> (select avg(total_customer) from base)