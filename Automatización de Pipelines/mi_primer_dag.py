# dags/mi_primer_dag.py
# Guardar este archivo en la carpeta: airflow-docker/dags/

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta


def saludar():
    """Función que imprime un saludo."""
    print("¡Hola desde Airflow!")
    return "Saludo completado"


# Argumentos por defecto para el DAG
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

# Definir DAG usando context manager (mejor práctica)
with DAG(
    "saludo_diario",
    default_args=default_args,
    description="DAG que saluda cada día",
    schedule_interval=timedelta(days=1),  # Ejecutar diariamente
    start_date=datetime(2024, 1, 1),
    catchup=False,  # No ejecutar ejecuciones pasadas
    tags=["ejemplo", "saludo"],
) as dag:

    # Tarea 1: Comando bash
    tarea_bash = BashOperator(
        task_id="tarea_bash",
        bash_command='echo "Ejecutando tarea bash a las $(date)"',
    )

    # Tarea 2: Función Python
    tarea_python = PythonOperator(
        task_id="tarea_python",
        python_callable=saludar,
    )

    # Tarea 3: Esperar (simular procesamiento)
    tarea_esperar = BashOperator(
        task_id="tarea_esperar",
        bash_command="sleep 5",
    )

    # Definir orden de ejecución
    # tarea_bash se ejecuta primero, luego tarea_python, luego tarea_esperar
    tarea_bash >> tarea_python >> tarea_esperar
