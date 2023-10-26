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
    if "Scheduler" not in REGISTERED_APPS.keys():
        return "Service not available"
    host = REGISTERED_APPS["Scheduler"]["host"]
    port = REGISTERED_APPS["Scheduler"]["port"]
    body = request.json
    response = requests.post(url = f"http://{host}:{port}/api/schedule", json=body)
    return response.json()

@app.route('/schedule', methods=['GET'])
def get_schedule():
    body = request.json
    user_id = body["user_id"]
    cache_data = get_data_from_cache(user_id,"GET /schedule")
    if cache_data == None:
        if "Scheduler" not in REGISTERED_APPS.keys():
            return "Service not available"
        host = REGISTERED_APPS["Scheduler"]["host"]
        port = REGISTERED_APPS["Scheduler"]["port"]
        response = requests.get(url = f"http://{host}:{port}/api/schedule?user_id={user_id}")
        data = response.json()
        data = {"schedule":response.json()}
        save_data_in_cache(user_id,"GET /schedule",data)
        return data
    return cache_data

@app.route('/schedule/day', methods=['GET'])
def get_schedule_for_day():
    body = request.json
    user_id = body["user_id"]
    day = body["day"]
    cache_data = get_data_from_cache(user_id,f"GET /schedule/day_{day}")
    if cache_data == None:
        if "Scheduler" not in REGISTERED_APPS.keys():
            return "Service not available"
        host = REGISTERED_APPS["Scheduler"]["host"]
        port = REGISTERED_APPS["Scheduler"]["port"]
        response = requests.get(url = f"http://{host}:{port}/api/schedule/day?user_id={user_id}&day={day}")
        data = response.json()
        data = {"schedule":response.json()}
        save_data_in_cache(user_id,f"GET /schedule/day_{day}",data)
        return data
    return cache_data

@app.route('/schedule/today', methods=['GET'])
def get_schedule_for_today():
    body = request.json
    user_id = body["user_id"]
    cache_data = get_data_from_cache(user_id,f"GET /schedule/today")
    if cache_data == None:
        if "Scheduler" not in REGISTERED_APPS.keys():
            return "Service not available"
        host = REGISTERED_APPS["Scheduler"]["host"]
        port = REGISTERED_APPS["Scheduler"]["port"]
        body = request.json
        response = requests.get(url = f"http://{host}:{port}/api/schedule/today?user_id={user_id}")
        data = response.json()
        data = {"schedule":response.json()}
        save_data_in_cache(user_id,f"GET /schedule/today",data)
        return data
    return cache_data

if __name__ == "__main__":
    register()
    app.run(host='localhost', port=4011, debug=True)