-- Query 1: Accelerator ROI
-- For every dollar paid in accelerators, how much ARR did Veltora generate?

SELECT
    c."Segment",
    SUM(CAST(REPLACE(REPLACE(c."Actual", '$', ''), ',', '') AS REAL)) AS total_arr,
    SUM(CAST(REPLACE(REPLACE(c."Std. Commission ($)", '$', ''), ',', '') AS REAL)) AS standard_commission,
    SUM(CAST(REPLACE(REPLACE(c."Total Monthly Variable ($)", '$', ''), ',', '') AS REAL)) AS total_variable_paid,
    SUM(CAST(REPLACE(REPLACE(c."Total Monthly Variable ($)", '$', ''), ',', '') AS REAL)) -
    SUM(CAST(REPLACE(REPLACE(c."Std. Commission ($)", '$', ''), ',', '') AS REAL)) AS accelerator_cost,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(c."Actual", '$', ''), ',', '') AS REAL)) /
        NULLIF(
            SUM(CAST(REPLACE(REPLACE(c."Total Monthly Variable ($)", '$', ''), ',', '') AS REAL)) -
            SUM(CAST(REPLACE(REPLACE(c."Std. Commission ($)", '$', ''), ',', '') AS REAL))
        , 0)
    , 2) AS arr_per_accel_dollar
FROM commissions c
WHERE c."Role" = 'AE'
AND CAST(REPLACE(c."Accel Multiplier (IFS)", 'x', '') AS REAL) > 1.0
GROUP BY c."Segment"
ORDER BY arr_per_accel_dollar DESC;