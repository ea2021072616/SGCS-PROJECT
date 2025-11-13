# Usa PHP con Apache
FROM php:8.4-apache

# Instala dependencias necesarias para Laravel
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libonig-dev libxml2-dev libzip-dev && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Copia el proyecto al contenedor
COPY . /var/www/html

# Cambia el DocumentRoot a la carpeta public
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Habilita mod_rewrite (rutas Laravel)
RUN a2enmod rewrite

# Evita el warning del ServerName
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Permisos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Define directorio de trabajo
WORKDIR /var/www/html

# Expone puerto 80
EXPOSE 80

# Inicia Apache
CMD ["apache2-foreground"]
