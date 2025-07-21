# Magento Docker Environment

Un environnement de développement Magento 2 utilisant Docker avec Apache, MySQL 8.0, phpMyAdmin et OpenSearch.

## 🚀 Démarrage rapide

### Prérequis

- Docker et Docker Compose installés sur votre système
- Au moins 4GB de RAM disponible
- Ports 80, 8580, 9200 et 9600 disponibles

### Configuration système requise

```bash
# Augmenter la limite de mémoire virtuelle pour OpenSearch
sudo sysctl -w vm.max_map_count=262144
```

### Installation

1. **Cloner le projet** (si ce n'est pas déjà fait)
```bash
git clone <url-du-repo>
cd magentoDocker
```

2. **Démarrer les services Docker**
```bash
docker-compose up -d
```

3. **Attendre que tous les services soient démarrés** (environ 2-3 minutes)
```bash
# Vérifier que tous les services sont en cours d'exécution
docker-compose ps
```
En principe, l'image detecte qu'il s'agit du premier chargement et install le projet.

Mais il est possible de faire une install en cli.

4. **Installer Magento**
```bash
docker exec web bash /scripts/install/01-install-magento.sh
```

5. **Installer les données d'exemple** (optionnel)
```bash
docker exec web bash /scripts/install/02-install-sampleData.sh
```

## 🔧 Configuration

### Variables d'environnement

Le fichier `.env` contient toutes les configurations nécessaires :

- **Base de données MySQL** :
  - Host: `db`
  - User: `magento`
  - Password: `magento`
  - Database: `magento`

- **Administration Magento** :
  - Username: `admin`
  - Password: `magentoRocks123`
  - Email: `admin@example.com`

- **Localisation** :
  - Langue: `fr_FR`
  - Timezone: `Europe/Paris`
  - Devise: `EUR`

## 🌐 Accès aux services

### Magento
- **Frontend** : http://localhost
- **Backend/Admin** : http://localhost/admin
  - Username: `admin`
  - Password: `magentoRocks123`

### phpMyAdmin
- **URL** : http://localhost:8580
- **Server** : `db`
- **Username** : `magento`
- **Password** : `magento`

### OpenSearch
- **API** : http://localhost:9200
- **Dashboard** : http://localhost:9600

## 📁 Structure du projet

```
magentoDocker/
├── docker-compose.yml          # Configuration des services Docker
├── .env                        # Variables d'environnement
├── Magento/                    # Code source Magento 2
├── php/                        # Configuration PHP/Apache
│   ├── Dockerfile
│   ├── php.ini
│   └── vhosts/
├── scripts/                    # Scripts d'installation
│   ├── install/
│   │   ├── 01-install-magento.sh
│   │   └── 02-install-sampleData.sh
│   └── startup/
└── readme.md
```

## 🔄 Commandes utiles

### Gestion des conteneurs
```bash
# Démarrer les services
docker-compose up -d

# Arrêter les services
docker-compose down

# Voir les logs
docker-compose logs -f

# Redémarrer un service
docker-compose restart web
```

### Magento CLI
```bash
# Accéder au conteneur web
docker exec -it web bash

# Commandes Magento courantes
docker exec web bin/magento cache:clean
docker exec web bin/magento cache:flush
docker exec web bin/magento indexer:reindex
docker exec web bin/magento setup:upgrade
docker exec web bin/magento setup:di:compile
docker exec web bin/magento setup:static-content:deploy -f
```

### Base de données
```bash
# Sauvegarde de la base de données
docker exec db mysqldump -u magento -pmagento magento > backup.sql

# Restauration de la base de données
docker exec -i db mysql -u magento -pmagento magento < backup.sql
```

## 🛠️ Développement

### Fichiers de configuration importants
- `php.ini` : Configuration PHP (monté depuis la racine du projet)
- `.env` : Variables d'environnement Docker
- `Magento/app/etc/config.php` : Configuration des modules Magento
- `Magento/app/etc/env.php` : **Configuration d'installation Magento** (contient les informations de base de données, cache, etc.)

### Logs
```bash
# Logs Apache
docker exec web tail -f /var/log/apache2/error.log

# Logs Magento
docker exec web tail -f /var/www/html/var/log/system.log
docker exec web tail -f /var/www/html/var/log/exception.log
```

## 🔍 Dépannage

### Problèmes courants

1. **Erreur de mémoire OpenSearch** :
   ```bash
   sudo sysctl -w vm.max_map_count=262144
   ```

2. **Permissions de fichiers** :
   ```bash
   docker exec web chown -R www-data:www-data /var/www/html
   docker exec web chmod -R 755 /var/www/html
   ```

3. **Cache Magento** :
   ```bash
   docker exec web bin/magento cache:clean
   docker exec web bin/magento cache:flush
   ```

4. **Réindexation** :
   ```bash
   docker exec web bin/magento indexer:reindex
   ```

5. **Problèmes d'installation Magento** :
   ```bash
   # Si l'installation échoue ou semble corrompue, supprimer le fichier env.php
   # Ce fichier indique à Magento que l'installation est terminée
   rm Magento/app/etc/env.php
   
   # Puis relancer l'installation
   docker exec web bash /scripts/install/01-install-magento.sh
   ```

6. **Erreurs de mémoire PHP** :
   ```bash
   # Vérifier la configuration de memory_limit dans php.ini
   docker exec web php -i | grep memory_limit
   
   # Vérifier la configuration PHP via le CLI
   docker exec web php -c /usr/local/etc/php/php.ini -r "echo ini_get('memory_limit');"
   
   # Si la mémoire est limitée malgré la configuration, forcer la limite via CLI
   docker exec web php -d memory_limit=2G /var/www/html/bin/magento setup:install [options...]
   
   # Vérifier les variables d'environnement PHP
   docker exec web env | grep PHP
   
   # Redémarrer le conteneur après modification du php.ini
   docker-compose restart web
   ```

   **Note** : Si les erreurs de mémoire persistent malgré une configuration correcte, cela peut indiquer :
   - Un processus enfant qui n'hérite pas de la configuration
   - Une limite imposée par l'image Docker elle-même
   - Un script qui override la limite de mémoire

7. **Installation qui échoue avec des erreurs de mémoire** :
   ```bash
   # Forcer l'installation avec une limite de mémoire spécifique
   docker exec web php -d memory_limit=2G /var/www/html/bin/magento setup:install \
     --base-url=$MAGENTO_URL \
     --backend-frontname=$MAGENTO_BACKEND_FRONTNAME \
     --language=$MAGENTO_LANGUAGE \
     --timezone=$MAGENTO_TIMEZONE \
     --currency=$MAGENTO_DEFAULT_CURRENCY \
     --db-host=$MYSQL_HOST \
     --db-name=$MYSQL_DATABASE \
     --db-user=$MYSQL_USER \
     --db-password=$MYSQL_PASSWORD \
     --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME \
     --admin-lastname=$MAGENTO_ADMIN_LASTNAME \
     --admin-email=$MAGENTO_ADMIN_EMAIL \
     --admin-user=$MAGENTO_ADMIN_USERNAME \
     --admin-password=$MAGENTO_ADMIN_PASSWORD \
     --use-rewrites=1
   ```

### Réinitialisation complète
```bash
# Arrêter et supprimer tous les conteneurs
docker-compose down -v

# Supprimer les volumes (ATTENTION : perte de données)
docker volume prune

# Redémarrer
docker-compose up -d
```

## 📋 TODO / Améliorations

- [ ] Configuration HTTPS
- [ ] Configuration de Redis pour le cache
- [ ] Scripts de sauvegarde automatique
- [ ] Configuration de développement avec Xdebug
- [ ] Scripts de déploiement

## 📞 Support

Pour toute question ou problème, consultez :
- [Documentation officielle Magento](https://devdocs.magento.com/)
- [Documentation Docker](https://docs.docker.com/)
- Les logs des conteneurs : `docker-compose logs [service]`
