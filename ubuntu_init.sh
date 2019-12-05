#!/bin/bash

# activate bbr
function activatebbr()
{
	if [[ !`grep bbr /etc/sysctl.conf` ]]; then
		echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
		sysctl -p
	fi
}

# add pubkey for root
function addpubkey(){
	if [[ ! -d ~/.ssh ]]; then
		mkdir ~/.ssh
		chmod 700 ~/.ssh
	fi
	echo "$1" > ~/.ssh/authorized_keys
	chmod 600 ~/.ssh/authorized_keys
}

# aliases
function aliases()
{
	if [[ !`grep 'custom alias' /etc/bash.bashrc` ]]; then
		echo "# custom alias" >> /etc/bash.bashrc
		echo "alias update-caddy='curl https://getcaddy.com | bash -s personal'" >> /etc/bash.bashrc
		echo "alias start='sudo systemctl start'" >> /etc/bash.bashrc
		echo "alias stop='sudo systemctl stop'" >> /etc/bash.bashrc
		echo "alias status='sudo systemctl status'" >> /etc/bash.bashrc
		echo "alias restart='sudo systemctl restart'" >> /etc/bash.bashrc
	fi
}

# create user ubuntu
function createuser()
{
	if [[ !`grep 'ubuntu' /etc/sudoers` ]]; then
		echo -e "\nubuntu ALL=(ALL) NOPASSWD: ALL\n" >> /etc/sudoers
	fi
	if [[ ! -d /home/ubuntu/.ssh ]]; then
		mkdir /home/ubuntu/.ssh
	fi
	echo "$1" > /home/ubuntu/.ssh/authorized_keys
	chmod 700 /home/ubuntu/.ssh
	chown -R ubuntu:ubuntu /home/ubuntu/.ssh
	chmod 600 /home/ubuntu/.ssh/authorized_keys
}

# disable password authentication
function disablepasswordauth(){
	read -n 1 -p  'Please make sure that you can login using private keys. Enter to confirm. Others to cancel. ' loginconfirm
	if [[ "$loginconfirm" == '' ]]; then
		if [[ `grep '^#PasswordAuthentication yes' /etc/ssh/sshd_config` ]]; then
			sed -i "s/^#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
		elif [[ `grep '^# PasswordAuthentication yes' /etc/ssh/sshd_config` ]]; then
			sed -i "s/^# PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
		elif [[ `grep '^PasswordAuthentication yes' /etc/ssh/sshd_config` ]]; then
			sed -i "s/^PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
		else
			echo 'No password configuration found. You need to change it manually.'
		fi
		systemctl restart sshd
	else
		echo 'Privkey import failed. Please check it manually.'
	fi
}

# configure ufw
function ufwconfig()
{
	read -p 'SSH port: ' port
	read -n 1 -p "Your ssh port is $port. Enter to confirm. Others to cancel. " portconfirm
	if [[ $portconfirm == '' ]]; then
		ufw allow $port/tcp
		ufw enable
	else
		echo 'ufw not activated.'
	fi
}

# root?
if [[ $EUID -ne 0 ]]; then
   echo "Error:This script must be run as root!" 1>&2
   exit 1
fi

# install update and software
apt update -y
apt upgrade -y
apt purge vim-tiny -y
apt install vim wget curl lrzsz screen ufw -y

# change time zone
timedatectl set-timezone Asia/Shanghai

# import priv key for both root and ubuntu
read -r -p 'Pub key: ' pubkey
addpubkey "$pubkey"

if [[ !`grep ubuntu /etc/passwd` ]]; then
	useradd -m ubuntu -s /bin/bash
fi
createuser "$pubkey"

# disable password authentication
disablepasswordauth

# activate bbr
activatebbr

# enable ufw
ufwconfig

# add alias
aliases

# finish
echo 'Init complete!'