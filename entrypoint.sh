#!/bin/bash

# Vérifier si une commande est passée en argument
if [[ "$#" -gt 0 ]]; then
    exec "$@"
else
    # Si aucune commande n'est fournie, maintenir le conteneur actif
    echo "No command provided. Keeping the container running..."
    tail -f /dev/null
fi
