# Usa PHP con Apache
FROM php:8.4-apache

# --- Instalar dependencias del sistema ---
RUN apt-get update && apt-get install -y \
    zip unzip git curl nodejs npm libpng-dev libonig-dev libxml2-dev libzip-dev && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# --- Instalar Composer ---
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# --- Copiar el código del proyecto ---
COPY . /var/www/html

WORKDIR /var/www/html

# --- Instalar dependencias PHP ---
RUN composer install --no-dev --optimize-autoloader

# --- Instalar dependencias de Node/Vite ---
RUN npm install && npm run build

# --- Configurar Apache para servir Laravel ---
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# --- Permisos ---
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# --- Exponer puerto 80 ---
EXPOSE 80

# --- Iniciar Apache ---
CMD ["apache2-foreground"]
