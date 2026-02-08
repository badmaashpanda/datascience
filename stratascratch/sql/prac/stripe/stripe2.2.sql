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


-- Now calculate three rates by charge created month:

-- inquiry_rate = charges with ≥1 inquiry / total charges
-- escalation_rate = charges with ≥1 escalation / total charges
-- loss_rate = charges that are resolved NOT overturned / total charges

-- Rules/definitions:
-- Escalation is tied to inquiry_id via escalation.inquiry_id.
-- Resolution is tied to inquiry_id via resolution.inquiry_id.
-- A charge can have multiple inquiries; inquiries can have escalation/resolution. Count each charge once per metric.
-- For loss_rate: a charge is a “loss” if it has at least one resolution row where overturned = false.

-- Output columns:

-- charge_month
-- total_charges
-- inquiry_charges
-- escalation_charges
-- loss_charges
-- inquiry_rate
-- escalation_rate
-- loss_rate


with base as (
select 
date_trunc('month', created) as charge_month,
exists (select 1 from inquiry i where i.charge_id = c.charge_id) as has_inquiry,
exists (select 1 from inquiry i join escalation e on i.inquiry_id = e.inquiry_id where i.charge_id = c.charge_id) as has_escalation,
exists (select 1 from inquiry i join resolution r on i.inquiry_id = r.inquiry_id where i.charge_id = c.charge_id AND r.overturned = false) as has_loss
from charge c
)

, agg as (
    select 
    charge_month,
    count(*) as total_charges,
    sum(has_inquiry) as inquiry_charges,
    sum(has_escalation) as escalation_charges,
    sum(has_loss) as loss_charges
    from base 
    group by 1
)

select 
charge_month,
total_charges,
inquiry_charges,
escalation_charges,
loss_charges,
inquiry_charges::float / nullif(total_charges,0) as inquiry_rate,
escalation_charges::float / nullif(total_charges,0) as escalation_rate,
loss_charges::float / nullif(total_charges,0) as loss_rate
from agg
order by 1


-- another way

WITH charge_base AS (
  SELECT
    c.charge_id,
    DATE_TRUNC('month', c.created)::date AS charge_month
  FROM charge c
),

inq AS (
  SELECT DISTINCT
    i.charge_id,
    1 AS has_inquiry
  FROM inquiry i
),

esc AS (
  SELECT DISTINCT
    i.charge_id,
    1 AS has_escalation
  FROM inquiry i
  JOIN escalation e
    ON e.inquiry_id = i.inquiry_id
),

loss AS (
  SELECT DISTINCT
    i.charge_id,
    1 AS has_loss
  FROM inquiry i
  JOIN resolution r
    ON r.inquiry_id = i.inquiry_id
   AND r.overturned = false
),

facts AS (
  SELECT
    cb.charge_month,
    cb.charge_id,
    COALESCE(inq.has_inquiry, 0)     AS has_inquiry,
    COALESCE(esc.has_escalation, 0)  AS has_escalation,
    COALESCE(loss.has_loss, 0)       AS has_loss
  FROM charge_base cb
  LEFT JOIN inq  ON inq.charge_id  = cb.charge_id
  LEFT JOIN esc  ON esc.charge_id  = cb.charge_id
  LEFT JOIN loss ON loss.charge_id = cb.charge_id
),

agg AS (
  SELECT
    charge_month,
    COUNT(*) AS total_charges,
    SUM(has_inquiry) AS inquiry_charges,
    SUM(has_escalation) AS escalation_charges,
    SUM(has_loss) AS loss_charges
  FROM facts
  GROUP BY 1
)

SELECT
  charge_month,
  total_charges,
  inquiry_charges,
  escalation_charges,
  loss_charges,
  inquiry_charges::float / NULLIF(total_charges, 0) AS inquiry_rate,
  escalation_charges::float / NULLIF(total_charges, 0) AS escalation_rate,
  loss_charges::float / NULLIF(total_charges, 0) AS loss_rate
FROM agg
ORDER BY 1;