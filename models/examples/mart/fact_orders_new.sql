{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='ORDER_ID'
) }}

SELECT
    ORDER_ID,
    CUSTOMER_ID,
    CUSTOMER_NAME,
    PRODUCT,
    CATEGORY,
    QUANTITY,

    AMOUNT AS GROSS_AMOUNT,

    DISCOUNT_PCT,

    AMOUNT * DISCOUNT_PCT / 100 AS DISCOUNT_AMOUNT,

    AMOUNT - (AMOUNT * DISCOUNT_PCT / 100) AS NET_AMOUNT,

    STATUS,
    ORDER_DATE,
    CREATED_AT,
    UPDATED_AT

FROM {{ ref('stg_orders') }}

{% if is_incremental() %}

WHERE UPDATED_AT > (
    SELECT MAX(UPDATED_AT)
    FROM {{ this }}
)
{% endif %}