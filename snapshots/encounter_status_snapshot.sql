{% snapshot encounter_status_snapshot %}

{{
    config(
        unique_key='ENCOUNTER_ID',
        strategy='check',
        check_cols=['status']
    )
}}

select 
ENCOUNTER_ID,
PATIENT_ID,
ADMIT_DATE,
DISCHARGE_DATE,
DIAGNOSIS_CODE,
STATUS
from {{ref('stg_encounters')}}

{%endsnapshot%}

