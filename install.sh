#!/bin/bash


cp ./files/update.rb  /var/lib/xroad/public/update.rb
chgrp xroad /var/lib/xroad/public/update.rb
chown xroad /var/lib/xroad/public/update.rb
chmod 755 /var/lib/xroad/public/update.rb

cat ./files/xroad-center > /etc/cron.d/xroad-center
#cp ./files/xroad-center /etc/cron.d/center-service
#chgrp xroad /etc/cron.d/xroad-center
#chown xroad /etc/cron.d/xroad-center

echo ""
echo "every thing it's ok, life is good..."
echo ""
