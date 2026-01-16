-- Question

-- For each transfer, show whether the user had any prior transfer before this one.

-- Table

-- fact.transfers

-- column	description
-- transfer_id	unique transfer
-- user_id	user who made the transfer
-- transfer_created_ts	when the transfer happened
-- Expected Output
-- transfer_id	has_prior_transfer
-- T1	0
-- T2	1
-- T3	0
-- …	…

-- Where:

-- has_prior_transfer = 1 if the same user_id has any transfer with an earlier transfer_created_ts

-- Otherwise 0

-- Hints (read only if stuck)

-- This is a yes/no question → use EXISTS

-- Inner query should:

-- Match on user_id

-- Filter to transfer_created_ts < current row’s transfer_created_ts



-- using window function
with cte as (
    select user_id,
    transfer_id,
    transfer_created_ts,
    row_number() over (partition by user_id order by transfer_created_ts) as rn
    from fact.transfers
)

select transfer_id,
case when rn > 1 then 1 else 0 end as has_prior_transfer
from cte


-- using co-related subquery
select 
transfer_id,
case when exists (
    select 1 from fact.transfers b 
    where a.user_id = b.user_id 
    and a.transfer_created_ts > b.transfer_created_ts
) then 1 else 0 end as has_prior_transfer
from fact.transfers a
