-- Premium vs Freemium
-- Find the total number of downloads for paying and non-paying users by date. Include only records where non-paying customers have more downloads than paying customers. The output should be sorted by earliest date first and contain 3 columns date, non-paying downloads, paying downloads.

with base as (select a.date,
a.user_id,
a.downloads,
b.acc_id,
c.paying_customer
from ms_download_facts a
inner join ms_user_dimension b on a.user_id=b.user_id
inner join ms_acc_dimension c on b.acc_id=c.acc_id
order by a.date)

,final as (
select date,
sum(case when paying_customer = 'no' then downloads else 0 end) as non_paying,
sum(case when paying_customer = 'yes' then downloads else 0 end) as paying
from base
group by 1
order by 1)

select date, non_paying, paying
from final where non_paying>paying