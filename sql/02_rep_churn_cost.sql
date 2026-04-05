-- Query 2: True Cost of Rep Churn
-- What was the total quota gap created by mid-year attrition?

SELECT
    r."Full Name",
    r."Role",
    r."Segment",
    r."End Mo." AS last_month,
    12 - CAST(r."End Mo." AS INTEGER) AS months_uncovered,
    SUM(CAST(REPLACE(REPLACE(a."Monthly Quota", '$', ''), ',', '') AS REAL)) AS total_quota,
    SUM(CAST(REPLACE(REPLACE(a."Actual Performance", '$', ''), ',', '') AS REAL)) AS total_actual,
    SUM(CAST(REPLACE(REPLACE(a."Monthly Quota", '$', ''), ',', '') AS REAL)) -
    SUM(CAST(REPLACE(REPLACE(a."Actual Performance", '$', ''), ',', '') AS REAL)) AS quota_gap
FROM reps r
JOIN actuals a ON r."Rep ID" = a."Rep ID"
WHERE r."Status" = 'Churned'
GROUP BY r."Rep ID", r."Full Name", r."Role", r."Segment", r."End Mo."
ORDER BY quota_gap DESC;