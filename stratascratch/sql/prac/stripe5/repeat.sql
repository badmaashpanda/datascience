-- SQL Question: Repeated Payments
-- Sometimes, payment transactions are repeated by accident. 
-- This can happen due to user error, API failure, or retry errors that cause a credit card to be charged multiple times.

-- Using the transactions table, identify payments that meet all of the following conditions:
-- Made at the same merchant
-- Using the same credit card
-- For the same amount
-- Occurring within 10 minutes of each other

-- Task:
-- Count the number of such repeated payments.

-- Transactions [transaction_id,merchant_id,credit_card_id,amount,transaction_timestamp]

with base as (
select 
transaction_id,
transaction_timestamp,
lag(transaction_timestamp) over (partition by merchant_id, credit_card_id, amount order by transaction_timestamp) as prev_timestamp
from transactions
)

, agg as (
    select 
    transaction_id,
    prev_timestamp,
    transaction_timestamp - prev_timestamp as time_difference
    from base
)

select count(transaction_id) as payment_count
from agg
where prev_timestamp >= transaction_timestamp - interval '10 minutes'
