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