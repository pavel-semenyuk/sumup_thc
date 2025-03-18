import psycopg2
import yaml


def read_csv(file_name: str, table_name: str, schema_name: str = 'raw', config_path: str = 'config/postgres.yml', csv_sep: str = ';'):
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

    sql = f'TRUNCATE TABLE {schema_name}.{table_name}'

    cursor.execute(sql)

    cursor.execute(f"SET search_path TO {schema_name};")

    with open(file_name, 'r') as csv_file:
        # Skipping the header row
        next(csv_file)
        cursor.copy_from(csv_file, table_name, sep=csv_sep)

    conn.commit()
    cursor.close()
    conn.close()


