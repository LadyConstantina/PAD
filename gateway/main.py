from flask import Flask, request, json
import requests
import time
import logging
import threading
from pymemcache.client import base

log_format = "%(asctime)s - [%(levelname)s] [%(module)s.%(funcName)s:%(lineno)d]: %(message)s"
logging.basicConfig(format=log_format, level=logging.INFO)
log = logging.getLogger(__name__)

app = Flask(__name__)

REGISTERED_APPS = dict()

cache = base.Client(('localhost',4012))

def get_data_from_cache(user_id, request):
    key = f"{request} for {user_id}".replace(" ","_")
    data = cache.get(key)
    return data

def save_data_in_cache(user_id,request,data):
    key = f"{request} for {user_id}".replace(" ","_")
    cache.set(key, data)

def register():
    response = requests.get('http://localhost:4010/', headers={"Content-type":"application/json","name":"Gateway","host":"localhost","port":'4011'})
    resp = response.json()
    for client in resp.keys():
        REGISTERED_APPS[client] = resp[client]

@app.route('/heartbeat', methods=['GET'])
def heartbeat():
    return json.dumps("alive")

@app.route('/new_service', methods=["POST"])
def add_new_service():
    resp = request.json
    for client in resp:
        REGISTERED_APPS[client] = resp[client]

@app.route('/schedule', methods=['GET'])
def get_schedule():
    cache_data = get_data_from_cache(1,"GET /schedule")
    if cache_data == None:
        # send request to MS
        data = json.dumps({"schedule":None})
        log.info(f"Set to cache {data}")
        save_data_in_cache(1,"GET /schedule",data)
        return data
    log.info("Got from cache")
    return cache_data

@app.route('/register', methods=['POST'])
def register_client():
    if "Scheduler" not in REGISTERED_APPS.keys():
        return "Service not available"
    host = REGISTERED_APPS["Scheduler"]["host"]
    port = REGISTERED_APPS["Scheduler"]["port"]
    body = request.json
    response = requests.post(url = f"http://{host}:{port}/api/register", json=body)
    client_tocken = response.json()
    log.info(client_tocken)
    return client_tocken

@app.route('/login', methods=['POST'])
def login_client():
    if "Scheduler" not in REGISTERED_APPS.keys():
        return "Service not available"
    host = REGISTERED_APPS["Scheduler"]["host"]
    port = REGISTERED_APPS["Scheduler"]["port"]
    body = request.json
    response = requests.post(url = f"http://{host}:{port}/api/login", json=body)
    client_tocken = response.json()
    log.info(client_tocken)
    return client_tocken

@app.route('/schedule', methods=['POST'])
def create_schedule():
    log.info("HERE")
    if "Scheduler" not in REGISTERED_APPS.keys():
        return "Service not available"
    host = REGISTERED_APPS["Scheduler"]["host"]
    port = REGISTERED_APPS["Scheduler"]["port"]
    body = request.json
    log.info("Sending request over")
    response = requests.post(url = f"http://{host}:{port}/api/schedule", json=body)
    #log.info(schedule)
    return response.json()

if __name__ == "__main__":
    register()
    app.run(host='localhost', port=4011, debug=True)