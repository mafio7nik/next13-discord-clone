FROM node:18-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json ./
COPY next.config.js ./
RUN npm install 
#COPY node_modules ./node_modules
RUN npm install -D @swc/cli @swc/core
#RUN set http_proxy= ; set https_proxy= ; npm config rm https-proxy; npm config set registry "https://registry.npmjs.org"; npm install



FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED 1


RUN npx prisma generate; npm run start

FROM node:18-alpine AS runner
#WORKDIR /app

#USER nextjs

EXPOSE 3000

#RUN npm run start

ENV PORT 3000

CMD ["npm", "start"]
