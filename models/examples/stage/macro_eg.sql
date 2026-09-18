select
    
    orderid as order_id,
    category,
    status,
    -- amount is stored in cents, convert it to dollars
    {{ cents_to_dollars('amount', 4) }} as amount,
    created as created_at
from {{ ref("stg_order")}}