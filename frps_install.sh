#!/bin/bash
# install frps and frps service

curl -o frp.tar.gz -fLO https://glare.now.sh/fatedier/frp/linux_amd64
tar -xzf frp.tar.gz
cd `ls -F | grep '/$' | grep frp`
sudo cp -f ./frps /usr/bin/frps
if [ ! -d /etc/frp ]; then
	sudo mkdir /etc/frp
fi
if [ ! -f /etc/frp/frps.ini ]; then
	sudo cp -f ./frps.ini /etc/frp/frps.ini
fi
sudo chown root:root /usr/bin/frps /etc/frp/frps.ini
sudo cp -f systemd/frps.service /etc/systemd/system/frps.service
sudo chown root:root /etc/systemd/system/frps.service
sudo systemctl daemon-reload
sudo systemctl enable frps
cd ..
rm -rf `ls -F | grep '/$' | grep frp`
echo 'Installation completed. Now you can edit /etc/frp/frps.ini and then start the service.'