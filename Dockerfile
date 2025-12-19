# ====== 1) Dependencias (incluye devDeps para poder compilar TypeScript)
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

# ====== 2) Build (compila TS a dist/)
FROM node:20-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY tsconfig*.json ./
COPY src ./src
# si tienes server.ts en raíz, descomenta la línea siguiente:
# COPY server.ts ./server.ts
RUN npm run build

# ====== 3) Runtime (solo prod deps + dist)
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=build /app/dist ./dist

EXPOSE 3000
CMD ["npm", "run", "start"]
