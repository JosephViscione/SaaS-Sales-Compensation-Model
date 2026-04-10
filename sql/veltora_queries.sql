-- Veltora Inc. — Sales Compensation Analysis Queries
-- Tool: MySQL Workbench
-- Database: veltora
-- Tables: commissions, reps, actuals


-- ============================================================
-- Query 1: Accelerator ROI
-- For every dollar paid in accelerators, how much ARR did Veltora generate?
-- ============================================================

SELECT
    'Accelerator ROI by Segment' AS query,
    c.`Segment`,
    SUM(CAST(REPLACE(REPLACE(c.`Actual`, '$', ''), ',', '') AS DECIMAL(15,2))) AS total_arr,
    SUM(CAST(REPLACE(REPLACE(c.`Std. Commission ($)`, '$', ''), ',', '') AS DECIMAL(15,2))) AS standard_commission,
    SUM(CAST(REPLACE(REPLACE(c.`Total Monthly Variable ($)`, '$', ''), ',', '') AS DECIMAL(15,2))) AS total_variable_paid,
    SUM(CAST(REPLACE(REPLACE(c.`Total Monthly Variable ($)`, '$', ''), ',', '') AS DECIMAL(15,2))) -
    SUM(CAST(REPLACE(REPLACE(c.`Std. Commission ($)`, '$', ''), ',', '') AS DECIMAL(15,2))) AS accelerator_cost,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(c.`Actual`, '$', ''), ',', '') AS DECIMAL(15,2))) /
        NULLIF(
            SUM(CAST(REPLACE(REPLACE(c.`Total Monthly Variable ($)`, '$', ''), ',', '') AS DECIMAL(15,2))) -
            SUM(CAST(REPLACE(REPLACE(c.`Std. Commission ($)`, '$', ''), ',', '') AS DECIMAL(15,2)))
        , 0)
    , 2) AS arr_per_accel_dollar
FROM commissions c
WHERE c.`Role` = 'AE'
AND CAST(REPLACE(c.`Accel Multiplier (IFS)`, 'x', '') AS DECIMAL(5,2)) > 1.0
GROUP BY c.`Segment`
ORDER BY arr_per_accel_dollar DESC;


-- ============================================================
-- Query 2: True Cost of Rep Churn
-- What was the total quota gap created by mid-year attrition?
-- ============================================================

SELECT
    'True Cost of Rep Churn' AS query,
    r.`Full Name`,
    r.`Role`,
    r.`Segment`,
    r.`End Mo.` AS last_month,
    12 - r.`End Mo.` AS months_uncovered,
    SUM(CAST(REPLACE(REPLACE(a.`Monthly Quota`, '$', ''), ',', '') AS DECIMAL(15,2))) AS total_quota,
    SUM(CAST(REPLACE(REPLACE(a.`Actual Performance`, '$', ''), ',', '') AS DECIMAL(15,2))) AS total_actual,
    SUM(CAST(REPLACE(REPLACE(a.`Monthly Quota`, '$', ''), ',', '') AS DECIMAL(15,2))) -
    SUM(CAST(REPLACE(REPLACE(a.`Actual Performance`, '$', ''), ',', '') AS DECIMAL(15,2))) AS quota_gap
FROM reps r
JOIN actuals a ON r.`Rep ID` = a.`Rep ID`
WHERE r.`Status` = 'Churned'
GROUP BY r.`Rep ID`, r.`Full Name`, r.`Role`, r.`Segment`, r.`End Mo.`
ORDER BY quota_gap DESC;


-- ============================================================
-- Query 3: Comp Efficiency by Segment
-- Which segment generated the most ARR per dollar of total comp spend?
-- ============================================================

SELECT
    'Comp Efficiency by Segment' AS query,
    c.`Segment`,
    SUM(CAST(REPLACE(REPLACE(c.`Actual`, '$', ''), ',', '') AS DECIMAL(15,2))) AS total_arr,
    SUM(CAST(REPLACE(REPLACE(c.`Total Monthly Cash ($)`, '$', ''), ',', '') AS DECIMAL(15,2))) AS total_comp_paid,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(c.`Actual`, '$', ''), ',', '') AS DECIMAL(15,2))) /
        NULLIF(
            SUM(CAST(REPLACE(REPLACE(c.`Total Monthly Cash ($)`, '$', ''), ',', '') AS DECIMAL(15,2)))
        , 0)
    , 2) AS arr_per_comp_dollar
FROM commissions c
WHERE c.`Role` = 'AE'
GROUP BY c.`Segment`
ORDER BY arr_per_comp_dollar DESC;


-- ============================================================
-- Query 4: Attainment Distribution by Role and Segment
-- How are reps distributed across attainment bands?
-- ============================================================

SELECT
    'Attainment Distribution by Role and Segment' AS query,
    r.`Role`,
    r.`Segment`,
    CASE
        WHEN CAST(REPLACE(a.`Attainment %`, '%', '') AS DECIMAL(6,2)) < 80  THEN 'Below 80%'
        WHEN CAST(REPLACE(a.`Attainment %`, '%', '') AS DECIMAL(6,2)) < 100 THEN '80-99%'
        WHEN CAST(REPLACE(a.`Attainment %`, '%', '') AS DECIMAL(6,2)) < 120 THEN '100-119%'
        ELSE 'Above 120%'
    END AS attainment_band,
    COUNT(*) AS month_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY r.`Role`, r.`Segment`), 1) AS pct_of_months
FROM actuals a
JOIN reps r ON a.`Rep ID` = r.`Rep ID`
WHERE r.`Role` != 'Manager'
GROUP BY r.`Role`, r.`Segment`, attainment_band
ORDER BY r.`Role`, r.`Segment`, attainment_band;
