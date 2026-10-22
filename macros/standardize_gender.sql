{% macro standardize_gender(column)%}

case
  when lower(trim({{column}})) in ('m','male') then 'male'
  when lower(trim({{column}})) in ('f','female') then 'female'
  else 'unknown'
end 

{%endmacro%}