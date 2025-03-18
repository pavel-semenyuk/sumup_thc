# SumUp Take Home Challenge
This repository contains an ETL pipeline to load transaction, device and store data to a PostgreSQL database to answer the following questions:
- Top 10 stores per transacted amount
- Top 10 products sold
- Average transacted amount per store typology and country
- Percentage of transactions per device type
- Average time for a store to perform its 5 first transactions

### Prerequisites
To install dependencies, run `pip install -r requirements.txt`. 
Change `dbt/profiles.yml` and `config/postgres.yml` files to include credentials to connect to the PostgreSQL database.

### Database structure
The resulting database consists of 4 schemas:
- `raw`: Data from `csv` files. 
- `staging`: Historical data.
- `intermediate`: Joined data
- `mart`: Aggregate tables and view with metrics

### Process outline
- The `csv` files are loaded into the `raw` layer using `psycopg2` library.
- All the transformations are in dbt:
  - `staging` models contain incrementally loaded historical data with transactions
  - Also in the `staging` layer are two snapshots with device and store data.
  - `intermediate` layer has the model with all data joined
  - `mart` layer has aggregate tables (precalculated metrics for product, store and total data) 
  - Also in the `mart` layer we build views that answer questions from the challenge
- dbt models have tests for not-null and uniqueness of primary keys, as well as accepted values tests for fields that can only be equal to a small number of values.

### Assumptions
- In the metrics only `accepted` transactions are accounted for.
- Amounts for all the stores are in the same currency.
- Device and store data is slowly-changing, and each record has validity. This is implemented with the help of `dbt snapshots`.
- The incoming data can have millions of records per day. In order to calculate metrics faster, aggregate tables are used.

### `dbt snapshot` logic
In production environment new records in the snapshotted tables will appear with the corresponding starting timestamp. 
Unfortunately, since snapshots do not support backfilling, when the `dbt snapshot` command is run first time, it will fill the `dbt_valid_from` field with the timestamp of run. 
In order to combat this, a workaround was implemented that manually updates this field. That's why separate `dbt snapshot` and `update_snapshot_timestamps()` calls are included in the `main.py`.
In the production environment, a normal `dbt build` would be enough (since we won't need backfilling of data for snapshots).

### Sensitive data
Input data has fields that contain sensitive information (`card_number` and `cvv`). 
This information is not needed for analytical purposes. Thus, this data is not included in any data layers apart from the `raw`. 
If this information is needed to be used somehow, hashing or other ways of protecting data need to be implemented.

### Possible improvements
There are changes that can be implemented to improve the project (for example, before pushing the project to production):
- The whole pipeline should be implemented in a workflow management system (for example, Airflow) for scheduling, monitoring and logging purposes.
- Documentation can be added directly to dbt models/snapshots.
- More optimized schemas can be implemented for the first layers of the data storage. For example, numerical product_name_id can be created in order to uniquely identify product instead of product_name.
- With more sources of data, a more normalized schema can also be implemented (e.g. locations, customers etc.)
