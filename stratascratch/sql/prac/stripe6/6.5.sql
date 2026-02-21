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