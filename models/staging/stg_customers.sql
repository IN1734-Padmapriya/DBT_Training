select
    customer_id,
    customer_name,
    city,
    email,
    created_at,
    updated_at
from {{ ref('customers') }}