-- Number Of Units Per Nationality
-- Find the number of apartments per nationality that are owned by people under 30 years old.
-- Output the nationality along with the number of apartments.
-- Sort records by the apartments count in descending order.

select nationality, count(distinct unit_id) from airbnb_hosts a
inner join airbnb_units b on a.host_id=b.host_id
where a.age<30 and b.unit_type = 'Apartment'
group by 1
