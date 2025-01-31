# Use a lightweight Node.js image
FROM node:14-alpine

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json ./
RUN npm install --production

# Copy the rest of the application code
COPY . .

# Expose the port that the app listens on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
