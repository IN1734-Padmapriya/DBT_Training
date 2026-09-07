SELECT
    order_id,
    customer_id,
    customer_name,
    email,
    phone,
    city,
    state,
    product,
    category,

    order_date,
    ship_date,

    DATEDIFF(
        'day',
        order_date,
        ship_date
    ) AS shipping_days,

    amount AS gross_amount,

    discount_pct,

    amount * discount_pct / 100 AS discount_amount,

    amount - (amount * discount_pct / 100) AS net_amount,

    status,

    CASE
        WHEN UPPER(status) = 'DELIVERED'
            THEN 'Completed'

        WHEN UPPER(status) = 'SHIPPED'
            THEN 'In Transit'

        WHEN UPPER(status) = 'PROCESSING'
            THEN 'Pending'

        WHEN UPPER(status) = 'RETURNED'
            THEN 'Returned'

        ELSE 'Other'
    END AS order_category,

    notes

FROM {{ ref('stg_order') }}