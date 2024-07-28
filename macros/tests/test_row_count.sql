{% test row_count(model, column_name, ref, column_name_ref) %}

WITH row_count_ref AS (
    SELECT COUNT({{ column_name_ref }}) AS row_count_ref
    FROM {{ ref }}
),

row_count_model AS (
    SELECT COUNT({{ column_name }}) AS row_count_model
    FROM {{ model }}
)

SELECT 
    row_count_model.row_count_model,
    row_count_ref.row_count_ref
FROM 
    row_count_model,
    row_count_ref
WHERE 
    row_count_model.row_count_model > row_count_ref.row_count_ref

{% endtest %}