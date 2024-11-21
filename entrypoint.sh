#!/bin/bash

# Vérifier si l'environnement est Windows via la variable d'environnement
if [[ "$WINDOWS" == "true" ]]; then
    echo "Windows environment detected via environment variable. Adjusting permissions..."
    chmod -R 777 /app
else
    echo "Skipping permissions adjustment."
fi

# Vérifier si une commande est passée en argument
if [[ "$#" -gt 0 ]]; then
    exec "$@"
else
    # Si aucune commande n'est fournie, maintenir le conteneur actif
    echo "No command provided. Keeping the container running..."
    tail -f /dev/null
fi
