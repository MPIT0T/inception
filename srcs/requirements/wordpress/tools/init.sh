#!/bin/bash

mkdir -p /run/php

# If WordPress core files are missing, copy them in
if [ ! -f /var/www/html/index.php ]; then
    echo "[INFO] Copying WordPress into mounted volume..."
    cp -r /tmp/wordpress/* /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

# Generate wp-config if needed
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "[INFO] Generating wp-config.php..."
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sed -i "s/database_name_here/${MYSQL_DATABASE}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" /var/www/html/wp-config.php
fi

exec php-fpm7.4 -F