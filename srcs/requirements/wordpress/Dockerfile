FROM debian:11

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y php php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc mariadb-client wget unzip curl && \
    apt clean

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

RUN mkdir -p /var/www/html /run/php

RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress /tmp/wordpress && \
    rm latest.tar.gz

# Set PHP-FPM to listen on TCP instead of Unix socket
RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf


COPY tools/init.sh /tools/init.sh
RUN chmod +x /tools/init.sh

EXPOSE 9000

ENTRYPOINT ["/tools/init.sh"]
