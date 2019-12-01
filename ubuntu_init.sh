#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "Error:This script must be run as root!" 1>&2
   exit 1
fi

# install update and software
apt update -y
apt upgrade -y
apt purge vim-tiny -y
apt install vim wget curl lrzsz screen ufw -y

# create user ubuntu
function creatuser()
{
	useradd -m ubuntu -s /bin/bash
	read -p 'Password for ubuntu: ' pass
	echo $pass | passwd ubuntu --stdin  &>/dev/null
	if [[ `grep 'ubuntu' /etc/sudoers` ]]; then
		echo -e "\nubuntu ALL=(ALL) NOPASSWD: ALL\n" >> /etc/sudoers
	fi
	mkdir /home/ubuntu/.ssh
	chmod 700 /home/ubuntu/.ssh
	chown -R ubuntu:ubuntu /home/ubuntu/.ssh
	echo $1 > /home/ubuntu/.ssh/authorized_keys
	chmod 600 /home/ubuntu/.ssh/authorized_keys
}

# activate bbr
if [[ !`sysctl net.ipv4.tcp_available_congestion_control | grep bbr` ]]; then
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	sysctl -p
fi

# change time zone
timedatectl set-timezone Asia/Shanghai

# import priv key for both root and ubuntu
read -p 'Pub key: ' pubkey
mkdir ~/.ssh
chmod 700 ~/.ssh
echo "$pubkey" > ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# add user ubuntu
if [[ `grep ubuntu /etc/passwd` ]]; then
	read -n 1 -p 'User ubuntu already exists. Change its password? [y/n]' changepw
	if [[ "$changepw" == 'y' ]]; then
		creatuser $pubkey
	else
		echo 'Password unchanged.'
	fi
else
	creatuser $pubkey
fi

# disable password authentication
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

# configure ufw
read -p 'SSH port: ' port
read -n 1 -p "Your ssh port is $port. Enter to confirm. Others to cancel. " portconfirm
if [[ $portconfirm == '' ]]; then
	ufw allow $port/tcp
	ufw enable
else
	echo 'ufw not activated.'
fi

# alias
if [[ `grep 'custom alias' /etc/bash.bashrc` ]]; then
	echo "# custom alias" >> /etc/bash.bashrc
	echo "alias update-caddy='curl https://getcaddy.com | bash -s personal'" >> /etc/bash.bashrc
	echo "alias start='sudo systemctl start'" >> /etc/bash.bashrc
	echo "alias stop='sudo systemctl stop'" >> /etc/bash.bashrc
	echo "alias status='sudo systemctl status'" >> /etc/bash.bashrc
	echo "alias restart='sudo systemctl restart'" >> /etc/bash.bashrc
fi

# finish
echo 'Init complete!'