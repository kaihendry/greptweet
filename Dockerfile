FROM alpine:latest

MAINTAINER Kai Hendry <hendry+greptweet@iki.fi>

RUN apk upgrade --update --available && \
    apk add \
      nginx \
      php5 \
      php5-fpm \
      php5-json \
      php5-curl php5-openssl ca-certificates \
      bash \
      vim \
      supervisor \
    && rm -f /var/cache/apk/* \
    && chmod -R 755 /var/lib/nginx

RUN mkdir -p /run/nginx
ADD www /srv/http
ADD nginx.conf /etc/nginx/nginx.conf
ADD php-fpm.ini /etc/supervisor.d/php-fpm.ini
ADD nginx.ini /etc/supervisor.d/nginx.ini

RUN echo "clear_env = no" >> /etc/php5/php-fpm.conf

RUN mkdir -p /srv/http/u
RUN chmod -R 777 /srv/http/u

EXPOSE 80

CMD supervisord -n -c /etc/supervisord.conf
