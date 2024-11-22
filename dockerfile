FROM php:8.2-cli

# Installer les extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    curl \
    && docker-php-ext-install zip pcntl pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

# Installer Node.js et npm
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Ajouter les arguments UID et GID
ARG UID
ARG GID

# Créer l'utilisateur appuser avec l'UID et le GID spécifiés
RUN groupadd -g ${GID} appgroup && \
    useradd -u ${UID} -g appgroup -m appuser

# Définir la variable PATH
ENV PATH="/home/appuser/.composer/vendor/bin:${PATH}"

# Définir le répertoire de travail
WORKDIR /app

# Changer le propriétaire du dossier /app
RUN chown -R appuser:appgroup /app

# Copier le script d'entrée dans le conteneur
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Rendre le script exécutable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Passer à l'utilisateur non privilégié
USER appuser

# Installer le Laravel Installer globalement pour appuser
RUN composer global require laravel/installer

# Définir le script d'entrée
ENTRYPOINT ["entrypoint.sh"]
