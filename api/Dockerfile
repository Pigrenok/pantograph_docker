FROM python:3.10-bullseye

RUN apt update && apt install git

RUN mkdir /app

WORKDIR /app

# Use this option if you want to use local copy of pygengraph repo, which should be in a directory `Schematize` next to the Dockerfile
# ADD Schematize /app_git
# RUN git clone /app_git .

RUN git clone https://github.com/Pigrenok/pantograph_visual.git .

WORKDIR /app/API

RUN pip install -r requirements.txt

CMD ["gunicorn", "-k gevent", "-w 2", "-b 0.0.0.0:5000", "panAPI:app"]
