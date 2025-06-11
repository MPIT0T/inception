#!/bin/bash
set -e

mkdir -p /run/php

# Wait for MariaDB to be ready
until mysqladmin ping -hmariadb --silent; do
    echo "[INFO] Waiting for MariaDB..."
    sleep 2
done

# Copy WordPress core if not yet copied
if [ ! -f /var/www/html/index.php ]; then
    echo "[INFO] Installing WordPress core files..."
    cp -r /tmp/wordpress/* /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

cd /var/www/html

# Generate config if not present
if [ ! -f wp-config.php ]; then
    echo "[INFO] Generating wp-config.php..."
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$DB_HOST" \
        --path=/var/www/html \
        --allow-root
fi

# Install WP if not already installed
if ! wp core is-installed --allow-root; then
    echo "[INFO] Installing WordPress site..."
    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root
fi

# Ensure permissions
chown -R www-data:www-data /var/www/html

# Start php-fpm
echo "[INFO] Launching PHP-FPM..."
exec php-fpm7.4 -F
