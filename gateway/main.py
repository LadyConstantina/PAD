from flask import Flask, request, json
import requests
import time
import logging
import threading
import memcache

log_format = "%(asctime)s - [%(levelname)s] [%(module)s.%(funcName)s:%(lineno)d]: %(message)s"
logging.basicConfig(format=log_format, level=logging.INFO)
log = logging.getLogger(__name__)

app = Flask(__name__)

REGISTERED_APPS = {}

cache = memcache.Client(['localhost:4012'], debug=0)

def get_data_from_cache(user_id, request):
    
    key = f"{request} for {user_id}".replace(" ","_")
    log.info(f"get {key}")
    data = cache.get(key)
    log.info(data)
    return data

def save_data_in_cache(user_id,request,data):
    key = f"{request} for {user_id}".replace(" ","_")
    log.info(key)
    cache.set(key, data, time=300)

def register():
    response = requests.get('http://localhost:4010/', headers={"Content-type":"application/json","name":"Gateway","host":"localhost","port":'4011'})
    log.info(response.text)

@app.route('/heartbeat', methods=['GET'])
def heartbeat():
    return json.dumps("alive")

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



if __name__ == "__main__":
    register()
    app.run(host='localhost', port=4011, debug=True)