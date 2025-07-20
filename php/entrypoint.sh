#!/bin/bash

# Point d'entrée simple pour Magento Docker
# Exécute les scripts personnalisés et démarre Apache

echo "=== Démarrage Container Magento ==="

# Attendre un peu que les services soient prêts
sleep 5

# Exécuter les scripts d'installation si c'est le premier démarrage
if [ ! -f "/var/www/html/app/etc/env.php" ]; then
    echo "=== Premier démarrage - Scripts d'installation ==="
    if [ -d "/scripts/install" ]; then
        for script in /scripts/install/*.sh; do
            if [ -f "$script" ]; then
                echo "Exécution: $(basename $script)"
                bash "$script"
            fi
        done
    fi
fi

# Exécuter les scripts de démarrage à chaque fois
echo "=== Scripts de démarrage ==="
if [ -d "/scripts/startup" ]; then
    for script in /scripts/startup/*.sh; do
        if [ -x "$script" ]; then
            echo "Exécution: $(basename $script)"
            bash "$script"
        fi
    done
fi

echo "=== Container prêt ==="

# Démarrer Apache
exec apache2-foreground
