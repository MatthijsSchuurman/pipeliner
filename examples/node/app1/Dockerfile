FROM node:19-alpine

WORKDIR /home/node/app
USER node:node

COPY --chown=node:node . .
RUN npm install --omit=dev

EXPOSE 8080
CMD [ "node", "index.js" ]