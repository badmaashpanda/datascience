-- Tables

-- charges
-- charge_id (pk)
-- created_at (timestamp)
-- amount (int, cents)
-- currency (text)
-- status (text: authorized, captured, failed, refunded)
-- merchant_id (text)
-- customer_id (text)
-- card_id (text)
-- ip (inet/text)
-- device_id (text)

-- disputes
-- dispute_id (pk)
-- charge_id (fk -> charges)
-- created_at (timestamp)
-- reason (text)
-- status (text)
-- amount (int, cents)

-- Assume one dispute per charge max unless you explicitly handle otherwise.

-- Detect bursty behavior:
-- Find card_ids that had 5 or more captured charges within any rolling 10-minute window in the last 24 hours.

-- Return:
-- card_id
-- window_start (timestamp of earliest charge in the burst)
-- window_end (timestamp of latest charge in the burst)
-- charge_count


-- For each captured charge in the last 7 days, return:
-- charge_id, card_id, created_at, amount
-- prior_captures_24h: number of prior captured charges on the same card_id in the previous 24 hours (strictly before the current charge time)

-- using corelated queries
select 
charge_id, 
card_id, 
created_at, 
amount,
    (
        select count(*) 
        from charges cq 
        where c.card_id = cq.card_id 
        and cq.status = 'captured'
        and cq.created_at >= c.created_at - interval '24 hours' 
        and cq.created_at < c.created_at
    ) as prior_captures_24h
from charges c 
where c.created_at >= now() - interval '7 days' and c.status = 'captured'