FROM node:16-alpine as base

EXPOSE 4200

RUN apk update && apk add --no-cache tini

RUN npm install -g @angular/cli
RUN npm install -g nx

WORKDIR /app

RUN ng new docker-app --defaults 
RUN mv docker-app/* ./
RUN rm -Rf docker-app

#COPY package.json package-local.json* ./

#RUN npm install --ignore-scripts \
#    && npm cache clean --force

#COPY . . 

#RUN npm run postinstall

FROM base 
ENTRYPOINT ["/sbin/tini", "--"]

#CMD nx serve internal-desktop --watch --host 0.0.0.0 --poll 1
CMD ng serve --host 0.0.0.0 --poll 1
