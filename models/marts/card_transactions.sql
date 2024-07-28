{{ config(materialized='table') }}

SELECT *

FROM {{ ref('int_card_transactions') }}