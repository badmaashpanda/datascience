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

-- Question 5 (hard): Monthly dispute loss rate by amount, with “final outcome”

-- Using the same schema, compute monthly net loss rate by charge created month.

-- Definitions
-- Consider a charge “disputed” if it has an inquiry.
-- A charge is a net loss if it has a resolution with overturned = false.
-- A charge is a win if it has a resolution with overturned = true.
-- Some inquiries may have no resolution yet. Treat those as open.

-- Output (per charge_month)
-- charge_month
-- total_charge_amount (sum of charge.amount)
-- disputed_charge_amount (sum of charge.amount for charges with ≥1 inquiry)
-- resolved_charge_amount (sum of charge.amount for charges with ≥1 resolution, either outcome)
-- lost_charge_amount (sum of charge.amount for charges with a loss resolution)
-- won_charge_amount (sum of charge.amount for charges with a win resolution)
-- open_dispute_charge_amount (disputed but no resolution)
-- net_loss_rate = lost_charge_amount / NULLIF(disputed_charge_amount, 0)

-- Rules / gotchas
-- Count each charge amount once per bucket (no double-counting if multiple inquiries/resolutions exist).
-- If a charge somehow has multiple resolutions (data weirdness), treat it as:
-- win if any resolution has overturned=true
-- else loss if any has overturned=false
-- (win beats loss)


with facts as (
    select 
    date_trunc('month', c.created) as charge_month,
    c.amount,
    exists (select 1 from inquiry i where c.charge_id = i.charge_id) as disputed_charge,
    exists (select 1 from inquiry i join resolution r on i.inquiry_id = r.inquiry_id where c.charge_id = i.charge_id and r.overturned is not null) as is_resolved,
    exists (select 1 from inquiry i join resolution r on i.inquiry_id = r.inquiry_id where c.charge_id = i.charge_id and r.overturned = true) as is_won,
    exists (select 1 from inquiry i join resolution r on i.inquiry_id = r.inquiry_id where c.charge_id = i.charge_id and r.overturned = false) as is_lost,
    exists (select 1 from inquiry i join resolution r on i.inquiry_id = r.inquiry_id where c.charge_id = i.charge_id and r.overturned is null) as is_open
from charge c 
)