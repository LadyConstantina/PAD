from flask import Flask, request, json
import requests
import logging
from pymemcache.client import base

log_format = "%(asctime)s - [%(levelname)s] [%(module)s.%(funcName)s:%(lineno)d]: %(message)s"
logging.basicConfig(format=log_format, level=logging.INFO)
log = logging.getLogger(__name__)

app = Flask(__name__)

cache_1 = base.Client(('localhost',4021))
cache_2 = base.Client(('localhost',4022))
cache_3 = base.Client(('localhost',4023))

CACHE_REGISTRY = {
    1: cache_1,
    2: cache_2,
    3: cache_3
}

NR_OF_CACHE_SERVICES_AVAILABLE = len(CACHE_REGISTRY.keys())

def register():
    requests.get('http://localhost:4010/', headers={"Content-type":"application/json","name":"Cache Leader","host":"localhost","port":'4020'})


def get_cache_service(key):
    cache_int = abs(hash(key)) % NR_OF_CACHE_SERVICES_AVAILABLE + 1
    cache_next_int = cache_int + 1 % NR_OF_CACHE_SERVICES_AVAILABLE + 1
    return (CACHE_REGISTRY[cache_int],CACHE_REGISTRY[cache_next_int])

def get_data_from_cache(user_id, request):
    key = f"{request} for {user_id}".replace(" ","_")
    cache_service_1, cache_service_2 = get_cache_service(key)
    try:
        data = cache_service_1.get(key)
    except:
        log.info(f"Cache {cache_service_1} unavailable. Trying cache {cache_service_2}")
        NR_OF_CACHE_SERVICES_AVAILABLE -= 1
        data = cache_service_2.get(key)
    return data

def save_data_in_cache(user_id,request,data):
    key = f"{request} for {user_id}".replace(" ","_")
    cache_service_1, cache_service_2 = get_cache_service(key)
    cache_service_1.set(key, data, expire = 60)
    cache_service_2.set(key, data, expire = 60)
    return "ok"

@app.route('/', methods=['GET'])
def get_cache():
    body = request.json
    user_id = body["user_id"]
    user_request = body["request"]
    return get_data_from_cache(user_id,user_request)


@app.route('/', methods=["POST"])
def add_cache():
    body = request.json
    user_id = body["user_id"]
    user_request = body["request"]
    data = body["data"]
    return save_data_in_cache(user_id,user_request,data)

@app.route('/heartbeat', methods=['GET'])
def heartbeat():
    return json.dumps("alive")

if __name__ == "__main__":
    register()
    app.run(host='localhost', port=4020, debug=True)