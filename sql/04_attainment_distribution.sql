-- Query 4: Attainment Distribution by Role and Segment
-- How are reps distributed across attainment bands?

SELECT
    r."Role",
    r."Segment",
    CASE
        WHEN CAST(REPLACE(a."Attainment %", '%', '') AS REAL) < 80 THEN 'Below 80%'
        WHEN CAST(REPLACE(a."Attainment %", '%', '') AS REAL) < 100 THEN '80-99%'
        WHEN CAST(REPLACE(a."Attainment %", '%', '') AS REAL) < 120 THEN '100-119%'
        ELSE 'Above 120%'
    END AS attainment_band,
    COUNT(*) AS month_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY r."Role", r."Segment"), 1) AS pct_of_months
FROM actuals a
JOIN reps r ON a."Rep ID" = r."Rep ID"
WHERE r."Role" != 'Manager'
GROUP BY r."Role", r."Segment", attainment_band
ORDER BY r."Role", r."Segment", attainment_band;