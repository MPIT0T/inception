FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y php php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc mariadb-client wget unzip curl && \
    apt clean

# Download and setup wordpress
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz && \
    mv wordpress /var/www/html && \
    chown -R www-data:www-data /var/www/html

COPY tools/init.sh /tools/init.sh
RUN chmod +x /tools/init.sh

EXPOSE 9000
ENTRYPOINT ["/tools/init.sh"]
