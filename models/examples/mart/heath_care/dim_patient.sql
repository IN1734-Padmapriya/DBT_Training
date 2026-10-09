{{
    config(
        materialized='table'
    )
}}

select 
name,
age,
blood_type,
gender,
medical_condition,
date_of_admission,
case 
  when DBT_VALID_TO is null then 'Y' else 'N'
  end as current_record_flag,
DBT_VALID_FROM as created_at,
coalesce(DBT_VALID_TO,DBT_VALID_FROM) as updated_at
from {{ref('snap_patient')}}

