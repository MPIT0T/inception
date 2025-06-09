#!/bin/bash
set -e

mkdir -p /run/php

# Copy WP if missing
if [ ! -f /var/www/html/index.php ]; then
    cp -r /tmp/wordpress/* /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

# Generate wp-config.php
if [ ! -f /var/www/html/wp-config.php ]; then
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sed -i "s/database_name_here/${MYSQL_DATABASE}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/${DB_HOST}/" /var/www/html/wp-config.php
    chown www-data:www-data /var/www/html/wp-config.php
fi

exec php-fpm7.4 -F