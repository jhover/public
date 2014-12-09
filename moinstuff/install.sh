#!/usr/bin/env bash
#MOINDIR=/home/httpd/moin/moin
MOINDIR=/var/www/moin/support


echo "sudo cp -pr macro $MOINDIR/data/plugin/"
sudo cp -pr macro $MOINDIR/data/plugin/

echo "sudo cp -pr action $MOINDIR/data/plugin/"
sudo cp -pr action $MOINDIR/data/plugin/

echo "sudo chown -R apache:apache $MOINDIR/data/plugin/macro"
sudo chown -R apache:apache $MOINDIR/data/plugin/macro

echo "sudo chown -R apache:apache $MOINDIR/data/plugin/action"
sudo chown -R apache:apache $MOINDIR/data/plugin/action

sudo /sbin/service httpd restart



