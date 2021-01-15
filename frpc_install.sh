#!/bin/bash
# install frpc and frpc service

curl -o frp.tar.gz -fLO https://glare.now.sh/fatedier/frp/linux_amd64
tar -xzf frp.tar.gz
cd `ls -F | grep '/$' | grep frp`
sudo cp -f ./frpc /usr/bin/frpc
if [ ! -d /etc/frp ]; then
	sudo mkdir /etc/frp
fi
if [ ! -f /etc/frp/frpc.ini ]; then
	sudo cp -f ./frpc.ini /etc/frp/frpc.ini
fi
sudo chown root:root /usr/bin/frpc /etc/frp/frpc.ini
sudo cp -f systemd/frpc.service /etc/systemd/system/frpc.service
sudo chown root:root /etc/systemd/system/frpc.service
sudo systemctl daemon-reload
sudo systemctl enable frpc
cd ..
rm -rf `ls -F | grep '/$' | grep frp`
rm frp.tar.gz
echo 'Installation completed. Now you can edit /etc/frp/frpc.ini and then start the service.'