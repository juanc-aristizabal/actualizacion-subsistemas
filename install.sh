#!/bin/bash


if [ ! -f /var/lib/xroad/public/ ]
then
    echo "error... no encuentra destino para guardar archivos"
    exit 0
fi

sudo apt install ruby

mkdir /var/lib/xroad/public/key
cp ./files/AND_certificate.crt /var/lib/xroad/public/key/AND_certificate.crt
cp ./files/AND_private.key /var/lib/xroad/public/key/AND_private.key
chown -R xroad /var/lib/xroad/public/key
chgrp -R xroad /var/lib/xroad/public/key

cp ./files/update.rb  /var/lib/xroad/public/update.rb
chgrp xroad /var/lib/xroad/public/update.rb
chown xroad /var/lib/xroad/public/update.rb
chmod 755 /var/lib/xroad/public/update.rb

cat ./files/xroad-center > /etc/cron.d/xroad-center

echo ""
echo "subsystem update enabled"
echo "everything's ok..."
echo ""


