{{
    config(
        materialized='table',
        pre_hook="{{ truncate_safe() }}"
    )
}}

SELECT
    UPPER(TRIM(department_code)) AS department_code,
    TRIM(department_name) AS department_name,
    CURRENT_TIMESTAMP() AS created_at
FROM {{ ref('hr_departments') }}