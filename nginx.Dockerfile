# Base image:
FROM nginx
 
# Install dependencies
RUN apt-get update -qq && apt-get -y install apache2-utils
 
# establish where Nginx should look for files
ENV RAILS_ROOT /apps/railsgoat/current
 
# Set our working directory inside the image
WORKDIR $RAILS_ROOT
 
# create log directory
RUN mkdir log
 
# copy over static assets
COPY public public/
 
# Copy Nginx config template
COPY config/nginx.conf /tmp/docker_example.nginx
 
# substitute variable references in the Nginx config template for real values from the environment
# put the final config in its place
 RUN envsubst '$RAILS_ROOT' < /tmp/docker_example.nginx > /etc/nginx/conf.d/default.conf
#RUN rm -rf /etc/nginx/sites-available/default
#ADD config/nginx.conf /etc/nginx/sites-enabled/nginx.conf
 
EXPOSE 80
 
# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "nginx", "-g", "daemon off;" ]
