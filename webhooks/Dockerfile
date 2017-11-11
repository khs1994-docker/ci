FROM node:9-alpine

RUN apk add --no-cache git tzdata openssh \
      && echo "registry=https://registry.npm.taobao.org" > ~/.npmrc

WORKDIR /data/ci

COPY . .

RUN npm install

CMD npm run update
