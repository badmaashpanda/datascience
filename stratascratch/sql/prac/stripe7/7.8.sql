-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- Compute the escalation rate by charge month: for charges created in each month, 
-- what % have at least one associated escalation (via inquiry → escalation)? 
-- Return charge_month, total_charges, charges_with_escalation, escalation_rate.

with facts as (
    select 
    date_trunc('month',c.created) as charge_month,
    count(distinct c.charge_id) as total_charges,
    count(distinct case when e.escalation_id is not null then c.charge_id end) as charges_with_escalation
    from charge c 
    left join inquiry i on c.charge_id = i.charge_id
    left join escalation e on i.inquiry_id = e.inquiry_id
    group by 1
)

select 
charge_month,
total_charges,
charges_with_escalation,
charges_with_escalation::float / nullif(total_charges,0) as escalation_rate
from facts
order by charge_month
