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
REGISTRATION_LOCK = threading.Lock()

@app.route('/', methods=['GET'])
def get_registered_services():
    service_name = request.headers.get("name")
    log.info(f"Got request to register from {service_name}")
    for service in REGISTERED_APPS.keys():
        log.info(f"There is a service {service}")
        for replica in REGISTERED_APPS[service]:
            log.info(f"There is a replica {replica}")
            requests.post(f"http://{replica['host']}:{replica['port']}/new_service", json=json.dumps(REGISTERED_APPS))
            log.info("Post request to replica finished")
    REGISTRATION_LOCK.acquire()
    log.info("Check if service exists")
    if service_name not in REGISTERED_APPS:
        log.info("Introduce new service")
        REGISTERED_APPS[service_name] = [{"host":request.headers.get("host"), "port":request.headers.get("port")}]
    else:
        log.info("Introduce to existing service")
        REGISTERED_APPS[service_name].append({"host":request.headers.get("host"), "port":request.headers.get("port")})
    log.info(REGISTERED_APPS)
    REGISTRATION_LOCK.release()
    return json.dumps(REGISTERED_APPS)

def monitor_services():
    while True:
        service_down = []
        REGISTRATION_LOCK.acquire()
        services = REGISTERED_APPS.keys()
        for service in services:
            for replica in REGISTERED_APPS[service]:
                log.info(f"Thread in for: {service}")
                try: 
                    requests.get(f"http://{replica['host']}:{replica['port']}/heartbeat")
                except:
                    service_down.append([service, replica])
        [REGISTERED_APPS[service].remove(replica) for service, replica in service_down]
        [REGISTERED_APPS.pop(service, None) for service, _ in service_down if len(REGISTERED_APPS[service]) == 0 ]
        service_down = []
        log.info(REGISTERED_APPS)
        REGISTRATION_LOCK.release()
        time.sleep(10)

if __name__ == "__main__":
    monitor_thread = threading.Thread(target=monitor_services)
    flask_thread = threading.Thread(target=app.run, kwargs={"host":'0.0.0.0', "port":4010, "debug":False})
    monitor_thread.start()
    flask_thread.start()