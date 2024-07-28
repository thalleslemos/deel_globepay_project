{{ config(materialized='view') }}

WITH source AS (
SELECT *

FROM {{ source('globepay', 'globepay_acceptance_report') }}
)

SELECT
    CONCAT(ref, flattened.key) AS id,
    ref AS transaction_id,
    flattened.key AS currency,
    flattened.value AS exchange_rate_to_usd
    
FROM source,
    LATERAL FLATTEN(input => RATES) AS flattened