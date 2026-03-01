-- schema
-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- Q1: For the last 30 days, compute the daily dispute inquiry rate:

with agg as (
    select 
    date_trunc('day',c.created) as charge_day,
    count(distinct c.charge_id) as total_charges,
    count(distinct case when i.inquiry_id is not null then c.charge_id end) as charges_with_inquiry
    from charge c
    left join inquiry i on c.charge_id = i.charge_id
    where c.created >= now() - interval '30 day'
    group by charge_day
)

select charge_day,
charges_with_inquiry,
total_charges,
charges_with_inquiry::float / nullif(total_charges,0) as inquiry_rate
from agg
order by charge_day 

-- Q2: For each charge_id, return the timestamp of the first inquiry created for that charge.

select charge_id, min(created) as first_inq_created from inquiry group by 1

-- another way
SELECT
  c.charge_id,
  MIN(i.created) AS first_inq_created
FROM charge c
LEFT JOIN inquiry i
  ON i.charge_id = c.charge_id
GROUP BY c.charge_id;

-- Q3: For each charge_id, return the number of inquiries and total charge amount, 
-- only for charges that have at least 2 inquiries.

with inq as (
    select charge_id,
    count(distinct inquiry_id) as number_of_inquiries
    from inquiry 
    group by charge_id
)

select c.charge_id,
i.number_of_inquiries,
c.amount 
from charge c 
join inq i on c.charge_id = i.charge_id
where i.number_of_inquiries >= 2

-- Q4: For each charge, return the first inquiry id 
-- and its created timestamp (one row per charge).

with ranked as (
    select 
    charge_id,
    inquiry_id,
    created,
    row_number() over (partition by charge_id order by created) as rn
    from inquiry 
)

select c.charge_id,
r.inquiry_id as first_inquiry_id,
r.created as first_inq_created
from charge c
left join ranked r on c.charge_id = r.charge_id and r.rn = 1


-- Q5: For each charge, return counts of inquiries, evidence, and escalations, 
-- plus the percent of inquiries that were overturned (decimal 0–1).

with facts as (
    select 
    i.charge_id,
    count(distinct i.inquiry_id) as total_inquiries,
    count(distinct e.evidence_id) as total_evidences,
    count(distinct es.escalation_id) as total_escalations,
    count(distinct case when r.resolution_id is not null and r.overturned = true then i.inquiry_id end) as overturned_inquiries
    from inquiry i 
    left join evidence e on i.inquiry_id = e.inquiry_id
    left join escalation es on i.inquiry_id = es.inquiry_id
    left join resolution r on i.inquiry_id = r.inquiry_id
    group by 1
)

select 
charge_id,
total_inquiries,
total_evidences,
total_escalations,
overturned_inquiries::float / nullif(total_inquiries,0) as perc_inq_overturned
from facts

-- Q6: For each inquiry, compute the minutes from inquiry creation 
-- to the first evidence creation (NULL if no evidence).

with first_evid as (
    select inquiry_id,
    min(created) as first_evid_ts
    from evidence 
    group by 1
)

select 
i.inquiry_id,
extract(epoch from (e.first_evid_ts - i.created))/60.0 as mins_to_first_evid
from inquiry i
left join first_evid e on i.inquiry_id = e.inquiry_id 


-- Q7: For each inquiry, find the timestamp of the first escalation that occurs after the first evidence; 
-- return NULL if there’s no evidence or no later escalation.

with first_evid as (
    select inquiry_id,
    min(created) as first_evid_ts
    from evidence 
    group by 1
)

, first_esc as (
    select e.inquiry_id,
    min(e.created) as first_esc_after_evid
    from escalation e 
    left join first_evid fe on e.inquiry_id = fe.inquiry_id
    where e.created > fe.first_evid_ts
    group by 1
)

select 
i.inquiry_id,
min(es.first_esc_after_evid)
from inquiry i
left join first_esc es on i.inquiry_id = es.inquiry_id
group by 1


