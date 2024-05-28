#!/bin/bash
sudo su -
apt update -y
apt install apache2 -y
systemctl enable apache2
systemctl start apache2
apt install firewalld -y
firewall-cmd --zone=public --change-interface=eth0 --permanent
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-service=https --permanent
firewall-cmd --reload