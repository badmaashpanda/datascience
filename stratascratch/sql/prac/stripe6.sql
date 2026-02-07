-- Charge - - -> Dispute inquiry - - -> Dispute escalation - - -> Evidence submission - - -> Resolution

-- charge                                escalation
-- +---------------+---------+           +---------------+---------+
-- | charge_id     | varchar |<--+       | escalation_id | varchar |
-- | created       | date    |   |       | created       | date    |
-- | amount        | int     |   |   +-->| inquiry_id    | varchar |
-- +---------------+---------+   |   |   +---------------+---------+
--                               |   |
-- inquiry                       |   |   evidence
-- +---------------+---------+   |   |   +---------------+---------+
-- | inquiry_id    | varchar |<--|---+   | evidence_id   | varchar |
-- | created       | date    |   |   |   | created       | date    |
-- | charge_id     | varchar |<--+   +-->| inquiry_id    | varchar |
-- +---------------+---------+       |   +---------------+---------+
--                                   |
-- resolution                        |
-- +---------------+---------+       | 
-- | resolution_id | varchar |       |
-- | created       | date    |       |
-- | inquiry_id    | varchar |<------+
-- | overturned    | bool    |
-- +---------------+---------+
-- */


--Dispute rate

With dedup_inq as (
Select charge_id, inquiry_id,
row_number() over (partition by charge_id, order by created) as row_num
 from
inquiry
)
	
,base as (
Select
date_trunc('month', a.created) as created_month,
a.charge_id,
B.inquiry_id
from charge a left join dedup_inq b on a.charge_id=b.charge_id and b.row_num = 1
)

, agg as (
Select 
Created_month,
count(charge_id) as Total_charges,
sum(case when inquiry_id is not null then 1 else 0 end) as disputed_charges
From base
group by 1)

Select 
Created_month,
Total_charges,
disputed_charges,
Case when Total_charges = 0 then null else disputed_charges/Total_charges::float end as dispute_inquiry_rate
From agg
order by 1
