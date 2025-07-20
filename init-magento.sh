#!/usr/bin/env bash

# Script d'initialisation pour Magento
# Lance l'installation uniquement au premier démarrage

INSTALL_FLAG="/var/www/html/app/etc/env.php"
INSTALL_SCRIPT="/usr/local/bin/install-magento"

echo "=== Démarrage du container Magento ==="

# Attendre un peu que les services soient complètement prêts
echo "Attente de l'initialisation des services..."
sleep 10

# Corriger les permissions des répertoires Magento
# echo "Configuration des permissions..."
# chown -R www-data:www-data /var/www/html
# find /var/www/html -type d -exec chmod 755 {} \;
# find /var/www/html -type f -exec chmod 644 {} \;

# Vérifier si Magento est déjà installé
if [ ! -f "$INSTALL_FLAG" ]; then
    echo "=== Premier démarrage détecté - Installation de Magento ==="
    
    # Vérifier que le script d'installation existe
    if [ -f "$INSTALL_SCRIPT" ]; then
        echo "Exécution du script d'installation..."
        # install-magento
        
        if [ $? -eq 0 ]; then
            echo "=== Installation de Magento terminée avec succès ==="
        else
            echo "=== Erreur lors de l'installation de Magento ==="
            exit 1
        fi
    else
        echo "Erreur : Script d'installation non trouvé à $INSTALL_SCRIPT"
        exit 1
    fi
else
    echo "=== Magento déjà installé - Démarrage normal ==="
fi



echo "=== Container Magento prêt ==="
# php bin/magento module:status | grep -q Magento_BundleSampleData && echo "Sample Data déjà déployé" || install-sampledata
