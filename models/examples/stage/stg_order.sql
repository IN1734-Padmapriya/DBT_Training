SELECT
    ORDER_ID AS order_id,

    UPPER(TRIM(CUSTOMER_ID)) AS customer_id,

    INITCAP(TRIM(FULL_NAME)) AS customer_name,

    LOWER(TRIM(EMAIL)) AS email,

    TRIM(PHONE) AS phone,

    INITCAP(TRIM(CITY)) AS city,

    UPPER(TRIM(STATE)) AS state,

    TRIM(PRODUCT) AS product,

    INITCAP(TRIM(CATEGORY)) AS category,

    CASE
        WHEN TRIM(ORDER_DATE) LIKE '____-__-__'
            THEN TRY_TO_DATE(TRIM(ORDER_DATE), 'YYYY-MM-DD')

        WHEN TRIM(ORDER_DATE) LIKE '____/__/__'
            THEN TRY_TO_DATE(TRIM(ORDER_DATE), 'YYYY/MM/DD')

        WHEN TRIM(ORDER_DATE) LIKE '__/__/____'
            THEN TRY_TO_DATE(TRIM(ORDER_DATE), 'MM/DD/YYYY')

        WHEN TRIM(ORDER_DATE) LIKE '____-__-__ __:__'
            THEN TRY_TO_DATE(
                TRIM(ORDER_DATE),
                'YYYY-MM-DD HH24:MI'
            )

        WHEN TRIM(ORDER_DATE) LIKE '%,%'
            THEN TRY_TO_DATE(
                TRIM(ORDER_DATE),
                'MMMM DD, YYYY'
            )

        ELSE NULL
    END AS order_date,

    CASE
        WHEN TRIM(SHIP_DATE) LIKE '____-__-__'
            THEN TRY_TO_DATE(TRIM(SHIP_DATE), 'YYYY-MM-DD')

        WHEN TRIM(SHIP_DATE) LIKE '____/__/__'
            THEN TRY_TO_DATE(TRIM(SHIP_DATE), 'YYYY/MM/DD')

        WHEN TRIM(SHIP_DATE) LIKE '__/__/____'
            THEN TRY_TO_DATE(TRIM(SHIP_DATE), 'MM/DD/YYYY')

        WHEN TRIM(SHIP_DATE) LIKE '%,%'
            THEN TRY_TO_DATE(
                TRIM(SHIP_DATE),
                'MMMM DD, YYYY'
            )

        ELSE NULL
    END AS ship_date,

    AMOUNT AS amount,

    DISCOUNT_PCT AS discount_pct,

    INITCAP(TRIM(STATUS)) AS status,

    TRIM(NOTES) AS notes

FROM {{ source('Orders', 'ORDERS') }}