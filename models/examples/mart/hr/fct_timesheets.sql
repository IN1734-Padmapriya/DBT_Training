
{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='TIMESHEET_ID',
        merge_update_columns=[
            'EMPLOYEE_ID',
            'EMPLOYEE_VERSION_SK',
            'WORK_DATE',
            'PROJECT_CODE',
            'HOURS',
            'BILLABLE_FLAG',
            'UPDATED_AT'
        ]
    )
}}

WITH source_data AS (

    SELECT
        TIMESHEET_ID,
        e.EMPLOYEE_ID,
        e.EMPLOYEE_VERSION_SK,
        t.WORK_DATE,
        PROJECT_CODE,
        t.HOURS,
        BILLABLE_FLAG,
        CURRENT_TIMESTAMP() AS CREATED_AT,
        CURRENT_TIMESTAMP() AS UPDATED_AT

    FROM {{ ref('stg_timesheets') }} AS t

    INNER JOIN {{ ref('dim_employee') }} AS e
        ON t.EMPLOYEE_ID= e.EMPLOYEE_ID
       AND e.iscurrent = 'Yes'

    WHERE t.WORK_DATE > (
        SELECT COALESCE(MAX(LAST_WORK_DATE), '1900-01-01'::DATE)
        FROM {{ ref('etl_control') }}
        WHERE SOURCE_NAME = 'hr_timesheets'
    )

)

{% if is_incremental() %}

SELECT S.*
FROM source_data AS S
LEFT JOIN {{ this }} AS T
    ON S.TIMESHEET_ID = T.TIMESHEET_ID
WHERE T.TIMESHEET_ID IS NULL
   OR S.EMPLOYEE_ID <> T.EMPLOYEE_ID
   OR S.EMPLOYEE_VERSION_SK <> T.EMPLOYEE_VERSION_SK
   OR S.WORK_DATE <> T.WORK_DATE
   OR S.PROJECT_CODE <> T.PROJECT_CODE
   OR S.HOURS <> T.HOURS
   OR S.BILLABLE_FLAG <> T.BILLABLE_FLAG

{% else %}

SELECT *
FROM source_data

{% endif %}
