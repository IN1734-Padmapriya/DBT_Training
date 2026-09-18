with amt as (
    select * from 
    {{ref ('stg_order')}}
    where status='Delivered'
)
,pivoted as (
    select ORDER_ID,
    {%-set Categorys =['Electronics','Home','Sports','Grocery','Office']-%}

    {% for category in Categorys %}
        sum(case when category ='{{category}}' then amount else 0 end) as {{category}}_amount
        {%- if not loop.last -%}
        ,{% endif %}
        
    {%- endfor -%}
    from amt
    group by ORDER_ID
)
select * from  pivoted

