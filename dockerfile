FROM php:8.1-cli

# Installer les extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install zip

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Installer le Laravel Installer globalement
RUN composer global require laravel/installer

# Ajouter le dossier des binaires globaux de Composer au PATH
ENV PATH="/root/.composer/vendor/bin:${PATH}"

WORKDIR /app

# Ajouter /app/vendor/bin à PATH (si nécessaire)
ENV PATH="/app/vendor/bin:${PATH}"