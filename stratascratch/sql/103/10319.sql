-- Monthly Percentage Difference
-- Given a table of purchases by date, calculate the month-over-month percentage change in revenue. The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, and sorted from the beginning of the year to the end of the year.
-- The percentage change column will be populated from the 2nd month forward and can be calculated as ((this month's revenue - last month's revenue) / last month's revenue)*100.

select to_char(created_at,'YYYY-MM') as year_month,
round(100*(sum(value) - (lag(sum(value),1) over ()))/(lag(sum(value),1) over ()),2) as diff_revenue
from sf_transactions
group by 1
order by 1