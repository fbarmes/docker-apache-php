
#-- Base image
FROM alpine:3


#-------------------------------------------------------------------------------
# update base
#-------------------------------------------------------------------------------
RUN \
  apk update \
  apk upgrade

#-------------------------------------------------------------------------------
# install apache httpd
#-------------------------------------------------------------------------------
RUN \
  apk add apache2


#-------------------------------------------------------------------------------
# install PHP
#-------------------------------------------------------------------------------
RUN \
  apk add php8 php8-apache2


#-------------------------------------------------------------------------------
# wrap up
#-------------------------------------------------------------------------------
EXPOSE 80
EXPOSE 443


ENV APACHE_SERVER_NAME=my-server


#-------------------------------------------------------------------------------
# setup site
#-------------------------------------------------------------------------------
COPY root /

#-------------------------------------------------------------------------------
# setup entrypoint
#-------------------------------------------------------------------------------
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

#-- install entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
