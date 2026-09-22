FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
FROM node:22-alpine
WORKDIR /app
ARG PORT=5173
ENV PORT=${PORT}
COPY --from=build /app/dist ./dist
COPY server.mjs ./
EXPOSE ${PORT}
CMD ["node", "server.mjs"]
