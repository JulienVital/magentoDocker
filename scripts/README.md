# Scripts Personnalisés Magento Docker

Structure simple :

```
scripts/
├── install/    # Scripts exécutés uniquement au premier démarrage
└── startup/    # Scripts exécutés à chaque démarrage
```

## Usage

1. **Scripts d'installation** : Placez vos scripts `.sh` dans `scripts/install/`
   - Exécutés seulement quand `app/etc/env.php` n'existe pas
   - Exemple : installation de modules, configuration initiale

2. **Scripts de démarrage** : Placez vos scripts `.sh` dans `scripts/startup/`
   - Exécutés à chaque démarrage du container
   - Exemple : nettoyage cache, permissions

## Exemples

### Installation d'un module
```bash
# scripts/install/02-my-module.sh
#!/bin/bash
composer require vendor/my-module
php bin/magento module:enable Vendor_MyModule
php bin/magento setup:upgrade
```

### Nettoyage au démarrage
```bash
# scripts/startup/02-cleanup.sh
#!/bin/bash
php bin/magento cache:clean
chown -R www-data:www-data var/ pub/
```

C'est tout ! Beaucoup plus simple.
