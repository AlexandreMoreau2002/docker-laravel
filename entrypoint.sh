#!/bin/bash

# Ajuster les permissions pour le dossier /app
chmod -R 777 /app

# Exécuter la commande passée en argument
exec "$@"
