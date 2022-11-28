#!/bin/bash


sudo apt install ruby

mkdir /var/lib/xroad/public/key
chgrp xroad /var/lib/xroad/public/key
chown xroad /var/lib/xroad/public/key
cp ./files/AND_cerrificate.crt /var/lib/xroad/public/key/AND_cerrificate.crt
cp ./files/AND_private.key /var/lib/xroad/public/key/AND_private.key

cp ./files/update.rb  /var/lib/xroad/public/update.rb
chgrp xroad /var/lib/xroad/public/update.rb
chown xroad /var/lib/xroad/public/update.rb
chmod 755 /var/lib/xroad/public/update.rb

cat ./files/xroad-center > /etc/cron.d/xroad-center

echo "Actualización de subsistemas activado"
echo "every thing it's ok, life is good..."
echo ""
