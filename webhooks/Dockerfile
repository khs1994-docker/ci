FROM node:9-alpine@sha256:b9e63df2deb2b0a30cf67ec8f66ae433dacd2d99d16465bf98884baf8ce7c398

RUN apk add --no-cache git tzdata openssh \
      && echo "registry=https://registry.npm.taobao.org" > ~/.npmrc

WORKDIR /data/ci

COPY . .

RUN npm install

CMD npm run update
