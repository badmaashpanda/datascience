-- Question

-- For each transfer, show the total loss the user had before this transfer.

-- Table

-- fact.transfers

-- column	description
-- transfer_id	unique transfer
-- user_id	user who made the transfer
-- transfer_created_ts	when the transfer happened
-- transfer_loss_usd	loss amount (0 if no loss)
-- Expected Output
-- transfer_id	prior_loss_usd
-- T1	NULL (or 0)
-- T2	15.00
-- T3	0
-- …	…

-- Where:

-- prior_loss_usd = sum of transfer_loss_usd for the same user
-- strictly before the current transfer’s transfer_created_ts

-- If there are no prior transfers, returning NULL or 0 is acceptable (just be consistent).

-- First: Correlated Subquery Version
-- Hints

-- You need a SUM(...)

-- Inner query filters:

-- same user_id

-- transfer_created_ts < outer.transfer_created_ts



select 
transfer_id,
(
    select sum(b.transfer_loss_usd)
    from fact.transfers b 
    where a.user_id = b.user_id and a.transfer_created_ts > b.transfer_created_ts
) as prior_loss_usd
from fact.transfers a


-- using window function
select 
transfer_id,
sum(transfer_loss_usd) over (partition by user_id order by transfer_created_ts rows between unbounded preceding and 1 preceding) as prior_loss_usd
from fact.transfers