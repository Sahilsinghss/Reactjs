# Use an official Node.js runtime as a parent image
FROM node:18
# Set the working directory in the container
WORKDIR /app
# Copy package.json and package-lock.json to the container
COPY . /app
# Install app dependencies
RUN npm install && \
    npm install express
# Bundle your app's source code inside the Docker image
#COPY . .
# Expose the port on which your app will run
EXPOSE 3000
# Define the command to run your app
CMD ["node", "app.js"]
