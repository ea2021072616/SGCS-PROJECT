#!/bin/sh
set -e

echo "Starting Laravel application..."

# If CA in env as base64, write it to file
if [ -n "$MYSQL_ATTR_SSL_CA_BASE64" ]; then
  echo "Setting up MySQL SSL certificate..."
  echo "$MYSQL_ATTR_SSL_CA_BASE64" | base64 -d > /etc/ssl/certs/ca.pem
  export MYSQL_ATTR_SSL_CA=/etc/ssl/certs/ca.pem
fi

# If CA file already exists in repo, use it
if [ -f "/etc/ssl/certs/ca.pem" ]; then
  export MYSQL_ATTR_SSL_CA=/etc/ssl/certs/ca.pem
fi

# Create necessary directories
mkdir -p /var/log/nginx /var/log/supervisor /var/www/html/storage/logs

# Ensure storage and cache permissions
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/public || true
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache || true

# Clear and cache Laravel configs for production
if [ "$APP_ENV" = "production" ]; then
    echo "Optimizing for production..."
    php artisan config:cache || true
    php artisan route:cache || true
    php artisan view:cache || true
fi

echo "Application ready!"

exec "$@"
