{{ config(
    materialized='incremental',
    unique_key='customer_id'
) }}

select
    customer_id,
    customer_name,
    city,
    email,
    created_at,
    updated_at
from {{ ref('stg_customers') }}

{% if is_incremental() %}

where updated_at > (
    select max(updated_at)
    from {{ this }}
)

{% endif %}