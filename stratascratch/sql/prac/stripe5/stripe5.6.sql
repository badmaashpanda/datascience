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

-- For charges created in the last 30 days, compute by charge_created_day:
-- charge_day
-- escalated_charges (number of charges that have at least one escalation)
-- p50_days_to_escalation (median days from charge.created to the first escalation for that charge)
-- p90_days_to_escalation (90th percentile of the same)

-- Definitions:
-- For a given charge, first escalation = the earliest escalation.created across all inquiries for that charge.
-- days_to_escalation = first_escalation_created - charge.created in days.
-- Exclude non-escalated charges from percentile calculations (but still report escalated_charges).

WITH charge_cohort AS (
  SELECT
    c.charge_id,
    date_trunc('day', c.created) AS charge_day,
    c.created AS charge_created
  FROM charge c
  WHERE c.created >= NOW() - INTERVAL '30 days'
),
first_escalation_per_charge AS (
  SELECT
    i.charge_id,
    MIN(e.created) AS first_escalation_created
  FROM inquiry i
  JOIN escalation e
    ON e.inquiry_id = i.inquiry_id
  GROUP BY i.charge_id
),
charge_escalation_facts AS (
  SELECT
    cc.charge_day,
    cc.charge_id,
    (fe.first_escalation_created - cc.charge_created) AS days_to_escalation
  FROM charge_cohort cc
  JOIN first_escalation_per_charge fe
    ON fe.charge_id = cc.charge_id
)
SELECT
  charge_day,
  COUNT(*) AS escalated_charges,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days_to_escalation) AS p50_days_to_escalation,
  PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY days_to_escalation) AS p90_days_to_escalation
FROM charge_escalation_facts
GROUP BY charge_day
ORDER BY charge_day;
