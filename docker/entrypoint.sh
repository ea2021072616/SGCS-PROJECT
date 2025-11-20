#!/bin/bash

set -e

echo "Esperando a que la base de datos esté lista..."
# Esperar a que la base de datos esté disponible
until php artisan db:show 2>/dev/null; do
    echo "Base de datos no disponible - esperando..."
    sleep 2
done

echo "Base de datos conectada!"

# Ejecutar migraciones
echo "Ejecutando migraciones..."
php artisan migrate --force

# Limpiar y cachear configuración
echo "Optimizando aplicación..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Asegurar permisos correctos
echo "Configurando permisos..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

echo "Iniciando servicios..."
# Iniciar supervisor (que maneja PHP-FPM y Nginx)
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
