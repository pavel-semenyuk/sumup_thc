import psycopg2
import yaml


def update_snapshot_timestamps(config_path='config/postgres.yml'):

    with open(config_path, 'r') as config_file:
        connection_dict = yaml.safe_load(config_file)

    conn = psycopg2.connect(
        host=connection_dict['host'],
        port=connection_dict['port'],
        user=connection_dict['user'],
        database=connection_dict['database'],
        password=connection_dict['password'],
    )
    cursor = conn.cursor()

    update_device = "update staging.device_snapshot set dbt_valid_from = '2020-01-01 00:00:00'::timestamp;"
    update_store = "update staging.store_snapshot set dbt_valid_from = '2020-01-01 00:00:00'::timestamp;"

    cursor.execute(update_device)
    cursor.execute(update_store)

    conn.commit()
    cursor.close()
    conn.close()