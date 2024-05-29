#!/bin/bash
sudo su -
apt update -y
apt install mysql-server
systemctl start mysql
systemctl enable mysql
apt install firewalld -y
firewall-cmd --zone=public --change-interface=eth0 --permanent
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload