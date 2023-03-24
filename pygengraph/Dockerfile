FROM python:3.10-bullseye

RUN apt update && apt install git

RUN mkdir /pygengraph

WORKDIR /pygengraph

# The next two commands should be substituted by either copy from directory with cloned repo or with git clone command from github

ADD pygengraph /app_git

RUN git clone /app_git .

RUN pip install .

ENTRYPOINT ["pantograph"]