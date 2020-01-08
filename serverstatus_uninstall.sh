#!/bin/bash

sudo systemctl stop serverstatus
sudo systemctl disable serverstatus
sudo rm /etc/systemd/system/serverstatus.service
sudo systemctl daemon-reload
sudo rm -f /usr/local/serverstatus/client-linux.py