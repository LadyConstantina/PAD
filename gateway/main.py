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


def register():
    response = requests.get('http://localhost:4010/', headers={"Content-type":"application/json","name":"Gateway"})
    log.info(response)

@app.route('/', methods=['GET'])
def get_registered_services():
    service_name = request.headers.get("name")
    if service_name not in REGISTERED_APPS:
        REGISTERED_APPS[service_name] = {"host":request.remote_addr, "port":request.environ.get('REMOTE_PORT')}
    return json.dumps(REGISTERED_APPS)


if __name__ == "__main__":
    register()
    app.run(host='0.0.0.0', port=4011, debug=True)