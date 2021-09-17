FROM node:16 as base


FROM base as dependencies
WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn install --production --prefer-offline \
 && yarn autoclean --force


FROM base
WORKDIR /usr/src/app

RUN yarn global add pm2

COPY --from=dependencies /usr/src/app/node_modules node_modules
COPY . .

EXPOSE 3000
ENTRYPOINT [ "pm2-runtime" ]

CMD [ "start", "ecosystem.yml" ]
