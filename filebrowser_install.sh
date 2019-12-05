#!/bin/bash

# input display directory
read -r -p 'Directory to display: ' displaydir
if [[ ! -d $displaydir ]]; then
	sudo mkdir -p $displaydir
	sudo chown ubuntu:ubuntu $displaydir
	sudo chmod 775 $displaydir
fi
sudo usermod -aG ubuntu www-data && sudo usermod -aG www-data ubuntu

# install filebrowser
curl -fsSL https://filebrowser.xyz/get.sh | bash

# create directory
sudo mkdir /etc/filebrowser
sudo chmod 775 /etc/filebrowser && sudo chown www-data:www-data /etc/filebrowser

# start service
sudo curl -s https://raw.githubusercontent.com/littlef0x/LittleScripts/master/filebrowser.service -o /etc/systemd/system/filebrowser.service
sudo sed -i "s~\/data~$displaydir~" /etc/systemd/system/filebrowser.service
sudo systemctl daemon-reload && sudo systemctl enable filebrowser && sudo systemctl start filebrowser