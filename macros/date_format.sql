{% macro format_date(column_name, granularity='hour') %}
    date_trunc('{{ granularity }}', to_timestamp({{ column_name }}, 'YYYY-MM-DD"T"HH24:MI:SS.FF'))
{% endmacro %}
