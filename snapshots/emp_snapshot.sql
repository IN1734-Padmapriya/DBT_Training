{% snapshot emp_snapshot %}

{{
    config(
        unique_key='employee_id',
        strategy='check',
        check_cols=["title", "salary", "department_code"]

    )
}}

select 
employee_id,
first_name,
last_name,
email,
department_code,
title,
salary,
hired_date 
from {{ref('stg_employees')}}

{%endsnapshot%}

