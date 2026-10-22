
{{
    config(
        materialized='ephemeral'
    )
}}

WITH daily_summary AS (

    -- Daily admissions
    SELECT
        ADMIT_DATE AS REPORT_DATE,
        COUNT(*) AS ADMISSIONS,
        0 AS DISCHARGES,
        AVG(
            DATEDIFF(DAY, ADMIT_DATE, DISCHARGE_DATE)
        ) AS AVG_LENGTH_OF_STAY
    FROM {{ ref('stg_encounters') }}
    GROUP BY ADMIT_DATE

    UNION ALL

    -- Daily discharges
    SELECT
        DISCHARGE_DATE AS REPORT_DATE,
        0 AS ADMISSIONS,
        COUNT(*) AS DISCHARGES,
        NULL AS AVG_LENGTH_OF_STAY
    FROM {{ ref('stg_encounters') }}
    WHERE DISCHARGE_DATE IS NOT NULL
    GROUP BY DISCHARGE_DATE

)

SELECT
    REPORT_DATE,
    SUM(ADMISSIONS) AS ADMISSIONS,
    SUM(DISCHARGES) AS DISCHARGES,
    AVG(AVG_LENGTH_OF_STAY) AS AVG_LENGTH_OF_STAY
FROM daily_summary
GROUP BY REPORT_DATE
