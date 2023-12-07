from flask import Flask, request, json
import requests
from requests.models import Response
import logging

log_format = "%(asctime)s - [%(levelname)s] [%(module)s.%(funcName)s:%(lineno)d]: %(message)s"
logging.basicConfig(format=log_format, level=logging.INFO)
log = logging.getLogger(__name__)

app = Flask(__name__)

REGISTERED_APPS = dict()


@app.route('/heartbeat', methods=['GET'])
def heartbeat():
    return json.dumps("alive")

@app.route('/new_service', methods=["POST"])
def add_new_service():
    REGISTERED_APPS = request.json
    return "ok"

@app.route('/register', methods=['POST'])
def register_client():
    if "Scheduler" not in REGISTERED_APPS.keys():
        return "Service not available"
    body = request.json
    response = post_routing_agent("api/register", body, "Scheduler")
    client_tocken = response.json()
    log.info(client_tocken)
    return client_tocken

@app.route('/login', methods=['POST'])
def login_client():
    if "Scheduler" not in REGISTERED_APPS.keys():
        return "Service not available"
    body = request.json
    response = post_routing_agent("api/login", body, "Scheduler")
    client_tocken = response.content
    return client_tocken

@app.route('/schedule', methods=['POST'])
def create_schedule():
    if "Scheduler" not in REGISTERED_APPS.keys():
        return "Service not available"
    body = request.json
    response = post_routing_agent("api/schedule", body, "Scheduler")
    return response.json()

@app.route('/schedule', methods=['GET'])
def get_schedule():
    body = request.json
    user_id = body["user_id"]
    host_cache = REGISTERED_APPS["Cache Leader"][0]["host"]
    port_cache = REGISTERED_APPS["Cache Leader"][0]["port"]
    response = requests.get(url = f"http://{host_cache}:{port_cache}/", json={"user_id":user_id,"request":"GET /schedule"})
    log.info(response.content)
    cache_data = response.json()["data"]
    if cache_data == None:
        if "Scheduler" not in REGISTERED_APPS.keys():
            return "Service not available"
        response = get_routing_agent(f"api/schedule?user_id={user_id}","Scheduler")
        data = response.json()
        data = {"schedule":data}
        requests.post(url = f"http://{host_cache}:{port_cache}/", json={"user_id":user_id,"request":"GET /schedule","data":data})
        return data
    return cache_data

@app.route('/schedule/day', methods=['GET'])
def get_schedule_for_day():
    body = request.json
    user_id = body["user_id"]
    day = body["day"]
    host_cache = REGISTERED_APPS["Cache Leader"][0]["host"]
    port_cache = REGISTERED_APPS["Cache Leader"][0]["port"]
    response = requests.get(url = f"http://{host_cache}:{port_cache}/", json={"user_id":user_id,"request":f"GET /schedule/day_{day}"})
    cache_data = response.json()["data"]
    if cache_data == None:
        if "Scheduler" not in REGISTERED_APPS.keys():
            return "Service not available"
        response = get_routing_agent(f"api/schedule/day?user_id={user_id}&day={day}","Scheduler")
        data = response.json()
        data = {"schedule":response.json()}
        requests.post(url = f"http://{host_cache}:{port_cache}/", json={"user_id":user_id,"request":f"GET /schedule/day_{day}","data":data})
        return data
    return cache_data

@app.route('/schedule/today', methods=['GET'])
def get_schedule_for_today():
    body = request.json
    user_id = body["user_id"]
    host_cache = REGISTERED_APPS["Cache Leader"][0]["host"]
    port_cache = REGISTERED_APPS["Cache Leader"][0]["port"]
    response = requests.get(url = f"http://{host_cache}:{port_cache}/", json={"user_id":user_id,"request":"GET /schedule/today"})
    cache_data = response.json()["data"]
    if cache_data == None:
        if "Scheduler" not in REGISTERED_APPS.keys():
            return "Service not available"
        response = get_routing_agent(f"api/schedule/today?user_id={user_id}","Scheduler")
        data = response.json()
        data = {"schedule":response.json()}
        requests.post(url = f"http://{host_cache}:{port_cache}/", json={"user_id":user_id,"request":"GET /schedule/today","data":data})
        return data
    return cache_data

@app.route('/notes', methods=["POST"])
def create_notes():
    if "Planner" not in REGISTERED_APPS.keys():
        return "Service not available"
    body = request.json
    response = post_routing_agent("api/notes", body, "Planner")
    return response.json()

@app.route('/notes', methods=["GET"])
def get_all_notes():
    body = request.json
    user_id = body["user_id"]
    host_cache = REGISTERED_APPS["Cache Leader"][0]["host"]
    port_cache = REGISTERED_APPS["Cache Leader"][0]["port"]
    response = requests.get(url = f"http://{host_cache}:{port_cache}/", json={"user_id":user_id,"request":"GET /notes"})
    cache_data = response.json()["data"]
    if cache_data == None:
        if "Planner" not in REGISTERED_APPS.keys():
            return "Service not available"
        response = get_routing_agent(f"api/notes?user_id={user_id}","Planner")
        data = response.json()
        data = {"notes":response.json()}
        requests.post(url = f"http://{host_cache}:{port_cache}/", json={"user_id":user_id,"request":"GET /notes","data":data})
        return data
    return cache_data

