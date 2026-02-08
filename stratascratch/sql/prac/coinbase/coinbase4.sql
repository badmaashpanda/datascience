-- <!-- Question 7 – Impact of Step-Up Friction on Loss Rate

-- You have:

-- fact.transfers (same as before)

-- source.step_up_friction

-- column	type	notes
-- user_id	varchar	
-- protection_level	int	higher = more friction
-- completed_ts	timestamp	when user successfully completed this step-up
-- outcome	varchar	e.g. 'completed', 'failed', 'abandoned'

-- Business goal:
-- Compare fraud performance (loss rate) for transfers with evidence of prior strong step-up completion vs transfers from users who have never successfully completed a strong step-up.

-- Define:

-- A user is considered “strongly stepped-up” if they have at least one step_up_friction row with:

-- completed_ts IS NOT NULL

-- protection_level >= 3 (assume 3+ is “strong”)

-- completed_ts <= transfer_created_ts (completed before the transfer)

-- For this question, simplify to user-level status, not per-transfer recomputation:

-- Create a user-level flag:

-- has_strong_stepup = 1 if the user has any completed step-up with protection_level >= 3 at any time in their history; 0 otherwise.

-- Using that flag, compute for all transfers in the last 90 days (by transfer_created_ts):

-- For each of the two groups:

-- has_strong_stepup = 1

-- has_strong_stepup = 0

-- compute:

-- total_volume_usd

-- total_loss_usd

-- loss_rate = total_loss_usd / total_volume_usd

-- Output:

-- has_strong_stepup (0 or 1)

-- total_volume_usd

-- total_loss_usd

-- loss_rate

-- Order by has_strong_stepup (0 first, then 1).

-- Assume Redshift/Postgres-like SQL.

-- Try writing that query, and then I’ll review it and (if you’d like) we can do a stricter version where the strong step-up must occur before each transfer rather than ever in history. -->


with users as (
    select distinct user_id
    from source.step_up_friction
    where completed_ts is not null and protection_level>=3
)

, txns as (
    select 
    user_id,
    transfer_created_ts,
    transfer_volume_usd,
    transfer_loss_usd
    from fact.transfers
    where transfer_created_ts >= current_date - interval '90 days'
)

, joined as (
    select a.*,
    case when b.user_id is not null then 1 else 0 end as has_strong_stepup
    from txns a left join user b on a.user_id = b.user_id
)

, agg as (
    select 
    has_strong_stepup,
    sum(transfer_loss_usd) as total_loss_usd,
    sum(transfer_volume_usd) as total_volume_usd
    from joined group by 1
)

select has_strong_stepup,total_volume_usd,total_loss_usd,
case when total_volume_usd = 0 then null else total_loss_usd/total_volume_usd end as loss_rate
from agg
order by 1