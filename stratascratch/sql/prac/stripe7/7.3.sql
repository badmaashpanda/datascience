-- Using the schema:

-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

--For each inquiry, return inquiry_id, the related charge_id, and the number of evidence submissions 
--before the escalation date (if no escalation, count all evidence).

with esc as (
    select inquiry_id,
    min(created) as first_escalation
    from escalation
    group by 1
)

select i.inquiry_id, 
i.charge_id,
count(case when e.first_escalation is null or ev.created < e.first_escalation then ev.evidence_id) as evidence_before_escalation
from inquiry i 
left join esc e on i.inquiry_id = e.inquiry_id
left join evidence ev on i.inquiry_id = ev.inquiry_id
group by 1,2



--- 
WITH esc AS (
  SELECT inquiry_id, MIN(created) AS first_escalation
  FROM escalation
  GROUP BY 1
)
SELECT
  i.inquiry_id,
  i.charge_id,
  COUNT(ev.evidence_id) FILTER (
    WHERE e.first_escalation IS NULL OR ev.created < e.first_escalation
  ) AS evidence_before_escalation
FROM inquiry i
LEFT JOIN esc e ON i.inquiry_id = e.inquiry_id
LEFT JOIN evidence ev ON i.inquiry_id = ev.inquiry_id
GROUP BY 1,2;