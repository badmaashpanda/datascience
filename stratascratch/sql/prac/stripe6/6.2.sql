-- Question 2 (Medium: window functions + percentiles)

-- Using the schema:

-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- For the last 30 days of inquiries (based on inquiry.created), compute for each inquiry_day:

-- total_inquiries (distinct inquiries created that day)
-- p50_hours_charge_to_inquiry
-- p90_hours_charge_to_inquiry

-- Where:
-- hours_to_inquiry = inquiry.created - charge.created

select 
date_trunc('day', i.created) as inquiry_day,
count(distinct inquiry_id) as total_inquiries,
percentile_cont(0.5) within group (order by (extract(epoch from i.created) - extract(epoch from c.created))/3600) as p50_hours_charge_to_inquiry,
percentile_cont(0.9) within group (order by (extract(epoch from i.created) - extract(epoch from c.created))/3600) as p90_hours_charge_to_inquiry
from inquiry i 
join charge c on i.charge_id = c.charge_id
where i.created >= now() - interval '30 days'
group by 1 order by 1

--- 
  select
    i.inquiry_id,
    date_trunc('day', i.created) as inquiry_day,
    (extract(epoch from i.created) - extract(epoch from c.created)) / 3600
      as hours_to_inquiry
  from inquiry i
  join charge c
    on i.charge_id = c.charge_id
  where i.created >= now() - interval '30 days'
    and i.created >= c.created
)

select
  inquiry_day,
  count(distinct inquiry_id) as total_inquiries,
  percentile_cont(0.5) within group (order by hours_to_inquiry)
    as p50_hours_charge_to_inquiry,
  percentile_cont(0.9) within group (order by hours_to_inquiry)
    as p90_hours_charge_to_inquiry
from inquiry_lag
group by inquiry_day
order by inquiry_day;
