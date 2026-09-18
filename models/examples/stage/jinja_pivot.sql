WITH amt AS (
    SELECT *
    FROM {{ ref('stg_order') }}
    WHERE status = 'Delivered'
),

pivoted AS (
    SELECT
    ORDER_ID,
    {%- set Categorys = ['Electronics', 'Home', 'Sports', 'Grocery', 'Office'] %}
    {%- for category in Categorys %}
        SUM(CASE WHEN category = '{{ category }}'
                 THEN amount ELSE 0 END) AS {{ category }}_amount{% if not loop.last %},{% endif %}
    {%- endfor %}
FROM amt
GROUP BY ORDER_ID
)

SELECT *
FROM pivoted