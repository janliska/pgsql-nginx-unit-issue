FROM nginx/unit:1.24.0-node15 as builder

ENV BUILD_ENVIRONMENT=docker
ENV BUILD_STAGE=build
ENV NODE_ENV=prod

WORKDIR /opt/app-root/src

COPY ./tsconfig.json ./
COPY package.json ./
COPY package-lock.json ./
COPY src ./src

RUN npm ci
RUN npm run build

# ---

FROM nginx/unit:1.24.0-node15 as runtime

COPY ./ /var/www
COPY ./unit.conf.json /docker-entrypoint.d/.unit.conf.json

ENV BUILD_ENVIRONMENT=docker
ENV BUILD_STAGE=runtime
ENV NODE_ENV=prod

WORKDIR /var/www

COPY --chown=node:node --from=builder /opt/app-root/src/build ./

RUN npm ci --only=production
RUN chmod +x index.js

EXPOSE 8100
