# Usa PHP con Apache
FROM php:8.4-apache

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libonig-dev libxml2-dev libzip-dev nodejs npm && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiar proyecto
COPY . /var/www/html

WORKDIR /var/www/html

# Instalar dependencias PHP
RUN composer install --no-dev --optimize-autoloader

# Instalar dependencias de Node y compilar frontend
RUN npm install && npm run build

# Cambiar el DocumentRoot a /public
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Evitar advertencia del ServerName
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Permisos correctos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exponer el puerto 80
EXPOSE 80

# Iniciar Apache
CMD ["apache2-foreground"]
