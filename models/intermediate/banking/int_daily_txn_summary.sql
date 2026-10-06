{{ config(materialized='ephemeral') }}

SELECT
    account_id,
    transaction_date AS transaction_date,

    SUM(CASE
        WHEN amount > 0 THEN amount
        ELSE 0
    END) AS credit_amount,

    SUM(CASE
        WHEN amount < 0 THEN ABS(amount)
        ELSE 0
    END) AS debit_amount

FROM {{ ref('stg_transactions') }}

GROUP BY
    account_id,
    transaction_date