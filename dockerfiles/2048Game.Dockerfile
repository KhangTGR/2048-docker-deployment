# Use a valid Ubuntu base image
FROM ubuntu:20.04

# Update package list and install necessary packages
RUN apt-get update && apt-get install -y nginx zip curl

# Configure Nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Download and unzip the 2048 game from GitHub
WORKDIR /var/www/html
RUN curl -o master.zip -L https://github.com/gabrielecirulli/2048/archive/master.zip \
    && unzip master.zip \
    && mv 2048-master/* . \
    && rm -rf 2048-master master.zip

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx
CMD [ "/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf" ]
