{{ config(materialized='view') }}

WITH source AS (
SELECT *

FROM {{ source('globepay', 'globepay_acceptance_report') }}
)

SELECT
    ref AS transaction_id,
    date_time AS transaction_timestamp_tz,
    DATE(date_time) AS transaction_date,
    TO_CHAR(date_time, 'YYYY-mm') AS transaction_year_month,
    TO_CHAR(date_time, 'YYYY') AS transaction_year,
    TO_CHAR(date_time, 'mm') AS transaction_month,
    TO_CHAR(date_time, 'dd') AS transaction_day,
    TO_CHAR(date_time, 'HH24:mm') AS transaction_time,
    TO_CHAR(date_time, 'HH24') AS transaction_hour,
    external_ref AS chargeback_id,
    status AS transaction_status,
    source AS payment_platform,
    state AS transaction_state,
    cvv_provided AS is_cvv_provided,
    amount,
    country,
    currency
    
FROM source