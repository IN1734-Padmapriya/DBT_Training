{{
    config(
        materialized='table',
        pre_hook="{{ truncate_safe() }}"
    )
}}
select 
trim(upper(employee_id)),
trim(first_name),
trim(last_name),
trim(email),
trim(upper(department_code)),
trim(title),
salary::NUMBER(10,2),
TO_DATE(hired_date),
current_timestamp() as created_at
from {{ref('hr_employees')}}