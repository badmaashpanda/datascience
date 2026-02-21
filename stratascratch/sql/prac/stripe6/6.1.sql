-- Question 1 (Easy: joins + aggregation)

-- Using the schema:

-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- Write a SQL query to produce a daily disputes funnel for the last 30 days, grouped by charge.created date:
-- For each charge_day, return:

-- total_charges
-- charges_with_inquiry (distinct charges that have an inquiry)
-- charges_with_escalation (distinct charges whose inquiry escalated)
-- charges_with_evidence (distinct charges whose inquiry has evidence)
-- charges_with_resolution (distinct charges whose inquiry has a resolution)

    select 
    date_trunc('day', c.created) as charge_day,
    count(distinct c.charge_id) as total_charges,
    count(distinct case when i.inquiry_id is not null then c.charge_id end) as charges_with_inquiry,
    count(distinct case when e.inquiry_id is not null then c.charge_id end) as charges_with_escalation,
    count(distinct case when v.inquiry_id is not null then c.charge_id end) as charges_with_evidence,
    count(distinct case when r.inquiry_id is not null then c.charge_id end) as charges_with_resolution
    from 
    charge c 
    left join inquiry i on c.charge_id = i.charge_id
    left join escalation e on i.inquiry_id = e.inquiry_id
    left join evidence v on i.inquiry_id = v.inquiry_id
    left join resolution r on i.inquiry_id = r.inquiry_id
    where  c.created >= now() - interval '30 days'
    group by 1
    order by 1