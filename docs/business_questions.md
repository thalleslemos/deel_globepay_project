# Business questions

This document will be used to register some answers for business questions related to the Globepay card transactions table.

## 1. What is the acceptance rate over time?

To answer this, we need a definition for the acceptance rate. Let's define it as (total accepted transactions)/(total transactions) during a defined period. It can be calculated daily, monthly, etc.
  
### 1.1 Daily acceptance rate
  
  ```sql
SELECT 

transaction_date,
COUNT(
CASE
    WHEN transaction_state = 'ACCEPTED' THEN transaction_id
    ELSE NULL
END)/COUNT(transaction_id) AS acceptance_rate

FROM globepay.dbt_production.card_transactions

GROUP BY transaction_date
ORDER BY transaction_date
```
</details>

**Snowflake chart of daily acceptance rate**
<div style="text-align: center;">
<img width="922" alt="image" src="https://github.com/user-attachments/assets/2517d81c-c467-406d-a96d-7809ad3b9d35">
</div>

### 1.2 Monthly acceptance rate
  
  ```sql
SELECT 

transaction_year_month,
COUNT(
CASE
    WHEN transaction_state = 'ACCEPTED' THEN transaction_id
    ELSE NULL
END)/COUNT(transaction_id) AS acceptance_rate

FROM globepay.dbt_production.card_transactions

GROUP BY transaction_year_month
ORDER BY transaction_year_month
```

**Snowflake results table for monthly acceptance rate** <br>
<div style="text-align: center;">
<img width="584" alt="image" src="https://github.com/user-attachments/assets/024c6c27-9240-495e-8e49-44444d30202c">
</div>

## 2. List the countries where the amount of declined transactions went over $25M

In order to do that, we must aggregate the DECLINED transactions by country and sum the amount_usd value. Then, we must filter the countries whose total amounts exceeds $25M.

```sql
SELECT 

country,
ROUND(SUM(amount_usd)/1000000,2) AS total_amount_million_usd

FROM globepay.dbt_production.card_transactions

WHERE transaction_state = 'DECLINED'

GROUP BY 1

HAVING total_amount_million_usd > 25

ORDER BY total_amount_million_usd DESC
```
**Snowflake bar chart of countries with over $25M in declined transactions**
<div style="text-align: center;">
<img width="480" alt="image" src="https://github.com/user-attachments/assets/8f91091c-7160-43f5-993c-0fa068b15ec7">
</div>

## 3. Which transactions are missing chargeback data?

If a transaction has no chargeback data, the column **is_chargedback** from the card_transactions table should be NULL.

```sql
SELECT transaction_id

FROM GLOBEPAY.DBT_PRODUCTION.CARD_TRANSACTIONS

WHERE is_chargedback IS NULL
```
This query produces no results. So, there are no transactions with missing chargeback data.
