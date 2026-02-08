-- -Question 8 – Strong Step-Up Must Occur Before Each Transfer

-- Same tables:

-- fact.transfers

-- column	type
-- transfer_id	varchar
-- user_id	varchar
-- transfer_created_ts	timestamp
-- transfer_volume_usd	numeric
-- transfer_loss_usd	numeric

-- source.step_up_friction

-- column	type
-- user_id	varchar
-- protection_level	int
-- completed_ts	timestamp
-- outcome	varchar
-- Business requirement

-- We now want to know whether a given transfer had the benefit of a prior strong step-up.

-- Define for each transfer:

-- has_prior_strong_stepup_for_this_transfer = 1 if the user has at least one step_up_friction record such that:

-- completed_ts IS NOT NULL

-- protection_level >= 3

-- completed_ts <= transfer_created_ts (it happened before or at the transfer time)

-- Otherwise 0.

-- We care about transfers in the last 90 days (by transfer_created_ts).

-- For those transfers, compute:

-- For each of:

-- has_prior_strong_stepup_for_this_transfer = 0

-- has_prior_strong_stepup_for_this_transfer = 1

-- Return:

-- has_prior_strong_stepup_for_this_transfer

-- total_volume_usd

-- total_loss_usd

-- loss_rate = total_loss_usd / total_volume_usd

-- Order by has_prior_strong_stepup_for_this_transfer (0 first).


with transfer_90 as (
    select * from 
    fact.transfers
    where transfer_created_ts >= current_date - interval '90 days'
)

, strong_steps as (
    select user_id, 
    max(completed_ts) as completed_ts,
    from source.step_up_friction
    where protection_level >= 3 and completed_ts IS NOT NULL
    group by 1
)

, joined as (
    select 
    case when b.user_id is not null then 1 else 0 end as has_prior_strong_stepup,
    sum(transfer_volume_usd) as total_volume_usd,
    sum(transfer_loss_usd) as total_loss_usd
    from transfer_90 a 
    left join strong_steps b on a.user_id=b.user_id and b.completed_ts<=a.transfer_created_ts
    group by 1
)

select has_prior_strong_stepup,
total_volume_usd,
total_loss_usd,
case when total_volume_usd = 0 then null else total_loss_usd/total_volume_usd end as loss_rate
from joined
order by 1