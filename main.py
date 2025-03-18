from utils.read_csv import read_csv
from utils.run_dbt import run_dbt
from utils.update_snapshot_timestamps import update_snapshot_timestamps

if __name__ == '__main__':
    read_csv(file_name='raw_csv/device.csv', table_name='device', schema_name='raw')
    read_csv(file_name='raw_csv/store.csv', table_name='store', schema_name='raw')
    read_csv(file_name='raw_csv/transaction.csv', table_name='transaction', schema_name='raw')

    run_dbt(cli_args=['snapshot'])
    update_snapshot_timestamps()  # This is a workaround for the first execution of the pipeline, see README
    run_dbt(cli_args=['build'])
