#!/bin/bash

aria2confdir=/home/ubuntu/.aria2

# input rpc-token and domain
read -r -p 'Domain of aria2 server: ' domain
read -r -p 'rpc-token: ' rpctoken

# install aria2
sudo apt install aria2 -y

# aria2 configuration
if [[ ! -d $aria2confdir ]]; then
	mkdir -p $aria2confdir
fi
wget --no-check-certificate -N "https://raw.githubusercontent.com/littlef0x/LittleScripts/master/aria2.conf" -o $aria2confdir/aria2.conf
wget --no-check-certificate -N "https://github.com/littlef0x/LittleScripts/raw/master/dht.dat" -o $aria2confdir/dht.dat
touch $aria2confdir/aria2.session
sed -i "s~DOUBIToyo~$rpctoken~" $aria2confdir/aria2.conf
sed -i "s~domain~$domain~g" $aria2confdir/aria2.conf

# start aria2 service
sudo curl -s https://raw.githubusercontent.com/littlef0x/LittleScripts/master/aria2.service -o /etc/systemd/system/aria2.service
sudo chown -R ubuntu:ubuntu $aria2confdir
sudo systemctl daemon-reload
sudo systemctl enable aria2
sudo systemctl start aria2