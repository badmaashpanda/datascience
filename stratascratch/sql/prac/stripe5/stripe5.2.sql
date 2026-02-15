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

-- We want to analyze how quickly inquiries escalate.

-- Write a SQL query that returns one row per escalation with:
-- escalation_id
-- inquiry_id
-- charge_id
-- charge_created
-- inquiry_created
-- escalation_created
-- days_to_escalation = (escalation_created - inquiry_created) in days

-- Constraints:
-- Only include rows where an escalation exists.
-- If a charge has multiple inquiries and multiple escalations, your query should still be correct (no accidental fan-out beyond “one row per escalation”).
-- Order by days_to_escalation descending.
-- After the query, explain how you prevented join duplication.


SELECT
  e.escalation_id,
  i.inquiry_id,
  c.charge_id,
  c.created AS charge_created,
  i.created AS inquiry_created,
  e.created AS escalation_created,
  (e.created - i.created) AS days_to_escalation
FROM escalation e
JOIN inquiry i
  ON e.inquiry_id = i.inquiry_id
JOIN charge c
  ON i.charge_id = c.charge_id
ORDER BY days_to_escalation DESC;

