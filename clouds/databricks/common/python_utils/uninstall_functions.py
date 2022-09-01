import os
from databricks import sql


python_util_path = os.path.dirname(os.path.realpath(__file__))

def get_uninstall_for_module(module_path, queries_list):
    database = os.getenv("DB_SCHEMA")
    _, _, functions = next(os.walk(module_path))
    for function in functions:
        if not function.endswith('.sql'):
            continue
        function_name = function[:-4]
        queries_list.append(f"DROP FUNCTION IF EXISTS {database}.{function_name};")

def run_query(queries):
    with sql.connect(server_hostname = os.getenv("DATABRICKS_SERVER_HOSTNAME"),
                    http_path       = os.getenv("DATABRICKS_HTTP_PATH"),
                    access_token    = os.getenv("DATABRICKS_TOKEN")) as connection:

        with connection.cursor() as cursor:
            for query in queries:
                print(query)
                cursor.execute(query)

if __name__ == '__main__':
    print("start")
    sql_path = os.path.join(
        python_util_path, 
        '..', 
        '..', 
        'modules',
        'sql'
    )
    modules = os.listdir(sql_path)
    print(sql_path, modules)
    queries_list = []
    for module in modules:
        module_path = os.path.join(
            sql_path,
            module
        )
        get_uninstall_for_module(module_path, queries_list)
    print(queries_list)
    run_query(queries_list)
    