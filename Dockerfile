FROM base/archlinux:latest
MAINTAINER Kai Hendry <hendry@iki.fi>
RUN pacman -Syu --noconfirm nginx php php-fpm supervisor git

# /srv/http used to match with Archlinux's php.ini open_basedir default
RUN git clone https://github.com/kaihendry/greptweet.git /srv/http
WORKDIR /srv/http
RUN git describe --always > version.txt

ADD nginx.conf /etc/nginx/nginx.conf
ADD php-fpm.ini /etc/supervisor.d/php-fpm.ini
ADD nginx.ini /etc/supervisor.d/nginx.ini
ADD secret.php /srv/http/secret.php

RUN chown -R http:http /srv/http

VOLUME /srv/http/u/

EXPOSE 80

# We use supervisord to keep the two processes we need going
CMD supervisord -n -c /etc/supervisord.conf

# sudo docker run -v /srv/www/greptweet.com:/srv/http/u -p 80:80 -t -i greptweet
