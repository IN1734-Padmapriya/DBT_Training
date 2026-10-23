{{
    config(
        materialized='table',
        pre_hook="{{ truncate_safe() }}"
    )
}}
select 
trim(upper(employee_id)) as employee_id,
trim(first_name) as first_name,
trim(last_name) as last_name ,
trim(email) as email,
trim(upper(department_code)) as department_code,
trim(title) as title,
salary::NUMBER(10,2) as salary,
TO_DATE(hired_date) as hired_date,
current_timestamp() as created_at
from {{ref('hr_employees')}}