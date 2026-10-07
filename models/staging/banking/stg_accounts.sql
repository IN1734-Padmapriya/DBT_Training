SELECT
    UPPER(account_id) AS account_id,
    LOWER(account_type) AS account_type,
    CAST(open_date AS DATE) AS open_date,
    balance,
    status,
    CURRENT_TIMESTAMP() AS created_at
FROM {{ ref('bank_accounts') }}