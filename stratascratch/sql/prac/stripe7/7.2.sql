-- Using the schema:

-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

--Among charges created in 2024, what percent had an inquiry within 7 days of the charge date? (Return a single row with the percentage.)

with base as (
    select 
    c.charge_id,
    c.created,
    max(case when i.created >= c.created and i.created <= c.created + interval '7 days' then 1 else 0 end) as has_inq_7_days
    from charges c 
    left join inquiry i on c.charge_id = i.charge_id
    where extract(YEAR from c.created) = '2024'
    group by 1,2
)

select 
sum(has_inq_7_days)::float / nullif(count(*), 0) as perc_7_day_inq
from base
