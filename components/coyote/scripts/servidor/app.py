from flask import Flask, render_template, request, redirect, url_for, send_from_directory, send_file, jsonify
import os
import datetime
import subprocess
from flask_socketio import SocketIO, emit, send
import eventlet
from flask_cors import CORS
import threading
import json
from dotenv import load_dotenv

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})
socketio = SocketIO(app, async_mode='eventlet')


load_dotenv()
test_dir = os.getenv("TEST_DIR")
output_dir = os.getenv("OUTPUT_DIR")
logs_dir = os.getenv("LOGS_DIR")


# **** Lanzador de scripts ******


def get_yaml_files():
    """Obtiene una lista de todos los archivos YAML en la carpeta de pruebas"""
    files = []
    for filename in os.listdir(test_dir):
        if filename.endswith(".yaml"):
            files.append(filename)
    return files


@app.route('/')
def index():
    """Página principal que muestra la lista de archivos YAML"""
    files = get_yaml_files()
    return render_template('index.html', files=files, os=os)


def run_logs(filename, testid):
    folder_name = filename.replace(".yaml", "")
    out_file_name = folder_name + "_" + testid

    if not os.path.exists(os.path.join(output_dir, folder_name)):
        os.makedirs(os.path.join(output_dir, folder_name))
    output_file = os.path.join(
        output_dir, folder_name, f"{out_file_name}.html")
    output_json = os.path.join(
        output_dir, folder_name, f"{out_file_name}.json")
    log_file = os.path.join(
        logs_dir, f"{out_file_name}.log")

    # cmd = f"mkdir -p /tmp/{{out_file_name}}; cd /tmp/{{out_file_name}}; coyote -c '{os.path.join(test_dir, filename)}' -out {output_file} -json-out {output_json}  > {log_file} 2>&1"
    cmd = f"mkdir -p /tmp/{{out_file_name}}; cd /tmp/{{out_file_name}}; coyote -c '{os.path.join(test_dir, filename)}' -out {output_file} -json-out {output_json} &"

    with open(log_file, 'w+') as lf:
        process = subprocess.Popen(
            cmd, stdout=lf, shell=True, stderr=lf)


def start_run_thread(filename, testid):
    print("Se lanza el thread")
    thread = threading.Thread(target=run_logs, args=(filename, testid))
    thread.start()
    thread.join()
    print("Fin")


@ app.route('/run', methods=['POST'])
def run_test():
    """Ejecuta el comando Coyote con el archivo YAML seleccionado"""
    filename = request.form['filename']
    print("Se va a ejecutar el test: " + filename)
    testid = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    out_file_name = filename.replace(".yaml", "") + "_" + testid
    start_run_thread(filename, testid)
    return redirect(url_for('logs', log_file=f"{out_file_name}.log"))
    return render_template('logs.html', log_file=f"{out_file_name}.log")


# ****** Visor de ejecuciones **********
def sort_files_by_date_desc(json_files):
    sorted_files = sorted(json_files, key=lambda x: x['Date'], reverse=True)
    return sorted_files


def parse_json_files(output_dir, path):
    json_files_dir = os.path.join(output_dir, path)
    json_files = [f for f in os.listdir(json_files_dir) if f.endswith('.json')]
    results = []
    for json_file in json_files:
        with open(os.path.join(json_files_dir, json_file)) as f:
            data = json.load(f)
            errors = data.get('Errors', 0)
            successful = data.get('Successful', 0)
            total_tests = data.get('TotalTests', 0)
            total_time = data.get('TotalTime', 0)
            date = data.get('Date', '')
            ok = errors <= 0
            html = f'/ejecuciones/{path}/{json_file[:-5]}.html'
            json_path = f'/ejecuciones/{path}/{json_file}'
            result = {
                'Titulo': json_file[:-5],
                'Errors': errors,
                'Successful': successful,
                'TotalTests': total_tests,
                'TotalTime': total_time,
                'Date': date,
                'OK': ok,
                'html': html,
                'json': json_path
            }
            results.append(result)
    return results


@ app.route('/ejecuciones/<path:path>')
def serve_file(path):
    full_path = os.path.join(output_dir, path)

    if os.path.isdir(full_path):
        out = sort_files_by_date_desc(parse_json_files(output_dir, path))
        return render_template('list_filesx.html', tests=out)
    else:
        return send_file(full_path)


@app.route('/borrar', methods=['POST'])
def borrar_archivos():
    # obtenemos el nombre del archivo a borrar desde el cuerpo de la petición
    nombre_archivo = request.json['nombre_archivo']

    # construimos la ruta completa de los archivos a borrar
    path_html = os.path.join(output_dir, nombre_archivo.split("_")[
                             0], nombre_archivo + '.html')
    path_json = os.path.join(output_dir, nombre_archivo.split("_")[
                             0], nombre_archivo + '.json')

    path_log = os.path.join(logs_dir, nombre_archivo + '.log')

    print(f"Tratando de eliminar test: {path_html}")

    # eliminamos los archivos si existen
    if os.path.exists(path_html):
        os.remove(path_html)
    if os.path.exists(path_json):
        os.remove(path_json)
    if os.path.exists(path_log):
        os.remove(path_log)

    # devolvemos una respuesta indicando que se eliminaron los archivos
    return jsonify({'mensaje': 'Se ha ejecutado el borrado'}), 200


@ app.route('/ejecuciones')
def serve_directoryx():
    print("En el servidor")
    path = request.args.get('path', '')
    full_path = os.path.join(output_dir, path)
    files = os.listdir(full_path)
    return f'''
        <ul>
        {''.join(f'<li><a href="/ejecuciones/{os.path.join(path, file)}">{file}</a></li>' for file in files)}
        </ul>
    '''

# ******* Visor de logs *********


@ app.route('/logs/<log_file>')
def logs(log_file):
    print("Solicitud a logs")
    log_path = os.path.join(logs_dir, log_file)
    if not os.path.isfile(log_path):
        return "Log file not found"

    with open(log_path, 'r') as lf:
        lines = lf.readlines()
        log_lines = [line.strip("\\\\n") for line in lines]

    return render_template('logs.html', test=log_file.split("_")[0], report=log_file.replace('.log', '.html'), log_file=log_file, log_lines="</br>".join(log_lines))


if __name__ == '__main__':
    eventlet.monkey_patch()
    socketio.run(app, host='0.0.0.0', port=5002)
