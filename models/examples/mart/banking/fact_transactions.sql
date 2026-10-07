{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='transaction_id'
    )
}}

with txns as (

    select
        txn.transaction_id,
        md5(cast(txn.transaction_id as varchar)) as txn_sk,
        txn.transaction_type,
        txn.transaction_date,
        txn.amount,
        ac.account_sk,

        current_timestamp() as updated_at,

        {% if is_incremental() %}
            coalesce(t.created_at, current_timestamp()) as created_at
        {% else %}
            current_timestamp() as created_at
        {% endif %}

    from {{ ref('stg_transactions') }} txn

    join {{ ref('dim_accounts') }} ac
        on txn.account_id = ac.account_id

    {% if is_incremental() %}
    left join {{ this }} t
        on txn.transaction_id = t.transaction_id
    {% endif %}
)

select *
from txns