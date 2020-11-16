#!/bin/bash

# input display directory
read -r -p 'Directory to display: ' displaydir
read -r -p 'Port: ' port
if [[ ! -d $displaydir ]]; then
	sudo mkdir -p $displaydir
	sudo chown ubuntu:ubuntu $displaydir
	sudo chmod 775 $displaydir
fi
sudo usermod -aG ubuntu ubuntu && sudo usermod -aG ubuntu ubuntu

# install filebrowser
curl -fsSL https://filebrowser.xyz/get.sh | bash

# create directory
sudo mkdir /etc/filebrowser
sudo chmod 775 /etc/filebrowser && sudo chown ubuntu:ubuntu /etc/filebrowser

# start service
sudo curl -s https://raw.githubusercontent.com/littlef0x/LittleScripts/master/filebrowser.service -o /etc/systemd/system/filebrowser.service
sudo sed -i "s~\/data~$displaydir~" /etc/systemd/system/filebrowser.service
sudo sed -i "s~8080~$port~" /etc/systemd/system/filebrowser.service
sudo systemctl daemon-reload && sudo systemctl enable filebrowser && sudo systemctl start filebrowser