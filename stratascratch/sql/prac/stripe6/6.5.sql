-- Using the schema:

-- charge(charge_id, created, amount)
-- inquiry(inquiry_id, created, charge_id)
-- escalation(escalation_id, created, inquiry_id)
-- evidence(evidence_id, created, inquiry_id)
-- resolution(resolution_id, created, inquiry_id, overturned)

-- Question 5 (Hard: Cohort survival + window functions)

-- We want to understand how disputes materialize over time.
-- For charges created in the last 30 days, build a cohort-style output showing:

-- For each charge_day and each days_since_charge bucket from 0 to 7:

-- charge_day
-- days_since_charge (integer difference between inquiry date and charge date)
-- charges_in_cohort (total distinct charges created that day)
-- charges_with_inquiry_on_day_n
-- cumulative_inquiry_rate_through_day_n

-- Definitions
-- Only consider the first inquiry per charge.
-- days_since_charge = date(inquiry.created) - date(charge.created)
-- Only include buckets where days_since_charge is between 0 and 7.

-- The cumulative rate should be:
-- (sum of charges_with_inquiry_on_day_n up to day_n) / charges_in_cohort

-- Requirements
-- Use a CTE to compute first inquiry per charge.
-- Join back to charges.
-- Use a window function to compute the cumulative rate per charge_day cohort.
-- Output sorted by charge_day, days_since_charge.

with first_inq as (
  select 
  charge_id,
  min(created) as first_inquiry_date
  from inquiry
  group by 1
)

, base as (
  select 
  date_trunc('day',c.created) as charge_day,
  c.charge_id,
  date(fi.first_inquiry_date) - date(c.created) as days_since_charge
  from charge c 
  left join first_inq fi on c.charge_id = fi.charge_id
  where c.created >= now() - interval '30 days'
)

, agg as (
  select charge_day,
  days_since_charge,
  count(distinct charge_id) over (partition by charge_day) as charges_in_cohort,
  count(distinct charge_id) over (partition by charge_day, days_since_charge) as charges_with_inquiry_on_day_n
  from base
  where days_since_charge >= 0 and days_since_charge <= 7
)

, cum as (
  select charge_day,
  days_since_charge,
  charges_in_cohort,
  charges_with_inquiry_on_day_n,
  sum(charges_with_inquiry_on_day_n) over (partition by charge_day order by days_since_charge) as cum_charges_with_inquiry_on_day_n
  from agg
)

select 
charge_day,
days_since_charge,
charges_in_cohort,
charges_with_inquiry_on_day_n,
cum_charges_with_inquiry_on_day_n::float /nullif(charges_in_cohort,0) as cumulative_inquiry_rate_through_day_n
from cum 
order by 1,2



