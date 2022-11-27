#!/bin/bash


cp ./files/update.rb  /var/lib/xroad/public/update.rb
chgrp xroad /var/lib/xroad/public/update.rb
chown xroad /var/lib/xroad/public/update.rb
chmod 755 /var/lib/xroad/public/update.rb

cat ./files/center-service > /etc/cron.d/center-service
#cp ./files/center-service /etc/cron.d/center-service
#chgrp xroad /etc/cron.d/center-service
#chown xroad /etc/cron.d/center-service

echo ""
echo "every thing it's ok, life is good..."
echo ""
