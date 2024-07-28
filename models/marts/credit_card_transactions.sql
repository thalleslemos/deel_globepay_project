{{ config(materialized='table') }}

SELECT *

FROM {{ ref('int_credit_card_transactions') }}