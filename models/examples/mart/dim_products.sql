{{ config(
    materialized='incremental',
    unique_key='product_id'
) }}

with source_data as (

    select
        product_id,
        product_name,
        category,
        price,
        created_at,
        updated_at,

        md5(
            concat(
                coalesce(product_name, ''),
                '|',
                coalesce(category, ''),
                '|',
                coalesce(price::varchar, '')
            )
        ) as record_hash

    from {{ ref('stg_products') }}

)

{% if is_incremental() %}

select s.*
from source_data s

left join {{ this }} t
    on s.product_id = t.product_id

where t.product_id is null
   or s.record_hash <> t.record_hash

{% else %}

select *
from source_data

{% endif %}