FROM alpine:latest

MAINTAINER Kai Hendry <hendry@iki.fi>

RUN apk upgrade --update --available && \
    apk add \
      nginx \
      php \
      php-fpm \
      php-json \
      php-curl php-openssl ca-certificates \
      bash \
      vim \
      supervisor \
    && rm -f /var/cache/apk/*

ADD www /srv/http
ADD nginx.conf /etc/nginx/nginx.conf
ADD php-fpm.ini /etc/supervisor.d/php-fpm.ini
ADD nginx.ini /etc/supervisor.d/nginx.ini

RUN mkdir -p /srv/http/u
VOLUME /srv/http/u/
VOLUME /srv/http/
VOLUME /var/log/nginx

EXPOSE 80

CMD supervisord -n -c /etc/supervisord.conf
