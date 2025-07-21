#!/bin/bash

# Exemple de script de démarrage
echo "Script de démarrage personnalisé"
# php bin/magento setup:upgrade
# php bin/magento setup:di:compile
# php bin/magento cache:flush

bin/magento module:disable Magento_AdminAdobeImsTwoFactorAuth
bin/magento module:disable Magento_TwoFactorAuth