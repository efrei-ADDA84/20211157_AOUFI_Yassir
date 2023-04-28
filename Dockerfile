FROM python:3.9-slim-buster

RUN pip install requests

WORKDIR /app

COPY TP1.py .

CMD [ "python", "./TP1.py" ]

