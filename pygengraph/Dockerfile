FROM python:3.10-bullseye

RUN apt update && apt install git

RUN mkdir /pygengraph

WORKDIR /pygengraph

# Use this option if you want to use local copy of pygengraph repo, which should be in a directory `pygengraph` next to the Dockerfile
# ADD pygengraph /app_git
# RUN git clone /app_git .

RUN git clone https://github.com/Pigrenok/pygengraph.git .

RUN pip install .

ENTRYPOINT ["pantograph"]