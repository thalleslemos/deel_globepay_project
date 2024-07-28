{{ config(materialized='ephemeral') }}

SELECT
    transactions.transaction_id,
    transactions.chargeback_id,
    transactions.payment_platform,
    transactions.transaction_timestamp_tz,
    transactions.transaction_date,
    transactions.transaction_year_month,
    transactions.transaction_year,
    transactions.transaction_month,
    transactions.transaction_day,
    transactions.transaction_time,
    transactions.transaction_hour,
    transactions.transaction_state,
    transactions.is_cvv_provided,
    transactions.amount,
    transactions.country,
    transactions.currency,
    transactions.transaction_status,
    t_rates.exchange_rate_to_usd,
    (transactions.amount * t_rates.exchange_rate_to_usd) AS amount_usd,
    chargebacks.is_chargedback,
    chargebacks.chargeback_status

FROM {{ ref('stg_globepay__transactions') }} AS transactions 

LEFT JOIN {{ ref('stg_globepay__transaction_rates') }} AS t_rates 
    ON transactions.transaction_id = t_rates.transaction_id
    AND transactions.currency = t_rates.currency

LEFT JOIN {{ ref('stg_globepay__chargebacks') }} AS chargebacks 
    ON transactions.chargeback_id = chargebacks.chargeback_id