FROM base/archlinux:latest
MAINTAINER Kai Hendry <hendry@iki.fi>
RUN pacman --noconfirm -Sy archlinux-keyring && pacman -q -Syu --noconfirm nginx php php-fpm supervisor

# /srv/http used to match with Archlinux's php.ini open_basedir default
ADD www /srv/http
ADD nginx.conf /etc/nginx/nginx.conf
ADD php-fpm.ini /etc/supervisor.d/php-fpm.ini
ADD nginx.ini /etc/supervisor.d/nginx.ini

# TODO setfacl?
RUN chown -R http:http /srv/http

VOLUME /srv/http/u/

EXPOSE 80

# We use supervisord to keep the two processes we need going
CMD supervisord -n -c /etc/supervisord.conf
