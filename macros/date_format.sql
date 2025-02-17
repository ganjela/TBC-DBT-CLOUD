{% macro format_date(column_name, granularity='hour') %}
    date_trunc('{{ granularity }}', {{ column_name }})
{% endmacro %}
