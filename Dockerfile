# Step 1: Use an official PHP image with apache
FROM php:8.2-apache

$Step 2: Install system dependencies
RUN apt-get update && apt-get install -y\
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_mysql

# Step 3: Set working directory
WORKDIR /var/www/html

# Step 4: Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


# Step 5: Copy application files to the container
COPY . .


# Step 6: Install Laravel dependencies
RUN composer install


# Step 7: Set permissions for Laravel
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage


# Step 8: Expose port 80
EXPOSE 80


# Step 9: Run Apache in the foreground
CMD ["apache2-foreground"]
