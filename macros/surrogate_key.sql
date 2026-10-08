{% macro surrogate_key(col) %}
   upper(
    {{dbutlis.generate_surrogate_keys(cols)}}
   )
{%endmacro%}