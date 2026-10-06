SELECT
    UPPER(transaction_id) AS transaction_id,
    account_id,
    CAST(transaction_date AS DATE) AS transaction_date,
    ROUND(amount,2) as amount,
    LOWER(transaction_type) AS transaction_type,
    description
FROM {{ ref('bank_transactions') }}