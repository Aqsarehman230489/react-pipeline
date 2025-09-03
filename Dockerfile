# Build stage
FROM node:18-alpine as build

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

# Production stage
FROM node:18-alpine as production

WORKDIR /app
COPY --from=build /app/package*.json ./
COPY --from=build /app/build ./build
COPY --from=build /app/node_modules ./node_modules

# Install serve to serve static files
RUN npm install -g serve

EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000 || exit 1

CMD ["serve", "-s", "build", "-l", "3000"]
