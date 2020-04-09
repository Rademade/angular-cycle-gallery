FROM node:12-alpine3.11
# git > npm, bower
# python > node-gyp > node-sass > gulp-sass
RUN apk add --no-cache build-base git python \
    && echo "{\"allow_root\": true}" >> /root/.bowerrc \
    && npm install -g bower
WORKDIR /app
CMD ["npx", "gulp"]
