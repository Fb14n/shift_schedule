FROM node:18

WORKDIR /app

COPY package*.json ./

RUN npm ci --unsafe-perm --no-audit --progress=false \
    && npm rebuild bcrypt --build-from-source
COPY . .

EXPOSE 3000

CMD ["node", "server.js"]