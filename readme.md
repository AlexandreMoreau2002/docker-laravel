# Projet Docker pour Laravel

## Liens pour le développement

- **phpMyAdmin** : [http://localhost:8081/](http://localhost:8081/)
- **Application Laravel** : [http://localhost:8002/](http://localhost:8002/)

## Installation

### Prérequis

- **WSL** (Windows Subsystem for Linux) installé et configuré.
- **Docker Desktop** installé et en cours d'exécution.
- **Git** installé sur votre machine.

### Étapes de configuration

1. **Ouvrir votre dossier WSL**

2. **Cloner le dépôt depuis GitHub**

   ```bash
   git clone https://github.com/AlexandreMoreau2002/docker-laravel.git
   ```

3. **Naviguer dans le répertoire du projet**

   ```bash
   cd docker-laravel
   ```

4. **Lancer Docker Desktop**

5. **Construire les images Docker**

   Dans le terminal, exécutez la commande suivante pour construire les images Docker définies dans le fichier `docker-compose.yml` :

   ```bash
   docker compose build
   ```

   **Explication :**

   La commande `docker compose build` reconstruit les images Docker définies dans le fichier `docker-compose.yml`. Elle lit les instructions des fichiers Dockerfile (ou des options spécifiées dans le compose) pour créer ou mettre à jour les images nécessaires, afin qu'elles soient prêtes à être utilisées avec `docker compose up`.

   **En résumé :**

   **Elle construit les images à jour pour votre application.**

6. **Créer et lancer les conteneurs**

   ```bash
   docker compose up -d
   ```

7. **Accéder au conteneur Laravel**

   ```bash
   docker compose exec laravel bash
   ```

8. **Créer un nouveau projet Laravel**

   Une fois dans le conteneur, exécutez la commande suivante pour créer un nouveau projet Laravel :

   ```bash
   laravel new nomDuProjet
   ```

9. **Configurer le fichier `.env` de Laravel**

   Ouvrez le fichier `.env` de votre projet Laravel (`/app/nom-du-projet/.env`) et modifiez les lignes suivantes :

   ```env
   APP_URL=http://localhost:8002
   VITE_DEV_SERVER_URL=http://localhost:5173

   DB_CONNECTION=mysql
   DB_HOST=db
   DB_PORT=3306
   DB_DATABASE=laravel
   DB_USERNAME=laravel
   DB_PASSWORD=laravel
   ```

## Modifier le script `dev` pour Laravel

La commande `php artisan serve` lance le serveur sur `127.0.0.1` par défaut, ce qui empêche l'accès depuis d'autres interfaces.

### Solution

Modifiez le script `dev` dans votre fichier `composer.json` pour qu'il écoute sur `0.0.0.0` :

```json
"dev": [
    "Composer\\Config::disableProcessTimeout",
    "npx concurrently -c \"#93c5fd,#c4b5fd,#fb7185,#fdba74\" \"php artisan serve --host=0.0.0.0 --port=8000\" \"php artisan queue:listen --tries=1\" \"php artisan pail --timeout=0\" \"npm run dev\" --names=server,queue,logs,vite"
]
```

---

## Configurer Vite pour être accessible

Modifiez la configuration de Vite pour qu'il écoute sur `0.0.0.0`.

1. **Modifier `package.json`**

   Ajoutez l'option `--host` au script `dev` :

   ```json
   "scripts": {
     "dev": "vite --host"
   }
   ```

2. **Modifier `vite.config.js`**

   Configurez le serveur pour écouter sur `0.0.0.0` :

   ```javascript
   // vite.config.js
   import { defineConfig } from 'vite'
   import laravel from 'laravel-vite-plugin'

   export default defineConfig({
     plugins: [
       laravel({
         input: ['resources/css/app.css', 'resources/js/app.js'],
         refresh: true,
       }),
     ],
     server: {
       host: '0.0.0.0', // Écoute sur toutes les interfaces
       port: 5173, // Assurez-vous que c'est le même port que dans docker-compose.yml
       strictPort: true, // Force Vite à utiliser le port spécifié
       hmr: {
         host: 'localhost', // Nécessaire pour le rechargement à chaud
         port: 5173,
       },
     },
   })
   ```

---

## Reconstruire et relancer les conteneurs Docker

Après avoir apporté toutes les modifications, vous devez reconstruire l'image Docker et relancer les conteneurs pour appliquer les changements.

1. **Arrêter les conteneurs en cours d'exécution**

   ```bash
   docker compose down
   ```

2. **Reconstruire l'image Laravel**

   ```bash
   docker compose build laravel
   ```

3. **Relancer les conteneurs en arrière-plan**

   ```bash
   docker compose up -d
   ```

---

## Accéder à l'application

- **Application Laravel** : [http://localhost:8002/](http://localhost:8002/)
- **phpMyAdmin** : [http://localhost:8081/](http://localhost:8081/)

---

## Remarques

- Assurez-vous que les ports spécifiés (`8000`, `8002`, `8081`, `5173`) ne sont pas utilisés par d'autres applications sur votre machine.
- Pour toute modification dans les fichiers de configuration Docker, n'oubliez pas de reconstruire et relancer les conteneurs.
- Consultez la documentation officielle de Laravel et Docker pour plus d'informations et de meilleures pratiques.

---

© 2024 Alexandre Moreau
