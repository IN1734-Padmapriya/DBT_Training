{{
    config(
        materialized='view'
    )
}}

SELECT
    UPPER(TRIM(PATIENT_ID)) AS PATIENT_ID,
    TRIM(FIRSTNAME) AS FIRSTNAME,
    TRIM(LASTNAME) AS LASTNAME,
    {{ standardize_gender('GENDER') }} AS GENDER,
    TO_DATE(DOB) AS DOB,
    CURRENT_TIMESTAMP() AS CREATED_AT
FROM {{ ref('patients') }}