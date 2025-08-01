#!/bin/bash

echo "=== Installation de Magento ==="

cd /var/www/html

# Forcer la limite de mémoire pour l'installation
php -d memory_limit=2G /var/www/html/bin/magento setup:install \
    --base-url=$MAGENTO_URL \
    --backend-frontname=$MAGENTO_BACKEND_FRONTNAME \
    --language=$MAGENTO_LANGUAGE \
    --timezone=$MAGENTO_TIMEZONE \
    --currency=$MAGENTO_DEFAULT_CURRENCY \
    --db-host=$MYSQL_HOST \
    --db-name=$MYSQL_DATABASE \
    --db-user=$MYSQL_USER \
    --db-password=$MYSQL_PASSWORD \
    --use-secure=$MAGENTO_USE_SECURE \
    --base-url-secure=$MAGENTO_BASE_URL_SECURE \
    --use-secure-admin=$MAGENTO_USE_SECURE_ADMIN \
    --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME \
    --admin-lastname=$MAGENTO_ADMIN_LASTNAME \
    --admin-email=$MAGENTO_ADMIN_EMAIL \
    --admin-user=$MAGENTO_ADMIN_USERNAME \
    --admin-password=$MAGENTO_ADMIN_PASSWORD \
    --use-rewrites=1 \
    --search-engine=opensearch \
    --opensearch-host=$OPENSEARCH_HOST \
    --opensearch-port=9200 \
    --opensearch-index-prefix=magento2 \
    --opensearch-timeout=15 \
    --opensearch-enable-auth=false

/var/www/html/bin/magento cron:install --force
/var/www/html/bin/magento module:disable Magento_AdminAdobeImsTwoFactorAuth Magento_TwoFactorAuth

/var/www/html/bin/magento cache:flush
echo "=== Installation Magento terminée ==="