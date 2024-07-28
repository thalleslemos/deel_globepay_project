{{ config(materialized='view') }}

WITH source AS ( 
SELECT *

FROM {{ source('globepay', 'globepay_chargeback_report') }}
)

SELECT
    external_ref AS chargeback_id,
    status AS chargeback_status,
    source AS payment_platform,
    chargeback AS is_chargedback

FROM source