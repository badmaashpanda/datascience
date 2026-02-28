-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- For charges created in 2024, compute the escalation rate: 
-- percent of inquiries that escalated (had at least one row in escalation). Return one row with the rate.

select 
count(distinct case when e.escalation_id is not null then i.inquiry_id end)::float / 
nullif(count(distinct i.inquiry_id),0) as escalation_rate
from inquiry i 
join charge c on i.charge_id = c.charge_id and c.created >= '2024-01-01'::date and c.created < '2025-01-01'::date
left join escalation e on i.inquiry_id = e.inquiry_id



-- 
SELECT
  COUNT(DISTINCT CASE WHEN e.inquiry_id IS NOT NULL THEN i.inquiry_id END)::float
  / NULLIF(COUNT(DISTINCT i.inquiry_id), 0) AS escalation_rate
FROM inquiry i
JOIN charge c
  ON i.charge_id = c.charge_id
 AND c.created >= DATE '2024-01-01'
 AND c.created <  DATE '2025-01-01'
LEFT JOIN escalation e
  ON i.inquiry_id = e.inquiry_id;