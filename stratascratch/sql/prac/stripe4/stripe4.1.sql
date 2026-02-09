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

-- For each month (based on the charge.created date), return:
    
-- charge_month (first day of the month is fine),
-- total_charges (count of charges created in that month),
-- inquired_charges (count of charges that have at least one associated inquiry),
-- overturned_inquired_charges (count of charges whose inquiry has a resolution with overturned = true),
-- overturn_rate = overturned_inquired_charges / nullif(inquired_charges, 0).

-- Use the schema in the diagram (tables: charge, inquiry, resolution). Make the query resilient to charges that have no inquiry or inquiries that have no resolution.