FROM tiangolo/uwsgi-nginx-flask:python3.8-alpine
ADD main.py .
RUN pip install requests
CMD ["python","main.py"]
ENTRYPOINT ["service_discovery"]