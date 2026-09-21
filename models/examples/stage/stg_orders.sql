SELECT
    ORDER_ID,
    CUSTOMER_ID,
    CUSTOMER_NAME,
    PRODUCT,
    CATEGORY,
    QUANTITY,
    AMOUNT,
    DISCOUNT_PCT,
    STATUS,
    ORDER_DATE,
    CREATED_AT,
    UPDATED_AT
FROM {{ ref('raw_orders') }}