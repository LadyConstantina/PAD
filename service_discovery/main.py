from flask import Flask, request, json
import requests
import time
import logging
import threading

log_format = "%(asctime)s - [%(levelname)s] [%(module)s.%(funcName)s:%(lineno)d]: %(message)s"
logging.basicConfig(format=log_format, level=logging.INFO)
log = logging.getLogger(__name__)

app = Flask(__name__)

REGISTERED_APPS = {}

@app.route('/', methods=['GET'])
def get_registered_services():
    service_name = request.headers.get("name")
    if service_name not in REGISTERED_APPS:
        REGISTERED_APPS[service_name] = {"host":request.remote_addr, "port":request.environ.get('REMOTE_PORT')}
    return json.dumps(REGISTERED_APPS)

def monitor_services():
    for service in REGISTERED_APPS.keys():
        response = requests.get(f"{REGISTERED_APPS[service]['host']}:{REGISTERED_APPS[service]['port']}/heartbeat")
        if response.status_code != 200:
            REGISTERED_APPS.pop(service, None)
            log.info(REGISTERED_APPS)
    time.sleep(10)

if __name__ == "__main__":
    threading.Thread(target=monitor_services)
    threading.Thread(target=app.run(host='0.0.0.0', port=4010, debug=True))