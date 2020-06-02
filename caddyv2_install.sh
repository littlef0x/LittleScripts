#!/bin/bash

# install caddy and caddy service
curl -fsSL -O https://github.com/caddyserver/caddy/releases/download/v2.0.0/caddy_2.0.0_linux_amd64.tar.gz
tar -xzf ./caddy_2.0.0-rc.2_linux_amd64.tar.gz caddy
sudo mv -f ./caddy /usr/bin/caddy
rm caddy*.tar.gz
sudo mkdir /etc/caddy && sudo mkdir /var/www
sudo curl -s https://raw.githubusercontent.com/littlef0x/LittleScripts/master/caddyv2.service -o /etc/systemd/system/caddy.service

# privilege
sudo usermod -aG ubuntu www-data && sudo usermod -aG www-data ubuntu
sudo chown -R www-data:www-data /etc/caddy && sudo chown -R www-data:www-data /var/www
sudo chmod 775 /etc/caddy && sudo chmod 775 /var/www
sudo -u www-data touch /etc/caddy/Caddyfile
sudo chmod 664 /etc/caddy/Caddyfile

# start caddy service
sudo systemctl daemon-reload
sudo systemctl enable caddy
sudo systemctl start caddy