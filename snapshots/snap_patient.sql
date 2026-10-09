
{% snapshot snap_patient %}

{{
    config(
        unique_key='name',
        strategy='check',
        check_cols=['medical_condition']
    )
}}

select
    name,
    age,
    blood_type,
    gender,
    medical_condition,
    date_of_admission
from {{ ref('health_care') }}

{% endsnapshot %}