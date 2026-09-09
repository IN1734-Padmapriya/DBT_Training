with 

source as (

    select * from {{ source('myschema', 'fact_orders') }}

),

renamed as (

    select
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
        shipping_days,
        gross_amount,
        discount_pct,
        discount_amount,
        net_amount,
        status,
        order_category,
        notes

    from source

)

select * from renamed