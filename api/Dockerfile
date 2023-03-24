FROM python:3.10-bullseye

RUN apt update && apt install git

RUN mkdir /app

WORKDIR /app

# The next two commands should be substituted by either copy from directory with cloned repo or with git clone command from github

ADD Schematize /app_git

RUN git clone /app_git .

WORKDIR /app/API

RUN pip install -r requirements.txt

CMD ["gunicorn", "-k gevent", "-w 2", "-b 0.0.0.0:5000", "panAPI:app"]
