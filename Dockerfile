# === STAGE 1: Build the React Application ===
# Use a Node.js image to build the static files.
FROM node:18-alpine AS build

# Set the working directory inside the container.
WORKDIR /app

# Copy package files and install dependencies.
# This step is cached by Docker if the files don't change.
COPY package.json ./
COPY package-lock.json ./
RUN npm install

# Copy the rest of the application source code.
COPY . ./

# Run the build script to generate optimized static files.
RUN npm run build

# === STAGE 2: Serve the Application with Nginx ===
# Use a lightweight Nginx image for the production server.
FROM nginx:stable-alpine

# Copy the optimized static files from the 'build' stage.
COPY --from=build /app/build /usr/share/nginx/html

# Copy our custom Nginx configuration.
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 to the outside world.
EXPOSE 80

# Command to start Nginx in the foreground.
CMD ["nginx", "-g", "daemon off;"]