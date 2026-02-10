-- Find charges that were a customer’s first-ever charge (by created) and then had an inquiry within 7 days.

-- Return:
-- customer_id
-- charge_id
-- charge_created
-- first_inquiry_created

-- Tables:
-- charge(charge_id, customer_id, created, amount, merchant_id)
-- inquiry(inquiry_id, charge_id, created)

-- Rules:
-- “First-ever” is per customer_id.
-- Use either a window function (row_number) or a correlated subquery (your choice).
-- If multiple inquiries exist, use the earliest inquiry date for that charge.

-- Only return rows where earliest inquiry is within 7 days of the charge.

with fe_charge as (
    select customer_id, charge_id, created as charge_created from (
    select customer_id, created,
    charge_id,
    row_number() over (partition by customer_id order by created) as rn 
    from charge
    ) a where a.rn = 1
)

, first_inq as (
    select 
    c.charge_id,
    min(i.created) as first_inquiry_created
    from fe_charge c join inquiry i on c.charge_id = i.charge_id
    group by 1
)
    select a.customer_id, 
    a.charge_id, 
    a.charge_created, 
    b.first_inquiry_created
    from fe_charge a join first_inq b on a.charge_id = b.charge_id
    where b.first_inquiry_created <= a.charge_created + interval '7 days'
