SELECT *
FROM {{ ref('stg_timesheets') }}
WHERE HOURS < 0
   OR HOURS > 24
