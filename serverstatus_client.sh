#!/bin/bash

# install dependencies
if command -v python >/dev/null 2>&1; then
	true
else
	sudo apt install python
fi

if command -v wget >/dev/null 2>&1; then
	true
else
	sudo apt install wget
fi

# get information
echo -n 'ServerStatus server IP or domain name:'
read server
echo -n 'Username of this server:'
read user
echo -n 'Password of this server:'
read password

# get serverstatus client
sudo mkdir /usr/local/serverstatus
sudo wget --no-check-certificate -qP /usr/local/serverstatus 'https://raw.githubusercontent.com/cppla/ServerStatus/master/clients/client-linux.py'
sudo sed -i "s/127.0.0.1/$server/" /usr/local/serverstatus/client-linux.py
sudo sed -i "s/s01/$user/" /usr/local/serverstatus/client-linux.py
sudo sed -i "s/USER_DEFAULT_PASSWORD/$password/" /usr/local/serverstatus/client-linux.py
sudo sed -i "s/argc.split('SERVER=')[-1]/socket.gethostbyname(argc.split('SERVER=')[-1])/" /usr/local/serverstatus/client-linux.py

# get systemd service file
sudo wget --no-check-certificate -qP /etc/systemd/system https://raw.githubusercontent.com/littlef0x/LittleScripts/master/serverstatus.service
if id ubuntu >/dev/null 2>&1; then
	true
else
	sed -i "s/ubuntu/root/g" /etc/systemd/system/serverstatus.service
fi
sudo systemctl daemon-reload
sudo systemctl enable serverstatus
sudo systemctl start serverstatus