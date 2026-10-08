{% macro date_buckets(column, level='month') %}

    {% if level == 'month' %}

        date_trunc('month', {{ column }})

    {% elif level == 'week' %}

        date_trunc('week', {{ column }})

    {% else %}

        {{ exceptions.raise_compiler_error(
            "Invalid level. Use 'month' or 'week'."
        ) }}

    {% endif %}

{% endmacro %}