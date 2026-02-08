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

-- Problem:
-- Fraudsters reuse infrastructure.
-- Find pairs of merchants that share at least 10 distinct cards in common in the last 30 days.

-- Return:
-- merchant_id_1
-- merchant_id_2
-- shared_cards_count

-- Rules:
-- Only include captured charges.
-- Do not return (A, B) and (B, A) as separate rows.
-- Do not return (A, A).
-- Only return pairs with shared_cards_count >= 10.

-- Hints you are not getting unless you beg:
-- This is a self-join problem.
-- You need to normalize merchant pairs.
-- DISTINCT matters.

with base as (
select
merchant_id,
card_id,
count(*) as num_distinct_cards
from charges
group by 1,2
)

, agg as (
select 
m1.merchant_id as merchant_id_1,
m2.merchant_id as merchant_id_2,
1 as matching_card
from base m1 join base m2 on m1.card_id = m2.card_id and m1.merchant_id != m2.merchant_id
)

select 
merchant_id_1,
merchant_id_2,
sum(matching_card) as shared_cards_count
from agg
group by 1,2
having sum(matching_card) >= 10


-- corrected solution

WITH merchant_cards AS (
  SELECT DISTINCT
    merchant_id,
    card_id
  FROM charges
  WHERE status = 'captured'
    AND created_at >= now() - interval '30 days'
),
pairs AS (
  SELECT
    LEAST(m1.merchant_id, m2.merchant_id) AS merchant_id_1,
    GREATEST(m1.merchant_id, m2.merchant_id) AS merchant_id_2,
    m1.card_id
  FROM merchant_cards m1
  JOIN merchant_cards m2
    ON m1.card_id = m2.card_id
   AND m1.merchant_id < m2.merchant_id   -- normalizes pairs and removes self-pairs
)
SELECT
  merchant_id_1,
  merchant_id_2,
  COUNT(*) AS shared_cards_count
FROM pairs
GROUP BY 1, 2
HAVING COUNT(*) >= 10
ORDER BY shared_cards_count DESC;
