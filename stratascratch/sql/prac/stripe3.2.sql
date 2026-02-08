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


-- For each month of inquiry creation, calculate:
-- total number of inquiries
-- number of inquiries that escalated
-- escalation rate
-- average number of days from inquiry creation to escalation creation

-- only include inquiries that actually escalated
-- fractional days are fine

-- Return:
-- inquiry_month,
-- total_inquiries,
-- escalated_inquiries,
-- escalation_rate,
-- avg_days_to_escalation

-- Order by inquiry_month.

-- Notes (read these, they matter):
-- An inquiry can have at most one escalation
-- Some inquiries never escalate
-- Use inquiry.created as the starting point
-- Use escalation.created as the ending point

