
{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='PATIENT_ID',
        merge_update_columns=[
            'PATIENT_SK',
            'FIRSTNAME',
            'LASTNAME',
            'GENDER',
            'DOB',
            'UPDATED_AT',
            'RECORD_HASH'
        ]
    )
}}

WITH source_data AS (

    SELECT
        MD5(UPPER(PATIENT_ID)) AS PATIENT_SK,
        PATIENT_ID,
        FIRSTNAME,
        LASTNAME,
        GENDER,
        DOB,
        CREATED_AT,
        CURRENT_TIMESTAMP() AS UPDATED_AT,

        MD5(
            CONCAT(
                COALESCE(TRIM(FIRSTNAME), ''), '|',
                COALESCE(TRIM(LASTNAME), ''), '|',
                COALESCE(GENDER, ''), '|',
                COALESCE(TO_VARCHAR(DOB), '')
            )
        ) AS RECORD_HASH

    FROM {{ ref('stg_patients') }}

)

{% if is_incremental() %}

SELECT S.*
FROM source_data S

LEFT JOIN {{ this }} T
    ON S.PATIENT_ID = T.PATIENT_ID

WHERE T.PATIENT_ID IS NULL
   OR S.RECORD_HASH IS DISTINCT FROM T.RECORD_HASH

{% else %}

SELECT *
FROM source_data

{% endif %}
