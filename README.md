# deel_globepay_project

This dbt project aims to model data from Deel client's card transactions. The data sources are given by Globepay, an industry-leading global payment processor.

## 1. Preliminary data exploration

There are 2 main reports that are the data sources of this project. Both are provided by Globepay:
- Globepay Acceptance Report
- Globepay Chargeback Report

### 1.1 Globepay Acceptance Report

This report brings information about card transactions with the following columns:
- EXTERNAL_REF: An external key (string) used to identify the chargeback operation
- STATUS: A status value to the transaction (TRUE/FALSE)
- SOURCE: The name of the processing plataform (GLOBALPAY)
- REF: A unique key (string) used to identify the transaction 
- DATE_TIME: The timestamp of the transaction
- STATE: The binary state of the transaction (Accepted or Declined)
- CVV_PROVIDED: Informs if the CVV was provided (TRUE/FALSE)
- AMOUNT: The amount that has been charged from the card
- COUNTRY: The two-character ISO country code of the card
- CURRENCY: The three-character ISO currency code
- RATES: JSON with the exchange rate used. Funds are settled in USD.

**Globepay Acceptance Report Schema**
 ![image](https://github.com/user-attachments/assets/f0a85335-e6ac-49c5-8e82-194ff416e268)

**Number of rows:** 5400 <br>
**Size:** 371 KB

### 1.2 Globepay Chargeback Report

This report brings information about transactions chargeback with the following columns:
- EXTERNAL_REF: A key (string) that can be used to link the chargeback operation with the card transaction
- CHARGEBACK: When TRUE, means the transaction has been chargedback and the amount has been refunded to the cardholder
- SOURCE: The name of the processing plataform (GLOBALPAY)
- STATUS: A status value to the chargeback operation (TRUE/FALSE)

**Globepay Chargeback Report Schema**

![image](https://github.com/user-attachments/assets/89a97545-011c-4993-8af3-d0d268433a7e)

**Number of rows:** 5400 <br>
**Size:** 371 KB

## 2. Summary of the model architecture

The architecture was built using Snowflake and dbt. 

Globepay reports are stored in snowflake as raw data. Then, they are used to build dbt models, which are transformed tested, generating a table that is loaded back to Snowflake.

The structure of this dbt project's models folder followed the [dbt best practices documentation](https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview):

- models
   - staging (views)
       - stg_globepay__chargebacks: data from the chargeback report with new column aliases
       - stg_globepay__transactions: data from the acceptance report with new column aliases and timestamp/date transformation
       - stg_globepay__transaction_rates: data from the acceptance report with a flattened 
    - intermediate (ephemeral)
       - int_card_transactions
    - marts (table)
       - card_transactions

The staging models are available as views on Snowflake and the mart **card_transactions** is stored as a table. They are in the GLOBEPAY database with two possible schemas:
- dbt_production: schema to be used by data analysts to perform analyzes and build dashboards
- dbt_sandbox: schema to be used for testing and development

Those schemas are associated to two different dbt profiles that are defined locally as "dev" and "prod".

## 3. Lineage graphs

![image](https://github.com/user-attachments/assets/06217a9b-e21f-4694-9447-39787076a2a9)

## 4. Tips around macros, data validation, and documentation

### 4.1 Column descriptions

All columns descriptions can be found at the schema.yml files in the models folder:
- [staging schema file](https://github.com/thalleslemos/deel_globepay_project/blob/main/models/staging/schema.yml)
- [intermediate schema file](https://github.com/thalleslemos/deel_globepay_project/blob/main/models/intermediate/schema.yml)
- [marts schema file](https://github.com/thalleslemos/deel_globepay_project/blob/main/models/marts/schema.yml)

### 4.2 Data validation

Most of the data tests applied in the models are the "not_null" and "unique" tests for the primary keys. Feel free to check the [dbt tests documentation](https://docs.getdbt.com/docs/build/data-tests) to learn more about them.

Even so, the "accepted values" test is being used with the STATE column in order to check if its value is "ACCEPTED" or "DECLINED" only.

There is also a [generic data test in the macros folder](https://github.com/thalleslemos/deel_globepay_project/blob/main/macros/tests/test_row_count.sql) that counts the records of a specified column from the model being tested and compare it with the count of a specified column from a specified reference.

This is being used to test if the intermediate model [int_card_transactions](https://github.com/thalleslemos/deel_globepay_project/blob/main/models/intermediate/int_card_transactions.sql) has a smaller or equal number of records when compared to the staging model [stg_globepay__transactions](https://github.com/thalleslemos/deel_globepay_project/blob/main/models/staging/stg_globepay__transactions.sql), since the intermediate model cannot have more transaction_id records than its own source.

### 4.3 Documentation

Useful documentation can be found here:
- [dbt documentation](https://docs.getdbt.com/docs/build/documentation)
- [Snowflake documentation](https://docs.snowflake.com/)

## 5. Business questions

Some business questions related to this project are answered [here](https://github.com/thalleslemos/deel_globepay_project/blob/main/docs/business_questions.md).
