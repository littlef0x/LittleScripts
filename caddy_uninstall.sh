#!/bin/bash

# delete systemd service
sudo systemctl stop caddy
sudo systemctl disable caddy
sudo rm -f /etc/systemd/system/caddy.service

# remove files
sudo rm -rf /etc/ssl/caddy
sudo rm -rf /etc/caddy
sudo rm -f /usr/local/bin/caddy

# delete aliases
sudo sed -i '/caddy/d' ~/.bashrc
sudo sed -i '/caddy/d' /etc/bash.bashrc