@app.route('/exam', methods=["GET"])
def get_exam_notes():
    body = request.json
    user_id = body["user_id"]
    subject = body["subject"]
    host_cache = REGISTERED_APPS["Cache Leader"][0]["host"]
    port_cache = REGISTERED_APPS["Cache Leader"][0]["port"]
    response = requests.get(url = f"http://{host_cache}:{port_cache}/", json={"user_id":user_id,"request":f"GET /notes_{subject}"})
    cache_data = response.json()["data"]
    if cache_data == None:
        if "Planner" not in REGISTERED_APPS.keys():
            return "Service not available"
        response = get_routing_agent(f"api/exam?user_id={user_id}&subject={subject}","Planner")
        data = response.json()
        data = {"notes":response.json()}
        requests.post(url = f"http://{host_cache}:{port_cache}/", json={"user_id":user_id,"request":f"GET /notes_{subject}","data":data})
        return data
    return cache_data

@app.route('/project', methods=["POST"])
def create_projects():
    if "Planner" not in REGISTERED_APPS.keys():
        return "Service not available"
    body = request.json
    response = post_routing_agent("api/project", body, "Planner")
    return response.json()

@app.route('/project', methods=["GET"])
def get_all_projects():
    body = request.json
    user_id = body["user_id"]
    host_cache = REGISTERED_APPS["Cache Leader"][0]["host"]
    port_cache = REGISTERED_APPS["Cache Leader"][0]["port"]
    response = requests.get(url = f"http://{host_cache}:{port_cache}/", json={"user_id":user_id,"request":"GET /project"})
    cache_data = response.json()["data"]
    if cache_data == None:
        if "Planner" not in REGISTERED_APPS.keys():
            return "Service not available"
        response = get_routing_agent(f"api/project?user_id={user_id}","Planner")
        data = response.json()
        data = {"project":response.json()}
        requests.post(url = f"http://{host_cache}:{port_cache}/", json={"user_id":user_id,"request":"GET /project","data":data})
        return data
    return cache_data

@app.route('/semestrial_project', methods=["POST"])
def saga_transaction_for_project():
    body = request.json
    response_1 = post_routing_agent("api/lesson", body, "Scheduler")
    if response_1.status_code == 200:
        response_2 = post_routing_agent("api/project", body, "Planner")
        if response_2.status_code == 200:
            return f"Transaction successful! \n result request 1: {response_1.content} \n result request 1: {response_2.content}"
        else:
            response_3 = delete_routing_agent("api/lesson", response_1.json(), "Scheduler")
            return "Transaction aborted due to service unavailable."
    return response_1.content

@app.before_first_request
def register():
    log.info("Sending register request")
    response = requests.get('http://localhost:4010/', headers={"Content-type":"application/json","name":"Gateway","host":"localhost","port":'4011'})
    log.info(f"Got response {response}")
    resp = response.json()
    for client in resp.keys():
        REGISTERED_APPS[client] = resp[client]

def post_routing_agent(request_uri, json_data, service):
    if service not in REGISTERED_APPS.keys():
        response = Response()
        response.status_code = 404
        response.code = "expired"
        response.error_type = "expired"
        response._content = "No service available"
        return response
    replica = REGISTERED_APPS[service][0]
    host = replica["host"]
    port = replica["port"]
    try:
        response = requests.post(url=f"http://{host}:{port}/{request_uri}", json=json_data, timeout=30)
        return response
    except:
        log.info(f"Trying another replica of service {service}")
    try:
        replica = REGISTERED_APPS[service][1]
        host = replica["host"]
        port = replica["port"]
        response = requests.post(url=f"http://{host}:{port}/{request_uri}", json=json_data, timeout=30)
    except:
        response = Response()
        response.status_code = 500
        response.code = "expired"
        response.error_type = "expired"
        response._content = f"Too many rerouts! Service {service} might be unavailable!"
    
    return response

def delete_routing_agent(request_uri, json_data, service):
    if service not in REGISTERED_APPS.keys():
        response = Response()
        response.status_code = 404
        response.code = "expired"
        response.error_type = "expired"
        response._content = "No service available"
        return response
    replica = REGISTERED_APPS[service][0]
    host = replica["host"]
    port = replica["port"]
    try:
        response = requests.delete(url=f"http://{host}:{port}/{request_uri}", json=json_data, timeout=30)
        return response
    except:
        log.info(f"Trying another replica of service {service}")
    try:
        replica = REGISTERED_APPS[service][1]
        host = replica["host"]
        port = replica["port"]
        response = requests.delete(url=f"http://{host}:{port}/{request_uri}", json=json_data, timeout=10)
    except:
        response = Response()
        response.status_code = 500
        response.code = "expired"
        response.error_type = "expired"
        response._content = f"Too many rerouts! Service {service} might be unavailable!"
    
    return response

def get_routing_agent(request_uri, service):
    if service not in REGISTERED_APPS.keys():
        response = Response()
        response.status_code = 404
        response.code = "expired"
        response.error_type = "expired"
        response._content = "No service available"
        return response
    replica = REGISTERED_APPS[service][0]
    host = replica["host"]
    port = replica["port"]
    response = None
    try:
        response = requests.get(url=f"http://{host}:{port}/{request_uri}", timeout=10)
        return response
    except:
        log.info(f"Trying another replica of service {service}")
    try:
        replica = REGISTERED_APPS[service][1]
        host = replica["host"]
        port = replica["port"]
        response = requests.get(url=f"http://{host}:{port}/{request_uri}", timeout=10)
    except:
        response = Response()
        response.status_code = 500
        response.code = "expired"
        response.error_type = "expired"
        response._content = f"Too many rerouts! Service {service} might be unavailable!"
    
    return response


if __name__ == "__main__":
    app.run(host='localhost', port=4011, debug=True)