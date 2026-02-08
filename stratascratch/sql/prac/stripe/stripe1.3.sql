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

WITH base AS (
  SELECT
    c1.card_id,
    c1.created_at AS window_start,
    c2.charge_id,
    c2.created_at AS charge_time
  FROM charges c1
  JOIN charges c2
    ON c1.card_id = c2.card_id
   AND c2.created_at BETWEEN c1.created_at AND c1.created_at + interval '10 minutes'
  WHERE c1.status = 'captured'
    AND c2.status = 'captured'
    AND c1.created_at >= now() - interval '24 hours'
)
SELECT
  card_id,
  window_start,
  MAX(charge_time) AS window_end,
  COUNT(*) AS charge_count
FROM base
GROUP BY 1, 2
HAVING COUNT(*) >= 5;