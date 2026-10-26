{{
    config(
        materialized='table'
    )
}}
select 
MD5(
    CONCAT(
        EMPLOYEE_ID,
        '|',
        TO_VARCHAR(DBT_VALID_FROM, 'YYYY-MM-DD HH24:MI:SS.FF9')
    )
) AS EMPLOYEE_VERSION_SK,
employee_id,
first_name,
last_name,
email,
department_code,
title,
salary,
hired_date,
dbt_valid_from,
dbt_valid_to, 
case
 when dbt_valid_to is null then 'Yes'
 else 'No'
end as iscurrent
from {{ref('emp_snapshot')}}