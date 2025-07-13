
from airflow.models.dag import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

with DAG(
    dag_id='dbt_project_full_run',
    start_date=datetime(2023, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=['dbt', 'data_warehouse', 'example'],
) as dag:
    # dbt debug pour vérifier la connexion et la configuration
    dbt_debug = BashOperator(
        task_id='dbt_debug',
        bash_command='cd $${DBT_PROFILES_DIR}/enterprise_dw && dbt debug --profile enterprise_dw',
    )

    # dbt seed pour charger les données statiques (si seeds/ existe)
    dbt_seed = BashOperator(
        task_id='dbt_seed',
        bash_command='cd $${DBT_PROFILES_DIR}/enterprise_dw && dbt seed --profile enterprise_dw',
    )

    # dbt run pour exécuter toutes les transformations
    dbt_run = BashOperator(
        task_id='dbt_run_all_models',
        bash_command='cd $${DBT_PROFILES_DIR}/enterprise_dw && dbt run --profile enterprise_dw',
    )

    # dbt test pour exécuter les tests de qualité des données
    dbt_test = BashOperator(
        task_id='dbt_run_tests',
        bash_command='cd $${DBT_PROFILES_DIR}/enterprise_dw && dbt test --profile enterprise_dw',
    )

    # Définir l'ordre des tâches
    dbt_debug >> dbt_seed >> dbt_run >> dbt_test
