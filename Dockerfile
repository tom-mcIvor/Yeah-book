# Use the official Node.js 18 runtime as the base image
FROM node:18-alpine

# Install build dependencies for native modules
RUN apk add --no-cache python3 py3-setuptools make g++

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy the rest of the application code
COPY . .

# Build the client application
RUN npm run build:client

# Create storage directory for file uploads
RUN mkdir -p /app/storage/images

# Expose the port the app runs on
EXPOSE 3000

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Start the application
CMD ["npm", "start"]