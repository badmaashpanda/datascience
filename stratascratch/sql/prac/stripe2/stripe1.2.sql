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

-- Velocity check: For each charge, compute how many captured charges happened on the same card_id in the preceding 1 hour (including the current charge). Return:
-- charge_id, card_id, created_at, amount
-- card_captures_last_1h

-- Filter to last 7 days to keep it sane.


select 
charge_id,
card_id,
created_at,
amount,
count(*) over (partition by card_id order by created_at range between interval '1 hour' preceding and current row) as card_captures_last_1h
from charges 
where created_at>= now() - interval '7 days'
and status = 'captured'


--count(*) over (partition by card_id order by created_at range between interval '1 hour' preceding and current row)