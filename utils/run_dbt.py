import os
from dbt.cli.main import dbtRunner


def run_dbt(cli_args: list = None):

    dbt_path = f"{os.getcwd()}/dbt/sumup_thc"

    os.chdir(dbt_path)
    os.environ["DBT_PROFILES_DIR"] = f"./.."

    runner = dbtRunner()
    result = runner.invoke(cli_args)

    os.chdir(f'{os.getcwd()}/../..')
