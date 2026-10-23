{{
    config(
        materialized='table',
        pre_hook="{{ truncate_safe() }}"
    )
}}

SELECT
    UPPER(TRIM(timesheet_id)) AS timesheet_id,
    UPPER(TRIM(employee_id)) AS employee_id,
    TO_DATE(work_date) AS work_date,
    UPPER(TRIM(project_code)) AS project_code,
    hours::NUMBER(5,2) AS hours,
    LOWER(TRIM(billable_flag)) AS billable_flag,
    CURRENT_TIMESTAMP() AS created_at
FROM {{ ref('hr_timesheets') }}