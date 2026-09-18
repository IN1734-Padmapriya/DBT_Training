select
    
    order_id as order_id,
    category,
    status,
    -- amount is stored in cents, convert it to dollars
    {{ cents_to_dollars('amount', 4) }} as amount
    
from {{ ref("stg_order")}}