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
    response = requests.get('http://localhost:4010/', headers={"Content-type":"application/json","name":"Gateway","host":"localhost","port":'4011'})
    log.info(response.text)

@app.route('/heartbeat', methods=['GET'])
def heartbeat():
    return json.dumps("alive")



if __name__ == "__main__":
    register()
    app.run(host='localhost', port=4011, debug=True)