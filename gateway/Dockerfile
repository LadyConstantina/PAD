FROM tiangolo/uwsgi-nginx-flask:python3.8-alpine
ADD main.py .
RUN pip install requests pymemcache
CMD ["python","main.py"]
ENTRYPOINT ["gateway"]