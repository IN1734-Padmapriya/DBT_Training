
SELECT
    PATIENT_ID,
    DOB
FROM {{ ref('dim_patients') }}
WHERE DOB > CURRENT_DATE()
