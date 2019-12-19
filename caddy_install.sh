#!/bin/bash

# install caddy and caddy service
curl https://getcaddy.com | bash -s personal
sudo mkdir /etc/caddy && sudo mkdir /var/www && sudo mkdir /etc/ssl/caddy
sudo curl -s https://raw.githubusercontent.com/mholt/caddy/master/dist/init/linux-systemd/caddy.service -o /etc/systemd/system/caddy.service

# privilege
sudo sed -i '/^ReadWriteDirectories=\/etc\/ssl\/caddy/a\ReadWriteDirectories=\/etc\/caddy\nReadWriteDirectories=\/var\/www' /etc/systemd/system/caddy.service
sudo usermod -aG ubuntu www-data && sudo usermod -aG www-data ubuntu
sudo chown -R www-data:www-data /etc/caddy && sudo chown -R www-data:www-data /var/www && sudo chown -R www-data:www-data /etc/ssl/caddy
sudo chmod 775 /etc/caddy && sudo chmod 775 /var/www && sudo chmod 775 /etc/ssl/caddy
sudo -u www-data touch /etc/caddy/Caddyfile
sudo chmod 664 /etc/caddy/Caddyfile

# start caddy service
sudo systemctl daemon-reload
sudo systemctl enable caddy
sudo systemctl start caddy