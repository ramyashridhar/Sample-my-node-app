# Stage 1: Build the app
FROM node:14 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Stage 2: Run the app
FROM node:14
WORKDIR /app
COPY --from=builder /app /app
CMD ["npm", "start"]
