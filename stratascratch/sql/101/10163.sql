-- Product Transaction Count
-- Find the number of transactions that occurred for each product. Output the product name along with the corresponding number of transactions and order records by the product id in ascending order. You can ignore products without transactions.

with base as (select a.product_name, a.product_id,
count(b.transaction_id) as count
from excel_sql_inventory_data a
inner join excel_sql_transaction_data b on a.product_id=b.product_id
group by 1,2)

select product_name, count from base 
order by product_id