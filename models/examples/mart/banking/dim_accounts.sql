{{
    config(
        materialized='incremental',
        unique_key='account_id'
    )
}}

with source as (

    select
        md5(cast(account_id as varchar)) as account_sk,
        account_id,
        account_type,
        open_date,
        created_at,
        current_timestamp() as updated_at,

        md5(
            concat(
                coalesce(cast(account_id as varchar), ''),
                '|',
                coalesce(account_type, ''),
                '|',
                coalesce(cast(open_date as varchar), '')
            )
        ) as hash_key

    from {{ ref('stg_accounts') }}
)

{% if is_incremental() %}

select
    s.*
from source s
left join {{ this }} t
    on s.account_id = t.account_id

where t.account_id is null
   or s.hash_key <> t.hash_key

{% else %}

select *
from source

{% endif %}