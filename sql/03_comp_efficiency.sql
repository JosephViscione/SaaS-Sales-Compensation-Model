-- Query 3: Comp Efficiency by Segment
-- Which segment generated the most ARR per dollar of total comp spend?

SELECT
    c."Segment",
    SUM(CAST(REPLACE(REPLACE(c."Actual", '$', ''), ',', '') AS REAL)) AS total_arr,
    SUM(CAST(REPLACE(REPLACE(c."Total Monthly Cash ($)", '$', ''), ',', '') AS REAL)) AS total_comp_paid,
    ROUND(
        SUM(CAST(REPLACE(REPLACE(c."Actual", '$', ''), ',', '') AS REAL)) /
        NULLIF(
            SUM(CAST(REPLACE(REPLACE(c."Total Monthly Cash ($)", '$', ''), ',', '') AS REAL))
        , 0)
    , 2) AS arr_per_comp_dollar
FROM commissions c
WHERE c."Role" = 'AE'
GROUP BY c."Segment"
ORDER BY arr_per_comp_dollar DESC;