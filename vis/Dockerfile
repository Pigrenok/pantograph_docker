# First stage: Production build of the app

FROM node:16-bullseye AS nodejs

# RUN apt update && apt install git

RUN mkdir /app

WORKDIR /app

# The next two commands should be substituted by either copy from directory with cloned repo or with git clone command from github
ADD Schematize /app_git

RUN git clone /app_git .

RUN rm -rf public/data

RUN npm install

RUN npm run build

# Second stage: Creating an image to serve built app.

FROM nginx:alpine

RUN apk update && apk add bash inotify-tools

COPY 50-nginx-setting-updater.sh /docker-entrypoint.d

RUN mkdir /etc/nginx/ssl/

RUN chmod +x /docker-entrypoint.d/50-nginx-setting-updater.sh

COPY --from=nodejs /app/build /usr/share/nginx/html

