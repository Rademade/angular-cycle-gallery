FROM node:12-alpine3.11
# git > npm
# python > node-gyp > node-sass > gulp-sass
RUN apk add --no-cache build-base git python
WORKDIR /app
CMD ["npx", "gulp"]
