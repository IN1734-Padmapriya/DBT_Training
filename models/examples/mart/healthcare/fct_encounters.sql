
{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='ENCOUNTER_ID',
        merge_update_columns=[
            'ENCOUNTER_SK',
            'PATIENT_SK',
            'ADMIT_DATE',
            'DISCHARGE_DATE',
            'DIAGNOSIS_CODE',
            'STATUS',
            'UPDATED_AT',
            'RECORD_HASH'
        ]
    )
}}
WITH source_data AS (

    SELECT
        MD5(UPPER(TRIM(enc.ENCOUNTER_ID))) AS ENCOUNTER_SK,
        UPPER(TRIM(enc.ENCOUNTER_ID)) AS ENCOUNTER_ID,
        p.PATIENT_SK,
        enc.ADMIT_DATE,
        enc.DISCHARGE_DATE,
        enc.DIAGNOSIS_CODE,
        enc.STATUS,
        enc.CREATED_AT,
        CURRENT_TIMESTAMP() AS UPDATED_AT,

        MD5(
            CONCAT(
                COALESCE(TO_VARCHAR(p.PATIENT_SK), ''), '|',
                COALESCE(TO_VARCHAR(enc.ADMIT_DATE), ''), '|',
                COALESCE(TO_VARCHAR(enc.DISCHARGE_DATE), ''), '|',
                COALESCE(TRIM(enc.DIAGNOSIS_CODE), ''), '|',
                COALESCE(TRIM(enc.STATUS), '')
            )
        ) AS RECORD_HASH

    FROM {{ ref('stg_encounters') }} AS enc

    INNER JOIN {{ ref('dim_patient') }} AS p
        ON UPPER(TRIM(enc.PATIENT_ID)) = p.PATIENT_ID

)

{% if is_incremental() %}

SELECT S.*
FROM source_data AS S

LEFT JOIN {{ this }} AS T
    ON S.ENCOUNTER_ID = T.ENCOUNTER_ID

WHERE T.ENCOUNTER_ID IS NULL
   OR S.RECORD_HASH <> T.RECORD_HASH

{% else %}

SELECT *
FROM source_data

{% endif %}
