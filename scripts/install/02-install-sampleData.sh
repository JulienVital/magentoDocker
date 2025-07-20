#!/bin/bash
echo "=== Installation du sample data ==="

/var/www/html/bin/magento sampledata:deploy
/var/www/html/bin/magento setup:upgrade

echo "=== Installation du sample data terminée ==="
