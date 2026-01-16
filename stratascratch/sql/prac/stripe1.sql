-- Question 1 — Foundational (Warm-up)
-- Context

-- You’re analyzing merchant-level fraud performance.

-- Prompt

-- For the last 90 days, calculate per merchant:

-- Number of captured charges

-- Number of disputed charges

-- Dispute rate

-- Requirements

-- Use captured charges as the denominator.

-- Include merchants with zero disputes.

-- Avoid double-counting charges.

-- Handle division by zero safely.

-- Tables

-- charges(charge_id, merchant_id, created_at, status)

-- disputes(dispute_id, charge_id, created_at)


