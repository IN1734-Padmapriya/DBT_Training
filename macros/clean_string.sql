{% macro clean_string(column,accepted_values=[]) %}
    {% if allowed_values | length > 0 %}

        case
            when lower(trim({{ column }})) in (
                {% for value in allowed_values %}
                    '{{ value | lower }}'
                    {% if not loop.last %}, {% endif %}
                {% endfor %}
            )
            then lower(trim({{ column }}))

            else 'other'
        end

    {% else %}

        lower(trim({{ column }}))

    {% endif %}

{% endmacro %}