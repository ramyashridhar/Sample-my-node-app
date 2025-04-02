# Use the official Node.js image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Expose the port that your Node app runs on
EXPOSE 3000

# Run the application
CMD ["node", "src/index.js"]
