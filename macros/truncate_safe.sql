{% macro truncate_safe() %}

    {% if execute %}
        {% set target_relation = this %}

        {% if target_relation is not none and load_relation(target_relation) is not none %}
            TRUNCATE TABLE {{ target_relation }}
        {% else %}
            SELECT 1
        {% endif %}

    {% else %}
        SELECT 1
    {% endif %}

{% endmacro %}